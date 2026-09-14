`timescale 1ns/1ps

module reg_file #(
    parameter XLEN = 32,
    parameter REG_COUNT = 32
)(
    input  wire             clk,
    input  wire             rst_n,
    input  wire [4:0]       rs1_addr,
    input  wire [4:0]       rs2_addr,
    output wire [XLEN-1:0]  rs1_data,
    output wire [XLEN-1:0]  rs2_data,
    input  wire             rd_we,
    input  wire [4:0]       rd_addr,
    input  wire [XLEN-1:0]  rd_data
);
    reg [XLEN-1:0] regs [0:REG_COUNT-1];

    always @(posedge clk) begin
        if (rd_we && rd_addr != 5'd0) begin
            regs[rd_addr] <= rd_data;
        end
    end

    assign rs1_data = (rs1_addr == 5'd0) ? {XLEN{1'b0}} :
                      (rd_we && rd_addr != 5'd0 && rd_addr == rs1_addr) ? rd_data :
                      regs[rs1_addr];
    assign rs2_data = (rs2_addr == 5'd0) ? {XLEN{1'b0}} :
                      (rd_we && rd_addr != 5'd0 && rd_addr == rs2_addr) ? rd_data :
                      regs[rs2_addr];
endmodule
