`timescale 1ns/1ps
//
// Testbench harness for running the official riscv-tests ISA bodies on the
// Harvard, machine-mode rv32i_core.
//
// Loads a per-test instruction image (+IMEM_HEX) into a flat instruction
// memory at word 0 and an optional data image (+DMEM_HEX) into a flat data
// memory based at 0x0001_0000. The custom env (tb_official/env/riscv_test.h)
// signals pass/fail with ECALL (mcause==11), leaving the result code in gp:
//   gp == 1  -> PASS
//   gp != 1  -> FAIL, failing sub-test number is (gp >> 1)
//
// The harness watches for the machine-ECALL trap and reports PASS:/FAIL:
// using the dataset-wide convention so run_all_tests-style scripts can scrape
// results. A cycle cap guards against a hung core (reported as a TIMEOUT
// FAIL). Two memory timing modes are supported to exercise the stall paths:
//   default            : single-cycle registered ready
//   +IMEM_WAIT_PERIOD=N : periodically deassert imem ready (instruction stall)
//   +DMEM_WAIT_PERIOD=N : periodically deassert dmem ready (data stall)
//
module riscv_test_tb;
    reg clk;
    reg rst_n;

    wire        imem_valid;
    wire [31:0] imem_addr;
    reg         imem_ready;
    reg  [31:0] imem_rdata;
    reg         imem_err;

    wire        dmem_valid;
    wire        dmem_we;
    wire [3:0]  dmem_be;
    wire [31:0] dmem_addr;
    wire [31:0] dmem_wdata;
    reg         dmem_ready;
    reg  [31:0] dmem_rdata;
    reg         dmem_err;

    wire        debug_halted;
    wire [31:0] debug_pc;
    wire [31:0] debug_instr;

    // 4096 words = 16 KB each; big enough for the largest ISA body.
    reg [31:0] imem [0:4095];
    reg [31:0] dmem [0:4095];

    reg [1023:0] imem_hex;
    reg [1023:0] dmem_hex;
    reg [511:0]  test_name;
    integer max_cycles;
    integer imem_wait_period;
    integer dmem_wait_period;
    integer cycle_count;
    integer i;
    integer have_dmem;

    integer imem_resp_count;
    reg     imem_wait_hold;
    reg     imem_serve;
    integer dmem_resp_count;
    reg     dmem_wait_hold;
    reg     dmem_serve;
    integer trace_en;
    reg     trap_seen;

    wire [31:0] imem_word_index;
    wire [31:0] dmem_word_index;
    assign imem_word_index = imem_addr[31:2];
    assign dmem_word_index = (dmem_addr - 32'h0001_0000) >> 2;

    rv32i_core dut (
        .clk(clk),
        .rst_n(rst_n),
        .irq_external(1'b0),
        .imem_valid(imem_valid),
        .imem_addr(imem_addr),
        .imem_ready(imem_ready),
        .imem_rdata(imem_rdata),
        .imem_err(imem_err),
        .dmem_valid(dmem_valid),
        .dmem_we(dmem_we),
        .dmem_be(dmem_be),
        .dmem_addr(dmem_addr),
        .dmem_wdata(dmem_wdata),
        .dmem_ready(dmem_ready),
        .dmem_rdata(dmem_rdata),
        .dmem_err(dmem_err),
        .debug_halted(debug_halted),
        .debug_pc(debug_pc),
        .debug_instr(debug_instr)
    );

    always #5 clk = ~clk;

    // ---- instruction memory model -------------------------------------
    // Address space below 0x4000 (word index < 4096) is valid instruction
    // memory; anything above faults (imem_err) so a runaway PC is caught.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            imem_ready      <= 1'b0;
            imem_rdata      <= 32'h0000_0013;
            imem_err        <= 1'b0;
            imem_resp_count <= 0;
            imem_wait_hold  <= 1'b0;
        end else begin
            imem_serve = imem_valid;
            if (imem_valid && imem_wait_period != 0 && !imem_wait_hold &&
                ((imem_resp_count % imem_wait_period) == (imem_wait_period - 1))) begin
                imem_serve     = 1'b0;
                imem_wait_hold <= 1'b1;
            end else begin
                imem_wait_hold <= 1'b0;
            end

            imem_ready <= imem_serve;
            imem_err   <= imem_serve && (imem_addr[31:14] != 18'b0);
            if (imem_serve && (imem_addr[31:14] == 18'b0))
                imem_rdata <= imem[imem_word_index[11:0]];
            else
                imem_rdata <= 32'h0000_0013;

            if (imem_serve)
                imem_resp_count <= imem_resp_count + 1;
        end
    end

    // ---- data memory model --------------------------------------------
    // Valid window is 0x0001_0000 .. 0x0001_3FFF (4096 words). Outside that
    // range dmem_err is asserted.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dmem_ready      <= 1'b0;
            dmem_rdata      <= 32'b0;
            dmem_err        <= 1'b0;
            dmem_resp_count <= 0;
            dmem_wait_hold  <= 1'b0;
        end else begin
            dmem_serve = dmem_valid;
            if (dmem_valid && dmem_wait_period != 0 && !dmem_wait_hold &&
                ((dmem_resp_count % dmem_wait_period) == (dmem_wait_period - 1))) begin
                dmem_serve     = 1'b0;
                dmem_wait_hold <= 1'b1;
            end else begin
                dmem_wait_hold <= 1'b0;
            end

            dmem_ready <= dmem_serve;
            dmem_err   <= dmem_serve &&
                          ((dmem_addr & 32'hFFFF_C000) != 32'h0001_0000);
            if (dmem_serve && ((dmem_addr & 32'hFFFF_C000) == 32'h0001_0000)) begin
                dmem_rdata <= dmem[dmem_word_index[11:0]];
                if (dmem_we) begin
                    if (dmem_be[0]) dmem[dmem_word_index[11:0]][7:0]   <= dmem_wdata[7:0];
                    if (dmem_be[1]) dmem[dmem_word_index[11:0]][15:8]  <= dmem_wdata[15:8];
                    if (dmem_be[2]) dmem[dmem_word_index[11:0]][23:16] <= dmem_wdata[23:16];
                    if (dmem_be[3]) dmem[dmem_word_index[11:0]][31:24] <= dmem_wdata[31:24];
                end
            end else begin
                dmem_rdata <= 32'b0;
            end

            if (dmem_serve)
                dmem_resp_count <= dmem_resp_count + 1;
        end
    end

    // ---- result detection ---------------------------------------------
    // The env exits via a machine ECALL (mcause==11). gp holds the verdict.
    // The ecall fault is raised while ecall is in ID, but the preceding
    // "li gp,1" / fail-path gp arithmetic may still be draining through WB,
    // so let the pipeline settle before sampling gp. The trap handler does
    // not touch gp, so the value is stable once those in-flight writes retire.
    task report_and_finish;
        reg [31:0] gp_val;
        integer subtest;
        begin
            repeat (5) @(posedge clk);
            gp_val = dut.u_id.u_reg_file.regs[3];
            if (gp_val == 32'd1) begin
                $display("PASS: %0s", test_name);
            end else begin
                subtest = gp_val >> 1;
                $display("FAIL: %0s gp=%08h subtest=%0d", test_name, gp_val, subtest);
            end
            $finish;
        end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        cycle_count = 0;
        max_cycles = 100000;
        imem_wait_period = 0;
        dmem_wait_period = 0;
        imem_resp_count = 0;
        dmem_resp_count = 0;
        imem_wait_hold = 1'b0;
        dmem_wait_hold = 1'b0;
        imem_serve = 1'b0;
        dmem_serve = 1'b0;
        test_name = "riscv_test";
        imem_hex = "";
        dmem_hex = "";
        have_dmem = 0;
        trace_en = 0;
        trap_seen = 1'b0;

        for (i = 0; i < 4096; i = i + 1) begin
            imem[i] = 32'h0000_0013;
            dmem[i] = 32'b0;
        end

        if (!$value$plusargs("IMEM_HEX=%s", imem_hex)) begin
            $display("FAIL: missing +IMEM_HEX=<file>");
            $finish;
        end
        if ($value$plusargs("DMEM_HEX=%s", dmem_hex)) have_dmem = 1;
        if ($value$plusargs("NAME=%s", test_name)) begin end
        if ($value$plusargs("MAX_CYCLES=%d", max_cycles)) begin end
        if ($value$plusargs("IMEM_WAIT_PERIOD=%d", imem_wait_period)) begin end
        if ($value$plusargs("DMEM_WAIT_PERIOD=%d", dmem_wait_period)) begin end
        if ($value$plusargs("TRACE=%d", trace_en)) begin end

        $readmemh(imem_hex, imem);
        if (have_dmem) begin
            // $readmemh tolerates an empty file; guard avoids a warning when
            // the test has no .data image.
            $readmemh(dmem_hex, dmem);
        end

        repeat (3) @(posedge clk);
        rst_n = 1'b1;
    end

    // ---- main observation loop ----------------------------------------
    always @(posedge clk) begin
        if (rst_n) begin
            cycle_count = cycle_count + 1;
            // Trap tracer: log every trap (cause/pc/tval) to tell a real core
            // bug apart from a test-environment mismatch on trap semantics.
            if (trace_en && dut.trap_valid) begin
                $display("TRAP c=%0d cause=%0d pc=%08h tval=%08h target=%08h",
                         cycle_count, dut.trap_cause, dut.trap_pc,
                         dut.trap_tval, dut.trap_target);
            end
            // Trace level 2: per-cycle EX-stage mret/mepc visibility.
            if (trace_en >= 2 && dut.ex_valid && dut.ex_mret) begin
                $display("MRET c=%0d ex_pc=%08h mepc_value=%08h",
                         cycle_count, dut.ex_pc, dut.u_csr_file.mepc);
            end
            // Trace level 3: per-cycle committed IF PC within a window.
            if (trace_en >= 3 && dut.if_valid && imem_ready) begin
                $display("IF  c=%0d pc=%08h instr=%08h", cycle_count,
                         dut.if_pc, dut.if_instr);
            end
            // Trace level 4: memory/stall interaction visibility.
            if (trace_en >= 4) begin
                $display("c=%0d mem_v=%b mem_i=%08h mem_wait=%b dv=%b drdy=%b | ex_i=%08h | wb_i=%08h rf_we=%b rf_rd=%0d rf_d=%08h || s[pc,ii,ie,em,mw]=%b%b%b%b%b f[ii,ie,em,mw]=%b%b%b%b",
                         cycle_count, dut.mem_valid, dut.mem_instr, dut.mem_wait,
                         dmem_valid, dmem_ready,
                         dut.ex_instr,
                         dut.wb_instr, dut.rf_we, dut.rf_waddr, dut.wb_data,
                         dut.stall_pc, dut.stall_if_id, dut.stall_id_ex,
                         dut.stall_ex_mem, dut.stall_mem_wb,
                         dut.flush_if_id, dut.flush_id_ex,
                         dut.flush_ex_mem, dut.flush_mem_wb);
            end
            // Trace level 5: if_stage internal fetch/hold/kill state.
            if (trace_en >= 5) begin
                $display("IFX c=%0d ifv=%b ifpc=%08h ifi=%08h | irdy=%b iaddr=%08h ird=%08h pcc=%08h preq=%08h | redir=%b | kill=%b hold=%b fwait=%b pcstall=%b | idv=%b idi=%08h exv=%b exi=%08h",
                         cycle_count, dut.if_valid, dut.if_pc, dut.if_instr,
                         imem_ready, dut.imem_addr, imem_rdata,
                         dut.u_if.pc_current, dut.u_if.pc_req_q,
                         dut.pc_redirect_valid,
                         dut.u_if.kill_fetch_q, dut.u_if.hold_valid_q,
                         dut.u_if.fetch_wait, dut.u_if.pc_stall,
                         dut.id_valid, dut.id_instr, dut.ex_valid, dut.ex_instr);
            end
            // Catch the pass/fail ECALL the cycle the trap fires.
            if (dut.trap_valid && (dut.trap_cause == 32'd11)) begin
                report_and_finish;
            end
            if (cycle_count >= max_cycles) begin
                $display("FAIL: %0s TIMEOUT after %0d cycles (pc=%08h instr=%08h)",
                         test_name, cycle_count, dut.if_pc, dut.if_instr);
                $finish;
            end
        end
    end
endmodule
