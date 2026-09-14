`timescale 1ns/1ps

module control_unit(
    input  wire        id_valid,
    input  wire [6:0]  opcode,
    input  wire [2:0]  funct3,
    input  wire [6:0]  funct7,
    input  wire [4:0]  rd,
    input  wire [4:0]  rs1,
    input  wire [11:0] system_imm,
    output reg         illegal_instr,
    output reg         reg_write,
    output reg         mem_read,
    output reg         mem_write,
    output reg  [1:0]  wb_sel,
    output reg  [4:0]  alu_op,
    output reg  [1:0]  alu_src_a_sel,
    output reg  [1:0]  alu_src_b_sel,
    output reg  [2:0]  imm_type,
    output reg  [2:0]  branch_type,
    output reg         jump,
    output reg         jalr,
    output reg  [1:0]  mem_size,
    output reg         mem_unsigned,
    output reg         csr_en,
    output reg  [1:0]  csr_op,
    output reg         csr_use_imm,
    output reg         ecall,
    output reg         ebreak,
    output reg         mret
);
    localparam OPCODE_LUI      = 7'b0110111;
    localparam OPCODE_AUIPC    = 7'b0010111;
    localparam OPCODE_JAL      = 7'b1101111;
    localparam OPCODE_JALR     = 7'b1100111;
    localparam OPCODE_BRANCH   = 7'b1100011;
    localparam OPCODE_LOAD     = 7'b0000011;
    localparam OPCODE_STORE    = 7'b0100011;
    localparam OPCODE_OP_IMM   = 7'b0010011;
    localparam OPCODE_OP       = 7'b0110011;
    localparam OPCODE_MISC_MEM = 7'b0001111;
    localparam OPCODE_SYSTEM   = 7'b1110011;

    localparam ALU_ADD    = 5'd0;
    localparam ALU_SUB    = 5'd1;
    localparam ALU_SLL    = 5'd2;
    localparam ALU_SLT    = 5'd3;
    localparam ALU_SLTU   = 5'd4;
    localparam ALU_XOR    = 5'd5;
    localparam ALU_SRL    = 5'd6;
    localparam ALU_SRA    = 5'd7;
    localparam ALU_OR     = 5'd8;
    localparam ALU_AND    = 5'd9;
    localparam ALU_COPY_B = 5'd10;

    localparam ALU_A_RS1  = 2'd0;
    localparam ALU_A_PC   = 2'd1;
    localparam ALU_A_ZERO = 2'd2;
    localparam ALU_B_RS2  = 2'd0;
    localparam ALU_B_IMM  = 2'd1;

    localparam WB_ALU = 2'd0;
    localparam WB_MEM = 2'd1;
    localparam WB_PC4 = 2'd2;
    localparam WB_CSR = 2'd3;

    localparam BR_NONE = 3'd0;
    localparam BR_EQ   = 3'd1;
    localparam BR_NE   = 3'd2;
    localparam BR_LT   = 3'd3;
    localparam BR_GE   = 3'd4;
    localparam BR_LTU  = 3'd5;
    localparam BR_GEU  = 3'd6;

    localparam MEM_SIZE_BYTE = 2'd0;
    localparam MEM_SIZE_HALF = 2'd1;
    localparam MEM_SIZE_WORD = 2'd2;

    localparam IMM_I = 3'd0;
    localparam IMM_S = 3'd1;
    localparam IMM_B = 3'd2;
    localparam IMM_U = 3'd3;
    localparam IMM_J = 3'd4;

    always @(*) begin
        illegal_instr = 1'b0;
        reg_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        wb_sel = WB_ALU;
        alu_op = ALU_ADD;
        alu_src_a_sel = ALU_A_RS1;
        alu_src_b_sel = ALU_B_RS2;
        imm_type = IMM_I;
        branch_type = BR_NONE;
        jump = 1'b0;
        jalr = 1'b0;
        mem_size = MEM_SIZE_WORD;
        mem_unsigned = 1'b0;
        csr_en = 1'b0;
        csr_op = 2'd0;
        csr_use_imm = 1'b0;
        ecall = 1'b0;
        ebreak = 1'b0;
        mret = 1'b0;

        if (id_valid) begin
            case (opcode)
                OPCODE_LUI: begin
                    reg_write = 1'b1;
                    alu_op = ALU_COPY_B;
                    alu_src_a_sel = ALU_A_ZERO;
                    alu_src_b_sel = ALU_B_IMM;
                    imm_type = IMM_U;
                end
                OPCODE_AUIPC: begin
                    reg_write = 1'b1;
                    alu_op = ALU_ADD;
                    alu_src_a_sel = ALU_A_PC;
                    alu_src_b_sel = ALU_B_IMM;
                    imm_type = IMM_U;
                end
                OPCODE_JAL: begin
                    reg_write = 1'b1;
                    wb_sel = WB_PC4;
                    alu_src_a_sel = ALU_A_PC;
                    alu_src_b_sel = ALU_B_IMM;
                    imm_type = IMM_J;
                    jump = 1'b1;
                end
                OPCODE_JALR: begin
                    reg_write = 1'b1;
                    wb_sel = WB_PC4;
                    alu_src_a_sel = ALU_A_RS1;
                    alu_src_b_sel = ALU_B_IMM;
                    imm_type = IMM_I;
                    jump = 1'b1;
                    jalr = 1'b1;
                    if (funct3 != 3'b000) illegal_instr = 1'b1;
                end
                OPCODE_BRANCH: begin
                    alu_src_a_sel = ALU_A_RS1;
                    alu_src_b_sel = ALU_B_RS2;
                    imm_type = IMM_B;
                    case (funct3)
                        3'b000: branch_type = BR_EQ;
                        3'b001: branch_type = BR_NE;
                        3'b100: branch_type = BR_LT;
                        3'b101: branch_type = BR_GE;
                        3'b110: branch_type = BR_LTU;
                        3'b111: branch_type = BR_GEU;
                        default: illegal_instr = 1'b1;
                    endcase
                end
                OPCODE_LOAD: begin
                    reg_write = 1'b1;
                    mem_read = 1'b1;
                    wb_sel = WB_MEM;
                    alu_src_b_sel = ALU_B_IMM;
                    imm_type = IMM_I;
                    case (funct3)
                        3'b000: begin mem_size = MEM_SIZE_BYTE; mem_unsigned = 1'b0; end
                        3'b001: begin mem_size = MEM_SIZE_HALF; mem_unsigned = 1'b0; end
                        3'b010: begin mem_size = MEM_SIZE_WORD; mem_unsigned = 1'b0; end
                        3'b100: begin mem_size = MEM_SIZE_BYTE; mem_unsigned = 1'b1; end
                        3'b101: begin mem_size = MEM_SIZE_HALF; mem_unsigned = 1'b1; end
                        default: illegal_instr = 1'b1;
                    endcase
                end
                OPCODE_STORE: begin
                    mem_write = 1'b1;
                    alu_src_b_sel = ALU_B_IMM;
                    imm_type = IMM_S;
                    case (funct3)
                        3'b000: mem_size = MEM_SIZE_BYTE;
                        3'b001: mem_size = MEM_SIZE_HALF;
                        3'b010: mem_size = MEM_SIZE_WORD;
                        default: illegal_instr = 1'b1;
                    endcase
                end
                OPCODE_OP_IMM: begin
                    reg_write = 1'b1;
                    alu_src_b_sel = ALU_B_IMM;
                    imm_type = IMM_I;
                    case (funct3)
                        3'b000: alu_op = ALU_ADD;
                        3'b010: alu_op = ALU_SLT;
                        3'b011: alu_op = ALU_SLTU;
                        3'b100: alu_op = ALU_XOR;
                        3'b110: alu_op = ALU_OR;
                        3'b111: alu_op = ALU_AND;
                        3'b001: begin
                            alu_op = ALU_SLL;
                            if (funct7 != 7'b0000000) illegal_instr = 1'b1;
                        end
                        3'b101: begin
                            if (funct7 == 7'b0000000) alu_op = ALU_SRL;
                            else if (funct7 == 7'b0100000) alu_op = ALU_SRA;
                            else illegal_instr = 1'b1;
                        end
                        default: illegal_instr = 1'b1;
                    endcase
                end
                OPCODE_OP: begin
                    reg_write = 1'b1;
                    case ({funct7, funct3})
                        {7'b0000000, 3'b000}: alu_op = ALU_ADD;
                        {7'b0100000, 3'b000}: alu_op = ALU_SUB;
                        {7'b0000000, 3'b001}: alu_op = ALU_SLL;
                        {7'b0000000, 3'b010}: alu_op = ALU_SLT;
                        {7'b0000000, 3'b011}: alu_op = ALU_SLTU;
                        {7'b0000000, 3'b100}: alu_op = ALU_XOR;
                        {7'b0000000, 3'b101}: alu_op = ALU_SRL;
                        {7'b0100000, 3'b101}: alu_op = ALU_SRA;
                        {7'b0000000, 3'b110}: alu_op = ALU_OR;
                        {7'b0000000, 3'b111}: alu_op = ALU_AND;
                        default: illegal_instr = 1'b1;
                    endcase
                end
                OPCODE_MISC_MEM: begin
                    if (funct3 != 3'b000) illegal_instr = 1'b1;
                end
                OPCODE_SYSTEM: begin
                    if (funct3 == 3'b000 && rd == 5'd0 && rs1 == 5'd0 && system_imm == 12'h000)
                            ecall = 1'b1;
                    else if (funct3 == 3'b000 && rd == 5'd0 && rs1 == 5'd0 && system_imm == 12'h001)
                            ebreak = 1'b1;
                    else if (funct3 == 3'b000 && rd == 5'd0 && rs1 == 5'd0 && system_imm == 12'h302)
                            mret = 1'b1;
                    else if (funct3 == 3'b000)
                            illegal_instr = 1'b1;
                    else begin
                        case (funct3)
                            3'b001: begin reg_write = 1'b1; wb_sel = WB_CSR; csr_en = 1'b1; csr_op = 2'd0; csr_use_imm = 1'b0; end
                            3'b010: begin reg_write = 1'b1; wb_sel = WB_CSR; csr_en = 1'b1; csr_op = 2'd1; csr_use_imm = 1'b0; end
                            3'b011: begin reg_write = 1'b1; wb_sel = WB_CSR; csr_en = 1'b1; csr_op = 2'd2; csr_use_imm = 1'b0; end
                            3'b101: begin reg_write = 1'b1; wb_sel = WB_CSR; csr_en = 1'b1; csr_op = 2'd0; csr_use_imm = 1'b1; end
                            3'b110: begin reg_write = 1'b1; wb_sel = WB_CSR; csr_en = 1'b1; csr_op = 2'd1; csr_use_imm = 1'b1; end
                            3'b111: begin reg_write = 1'b1; wb_sel = WB_CSR; csr_en = 1'b1; csr_op = 2'd2; csr_use_imm = 1'b1; end
                            default: illegal_instr = 1'b1;
                        endcase
                    end
                end
                default: illegal_instr = 1'b1;
            endcase

            if (illegal_instr) begin
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                jump = 1'b0;
                jalr = 1'b0;
                branch_type = BR_NONE;
                csr_en = 1'b0;
                csr_op = 2'd0;
                csr_use_imm = 1'b0;
                ecall = 1'b0;
                ebreak = 1'b0;
                mret = 1'b0;
            end
        end
    end
endmodule
