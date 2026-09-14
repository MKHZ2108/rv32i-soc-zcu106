`timescale 1ns/1ps

module carry_select_adder #(
    parameter XLEN = 32,
    parameter BLOCK_WIDTH = 4
)(
    input  wire [XLEN-1:0] a,
    input  wire [XLEN-1:0] b,
    input  wire            cin,
    output wire [XLEN-1:0] sum,
    output wire            cout
);
    localparam BLOCKS = (XLEN + BLOCK_WIDTH - 1) / BLOCK_WIDTH;
    wire [BLOCKS:0] carry;
    genvar i;

    assign carry[0] = cin;
    assign cout = carry[BLOCKS];

    generate
        for (i = 0; i < BLOCKS; i = i + 1) begin : gen_cs
            localparam L = i * BLOCK_WIDTH;
            localparam W = ((L + BLOCK_WIDTH) <= XLEN) ? BLOCK_WIDTH : (XLEN - L);
            wire [W-1:0] sum0;
            wire [W-1:0] sum1;
            wire cout0;
            wire cout1;

            assign {cout0, sum0} = {1'b0, a[L +: W]} + {1'b0, b[L +: W]};
            assign {cout1, sum1} = {1'b0, a[L +: W]} + {1'b0, b[L +: W]} + {{W{1'b0}}, 1'b1};
            assign sum[L +: W] = carry[i] ? sum1 : sum0;
            assign carry[i+1] = carry[i] ? cout1 : cout0;
        end
    endgenerate
endmodule
