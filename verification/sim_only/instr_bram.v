`timescale 1ns/1ps

module instr_bram #(
    parameter ADDR_WIDTH = 16,
    parameter INIT_FILE  = ""
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid,
    input  wire [31:0] addr,
    output reg         ready,
    output reg  [31:0] rdata,
    output reg         err
);
    localparam WORDS = (1 << (ADDR_WIDTH-2));

    (* ram_style = "block", rom_style = "block" *)
    reg [31:0] mem [0:WORDS-1];
    wire out_of_range;
    integer init_i;

    assign out_of_range = |addr[31:ADDR_WIDTH];

    initial begin
        for (init_i = 0; init_i < WORDS; init_i = init_i + 1)
            mem[init_i] = 32'h0000_0013;
        if (INIT_FILE != "")
            $readmemh(INIT_FILE, mem);
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ready <= 1'b0;
            err <= 1'b0;
        end else begin
            ready <= valid;
            err <= valid && out_of_range;
        end
    end

    always @(posedge clk) begin
        if (valid && !out_of_range)
            rdata <= mem[addr[ADDR_WIDTH-1:2]];
        else
            rdata <= 32'b0;
    end
endmodule
