`timescale 1ns/1ps

module alu_ext_tb;
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

    reg  [31:0] a;
    reg  [31:0] b;
    reg  [4:0]  alu_op;
    wire [31:0] result_baseline;
    wire        zero_baseline;
    wire        lt_signed_baseline;
    wire        lt_unsigned_baseline;

    integer errors;
    integer i;
    integer op_i;

    alu #(.ADDER_IMPL(0), .SHIFTER_IMPL(0)) u_baseline (
        .a(a), .b(b), .alu_op(alu_op), .result(result_baseline),
        .zero(zero_baseline), .lt_signed(lt_signed_baseline),
        .lt_unsigned(lt_unsigned_baseline)
    );

    function [31:0] expected_result;
        input [31:0] fa;
        input [31:0] fb;
        input [4:0]  fop;
        begin
            case (fop)
                ALU_ADD:    expected_result = fa + fb;
                ALU_SUB:    expected_result = fa - fb;
                ALU_SLL:    expected_result = fa << fb[4:0];
                ALU_SLT:    expected_result = ($signed(fa) < $signed(fb)) ? 32'd1 : 32'd0;
                ALU_SLTU:   expected_result = (fa < fb) ? 32'd1 : 32'd0;
                ALU_XOR:    expected_result = fa ^ fb;
                ALU_SRL:    expected_result = fa >> fb[4:0];
                ALU_SRA:    expected_result = $signed(fa) >>> fb[4:0];
                ALU_OR:     expected_result = fa | fb;
                ALU_AND:    expected_result = fa & fb;
                ALU_COPY_B: expected_result = fb;
                default:    expected_result = 32'b0;
            endcase
        end
    endfunction

    task check;
        input [127:0] name;
        input [31:0]  expected;
        begin
            if (result_baseline !== expected) begin
                $display("FAIL: %0s baseline result=%08h expected=%08h", name, result_baseline, expected);
                errors = errors + 1;
            end
            if (zero_baseline !== (expected == 32'b0)) begin
                $display("FAIL: %0s zero=%0b expected=%0b", name, zero_baseline, expected == 32'b0);
                errors = errors + 1;
            end
            if (lt_signed_baseline !== ($signed(a) < $signed(b))) begin
                $display("FAIL: %0s lt_signed mismatch", name);
                errors = errors + 1;
            end
            if (lt_unsigned_baseline !== (a < b)) begin
                $display("FAIL: %0s lt_unsigned mismatch", name);
                errors = errors + 1;
            end
        end
    endtask

    task run_vector;
        input [31:0] va;
        input [31:0] vb;
        begin
            a = va;
            b = vb;
            for (op_i = 0; op_i <= ALU_COPY_B; op_i = op_i + 1) begin
                alu_op = op_i[4:0];
                #1;
                check("alu_op", expected_result(a, b, alu_op));
            end
        end
    endtask

    initial begin
        errors = 0;
        a = 32'b0;
        b = 32'b0;
        alu_op = ALU_ADD;

        run_vector(32'h0000_0000, 32'h0000_0000);
        run_vector(32'h0000_0001, 32'h0000_0001);
        run_vector(32'hFFFF_FFFF, 32'h0000_0001);
        run_vector(32'h8000_0000, 32'h0000_001F);
        run_vector(32'h7FFF_FFFF, 32'h8000_0000);
        run_vector(32'h1234_5678, 32'h8765_4321);

        for (i = 0; i < 64; i = i + 1)
            run_vector($random, $random);

        alu_op = 5'd31;
        #1;
        check("default op", 32'b0);

        if (errors == 0) begin
            $display("PASS: alu_ext_tb");
            $finish;
        end

        $display("FAIL: alu_ext_tb %0d errors", errors);
        $finish;
    end
endmodule
