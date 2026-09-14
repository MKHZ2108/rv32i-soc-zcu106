`timescale 1ns/1ps

module decoder_imm_ext_tb;
    reg  [31:0] instr;
    reg  [2:0]  imm_type;
    wire [6:0]  opcode;
    wire [4:0]  rd;
    wire [2:0]  funct3;
    wire [4:0]  rs1;
    wire [4:0]  rs2;
    wire [6:0]  funct7;
    wire [31:0] imm;
    integer errors;

    decoder u_decoder (
        .instr(instr), .opcode(opcode), .rd(rd), .funct3(funct3),
        .rs1(rs1), .rs2(rs2), .funct7(funct7)
    );

    imm_gen u_imm_gen (
        .instr(instr), .imm_type(imm_type), .imm(imm)
    );

    function [31:0] r_type;
        input [6:0] f7;
        input [4:0] r2;
        input [4:0] r1;
        input [2:0] f3;
        input [4:0] rd_i;
        input [6:0] op;
        begin
            r_type = {f7, r2, r1, f3, rd_i, op};
        end
    endfunction

    function [31:0] i_type;
        input [31:0] imm_i;
        input [4:0]  r1;
        input [2:0]  f3;
        input [4:0]  rd_i;
        input [6:0]  op;
        begin
            i_type = {imm_i[11:0], r1, f3, rd_i, op};
        end
    endfunction

    function [31:0] s_type;
        input [31:0] imm_i;
        input [4:0]  r2;
        input [4:0]  r1;
        input [2:0]  f3;
        input [6:0]  op;
        begin
            s_type = {imm_i[11:5], r2, r1, f3, imm_i[4:0], op};
        end
    endfunction

    function [31:0] b_type;
        input [31:0] imm_i;
        input [4:0]  r2;
        input [4:0]  r1;
        input [2:0]  f3;
        input [6:0]  op;
        begin
            b_type = {imm_i[12], imm_i[10:5], r2, r1, f3, imm_i[4:1], imm_i[11], op};
        end
    endfunction

    function [31:0] u_type;
        input [31:0] imm_i;
        input [4:0]  rd_i;
        input [6:0]  op;
        begin
            u_type = {imm_i[31:12], rd_i, op};
        end
    endfunction

    function [31:0] j_type;
        input [31:0] imm_i;
        input [4:0]  rd_i;
        input [6:0]  op;
        begin
            j_type = {imm_i[20], imm_i[10:1], imm_i[11], imm_i[19:12], rd_i, op};
        end
    endfunction

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
        instr = r_type(7'b0100000, 5'd7, 5'd6, 3'b000, 5'd5, 7'b0110011);
        imm_type = 3'd0;
        #1;
        check(opcode == 7'b0110011, "opcode decode");
        check(rd == 5'd5, "rd decode");
        check(funct3 == 3'b000, "funct3 decode");
        check(rs1 == 5'd6, "rs1 decode");
        check(rs2 == 5'd7, "rs2 decode");
        check(funct7 == 7'b0100000, "funct7 decode");

        instr = i_type(32'hFFFF_FFF0, 5'd4, 3'b000, 5'd3, 7'b0010011);
        imm_type = 3'd0;
        #1;
        check(imm == 32'hFFFF_FFF0, "I immediate sign extend");

        instr = s_type(32'hFFFF_FFEC, 5'd9, 5'd10, 3'b010, 7'b0100011);
        imm_type = 3'd1;
        #1;
        check(imm == 32'hFFFF_FFEC, "S immediate sign extend");

        instr = b_type(32'hFFFF_FFF8, 5'd2, 5'd1, 3'b000, 7'b1100011);
        imm_type = 3'd2;
        #1;
        check(imm == 32'hFFFF_FFF8, "B immediate negative offset");

        instr = u_type(32'h1234_5000, 5'd11, 7'b0110111);
        imm_type = 3'd3;
        #1;
        check(imm == 32'h1234_5000, "U immediate");

        instr = j_type(32'hFFFF_F800, 5'd1, 7'b1101111);
        imm_type = 3'd4;
        #1;
        check(imm == 32'hFFFF_F800, "J immediate negative offset");

        imm_type = 3'd7;
        #1;
        check(imm == 32'b0, "default immediate");

        if (errors == 0) begin
            $display("PASS: decoder_imm_ext_tb");
            $finish;
        end

        $display("FAIL: decoder_imm_ext_tb %0d errors", errors);
        $finish;
    end
endmodule
