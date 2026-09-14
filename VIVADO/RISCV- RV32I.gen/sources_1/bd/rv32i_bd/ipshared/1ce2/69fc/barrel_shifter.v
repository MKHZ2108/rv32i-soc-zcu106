`timescale 1ns/1ps

module barrel_shifter #(
    parameter XLEN = 32
)(
    input  wire [XLEN-1:0] data_in,
    input  wire [4:0]      shamt,
    input  wire [1:0]      shift_op,
    output wire [XLEN-1:0] data_out
);
    wire is_left;
    wire [XLEN-1:0] reversed_in;
    wire [XLEN-1:0] shift_in;
    wire [XLEN-1:0] s1;
    wire [XLEN-1:0] s2;
    wire [XLEN-1:0] s4;
    wire [XLEN-1:0] s8;
    wire [XLEN-1:0] s16;
    wire [XLEN-1:0] reversed_out;
    wire fill;
    genvar i;

    assign is_left = (shift_op == 2'd0);
    assign fill = (shift_op == 2'd2) ? data_in[XLEN-1] : 1'b0;

    generate
        for (i = 0; i < XLEN; i = i + 1) begin : gen_reverse
            assign reversed_in[i] = data_in[XLEN-1-i];
            assign reversed_out[i] = s16[XLEN-1-i];
        end
    endgenerate

    assign shift_in = is_left ? reversed_in : data_in;
    assign s1  = shamt[0] ? {{1{fill}},  shift_in[XLEN-1:1]} : shift_in;
    assign s2  = shamt[1] ? {{2{fill}},  s1[XLEN-1:2]}       : s1;
    assign s4  = shamt[2] ? {{4{fill}},  s2[XLEN-1:4]}       : s2;
    assign s8  = shamt[3] ? {{8{fill}},  s4[XLEN-1:8]}       : s4;
    assign s16 = shamt[4] ? {{16{fill}}, s8[XLEN-1:16]}      : s8;

    assign data_out = is_left ? reversed_out : s16;
endmodule
