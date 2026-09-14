`timescale 1ns/1ps

module mem_stage_ext_tb;
    reg         mem_valid;
    reg         mem_fault_in;
    reg  [31:0] mem_fault_cause_in;
    reg  [31:0] mem_fault_tval_in;
    reg  [31:0] mem_alu_result;
    reg  [31:0] mem_store_data;
    reg         mem_mem_read;
    reg         mem_mem_write;
    reg  [1:0]  mem_mem_size;
    reg         mem_mem_unsigned;
    wire        dmem_valid;
    wire        dmem_we;
    wire [3:0]  dmem_be;
    wire [31:0] dmem_addr;
    wire [31:0] dmem_wdata;
    reg         dmem_ready;
    reg  [31:0] dmem_rdata;
    reg         dmem_err;
    wire        mem_wait;
    wire        mem_fault_out;
    wire [31:0] mem_fault_cause;
    wire [31:0] mem_fault_tval;
    wire [31:0] mem_load_data;

    integer errors;

    mem_stage dut (
        .mem_valid(mem_valid),
        .mem_fault_in(mem_fault_in),
        .mem_fault_cause_in(mem_fault_cause_in),
        .mem_fault_tval_in(mem_fault_tval_in),
        .mem_alu_result(mem_alu_result),
        .mem_store_data(mem_store_data),
        .mem_mem_read(mem_mem_read),
        .mem_mem_write(mem_mem_write),
        .mem_mem_size(mem_mem_size),
        .mem_mem_unsigned(mem_mem_unsigned),
        .dmem_valid(dmem_valid),
        .dmem_we(dmem_we),
        .dmem_be(dmem_be),
        .dmem_addr(dmem_addr),
        .dmem_wdata(dmem_wdata),
        .dmem_ready(dmem_ready),
        .dmem_rdata(dmem_rdata),
        .dmem_err(dmem_err),
        .mem_wait(mem_wait),
        .mem_fault_out(mem_fault_out),
        .mem_fault_cause(mem_fault_cause),
        .mem_fault_tval(mem_fault_tval),
        .mem_load_data(mem_load_data)
    );

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

    task init_inputs;
        begin
            mem_valid = 1'b1;
            mem_fault_in = 1'b0;
            mem_fault_cause_in = 32'hAAAA_0000;
            mem_fault_tval_in = 32'hBBBB_0000;
            mem_alu_result = 32'h0001_0000;
            mem_store_data = 32'hAABB_CCDD;
            mem_mem_read = 1'b0;
            mem_mem_write = 1'b0;
            mem_mem_size = 2'd2;
            mem_mem_unsigned = 1'b0;
            dmem_ready = 1'b1;
            dmem_rdata = 32'h807F_34FF;
            dmem_err = 1'b0;
        end
    endtask

    initial begin
        errors = 0;
        init_inputs();

        mem_mem_write = 1'b1;
        mem_mem_size = 2'd0;

        mem_alu_result = 32'h0001_0000; #1;
        check(dmem_valid && dmem_we && dmem_be == 4'b0001 && dmem_wdata == 32'h0000_00DD,
              "SB offset 0 byte enable/data");
        mem_alu_result = 32'h0001_0001; #1;
        check(dmem_be == 4'b0010 && dmem_wdata == 32'h0000_DD00, "SB offset 1 byte enable/data");
        mem_alu_result = 32'h0001_0002; #1;
        check(dmem_be == 4'b0100 && dmem_wdata == 32'h00DD_0000, "SB offset 2 byte enable/data");
        mem_alu_result = 32'h0001_0003; #1;
        check(dmem_be == 4'b1000 && dmem_wdata == 32'hDD00_0000, "SB offset 3 byte enable/data");

        mem_mem_size = 2'd1;
        mem_alu_result = 32'h0001_0000; #1;
        check(dmem_be == 4'b0011 && dmem_wdata == 32'h0000_CCDD, "SH low half");
        mem_alu_result = 32'h0001_0002; #1;
        check(dmem_be == 4'b1100 && dmem_wdata == 32'hCCDD_0000, "SH high half");

        mem_mem_size = 2'd2;
        mem_alu_result = 32'h0001_0000; #1;
        check(dmem_be == 4'b1111 && dmem_wdata == 32'hAABB_CCDD, "SW word");

        init_inputs();
        mem_mem_read = 1'b1;
        mem_mem_size = 2'd0;
        mem_alu_result = 32'h0001_0000;
        mem_mem_unsigned = 1'b0; #1;
        check(mem_load_data == 32'hFFFF_FFFF, "LB sign extend byte 0");
        mem_mem_unsigned = 1'b1; #1;
        check(mem_load_data == 32'h0000_00FF, "LBU zero extend byte 0");

        mem_alu_result = 32'h0001_0003;
        mem_mem_unsigned = 1'b0; #1;
        check(mem_load_data == 32'hFFFF_FF80, "LB sign extend byte 3");

        mem_mem_size = 2'd1;
        mem_alu_result = 32'h0001_0000;
        mem_mem_unsigned = 1'b0; #1;
        check(mem_load_data == 32'h0000_34FF, "LH low half positive");
        mem_alu_result = 32'h0001_0002;
        mem_mem_unsigned = 1'b0; #1;
        check(mem_load_data == 32'hFFFF_807F, "LH high half negative");
        mem_mem_unsigned = 1'b1; #1;
        check(mem_load_data == 32'h0000_807F, "LHU high half");

        mem_mem_size = 2'd2;
        mem_alu_result = 32'h0001_0000; #1;
        check(mem_load_data == 32'h807F_34FF, "LW word");

        dmem_ready = 1'b0;
        #1;
        check(mem_wait && dmem_valid, "load waits while dmem not ready");
        dmem_ready = 1'b1;

        mem_mem_size = 2'd1;
        mem_alu_result = 32'h0001_0001;
        #1;
        check(mem_fault_out && mem_fault_cause == 32'd4 && mem_fault_tval == 32'h0001_0001,
              "misaligned LH fault");
        check(!dmem_valid, "misaligned access suppresses dmem_valid");

        mem_mem_read = 1'b0;
        mem_mem_write = 1'b1;
        mem_mem_size = 2'd2;
        mem_alu_result = 32'h0001_0002;
        #1;
        check(mem_fault_out && mem_fault_cause == 32'd6, "misaligned SW fault");

        mem_alu_result = 32'h0001_0000;
        dmem_err = 1'b1;
        #1;
        check(mem_fault_out && mem_fault_cause == 32'd7 && mem_fault_tval == 32'h0001_0000,
              "store access fault");

        mem_fault_in = 1'b1;
        mem_fault_cause_in = 32'h0000_1234;
        mem_fault_tval_in = 32'h0000_5678;
        dmem_err = 1'b0;
        #1;
        check(mem_fault_out && mem_fault_cause == 32'h0000_1234 &&
              mem_fault_tval == 32'h0000_5678, "incoming fault preserved");

        if (errors == 0) begin
            $display("PASS: mem_stage_ext_tb");
            $finish;
        end

        $display("FAIL: mem_stage_ext_tb %0d errors", errors);
        $finish;
    end
endmodule
