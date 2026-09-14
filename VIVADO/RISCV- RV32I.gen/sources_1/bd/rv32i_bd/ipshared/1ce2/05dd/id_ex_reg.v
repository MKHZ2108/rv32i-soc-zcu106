`timescale 1ns/1ps

module id_ex_reg(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        stall,
    input  wire        flush,
    input  wire        id_valid,
    input  wire [31:0] id_pc,
    input  wire [31:0] id_pc_plus4,
    input  wire [31:0] id_instr,
    input  wire        id_fault,
    input  wire [31:0] id_fault_cause,
    input  wire [31:0] id_fault_tval,
    input  wire [4:0]  id_rs1,
    input  wire [4:0]  id_rs2,
    input  wire [4:0]  id_rd,
    input  wire [31:0] id_rs1_data,
    input  wire [31:0] id_rs2_data,
    input  wire [31:0] id_imm,
    input  wire        id_reg_write,
    input  wire        id_mem_read,
    input  wire        id_mem_write,
    input  wire [1:0]  id_wb_sel,
    input  wire [4:0]  id_alu_op,
    input  wire [1:0]  id_alu_src_a_sel,
    input  wire [1:0]  id_alu_src_b_sel,
    input  wire [2:0]  id_branch_type,
    input  wire        id_jump,
    input  wire        id_jalr,
    input  wire [1:0]  id_mem_size,
    input  wire        id_mem_unsigned,
    input  wire        id_csr_en,
    input  wire [1:0]  id_csr_op,
    input  wire        id_csr_use_imm,
    input  wire        id_mret,
    output reg         ex_valid,
    output reg  [31:0] ex_pc,
    output reg  [31:0] ex_pc_plus4,
    output reg  [31:0] ex_instr,
    output reg         ex_fault,
    output reg  [31:0] ex_fault_cause,
    output reg  [31:0] ex_fault_tval,
    output reg  [4:0]  ex_rs1,
    output reg  [4:0]  ex_rs2,
    output reg  [4:0]  ex_rd,
    output reg  [31:0] ex_rs1_data,
    output reg  [31:0] ex_rs2_data,
    output reg  [31:0] ex_imm,
    output reg         ex_reg_write,
    output reg         ex_mem_read,
    output reg         ex_mem_write,
    output reg  [1:0]  ex_wb_sel,
    output reg  [4:0]  ex_alu_op,
    output reg  [1:0]  ex_alu_src_a_sel,
    output reg  [1:0]  ex_alu_src_b_sel,
    output reg  [2:0]  ex_branch_type,
    output reg         ex_jump,
    output reg         ex_jalr,
    output reg  [1:0]  ex_mem_size,
    output reg         ex_mem_unsigned,
    output reg         ex_csr_en,
    output reg  [1:0]  ex_csr_op,
    output reg         ex_csr_use_imm,
    output reg         ex_mret
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ex_valid <= 1'b0;
            ex_pc <= 32'b0;
            ex_pc_plus4 <= 32'b0;
            ex_instr <= 32'h0000_0013;
            ex_fault <= 1'b0;
            ex_fault_cause <= 32'b0;
            ex_fault_tval <= 32'b0;
            ex_rs1 <= 5'b0;
            ex_rs2 <= 5'b0;
            ex_rd <= 5'b0;
            ex_rs1_data <= 32'b0;
            ex_rs2_data <= 32'b0;
            ex_imm <= 32'b0;
            ex_reg_write <= 1'b0;
            ex_mem_read <= 1'b0;
            ex_mem_write <= 1'b0;
            ex_wb_sel <= 2'd0;
            ex_alu_op <= 5'd0;
            ex_alu_src_a_sel <= 2'd0;
            ex_alu_src_b_sel <= 2'd0;
            ex_branch_type <= 3'd0;
            ex_jump <= 1'b0;
            ex_jalr <= 1'b0;
            ex_mem_size <= 2'd2;
            ex_mem_unsigned <= 1'b0;
            ex_csr_en <= 1'b0;
            ex_csr_op <= 2'd0;
            ex_csr_use_imm <= 1'b0;
            ex_mret <= 1'b0;
        end else if (flush) begin
            ex_valid <= 1'b0;
            ex_pc <= 32'b0;
            ex_pc_plus4 <= 32'b0;
            ex_instr <= 32'h0000_0013;
            ex_fault <= 1'b0;
            ex_fault_cause <= 32'b0;
            ex_fault_tval <= 32'b0;
            ex_rs1 <= 5'b0;
            ex_rs2 <= 5'b0;
            ex_rd <= 5'b0;
            ex_rs1_data <= 32'b0;
            ex_rs2_data <= 32'b0;
            ex_imm <= 32'b0;
            ex_reg_write <= 1'b0;
            ex_mem_read <= 1'b0;
            ex_mem_write <= 1'b0;
            ex_wb_sel <= 2'd0;
            ex_alu_op <= 5'd0;
            ex_alu_src_a_sel <= 2'd0;
            ex_alu_src_b_sel <= 2'd0;
            ex_branch_type <= 3'd0;
            ex_jump <= 1'b0;
            ex_jalr <= 1'b0;
            ex_mem_size <= 2'd2;
            ex_mem_unsigned <= 1'b0;
            ex_csr_en <= 1'b0;
            ex_csr_op <= 2'd0;
            ex_csr_use_imm <= 1'b0;
            ex_mret <= 1'b0;
        end else if (!stall) begin
            ex_valid <= id_valid;
            ex_pc <= id_pc;
            ex_pc_plus4 <= id_pc_plus4;
            ex_instr <= id_instr;
            ex_fault <= id_fault;
            ex_fault_cause <= id_fault_cause;
            ex_fault_tval <= id_fault_tval;
            ex_rs1 <= id_rs1;
            ex_rs2 <= id_rs2;
            ex_rd <= id_rd;
            ex_rs1_data <= id_rs1_data;
            ex_rs2_data <= id_rs2_data;
            ex_imm <= id_imm;
            ex_reg_write <= id_reg_write;
            ex_mem_read <= id_mem_read;
            ex_mem_write <= id_mem_write;
            ex_wb_sel <= id_wb_sel;
            ex_alu_op <= id_alu_op;
            ex_alu_src_a_sel <= id_alu_src_a_sel;
            ex_alu_src_b_sel <= id_alu_src_b_sel;
            ex_branch_type <= id_branch_type;
            ex_jump <= id_jump;
            ex_jalr <= id_jalr;
            ex_mem_size <= id_mem_size;
            ex_mem_unsigned <= id_mem_unsigned;
            ex_csr_en <= id_csr_en;
            ex_csr_op <= id_csr_op;
            ex_csr_use_imm <= id_csr_use_imm;
            ex_mret <= id_mret;
        end
    end
endmodule
