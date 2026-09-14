`timescale 1ns/1ps

module commit_stall_ext_tb;
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
    integer errors;

    rv32i_core dut (
        .clk(clk), .rst_n(rst_n),
        .irq_external(1'b0),
        .imem_valid(imem_valid), .imem_addr(imem_addr),
        .imem_ready(imem_ready), .imem_rdata(imem_rdata), .imem_err(imem_err),
        .dmem_valid(dmem_valid), .dmem_we(dmem_we), .dmem_be(dmem_be),
        .dmem_addr(dmem_addr), .dmem_wdata(dmem_wdata),
        .dmem_ready(dmem_ready), .dmem_rdata(dmem_rdata), .dmem_err(dmem_err),
        .debug_halted(debug_halted), .debug_pc(debug_pc), .debug_instr(debug_instr)
    );

    always #5 clk = ~clk;

    task check;
        input condition;
        input [127:0] message;
        begin
            if (!condition) begin
                $display("FAIL: %0s", message);
                errors = errors + 1;
            end
        end
    endtask

    task force_wb_payload;
        input fault;
        input mret;
        begin
            force dut.wb_valid = 1'b1;
            force dut.wb_fault = fault;
            force dut.wb_mret = mret;
            force dut.wb_reg_write = 1'b0;
            force dut.wb_csr_we = 1'b0;
            force dut.wb_rd = 5'd0;
            force dut.wb_pc = 32'h0000_0040;
            force dut.wb_fault_cause = 32'd2;
            force dut.wb_fault_tval = 32'hDEAD_BEEF;
            force dut.stall_mem_wb = 1'b1;
        end
    endtask

    task release_wb_payload;
        begin
            release dut.wb_valid;
            release dut.wb_fault;
            release dut.wb_mret;
            release dut.wb_reg_write;
            release dut.wb_csr_we;
            release dut.wb_rd;
            release dut.wb_pc;
            release dut.wb_fault_cause;
            release dut.wb_fault_tval;
            release dut.stall_mem_wb;
        end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        imem_ready = 1'b0;
        imem_rdata = 32'h0000_0013;
        imem_err = 1'b0;
        dmem_ready = 1'b0;
        dmem_rdata = 32'b0;
        dmem_err = 1'b0;
        errors = 0;

        repeat (3) @(posedge clk);
        rst_n = 1'b1;
        repeat (2) @(posedge clk);

        force_wb_payload(1'b0, 1'b0);
        repeat (4) @(posedge clk);
        #1;
        check(dut.u_csr_file.instret_counter == 64'd1, "retire fires once while WB is stalled");
        release_wb_payload();
        @(posedge clk);
        #1;

        dut.u_csr_file.mstatus = 32'h0000_1800; // MPP=M, MIE=0, MPIE=0.
        force_wb_payload(1'b0, 1'b1);
        repeat (4) @(posedge clk);
        #1;
        check(dut.u_csr_file.mstatus[3] == 1'b0 &&
              dut.u_csr_file.mstatus[7] == 1'b1,
              "MRET side effect fires once while WB is stalled");
        check(dut.u_csr_file.instret_counter == 64'd2, "MRET retire fires once");
        release_wb_payload();

        if (errors == 0) begin
            $display("PASS: commit_stall_ext_tb");
            $finish;
        end

        $display("FAIL: commit_stall_ext_tb %0d errors", errors);
        $finish;
    end
endmodule
