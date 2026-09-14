`timescale 1ns/1ps

module mem_wb_reg(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        stall,
    input  wire        flush,
    input  wire        mem_valid,
    input  wire [31:0] mem_pc,
    input  wire [31:0] mem_pc_plus4,
    input  wire [31:0] mem_instr,
    input  wire        mem_fault,
    input  wire [31:0] mem_fault_cause,
    input  wire [31:0] mem_fault_tval,
    input  wire [4:0]  mem_rd,
    input  wire [31:0] mem_alu_result,
    input  wire [31:0] mem_load_data,
    input  wire [31:0] mem_csr_rdata,
    input  wire [31:0] mem_csr_wdata,
    input  wire [11:0] mem_csr_addr,
    input  wire        mem_csr_we,
    input  wire        mem_mret,
    input  wire        mem_reg_write,
    input  wire [1:0]  mem_wb_sel,
    output reg         wb_valid,
    output reg  [31:0] wb_pc,
    output reg  [31:0] wb_pc_plus4,
    output reg  [31:0] wb_instr,
    output reg         wb_fault,
    output reg  [31:0] wb_fault_cause,
    output reg  [31:0] wb_fault_tval,
    output reg  [4:0]  wb_rd,
    output reg  [31:0] wb_alu_result,
    output reg  [31:0] wb_load_data,
    output reg  [31:0] wb_csr_rdata,
    output reg  [31:0] wb_csr_wdata,
    output reg  [11:0] wb_csr_addr,
    output reg         wb_csr_we,
    output reg         wb_mret,
    output reg         wb_reg_write,
    output reg  [1:0]  wb_wb_sel
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wb_valid <= 1'b0;
            wb_pc <= 32'b0;
            wb_pc_plus4 <= 32'b0;
            wb_instr <= 32'h0000_0013;
            wb_fault <= 1'b0;
            wb_fault_cause <= 32'b0;
            wb_fault_tval <= 32'b0;
            wb_rd <= 5'b0;
            wb_alu_result <= 32'b0;
            wb_load_data <= 32'b0;
            wb_csr_rdata <= 32'b0;
            wb_csr_wdata <= 32'b0;
            wb_csr_addr <= 12'b0;
            wb_csr_we <= 1'b0;
            wb_mret <= 1'b0;
            wb_reg_write <= 1'b0;
            wb_wb_sel <= 2'd0;
        end else if (flush) begin
            wb_valid <= 1'b0;
            wb_pc <= 32'b0;
            wb_pc_plus4 <= 32'b0;
            wb_instr <= 32'h0000_0013;
            wb_fault <= 1'b0;
            wb_fault_cause <= 32'b0;
            wb_fault_tval <= 32'b0;
            wb_rd <= 5'b0;
            wb_alu_result <= 32'b0;
            wb_load_data <= 32'b0;
            wb_csr_rdata <= 32'b0;
            wb_csr_wdata <= 32'b0;
            wb_csr_addr <= 12'b0;
            wb_csr_we <= 1'b0;
            wb_mret <= 1'b0;
            wb_reg_write <= 1'b0;
            wb_wb_sel <= 2'd0;
        end else if (!stall) begin
            wb_valid <= mem_valid;
            wb_pc <= mem_pc;
            wb_pc_plus4 <= mem_pc_plus4;
            wb_instr <= mem_instr;
            wb_fault <= mem_fault;
            wb_fault_cause <= mem_fault_cause;
            wb_fault_tval <= mem_fault_tval;
            wb_rd <= mem_rd;
            wb_alu_result <= mem_alu_result;
            wb_load_data <= mem_load_data;
            wb_csr_rdata <= mem_csr_rdata;
            wb_csr_wdata <= mem_csr_wdata;
            wb_csr_addr <= mem_csr_addr;
            wb_csr_we <= mem_csr_we;
            wb_mret <= mem_mret;
            wb_reg_write <= mem_reg_write;
            wb_wb_sel <= mem_wb_sel;
        end
    end
endmodule
