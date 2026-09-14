`timescale 1ns/1ps

module trap_unit_tb;
    reg         if_valid;
    reg         if_fault;
    reg  [31:0] if_pc;
    reg  [31:0] if_fault_cause;
    reg  [31:0] if_fault_tval;
    reg         id_valid;
    reg         id_fault;
    reg  [31:0] id_pc;
    reg  [31:0] id_fault_cause;
    reg  [31:0] id_fault_tval;
    reg         ex_valid;
    reg         ex_fault;
    reg  [31:0] ex_pc;
    reg  [31:0] ex_fault_cause;
    reg  [31:0] ex_fault_tval;
    reg         mem_valid;
    reg         mem_fault;
    reg  [31:0] mem_pc;
    reg  [31:0] mem_fault_cause;
    reg  [31:0] mem_fault_tval;
    reg         wb_valid;
    reg         wb_fault;
    reg  [31:0] wb_pc;
    reg  [31:0] wb_fault_cause;
    reg  [31:0] wb_fault_tval;
    reg  [31:0] mtvec_value;
    wire        trap_valid;
    wire [31:0] trap_pc;
    wire [31:0] trap_cause;
    wire [31:0] trap_tval;
    wire [31:0] trap_target;
    integer errors;

    trap_unit dut (
        .if_valid(if_valid), .if_fault(if_fault), .if_pc(if_pc),
        .if_fault_cause(if_fault_cause), .if_fault_tval(if_fault_tval),
        .id_valid(id_valid), .id_fault(id_fault), .id_pc(id_pc),
        .id_fault_cause(id_fault_cause), .id_fault_tval(id_fault_tval),
        .ex_valid(ex_valid), .ex_fault(ex_fault), .ex_pc(ex_pc),
        .ex_fault_cause(ex_fault_cause), .ex_fault_tval(ex_fault_tval),
        .mem_valid(mem_valid), .mem_fault(mem_fault), .mem_pc(mem_pc),
        .mem_fault_cause(mem_fault_cause), .mem_fault_tval(mem_fault_tval),
        .wb_valid(wb_valid), .wb_fault(wb_fault), .wb_pc(wb_pc),
        .wb_fault_cause(wb_fault_cause), .wb_fault_tval(wb_fault_tval),
        .mtvec_value(mtvec_value),
        .trap_valid(trap_valid), .trap_pc(trap_pc),
        .trap_cause(trap_cause), .trap_tval(trap_tval),
        .trap_target(trap_target)
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

    initial begin
        errors = 0;
        if_valid = 1'b0;
        if_fault = 1'b0;
        if_pc = 32'b0;
        if_fault_cause = 32'b0;
        if_fault_tval = 32'b0;
        id_valid = 1'b0;
        id_fault = 1'b0;
        id_pc = 32'b0;
        id_fault_cause = 32'b0;
        id_fault_tval = 32'b0;
        ex_valid = 1'b0;
        ex_fault = 1'b0;
        ex_pc = 32'b0;
        ex_fault_cause = 32'b0;
        ex_fault_tval = 32'b0;
        mem_valid = 1'b0;
        mem_fault = 1'b0;
        mem_pc = 32'b0;
        mem_fault_cause = 32'b0;
        mem_fault_tval = 32'b0;
        wb_valid = 1'b0;
        wb_fault = 1'b0;
        wb_pc = 32'b0;
        wb_fault_cause = 32'b0;
        wb_fault_tval = 32'b0;
        mtvec_value = 32'h0000_0083;
        #1;
        check(!trap_valid && trap_target == 32'h0000_0080, "idle/direct mtvec base");

        id_valid = 1'b1;
        id_fault = 1'b1;
        id_pc = 32'h0000_0020;
        id_fault_cause = 32'd11;
        #1;
        check(trap_valid && trap_pc == 32'h0000_0020 && trap_cause == 32'd11,
              "ID trap selected");

        mem_valid = 1'b1;
        mem_fault = 1'b1;
        mem_pc = 32'h0000_0010;
        mem_fault_cause = 32'd4;
        mem_fault_tval = 32'h0001_0002;
        #1;
        check(trap_valid && trap_pc == 32'h0000_0010 &&
              trap_cause == 32'd4 && trap_tval == 32'h0001_0002,
              "older MEM trap priority");

        mem_valid = 1'b0;
        mem_fault = 1'b0;
        id_fault_cause = 32'h8000_000B;
        mtvec_value = 32'h0000_0081;
        #1;
        check(trap_target == 32'h0000_00AC,
              "vectored mtvec uses external interrupt cause");

        if (errors == 0) begin
            $display("PASS: trap_unit priority and target");
            $finish;
        end

        $display("FAIL: %0d errors", errors);
        $finish;
    end
endmodule
