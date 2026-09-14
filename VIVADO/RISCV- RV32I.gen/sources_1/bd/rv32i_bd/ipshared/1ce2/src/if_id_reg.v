`timescale 1ns/1ps

module if_id_reg(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        stall,
    input  wire        flush,
    input  wire        if_valid,
    input  wire [31:0] if_pc,
    input  wire [31:0] if_pc_plus4,
    input  wire [31:0] if_instr,
    input  wire        if_fault,
    input  wire [31:0] if_fault_cause,
    input  wire [31:0] if_fault_tval,
    output reg         id_valid,
    output reg  [31:0] id_pc,
    output reg  [31:0] id_pc_plus4,
    output reg  [31:0] id_instr,
    output reg         id_fault,
    output reg  [31:0] id_fault_cause,
    output reg  [31:0] id_fault_tval
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            id_valid <= 1'b0;
            id_pc <= 32'b0;
            id_pc_plus4 <= 32'b0;
            id_instr <= 32'h0000_0013;
            id_fault <= 1'b0;
            id_fault_cause <= 32'b0;
            id_fault_tval <= 32'b0;
        end else if (flush) begin
            id_valid <= 1'b0;
            id_pc <= 32'b0;
            id_pc_plus4 <= 32'b0;
            id_instr <= 32'h0000_0013;
            id_fault <= 1'b0;
            id_fault_cause <= 32'b0;
            id_fault_tval <= 32'b0;
        end else if (!stall) begin
            id_valid <= if_valid;
            id_pc <= if_pc;
            id_pc_plus4 <= if_pc_plus4;
            id_instr <= if_instr;
            id_fault <= if_fault;
            id_fault_cause <= if_fault_cause;
            id_fault_tval <= if_fault_tval;
        end
    end
endmodule
