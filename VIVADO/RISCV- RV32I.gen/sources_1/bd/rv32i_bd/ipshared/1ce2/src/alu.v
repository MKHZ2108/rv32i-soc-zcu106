`timescale 1ns/1ps

module alu #(
    parameter XLEN         = 32,
    // ADDER_IMPL: 0=ripple, 1=CLA group, 2=carry-select
    parameter ADDER_IMPL   = 0,
    // SHIFTER_IMPL: 0=Verilog shift operators, 1=barrel_shifter
    parameter SHIFTER_IMPL = 0
)(
    input  wire [XLEN-1:0] a,
    input  wire [XLEN-1:0] b,
    input  wire [4:0]      alu_op,
    output reg  [XLEN-1:0] result,
    output wire            zero,
    output wire            lt_signed,
    output wire            lt_unsigned
);
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

    wire is_sub;
    wire [XLEN-1:0] adder_b;
    wire [XLEN-1:0] adder_sum;
    wire signed [XLEN-1:0] signed_a;
    wire [XLEN-1:0] shifter_result;
    wire [XLEN-1:0] sra_result;
    wire [1:0] shift_op;

    assign is_sub = (alu_op == ALU_SUB) || (alu_op == ALU_SLT) || (alu_op == ALU_SLTU);
    assign adder_b = is_sub ? ~b : b;
    assign signed_a = a;
    assign shift_op = (alu_op == ALU_SLL) ? 2'd0 :
                      (alu_op == ALU_SRA) ? 2'd2 : 2'd1;
    assign sra_result = signed_a >>> b[4:0];
    assign zero = (result == {XLEN{1'b0}});
    assign lt_signed = ($signed(a) < $signed(b));
    assign lt_unsigned = (a < b);

    generate
        if (ADDER_IMPL == 0) begin : gen_ripple
            ripple_adder #(.XLEN(XLEN)) u_adder (
                .a(a), .b(adder_b), .cin(is_sub), .sum(adder_sum), .cout()
            );
        end else if (ADDER_IMPL == 1) begin : gen_cla
            cla_32bit_group u_adder (
                .a(a[31:0]), .b(adder_b[31:0]), .cin(is_sub),
                .sum(adder_sum[31:0]), .cout()
            );
        end else begin : gen_carry_select
            carry_select_adder #(.XLEN(XLEN)) u_adder (
                .a(a), .b(adder_b), .cin(is_sub), .sum(adder_sum), .cout()
            );
        end
    endgenerate

    generate
        if (SHIFTER_IMPL == 0) begin : gen_synth_shift
            assign shifter_result = (shift_op == 2'd0) ? (a << b[4:0]) :
                                    (shift_op == 2'd2) ? sra_result :
                                    (a >> b[4:0]);
        end else begin : gen_barrel_shift
            barrel_shifter #(.XLEN(XLEN)) u_shifter (
                .data_in(a), .shamt(b[4:0]), .shift_op(shift_op), .data_out(shifter_result)
            );
        end
    endgenerate

    always @(*) begin
        case (alu_op)
            ALU_ADD:    result = adder_sum;
            ALU_SUB:    result = adder_sum;
            ALU_SLL:    result = shifter_result;
            ALU_SLT:    result = {{(XLEN-1){1'b0}}, lt_signed};
            ALU_SLTU:   result = {{(XLEN-1){1'b0}}, lt_unsigned};
            ALU_XOR:    result = a ^ b;
            ALU_SRL:    result = shifter_result;
            ALU_SRA:    result = shifter_result;
            ALU_OR:     result = a | b;
            ALU_AND:    result = a & b;
            ALU_COPY_B: result = b;
            default:     result = {XLEN{1'b0}};
        endcase
    end
endmodule
