`timescale 1ns/1ps

module ex_stage #(
    parameter XLEN         = 32,
    parameter ADDER_IMPL   = 0,
    parameter SHIFTER_IMPL = 0
)(
    input  wire        ex_valid,
    input  wire [31:0] ex_pc,
    input  wire [31:0] ex_pc_plus4,
    input  wire [31:0] ex_instr,
    input  wire        ex_fault_in,
    input  wire [31:0] ex_fault_cause_in,
    input  wire [31:0] ex_fault_tval_in,
    input  wire [4:0]  ex_rs1,
    input  wire [31:0] ex_rs1_data,
    input  wire [31:0] ex_rs2_data,
    input  wire [31:0] ex_imm,
    input  wire [4:0]  ex_alu_op,
    input  wire [1:0]  ex_alu_src_a_sel,
    input  wire [1:0]  ex_alu_src_b_sel,
    input  wire [2:0]  ex_branch_type,
    input  wire        ex_jump,
    input  wire        ex_jalr,
    input  wire        ex_csr_en,
    input  wire [1:0]  ex_csr_op,
    input  wire        ex_csr_use_imm,
    input  wire        ex_mret,
    input  wire [1:0]  forward_a_sel,
    input  wire [1:0]  forward_b_sel,
    input  wire [31:0] forward_mem_data,
    input  wire [31:0] forward_wb_data,
    input  wire [31:0] csr_rdata,
    input  wire [31:0] mepc_value,
    input  wire        csr_valid,
    input  wire        csr_read_only,
    output wire        pc_redirect_valid,
    output wire [31:0] pc_redirect_target,
    output wire        ex_fault_out,
    output wire [31:0] ex_fault_cause,
    output wire [31:0] ex_fault_tval,
    output wire [31:0] ex_alu_result,
    output wire [31:0] ex_store_data,
    output wire [31:0] ex_csr_rdata,
    output reg  [31:0] ex_csr_wdata,
    output wire [11:0] ex_csr_addr,
    output wire        ex_csr_we
);
    reg [31:0] rs1_fwd;
    reg [31:0] rs2_fwd;
    reg [31:0] alu_a;
    reg [31:0] alu_b;
    wire branch_taken;
    wire [31:0] jump_target;
    wire [31:0] csr_operand;

    always @(*) begin
        case (forward_a_sel)
            2'd1: rs1_fwd = forward_mem_data;
            2'd2: rs1_fwd = forward_wb_data;
            default:  rs1_fwd = ex_rs1_data;
        endcase

        case (forward_b_sel)
            2'd1: rs2_fwd = forward_mem_data;
            2'd2: rs2_fwd = forward_wb_data;
            default:  rs2_fwd = ex_rs2_data;
        endcase

        case (ex_alu_src_a_sel)
            2'd1: alu_a = ex_pc;
            2'd2: alu_a = 32'b0;
            default:     alu_a = rs1_fwd;
        endcase

        case (ex_alu_src_b_sel)
            2'd1: alu_b = ex_imm;
            2'd2: alu_b = 32'd4;
            default:     alu_b = rs2_fwd;
        endcase
    end

    alu #(
        .XLEN(XLEN), .ADDER_IMPL(ADDER_IMPL),
        .SHIFTER_IMPL(SHIFTER_IMPL)
    ) u_alu (
        .a(alu_a), .b(alu_b), .alu_op(ex_alu_op),
        .result(ex_alu_result), .zero(), .lt_signed(), .lt_unsigned()
    );

    branch_unit u_branch (
        .rs1_value(rs1_fwd), .rs2_value(rs2_fwd),
        .branch_type(ex_branch_type), .branch_taken(branch_taken)
    );

    assign jump_target = ex_jalr ? ((rs1_fwd + ex_imm) & 32'hFFFF_FFFE) : (ex_pc + ex_imm);
    assign csr_operand = ex_csr_use_imm ? {27'b0, ex_rs1} : rs1_fwd;
    assign pc_redirect_valid =
        (ex_valid && !ex_fault_in &&
         ((ex_branch_type != 3'd0 && branch_taken) || ex_jump) &&
         ~|jump_target[1:0]) ||
        (ex_valid && ex_mret && !ex_fault_in);
    assign pc_redirect_target = (ex_valid && ex_mret && !ex_fault_in) ? mepc_value : jump_target;
    assign ex_fault_out =
        ex_fault_in |
        (ex_valid && !ex_fault_in &&
         ((ex_branch_type != 3'd0 && branch_taken) || ex_jump) &&
         |jump_target[1:0]) |
        (ex_valid && !ex_fault_in && ex_csr_en &&
         (!csr_valid ||
          (((ex_csr_op == 2'd0) || (csr_operand != 32'b0)) && csr_read_only)));
    assign ex_fault_cause =
        ex_fault_in ? ex_fault_cause_in :
        (ex_valid && !ex_fault_in &&
         ((ex_branch_type != 3'd0 && branch_taken) || ex_jump) &&
         |jump_target[1:0]) ? 32'd0 :
        (ex_valid && !ex_fault_in && ex_csr_en &&
         (!csr_valid ||
          (((ex_csr_op == 2'd0) || (csr_operand != 32'b0)) && csr_read_only))) ? 32'd2 :
        32'd0;
    assign ex_fault_tval =
        ex_fault_in ? ex_fault_tval_in :
        (ex_valid && !ex_fault_in &&
         ((ex_branch_type != 3'd0 && branch_taken) || ex_jump) &&
         |jump_target[1:0]) ? jump_target :
        (ex_valid && !ex_fault_in && ex_csr_en &&
         (!csr_valid ||
          (((ex_csr_op == 2'd0) || (csr_operand != 32'b0)) && csr_read_only))) ? ex_instr :
        32'd0;
    assign ex_store_data = rs2_fwd;
    assign ex_csr_rdata = csr_rdata;
    assign ex_csr_addr = ex_instr[31:20];
    assign ex_csr_we =
        ex_csr_en && ((ex_csr_op == 2'd0) || (csr_operand != 32'b0)) &&
        !(ex_csr_en &&
          (!csr_valid ||
           (((ex_csr_op == 2'd0) || (csr_operand != 32'b0)) && csr_read_only))) &&
        ex_valid && !ex_fault_in && !ex_mret;

    always @(*) begin
        case (ex_csr_op)
            2'd1: ex_csr_wdata = csr_rdata | csr_operand;
            2'd2: ex_csr_wdata = csr_rdata & ~csr_operand;
            default: ex_csr_wdata = csr_operand;
        endcase
    end
endmodule
