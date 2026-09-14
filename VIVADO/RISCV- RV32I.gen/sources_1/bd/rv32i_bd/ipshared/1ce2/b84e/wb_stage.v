`timescale 1ns/1ps

module wb_stage(
    input  wire        wb_valid,
    input  wire        wb_fault,
    input  wire [4:0]  wb_rd,
    input  wire        wb_reg_write_in,
    input  wire [1:0]  wb_wb_sel,
    input  wire [31:0] wb_alu_result,
    input  wire [31:0] wb_load_data,
    input  wire [31:0] wb_pc_plus4,
    input  wire [31:0] wb_csr_rdata,
    output wire        rf_we,
    output wire [4:0]  rf_waddr,
    output reg  [31:0] wb_data
);
    assign rf_we = wb_valid && !wb_fault && wb_reg_write_in && (wb_rd != 5'd0);
    assign rf_waddr = wb_rd;

    always @(*) begin
        case (wb_wb_sel)
            2'd1: wb_data = wb_load_data;
            2'd2: wb_data = wb_pc_plus4;
            2'd3: wb_data = wb_csr_rdata;
            default: wb_data = wb_alu_result;
        endcase
    end
endmodule
