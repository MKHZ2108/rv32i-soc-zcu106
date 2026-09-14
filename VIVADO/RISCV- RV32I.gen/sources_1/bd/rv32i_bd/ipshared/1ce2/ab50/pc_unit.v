`timescale 1ns/1ps

module pc_unit #(
    parameter RESET_PC = 32'h0000_0000
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        stall,
    input  wire        pc_redirect_valid,
    input  wire [31:0] pc_redirect_target,
    output reg  [31:0] pc_current,
    output wire [31:0] pc_plus4
);
    reg [31:0] pc_next;

    assign pc_plus4 = pc_current + 32'd4;

    always @(*) begin
        if (pc_redirect_valid)
            pc_next = pc_redirect_target;
        else if (stall)
            pc_next = pc_current;
        else
            pc_next = pc_plus4;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pc_current <= RESET_PC;
        else
            pc_current <= pc_next;
    end
endmodule
