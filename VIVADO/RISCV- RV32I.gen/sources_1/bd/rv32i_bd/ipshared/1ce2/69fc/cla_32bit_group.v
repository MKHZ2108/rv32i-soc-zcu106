`timescale 1ns/1ps

module cla_32bit_group(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire        cin,
    output wire [31:0] sum,
    output wire        cout
);
    wire [7:0] group_p;
    wire [7:0] group_g;
    wire [8:0] group_c;
    genvar i;

    assign group_c[0] = cin;

    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_group
            cla_4bit u_cla4 (
                .a(a[(i*4)+3:i*4]),
                .b(b[(i*4)+3:i*4]),
                .cin(group_c[i]),
                .sum(sum[(i*4)+3:i*4]),
                .cout(),
                .group_generate(group_g[i]),
                .group_propagate(group_p[i])
            );
        end
    endgenerate

    assign group_c[1] = group_g[0] | (group_p[0] & group_c[0]);
    assign group_c[2] = group_g[1] | (group_p[1] & group_g[0]) |
                        (group_p[1] & group_p[0] & group_c[0]);
    assign group_c[3] = group_g[2] | (group_p[2] & group_g[1]) |
                        (group_p[2] & group_p[1] & group_g[0]) |
                        (group_p[2] & group_p[1] & group_p[0] & group_c[0]);
    assign group_c[4] = group_g[3] | (group_p[3] & group_g[2]) |
                        (group_p[3] & group_p[2] & group_g[1]) |
                        (group_p[3] & group_p[2] & group_p[1] & group_g[0]) |
                        (group_p[3] & group_p[2] & group_p[1] & group_p[0] & group_c[0]);
    assign group_c[5] = group_g[4] | (group_p[4] & group_g[3]) |
                        (group_p[4] & group_p[3] & group_g[2]) |
                        (group_p[4] & group_p[3] & group_p[2] & group_g[1]) |
                        (group_p[4] & group_p[3] & group_p[2] & group_p[1] & group_g[0]) |
                        (group_p[4] & group_p[3] & group_p[2] & group_p[1] & group_p[0] & group_c[0]);
    assign group_c[6] = group_g[5] | (group_p[5] & group_g[4]) |
                        (group_p[5] & group_p[4] & group_g[3]) |
                        (group_p[5] & group_p[4] & group_p[3] & group_g[2]) |
                        (group_p[5] & group_p[4] & group_p[3] & group_p[2] & group_g[1]) |
                        (group_p[5] & group_p[4] & group_p[3] & group_p[2] & group_p[1] & group_g[0]) |
                        (group_p[5] & group_p[4] & group_p[3] & group_p[2] & group_p[1] & group_p[0] & group_c[0]);
    assign group_c[7] = group_g[6] | (group_p[6] & group_g[5]) |
                        (group_p[6] & group_p[5] & group_g[4]) |
                        (group_p[6] & group_p[5] & group_p[4] & group_g[3]) |
                        (group_p[6] & group_p[5] & group_p[4] & group_p[3] & group_g[2]) |
                        (group_p[6] & group_p[5] & group_p[4] & group_p[3] & group_p[2] & group_g[1]) |
                        (group_p[6] & group_p[5] & group_p[4] & group_p[3] & group_p[2] & group_p[1] & group_g[0]) |
                        (group_p[6] & group_p[5] & group_p[4] & group_p[3] & group_p[2] & group_p[1] & group_p[0] & group_c[0]);
    assign group_c[8] = group_g[7] | (group_p[7] & group_g[6]) |
                        (group_p[7] & group_p[6] & group_g[5]) |
                        (group_p[7] & group_p[6] & group_p[5] & group_g[4]) |
                        (group_p[7] & group_p[6] & group_p[5] & group_p[4] & group_g[3]) |
                        (group_p[7] & group_p[6] & group_p[5] & group_p[4] & group_p[3] & group_g[2]) |
                        (group_p[7] & group_p[6] & group_p[5] & group_p[4] & group_p[3] & group_p[2] & group_g[1]) |
                        (group_p[7] & group_p[6] & group_p[5] & group_p[4] & group_p[3] & group_p[2] & group_p[1] & group_g[0]) |
                        (group_p[7] & group_p[6] & group_p[5] & group_p[4] & group_p[3] & group_p[2] & group_p[1] & group_p[0] & group_c[0]);

    assign cout = group_c[8];
endmodule
