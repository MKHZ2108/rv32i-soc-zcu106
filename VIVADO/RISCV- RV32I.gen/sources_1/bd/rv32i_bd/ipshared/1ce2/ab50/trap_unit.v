`timescale 1ns/1ps

module trap_unit(
    input  wire        if_valid,
    input  wire        if_fault,
    input  wire [31:0] if_pc,
    input  wire [31:0] if_fault_cause,
    input  wire [31:0] if_fault_tval,
    input  wire        id_valid,
    input  wire        id_fault,
    input  wire [31:0] id_pc,
    input  wire [31:0] id_fault_cause,
    input  wire [31:0] id_fault_tval,
    input  wire        ex_valid,
    input  wire        ex_fault,
    input  wire [31:0] ex_pc,
    input  wire [31:0] ex_fault_cause,
    input  wire [31:0] ex_fault_tval,
    input  wire        mem_valid,
    input  wire        mem_fault,
    input  wire [31:0] mem_pc,
    input  wire [31:0] mem_fault_cause,
    input  wire [31:0] mem_fault_tval,
    input  wire        wb_valid,
    input  wire        wb_fault,
    input  wire [31:0] wb_pc,
    input  wire [31:0] wb_fault_cause,
    input  wire [31:0] wb_fault_tval,
    input  wire [31:0] mtvec_value,
    output reg         trap_valid,
    output reg  [31:0] trap_pc,
    output reg  [31:0] trap_cause,
    output reg  [31:0] trap_tval,
    output wire [31:0] trap_target
);
    wire [31:0] mtvec_base;
    wire [31:0] interrupt_vector_offset;

    assign mtvec_base = {mtvec_value[31:2], 2'b00};
    assign interrupt_vector_offset = {trap_cause[29:0], 2'b00};
    assign trap_target =
        (mtvec_value[1:0] == 2'b01 && trap_cause[31]) ?
        (mtvec_base + interrupt_vector_offset) :
        mtvec_base;

    always @(*) begin
        trap_valid = 1'b0;
        trap_pc = 32'b0;
        trap_cause = 32'b0;
        trap_tval = 32'b0;

        if (wb_valid && wb_fault) begin
            trap_valid = 1'b1;
            trap_pc = wb_pc;
            trap_cause = wb_fault_cause;
            trap_tval = wb_fault_tval;
        end else if (mem_valid && mem_fault) begin
            trap_valid = 1'b1;
            trap_pc = mem_pc;
            trap_cause = mem_fault_cause;
            trap_tval = mem_fault_tval;
        end else if (ex_valid && ex_fault) begin
            trap_valid = 1'b1;
            trap_pc = ex_pc;
            trap_cause = ex_fault_cause;
            trap_tval = ex_fault_tval;
        end else if (id_valid && id_fault) begin
            trap_valid = 1'b1;
            trap_pc = id_pc;
            trap_cause = id_fault_cause;
            trap_tval = id_fault_tval;
        end else if (if_valid && if_fault) begin
            trap_valid = 1'b1;
            trap_pc = if_pc;
            trap_cause = if_fault_cause;
            trap_tval = if_fault_tval;
        end
    end
endmodule
