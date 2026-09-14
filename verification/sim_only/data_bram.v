`timescale 1ns/1ps

module data_bram #(
    parameter ADDR_WIDTH = 16,
    parameter BASE_ADDR  = 32'h0001_0000,
    parameter INIT_FILE  = ""
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid,
    input  wire        we,
    input  wire [3:0]  be,
    input  wire [31:0] addr,
    input  wire [31:0] wdata,
    output reg         ready,
    output reg  [31:0] rdata,
    output reg         err
);
    localparam WORDS = (1 << (ADDR_WIDTH-2));

    (* ram_style = "block" *)
    reg [31:0] mem [0:WORDS-1];
    wire [ADDR_WIDTH-1:0] local_addr;
    wire out_of_range;
    integer init_i;

    assign local_addr = addr[ADDR_WIDTH-1:0] - BASE_ADDR[ADDR_WIDTH-1:0];
    assign out_of_range = (addr[31:ADDR_WIDTH] != BASE_ADDR[31:ADDR_WIDTH]);

    initial begin
        for (init_i = 0; init_i < WORDS; init_i = init_i + 1)
            mem[init_i] = 32'b0;
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
        if (valid && !out_of_range) begin
            rdata <= mem[local_addr[ADDR_WIDTH-1:2]];
            if (we) begin
                if (be[0]) mem[local_addr[ADDR_WIDTH-1:2]][7:0] <= wdata[7:0];
                if (be[1]) mem[local_addr[ADDR_WIDTH-1:2]][15:8] <= wdata[15:8];
                if (be[2]) mem[local_addr[ADDR_WIDTH-1:2]][23:16] <= wdata[23:16];
                if (be[3]) mem[local_addr[ADDR_WIDTH-1:2]][31:24] <= wdata[31:24];
            end
        end else begin
            rdata <= 32'b0;
        end
    end
endmodule
