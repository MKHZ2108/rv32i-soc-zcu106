`timescale 1ns/1ps

module external_interrupt_ext_tb;
    reg clk;
    reg rst_n;
    reg irq_external;

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

    reg [31:0] imem [0:63];
    integer i;
    integer errors;
    integer timeout_cycles;
    integer x5_at_trap;
    reg interrupt_seen;
    reg early_interrupt;

    localparam [31:0] MCAUSE_MACHINE_EXTERNAL_INTERRUPT = 32'h8000_000B;

    rv32i_core dut (
        .clk(clk),
        .rst_n(rst_n),
        .irq_external(irq_external),
        .imem_valid(imem_valid),
        .imem_addr(imem_addr),
        .imem_cancel(),
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

    function [31:0] i_type;
        input [31:0] imm_i;
        input [4:0]  rs1_i;
        input [2:0]  f3;
        input [4:0]  rd_i;
        input [6:0]  opcode_i;
        begin
            i_type = {imm_i[11:0], rs1_i, f3, rd_i, opcode_i};
        end
    endfunction

    function [31:0] csr_write;
        input [11:0] csr_i;
        input [4:0]  rs1_i;
        begin
            csr_write = {csr_i, rs1_i, 3'b001, 5'd0, 7'b1110011};
        end
    endfunction

    function [31:0] jal;
        input [31:0] imm_i;
        input [4:0]  rd_i;
        begin
            jal = {imm_i[20], imm_i[10:1], imm_i[11],
                   imm_i[19:12], rd_i, 7'b1101111};
        end
    endfunction

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
        end else begin
            imem_ready <= imem_valid;
            imem_err <= |imem_addr[31:8];
            if (imem_valid && !(|imem_addr[31:8]))
                imem_rdata <= imem[imem_addr[7:2]];
            else
                imem_rdata <= 32'h0000_0013;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dmem_ready <= 1'b0;
            dmem_rdata <= 32'b0;
            dmem_err <= 1'b0;
        end else begin
            dmem_ready <= dmem_valid;
            dmem_rdata <= 32'b0;
            dmem_err <= dmem_valid;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            early_interrupt <= 1'b0;
        else if (dut.trap_fire &&
                 dut.wb_fault_cause == MCAUSE_MACHINE_EXTERNAL_INTERRUPT &&
                 dut.wb_pc < 32'h0000_0018)
            early_interrupt <= 1'b1;
    end

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        irq_external = 1'b1;
        errors = 0;
        interrupt_seen = 1'b0;
        early_interrupt = 1'b0;
        x5_at_trap = 0;

        for (i = 0; i < 64; i = i + 1)
            imem[i] = 32'h0000_0013;

        // Keep IRQ asserted from reset. It must remain masked until both
        // mstatus.MIE and mie.MEIE have been programmed.
        imem[0] = i_type(32'h0000_0080, 5'd0, 3'b000, 5'd1, 7'b0010011);
        imem[1] = csr_write(12'h305, 5'd1); // mtvec = 0x80, direct mode
        imem[2] = i_type(32'hFFFF_F800, 5'd0, 3'b000, 5'd1, 7'b0010011);
        imem[3] = csr_write(12'h304, 5'd1); // mie.MEIE = 1
        imem[4] = i_type(32'h0000_0008, 5'd0, 3'b000, 5'd1, 7'b0010011);
        imem[5] = csr_write(12'h300, 5'd1); // mstatus.MIE = 1
        imem[6] = i_type(32'h0000_0001, 5'd5, 3'b000, 5'd5, 7'b0010011);
        imem[7] = jal(32'hFFFF_FFFC, 5'd0);

        // Machine external interrupt handler.
        imem[32] = i_type(32'h0000_0001, 5'd10, 3'b000, 5'd10, 7'b0010011);
        imem[33] = 32'h3020_0073; // mret

        repeat (3) @(posedge clk);
        rst_n = 1'b1;

        for (timeout_cycles = 0;
             timeout_cycles < 300 && !interrupt_seen;
             timeout_cycles = timeout_cycles + 1) begin
            @(posedge clk);
            #1;
            if (dut.u_csr_file.mcause == MCAUSE_MACHINE_EXTERNAL_INTERRUPT) begin
                interrupt_seen = 1'b1;
                x5_at_trap = dut.u_id.u_reg_file.regs[5];
                irq_external = 1'b0;
            end
        end

        check(interrupt_seen, "enabled external IRQ reaches the trap handler");
        check(!early_interrupt, "IRQ stays masked during CSR setup");
        check(dut.u_csr_file.mepc == 32'h0000_0018 ||
              dut.u_csr_file.mepc == 32'h0000_001C,
              "mepc identifies an unexecuted main-loop instruction");
        check(dut.u_csr_file.mtval == 32'b0, "interrupt writes zero mtval");
        check(dut.u_csr_file.mstatus[3] == 1'b0 &&
              dut.u_csr_file.mstatus[7] == 1'b1,
              "trap entry clears MIE and saves it in MPIE");

        repeat (100) @(posedge clk);
        #1;
        check(dut.u_id.u_reg_file.regs[10] == 32'd1,
              "external interrupt handler executes exactly once");
        check(dut.u_id.u_reg_file.regs[5] > x5_at_trap,
              "mret resumes the interrupted main loop");
        check(dut.u_csr_file.mstatus[3] == 1'b1,
              "mret restores global interrupt enable");
        check(dut.u_csr_file.mcause == MCAUSE_MACHINE_EXTERNAL_INTERRUPT,
              "mcause reports machine external interrupt");

        if (errors == 0) begin
            $display("PASS: external_interrupt_ext_tb");
            $finish;
        end

        $display("FAIL: external_interrupt_ext_tb %0d errors", errors);
        $finish;
    end
endmodule
