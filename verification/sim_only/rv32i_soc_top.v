`timescale 1ns/1ps

module rv32i_soc_top #(
    parameter XLEN            = 32,
    parameter RESET_PC        = 32'h0000_0000,
    parameter IMEM_ADDR_WIDTH = 16,
    parameter DMEM_ADDR_WIDTH = 16,
    // ADDER_IMPL: 0=ripple, 1=CLA group, 2=carry-select
    parameter ADDER_IMPL      = 0,
    // SHIFTER_IMPL: 0=Verilog shift operators, 1=barrel_shifter
    parameter SHIFTER_IMPL    = 0,
    parameter DMEM_BASE       = 32'h0001_0000,
    parameter DMEM_MASK       = 32'hFFFF_0000,
    parameter IMEM_INIT_FILE  = "",
    parameter DMEM_INIT_FILE  = ""
)(
    input  wire        clk,
    input  wire        rst_n,
    output wire        debug_halted,
    output wire [31:0] debug_pc,
    output wire [31:0] debug_instr
);
    (* ASYNC_REG = "TRUE" *) reg [1:0] rst_sync;

    wire rst_n_sync;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rst_sync <= 2'b00;
        else
            rst_sync <= {rst_sync[0], 1'b1};
    end

    assign rst_n_sync = rst_sync[1];

    wire imem_valid;
    wire [31:0] imem_addr;
    wire imem_ready;
    wire [31:0] imem_rdata;
    wire imem_err;

    wire core_dmem_valid;
    wire core_dmem_we;
    wire [3:0] core_dmem_be;
    wire [31:0] core_dmem_addr;
    wire [31:0] core_dmem_wdata;
    wire core_dmem_ready;
    wire [31:0] core_dmem_rdata;
    wire core_dmem_err;

    wire dmem_valid;
    wire dmem_we;
    wire [3:0] dmem_be;
    wire [31:0] dmem_addr;
    wire [31:0] dmem_wdata;
    wire dmem_ready;
    wire [31:0] dmem_rdata;
    wire dmem_err;

    rv32i_core #(
        .XLEN(XLEN), .RESET_PC(RESET_PC), .ADDER_IMPL(ADDER_IMPL),
        .SHIFTER_IMPL(SHIFTER_IMPL)
    ) u_core (
        .clk(clk), .rst_n(rst_n_sync),
        .irq_external(1'b0),
        .imem_valid(imem_valid), .imem_addr(imem_addr), .imem_cancel(),
        .imem_ready(imem_ready), .imem_rdata(imem_rdata), .imem_err(imem_err),
        .dmem_valid(core_dmem_valid), .dmem_we(core_dmem_we),
        .dmem_be(core_dmem_be), .dmem_addr(core_dmem_addr),
        .dmem_wdata(core_dmem_wdata), .dmem_ready(core_dmem_ready),
        .dmem_rdata(core_dmem_rdata), .dmem_err(core_dmem_err),
        .debug_halted(debug_halted), .debug_pc(debug_pc), .debug_instr(debug_instr)
    );

    instr_bram #(
        .ADDR_WIDTH(IMEM_ADDR_WIDTH),
        .INIT_FILE(IMEM_INIT_FILE)
    ) u_imem (
        .clk(clk), .rst_n(rst_n_sync), .valid(imem_valid), .addr(imem_addr),
        .ready(imem_ready), .rdata(imem_rdata), .err(imem_err)
    );

    bus_interconnect #(
        .DMEM_BASE(DMEM_BASE),
        .DMEM_MASK(DMEM_MASK)
    ) u_bus (
        .clk(clk), .rst_n(rst_n_sync),
        .m_valid(core_dmem_valid), .m_we(core_dmem_we), .m_be(core_dmem_be),
        .m_addr(core_dmem_addr), .m_wdata(core_dmem_wdata),
        .m_ready(core_dmem_ready), .m_rdata(core_dmem_rdata), .m_err(core_dmem_err),
        .dmem_valid(dmem_valid), .dmem_we(dmem_we), .dmem_be(dmem_be),
        .dmem_addr(dmem_addr), .dmem_wdata(dmem_wdata),
        .dmem_ready(dmem_ready), .dmem_rdata(dmem_rdata), .dmem_err(dmem_err)
    );

    data_bram #(
        .ADDR_WIDTH(DMEM_ADDR_WIDTH),
        .BASE_ADDR(DMEM_BASE),
        .INIT_FILE(DMEM_INIT_FILE)
    ) u_dmem (
        .clk(clk), .rst_n(rst_n_sync), .valid(dmem_valid), .we(dmem_we),
        .be(dmem_be), .addr(dmem_addr), .wdata(dmem_wdata),
        .ready(dmem_ready), .rdata(dmem_rdata), .err(dmem_err)
    );

endmodule
