`timescale 1ns/1ps

module ex_mem_reg(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        stall,
    input  wire        flush,
    input  wire        ex_valid,
    input  wire [31:0] ex_pc,
    input  wire [31:0] ex_pc_plus4,
    input  wire [31:0] ex_instr,
    input  wire        ex_fault,
    input  wire [31:0] ex_fault_cause,
    input  wire [31:0] ex_fault_tval,
    input  wire [4:0]  ex_rd,
    input  wire [31:0] ex_alu_result,
    input  wire [31:0] ex_store_data,
    input  wire [31:0] ex_csr_rdata,
    input  wire [31:0] ex_csr_wdata,
    input  wire [11:0] ex_csr_addr,
    input  wire        ex_csr_we,
    input  wire        ex_mret,
    input  wire        ex_reg_write,
    input  wire        ex_mem_read,
    input  wire        ex_mem_write,
    input  wire [1:0]  ex_wb_sel,
    input  wire [1:0]  ex_mem_size,
    input  wire        ex_mem_unsigned,
    output reg         mem_valid,
    output reg  [31:0] mem_pc,
    output reg  [31:0] mem_pc_plus4,
    output reg  [31:0] mem_instr,
    output reg         mem_fault,
    output reg  [31:0] mem_fault_cause,
    output reg  [31:0] mem_fault_tval,
    output reg  [4:0]  mem_rd,
    output reg  [31:0] mem_alu_result,
    output reg  [31:0] mem_store_data,
    output reg  [31:0] mem_csr_rdata,
    output reg  [31:0] mem_csr_wdata,
    output reg  [11:0] mem_csr_addr,
    output reg         mem_csr_we,
    output reg         mem_mret,
    output reg         mem_reg_write,
    output reg         mem_mem_read,
    output reg         mem_mem_write,
    output reg  [1:0]  mem_wb_sel,
    output reg  [1:0]  mem_mem_size,
    output reg         mem_mem_unsigned
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mem_valid <= 1'b0;
            mem_pc <= 32'b0;
            mem_pc_plus4 <= 32'b0;
            mem_instr <= 32'h0000_0013;
            mem_fault <= 1'b0;
            mem_fault_cause <= 32'b0;
            mem_fault_tval <= 32'b0;
            mem_rd <= 5'b0;
            mem_alu_result <= 32'b0;
            mem_store_data <= 32'b0;
            mem_csr_rdata <= 32'b0;
            mem_csr_wdata <= 32'b0;
            mem_csr_addr <= 12'b0;
            mem_csr_we <= 1'b0;
            mem_mret <= 1'b0;
            mem_reg_write <= 1'b0;
            mem_mem_read <= 1'b0;
            mem_mem_write <= 1'b0;
            mem_wb_sel <= 2'd0;
            mem_mem_size <= 2'd2;
            mem_mem_unsigned <= 1'b0;
        end else if (flush) begin
            mem_valid <= 1'b0;
            mem_pc <= 32'b0;
            mem_pc_plus4 <= 32'b0;
            mem_instr <= 32'h0000_0013;
            mem_fault <= 1'b0;
            mem_fault_cause <= 32'b0;
            mem_fault_tval <= 32'b0;
            mem_rd <= 5'b0;
            mem_alu_result <= 32'b0;
            mem_store_data <= 32'b0;
            mem_csr_rdata <= 32'b0;
            mem_csr_wdata <= 32'b0;
            mem_csr_addr <= 12'b0;
            mem_csr_we <= 1'b0;
            mem_mret <= 1'b0;
            mem_reg_write <= 1'b0;
            mem_mem_read <= 1'b0;
            mem_mem_write <= 1'b0;
            mem_wb_sel <= 2'd0;
            mem_mem_size <= 2'd2;
            mem_mem_unsigned <= 1'b0;
        end else if (!stall) begin
            mem_valid <= ex_valid;
            mem_pc <= ex_pc;
            mem_pc_plus4 <= ex_pc_plus4;
            mem_instr <= ex_instr;
            mem_fault <= ex_fault;
            mem_fault_cause <= ex_fault_cause;
            mem_fault_tval <= ex_fault_tval;
            mem_rd <= ex_rd;
            mem_alu_result <= ex_alu_result;
            mem_store_data <= ex_store_data;
            mem_csr_rdata <= ex_csr_rdata;
            mem_csr_wdata <= ex_csr_wdata;
            mem_csr_addr <= ex_csr_addr;
            mem_csr_we <= ex_csr_we;
            mem_mret <= ex_mret;
            mem_reg_write <= ex_reg_write;
            mem_mem_read <= ex_mem_read;
            mem_mem_write <= ex_mem_write;
            mem_wb_sel <= ex_wb_sel;
            mem_mem_size <= ex_mem_size;
            mem_mem_unsigned <= ex_mem_unsigned;
        end
    end
endmodule
