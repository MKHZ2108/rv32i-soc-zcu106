`timescale 1ns/1ps

module arch_mini_core_tb;
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

    reg [31:0] imem [0:255];
    reg [31:0] dmem [0:255];
    reg [31:0] expected [0:31];
    reg [31:0] expect0;
    reg [31:0] expect1;
    reg [31:0] expect2;
    reg [31:0] expect3;
    reg [31:0] expect4;
    reg [31:0] expect5;
    reg [31:0] expect6;
    reg [31:0] expect7;
    reg [1023:0] program_file;
    reg [511:0] test_name;
    integer cycles;
    integer program_words;
    integer num_expect;
    integer errors;
    integer i;
    integer cycle_count;
    integer debug_enable;
    integer imem_wait_period;
    integer imem_response_count;
    reg     imem_wait_hold;
    reg     serve_imem;
    wire [31:0] dmem_index;

    assign dmem_index = (dmem_addr - 32'h0001_0000) >> 2;

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

    task check;
        input condition;
        input [255:0] message;
        begin
            if (!condition) begin
                $display("FAIL: %0s", message);
                errors = errors + 1;
            end
        end
    endtask

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            imem_ready <= 1'b0;
            imem_rdata <= 32'h0000_0013;
            imem_err <= 1'b0;
            imem_response_count <= 0;
            imem_wait_hold <= 1'b0;
        end else begin
            serve_imem = imem_valid;
            if (imem_valid && imem_wait_period != 0 && !imem_wait_hold &&
                ((imem_response_count % imem_wait_period) == (imem_wait_period - 1))) begin
                serve_imem = 1'b0;
                imem_wait_hold <= 1'b1;
            end else begin
                imem_wait_hold <= 1'b0;
            end

            imem_ready <= serve_imem;
            imem_err <= serve_imem && |imem_addr[31:10];
            if (serve_imem && !(|imem_addr[31:10]))
                imem_rdata <= imem[imem_addr[9:2]];
            else
                imem_rdata <= 32'h0000_0013;

            if (serve_imem)
                imem_response_count <= imem_response_count + 1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dmem_ready <= 1'b0;
            dmem_rdata <= 32'b0;
            dmem_err <= 1'b0;
        end else begin
            dmem_ready <= dmem_valid;
            dmem_err <= dmem_valid && ((dmem_addr & 32'hFFFF_0000) != 32'h0001_0000);
            if (dmem_valid && ((dmem_addr & 32'hFFFF_0000) == 32'h0001_0000)) begin
                dmem_rdata <= dmem[dmem_index[7:0]];
                if (dmem_we) begin
                    if (dmem_be[0]) dmem[dmem_index[7:0]][7:0] <= dmem_wdata[7:0];
                    if (dmem_be[1]) dmem[dmem_index[7:0]][15:8] <= dmem_wdata[15:8];
                    if (dmem_be[2]) dmem[dmem_index[7:0]][23:16] <= dmem_wdata[23:16];
                    if (dmem_be[3]) dmem[dmem_index[7:0]][31:24] <= dmem_wdata[31:24];
                end
            end else begin
                dmem_rdata <= 32'b0;
            end
        end
    end

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        errors = 0;
        cycles = 400;
        program_words = 256;
        num_expect = 0;
        cycle_count = 0;
        debug_enable = 0;
        imem_wait_period = 0;
        imem_response_count = 0;
        imem_wait_hold = 1'b0;
        serve_imem = 1'b0;
        test_name = "mini_arch";
        program_file = "";
        expect0 = 32'b0;
        expect1 = 32'b0;
        expect2 = 32'b0;
        expect3 = 32'b0;
        expect4 = 32'b0;
        expect5 = 32'b0;
        expect6 = 32'b0;
        expect7 = 32'b0;

        for (i = 0; i < 256; i = i + 1) begin
            imem[i] = 32'h0000_0013;
            dmem[i] = 32'b0;
        end

        for (i = 0; i < 32; i = i + 1) begin
            dut.u_id.u_reg_file.regs[i] = 32'b0;
        end

        for (i = 0; i < 32; i = i + 1)
            expected[i] = 32'b0;

        if (!$value$plusargs("PROGRAM=%s", program_file)) begin
            $display("FAIL: missing +PROGRAM=<hex-file>");
            $finish;
        end
        if ($value$plusargs("NAME=%s", test_name)) begin end
        if ($value$plusargs("CYCLES=%d", cycles)) begin end
        if ($value$plusargs("PROGRAM_WORDS=%d", program_words)) begin end
        if ($value$plusargs("NUM_EXPECT=%d", num_expect)) begin end
        if ($value$plusargs("DEBUG=%d", debug_enable)) begin end
        if ($value$plusargs("IMEM_WAIT_PERIOD=%d", imem_wait_period)) begin end
        if ($value$plusargs("EXPECT0=%h", expect0)) begin end
        if ($value$plusargs("EXPECT1=%h", expect1)) begin end
        if ($value$plusargs("EXPECT2=%h", expect2)) begin end
        if ($value$plusargs("EXPECT3=%h", expect3)) begin end
        if ($value$plusargs("EXPECT4=%h", expect4)) begin end
        if ($value$plusargs("EXPECT5=%h", expect5)) begin end
        if ($value$plusargs("EXPECT6=%h", expect6)) begin end
        if ($value$plusargs("EXPECT7=%h", expect7)) begin end

        expected[0] = expect0;
        expected[1] = expect1;
        expected[2] = expect2;
        expected[3] = expect3;
        expected[4] = expect4;
        expected[5] = expect5;
        expected[6] = expect6;
        expected[7] = expect7;

        $readmemh(program_file, imem, 0, program_words - 1);

        repeat (3) @(posedge clk);
        rst_n = 1'b1;
        repeat (cycles) @(posedge clk);

        for (i = 0; i < num_expect; i = i + 1) begin
            if (dmem[i] !== expected[i]) begin
                $display("FAIL: %0s signature[%0d]=%08h expected=%08h",
                         test_name, i, dmem[i], expected[i]);
                errors = errors + 1;
            end
        end

        if (errors != 0) begin
            $display("DEBUG: x3=%08h x4=%08h x5=%08h x6=%08h x7=%08h x8=%08h x9=%08h x10=%08h x11=%08h",
                     dut.u_id.u_reg_file.regs[3], dut.u_id.u_reg_file.regs[4],
                     dut.u_id.u_reg_file.regs[5], dut.u_id.u_reg_file.regs[6],
                     dut.u_id.u_reg_file.regs[7], dut.u_id.u_reg_file.regs[8],
                     dut.u_id.u_reg_file.regs[9], dut.u_id.u_reg_file.regs[10],
                     dut.u_id.u_reg_file.regs[11]);
            $display("DEBUG: dmem0=%08h dmem1=%08h dmem2=%08h dmem3=%08h dmem4=%08h dmem5=%08h dmem6=%08h dmem7=%08h",
                     dmem[0], dmem[1], dmem[2], dmem[3],
                     dmem[4], dmem[5], dmem[6], dmem[7]);
        end

        check(!dut.trap_valid, "unexpected trap at end of mini arch test");
        check(dut.u_id.u_reg_file.regs[0] == 32'b0, "x0 must stay zero");
        check(debug_halted == 1'b0, "debug_halted stays low");

        if (errors == 0) begin
            $display("PASS: %0s", test_name);
            $finish;
        end

        $display("FAIL: %0s %0d errors", test_name, errors);
        $finish;
    end

    always @(posedge clk) begin
        if (rst_n) begin
            cycle_count = cycle_count + 1;
            if (debug_enable && cycle_count < 80) begin
                $display("DBG c=%0d if_pc=%08h if_i=%08h if_v=%0b id_i=%08h id_v=%0b ex_i=%08h ex_v=%0b mem_i=%08h mem_v=%0b mem_rd=%0b mem_wr=%0b mem_wait=%0b d_v=%0b d_rdy=%0b d_we=%0b d_addr=%08h d_wdata=%08h d_rdata=%08h wb_i=%08h wb_v=%0b rf_we=%0b rf_rd=%0d rf_data=%08h",
                         cycle_count, dut.if_pc, dut.if_instr, dut.if_valid,
                         dut.id_instr, dut.id_valid, dut.ex_instr, dut.ex_valid,
                         dut.mem_instr, dut.mem_valid, dut.mem_mem_read,
                         dut.mem_mem_write, dut.mem_wait,
                         dmem_valid, dmem_ready, dmem_we, dmem_addr,
                         dmem_wdata, dmem_rdata, dut.wb_instr, dut.wb_valid,
                         dut.rf_we, dut.rf_waddr, dut.wb_data);
            end
        end
    end
endmodule
