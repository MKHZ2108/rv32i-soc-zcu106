`timescale 1ns/1ps

module ripple_adder #(
    parameter XLEN = 32
)(
    input  wire [XLEN-1:0] a,
    input  wire [XLEN-1:0] b,
    input  wire            cin,
    output wire [XLEN-1:0] sum,
    output wire            cout
);
    wire [XLEN:0] full_sum;

    assign full_sum = {1'b0, a} + {1'b0, b} + {{XLEN{1'b0}}, cin};
    assign sum = full_sum[XLEN-1:0];
    assign cout = full_sum[XLEN];
endmodule
