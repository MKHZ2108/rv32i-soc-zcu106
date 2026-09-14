`timescale 1ns/1ps

module control_unit_rv32i_tb;
    reg         id_valid;
    reg  [6:0]  opcode;
    reg  [2:0]  funct3;
    reg  [6:0]  funct7;
    reg  [4:0]  rd;
    reg  [4:0]  rs1;
    reg  [11:0] system_imm;

    wire        illegal_instr;
    wire        reg_write;
    wire        mem_read;
    wire        mem_write;
    wire [1:0]  wb_sel;
    wire [4:0]  alu_op;
    wire [1:0]  alu_src_a_sel;
    wire [1:0]  alu_src_b_sel;
    wire [2:0]  imm_type;
    wire [2:0]  branch_type;
    wire        jump;
    wire        jalr;
    wire [1:0]  mem_size;
    wire        mem_unsigned;
    wire        csr_en;
    wire [1:0]  csr_op;
    wire        csr_use_imm;
    wire        ecall;
    wire        ebreak;
    wire        mret;

    integer errors;
    integer accepted;

    control_unit dut (
        .id_valid(id_valid),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .rd(rd),
        .rs1(rs1),
        .system_imm(system_imm),
        .illegal_instr(illegal_instr),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .wb_sel(wb_sel),
        .alu_op(alu_op),
        .alu_src_a_sel(alu_src_a_sel),
        .alu_src_b_sel(alu_src_b_sel),
        .imm_type(imm_type),
        .branch_type(branch_type),
        .jump(jump),
        .jalr(jalr),
        .mem_size(mem_size),
        .mem_unsigned(mem_unsigned),
        .csr_en(csr_en),
        .csr_op(csr_op),
        .csr_use_imm(csr_use_imm),
        .ecall(ecall),
        .ebreak(ebreak),
        .mret(mret)
    );

    task apply_fields;
        input [6:0] op;
        input [2:0] f3;
        input [6:0] f7;
        input [11:0] imm12;
        begin
            opcode = op;
            funct3 = f3;
            funct7 = f7;
            rd = 5'd0;
            rs1 = 5'd0;
            system_imm = imm12;
            #1;
        end
    endtask

    task expect_legal;
        input [127:0] name;
        begin
            accepted = accepted + 1;
            if (illegal_instr) begin
                $display("FAIL: %0s decoded as illegal", name);
                errors = errors + 1;
            end
        end
    endtask

    task expect_illegal;
        input [127:0] name;
        begin
            if (!illegal_instr) begin
                $display("FAIL: %0s decoded as legal", name);
                errors = errors + 1;
            end
        end
    endtask

    task expect_system;
        input [127:0] name;
        input expect_ecall;
        input expect_ebreak;
        input expect_mret;
        begin
            expect_legal(name);
            if (ecall !== expect_ecall || ebreak !== expect_ebreak || mret !== expect_mret) begin
                $display("FAIL: %0s system decode ecall=%0b ebreak=%0b mret=%0b",
                         name, ecall, ebreak, mret);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;
        accepted = 0;
        id_valid = 1'b1;
        opcode = 7'b0;
        funct3 = 3'b0;
        funct7 = 7'b0;
        rd = 5'b0;
        rs1 = 5'b0;
        system_imm = 12'b0;

        apply_fields(7'b0110111, 3'b000, 7'b0000000, 12'h000); expect_legal("LUI");
        apply_fields(7'b0010111, 3'b000, 7'b0000000, 12'h000); expect_legal("AUIPC");
        apply_fields(7'b1101111, 3'b000, 7'b0000000, 12'h000); expect_legal("JAL");
        apply_fields(7'b1100111, 3'b000, 7'b0000000, 12'h000); expect_legal("JALR");

        apply_fields(7'b1100011, 3'b000, 7'b0000000, 12'h000); expect_legal("BEQ");
        apply_fields(7'b1100011, 3'b001, 7'b0000000, 12'h000); expect_legal("BNE");
        apply_fields(7'b1100011, 3'b100, 7'b0000000, 12'h000); expect_legal("BLT");
        apply_fields(7'b1100011, 3'b101, 7'b0000000, 12'h000); expect_legal("BGE");
        apply_fields(7'b1100011, 3'b110, 7'b0000000, 12'h000); expect_legal("BLTU");
        apply_fields(7'b1100011, 3'b111, 7'b0000000, 12'h000); expect_legal("BGEU");

        apply_fields(7'b0000011, 3'b000, 7'b0000000, 12'h000); expect_legal("LB");
        apply_fields(7'b0000011, 3'b001, 7'b0000000, 12'h000); expect_legal("LH");
        apply_fields(7'b0000011, 3'b010, 7'b0000000, 12'h000); expect_legal("LW");
        apply_fields(7'b0000011, 3'b100, 7'b0000000, 12'h000); expect_legal("LBU");
        apply_fields(7'b0000011, 3'b101, 7'b0000000, 12'h000); expect_legal("LHU");

        apply_fields(7'b0100011, 3'b000, 7'b0000000, 12'h000); expect_legal("SB");
        apply_fields(7'b0100011, 3'b001, 7'b0000000, 12'h000); expect_legal("SH");
        apply_fields(7'b0100011, 3'b010, 7'b0000000, 12'h000); expect_legal("SW");

        apply_fields(7'b0010011, 3'b000, 7'b0000000, 12'h000); expect_legal("ADDI");
        apply_fields(7'b0010011, 3'b010, 7'b0000000, 12'h000); expect_legal("SLTI");
        apply_fields(7'b0010011, 3'b011, 7'b0000000, 12'h000); expect_legal("SLTIU");
        apply_fields(7'b0010011, 3'b100, 7'b0000000, 12'h000); expect_legal("XORI");
        apply_fields(7'b0010011, 3'b110, 7'b0000000, 12'h000); expect_legal("ORI");
        apply_fields(7'b0010011, 3'b111, 7'b0000000, 12'h000); expect_legal("ANDI");
        apply_fields(7'b0010011, 3'b001, 7'b0000000, 12'h000); expect_legal("SLLI");
        apply_fields(7'b0010011, 3'b101, 7'b0000000, 12'h000); expect_legal("SRLI");
        apply_fields(7'b0010011, 3'b101, 7'b0100000, 12'h400); expect_legal("SRAI");

        apply_fields(7'b0110011, 3'b000, 7'b0000000, 12'h000); expect_legal("ADD");
        apply_fields(7'b0110011, 3'b000, 7'b0100000, 12'h400); expect_legal("SUB");
        apply_fields(7'b0110011, 3'b001, 7'b0000000, 12'h000); expect_legal("SLL");
        apply_fields(7'b0110011, 3'b010, 7'b0000000, 12'h000); expect_legal("SLT");
        apply_fields(7'b0110011, 3'b011, 7'b0000000, 12'h000); expect_legal("SLTU");
        apply_fields(7'b0110011, 3'b100, 7'b0000000, 12'h000); expect_legal("XOR");
        apply_fields(7'b0110011, 3'b101, 7'b0000000, 12'h000); expect_legal("SRL");
        apply_fields(7'b0110011, 3'b101, 7'b0100000, 12'h400); expect_legal("SRA");
        apply_fields(7'b0110011, 3'b110, 7'b0000000, 12'h000); expect_legal("OR");
        apply_fields(7'b0110011, 3'b111, 7'b0000000, 12'h000); expect_legal("AND");

        apply_fields(7'b0001111, 3'b000, 7'b0000000, 12'h000); expect_legal("FENCE");
        apply_fields(7'b1110011, 3'b000, 7'b0000000, 12'h000); expect_system("ECALL", 1'b1, 1'b0, 1'b0);
        apply_fields(7'b1110011, 3'b000, 7'b0000000, 12'h001); expect_system("EBREAK", 1'b0, 1'b1, 1'b0);
        apply_fields(7'b1110011, 3'b000, 7'b0011000, 12'h302); expect_system("MRET", 1'b0, 1'b0, 1'b1);

        apply_fields(7'b1110011, 3'b000, 7'b0000000, 12'h000); rd = 5'd1; #1; expect_illegal("ECALL with rd != x0");
        apply_fields(7'b1110011, 3'b000, 7'b0000000, 12'h001); rs1 = 5'd1; #1; expect_illegal("EBREAK with rs1 != x0");
        apply_fields(7'b1110011, 3'b000, 7'b0011000, 12'h302); rd = 5'd1; #1; expect_illegal("MRET with rd != x0");
        apply_fields(7'b1110011, 3'b000, 7'b0011000, 12'h302); rs1 = 5'd1; #1; expect_illegal("MRET with rs1 != x0");

        apply_fields(7'b1110011, 3'b001, 7'b0000000, 12'h300); expect_legal("CSRRW");
        apply_fields(7'b1110011, 3'b010, 7'b0000000, 12'h300); expect_legal("CSRRS");
        apply_fields(7'b1110011, 3'b011, 7'b0000000, 12'h300); expect_legal("CSRRC");
        apply_fields(7'b1110011, 3'b101, 7'b0000000, 12'h300); expect_legal("CSRRWI");
        apply_fields(7'b1110011, 3'b110, 7'b0000000, 12'h300); expect_legal("CSRRSI");
        apply_fields(7'b1110011, 3'b111, 7'b0000000, 12'h300); expect_legal("CSRRCI");
        apply_fields(7'b0001111, 3'b001, 7'b0000000, 12'h000); expect_illegal("FENCE.I/Zifencei not RV32I");

        if (accepted != 47) begin
            $display("FAIL: accepted instruction count=%0d expected=47", accepted);
            errors = errors + 1;
        end

        if (errors == 0) begin
            $display("PASS: control_unit accepts RV32I base, Zicsr, and MRET");
            $finish;
        end

        $display("FAIL: %0d errors", errors);
        $finish;
    end
endmodule
