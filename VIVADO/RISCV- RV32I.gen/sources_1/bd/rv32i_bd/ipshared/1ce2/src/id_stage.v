`timescale 1ns/1ps

module id_stage #(
    parameter XLEN = 32
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        id_valid,
    input  wire [31:0] id_pc,
    input  wire [31:0] id_instr,
    input  wire        id_fault_in,
    input  wire [31:0] id_fault_cause_in,
    input  wire [31:0] id_fault_tval_in,
    input  wire        wb_reg_write,
    input  wire [4:0]  wb_rd,
    input  wire [31:0] wb_data,
    output wire        id_fault_out,
    output wire        id_illegal_instr,
    output wire        id_ecall,
    output wire        id_ebreak,
    output wire        id_mret,
    output wire [31:0] id_fault_cause,
    output wire [31:0] id_fault_tval,
    output wire [4:0]  id_rs1,
    output wire [4:0]  id_rs2,
    output wire [4:0]  id_rd,
    output wire [31:0] id_rs1_data,
    output wire [31:0] id_rs2_data,
    output wire [31:0] id_imm,
    output wire        id_reg_write,
    output wire        id_mem_read,
    output wire        id_mem_write,
    output wire [1:0]  id_wb_sel,
    output wire [4:0]  id_alu_op,
    output wire [1:0]  id_alu_src_a_sel,
    output wire [1:0]  id_alu_src_b_sel,
    output wire [2:0]  id_branch_type,
    output wire        id_jump,
    output wire        id_jalr,
    output wire [1:0]  id_mem_size,
    output wire        id_mem_unsigned,
    output wire        id_csr_en,
    output wire [1:0]  id_csr_op,
    output wire        id_csr_use_imm
);
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [2:0] imm_type;

    decoder u_decoder (
        .instr(id_instr), .opcode(opcode), .rd(id_rd), .funct3(funct3),
        .rs1(id_rs1), .rs2(id_rs2), .funct7(funct7)
    );

    control_unit u_control (
        .id_valid(id_valid), .opcode(opcode), .funct3(funct3), .funct7(funct7),
        .rd(id_rd), .rs1(id_rs1),
        .system_imm(id_instr[31:20]),
        .illegal_instr(id_illegal_instr), .reg_write(id_reg_write),
        .mem_read(id_mem_read), .mem_write(id_mem_write), .wb_sel(id_wb_sel),
        .alu_op(id_alu_op), .alu_src_a_sel(id_alu_src_a_sel),
        .alu_src_b_sel(id_alu_src_b_sel), .imm_type(imm_type),
        .branch_type(id_branch_type), .jump(id_jump), .jalr(id_jalr),
        .mem_size(id_mem_size), .mem_unsigned(id_mem_unsigned),
        .csr_en(id_csr_en), .csr_op(id_csr_op), .csr_use_imm(id_csr_use_imm),
        .ecall(id_ecall), .ebreak(id_ebreak), .mret(id_mret)
    );

    imm_gen u_imm_gen (.instr(id_instr), .imm_type(imm_type), .imm(id_imm));

    reg_file #(.XLEN(XLEN)) u_reg_file (
        .clk(clk), .rst_n(rst_n), .rs1_addr(id_rs1), .rs2_addr(id_rs2),
        .rs1_data(id_rs1_data), .rs2_data(id_rs2_data),
        .rd_we(wb_reg_write), .rd_addr(wb_rd), .rd_data(wb_data)
    );

    assign id_fault_out = id_valid && (id_fault_in | id_illegal_instr | id_ecall | id_ebreak);
    assign id_fault_cause = id_fault_in     ? id_fault_cause_in :
                             id_illegal_instr ? 32'd2 :
                             id_ebreak        ? 32'd3 :
                             id_ecall         ? 32'd11 :
                                                32'd0;
    assign id_fault_tval = id_fault_in      ? id_fault_tval_in :
                            id_illegal_instr ? id_instr :
                            id_ebreak        ? id_pc :
                                               32'd0;
endmodule
