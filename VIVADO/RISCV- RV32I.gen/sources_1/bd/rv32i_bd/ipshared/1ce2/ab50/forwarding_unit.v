`timescale 1ns/1ps

module forwarding_unit(
    input  wire [4:0] ex_rs1,
    input  wire [4:0] ex_rs2,
    input  wire       mem_reg_write,
    input  wire [4:0] mem_rd,
    input  wire       wb_reg_write,
    input  wire [4:0] wb_rd,
    output reg  [1:0] forward_a_sel,
    output reg  [1:0] forward_b_sel
);
    always @(*) begin
        forward_a_sel = 2'd0;
        forward_b_sel = 2'd0;

        if (mem_reg_write && mem_rd != 5'd0 && mem_rd == ex_rs1)
            forward_a_sel = 2'd1;
        else if (wb_reg_write && wb_rd != 5'd0 && wb_rd == ex_rs1)
            forward_a_sel = 2'd2;

        if (mem_reg_write && mem_rd != 5'd0 && mem_rd == ex_rs2)
            forward_b_sel = 2'd1;
        else if (wb_reg_write && wb_rd != 5'd0 && wb_rd == ex_rs2)
            forward_b_sel = 2'd2;
    end
endmodule
