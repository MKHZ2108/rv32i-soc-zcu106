`timescale 1ns/1ps

module rv32i_axi_integration_top #(
    parameter XLEN         = 32,
    parameter RESET_PC     = 32'h0000_0000,
    parameter ADDER_IMPL   = 0,
    parameter SHIFTER_IMPL = 0
)(
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF M_AXI_IMEM:M_AXI_DMEM, ASSOCIATED_RESET aresetn" *)
    input  wire        aclk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW" *)
    input  wire        aresetn,
    (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 irq_external INTERRUPT" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME irq_external, SENSITIVITY LEVEL_HIGH" *)
    input  wire        irq_external,

    output wire        debug_halted,
    output wire [31:0] debug_pc,
    output wire [31:0] debug_instr,

    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM AWADDR" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXI_IMEM, PROTOCOL AXI4LITE, ADDR_WIDTH 32, DATA_WIDTH 32, READ_WRITE_MODE READ_ONLY" *)
    output wire [31:0] m_axi_imem_awaddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM AWPROT" *)
    output wire [2:0]  m_axi_imem_awprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM AWVALID" *)
    output wire        m_axi_imem_awvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM AWREADY" *)
    input  wire        m_axi_imem_awready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM WDATA" *)
    output wire [31:0] m_axi_imem_wdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM WSTRB" *)
    output wire [3:0]  m_axi_imem_wstrb,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM WVALID" *)
    output wire        m_axi_imem_wvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM WREADY" *)
    input  wire        m_axi_imem_wready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM BRESP" *)
    input  wire [1:0]  m_axi_imem_bresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM BVALID" *)
    input  wire        m_axi_imem_bvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM BREADY" *)
    output wire        m_axi_imem_bready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM ARADDR" *)
    output wire [31:0] m_axi_imem_araddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM ARPROT" *)
    output wire [2:0]  m_axi_imem_arprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM ARVALID" *)
    output wire        m_axi_imem_arvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM ARREADY" *)
    input  wire        m_axi_imem_arready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM RDATA" *)
    input  wire [31:0] m_axi_imem_rdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM RRESP" *)
    input  wire [1:0]  m_axi_imem_rresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM RVALID" *)
    input  wire        m_axi_imem_rvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM RREADY" *)
    output wire        m_axi_imem_rready,

    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM AWADDR" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXI_DMEM, PROTOCOL AXI4LITE, ADDR_WIDTH 32, DATA_WIDTH 32, READ_WRITE_MODE READ_WRITE" *)
    output wire [31:0] m_axi_dmem_awaddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM AWPROT" *)
    output wire [2:0]  m_axi_dmem_awprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM AWVALID" *)
    output wire        m_axi_dmem_awvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM AWREADY" *)
    input  wire        m_axi_dmem_awready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM WDATA" *)
    output wire [31:0] m_axi_dmem_wdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM WSTRB" *)
    output wire [3:0]  m_axi_dmem_wstrb,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM WVALID" *)
    output wire        m_axi_dmem_wvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM WREADY" *)
    input  wire        m_axi_dmem_wready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM BRESP" *)
    input  wire [1:0]  m_axi_dmem_bresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM BVALID" *)
    input  wire        m_axi_dmem_bvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM BREADY" *)
    output wire        m_axi_dmem_bready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM ARADDR" *)
    output wire [31:0] m_axi_dmem_araddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM ARPROT" *)
    output wire [2:0]  m_axi_dmem_arprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM ARVALID" *)
    output wire        m_axi_dmem_arvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM ARREADY" *)
    input  wire        m_axi_dmem_arready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM RDATA" *)
    input  wire [31:0] m_axi_dmem_rdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM RRESP" *)
    input  wire [1:0]  m_axi_dmem_rresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM RVALID" *)
    input  wire        m_axi_dmem_rvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM RREADY" *)
    output wire        m_axi_dmem_rready
);
    wire imem_valid;
    wire [31:0] imem_addr;
    wire imem_cancel;
    wire imem_ready;
    wire [31:0] imem_rdata;
    wire imem_err;

    wire dmem_valid;
    wire dmem_we;
    wire [3:0] dmem_be;
    wire [31:0] dmem_addr;
    wire [31:0] dmem_wdata;
    wire dmem_ready;
    wire [31:0] dmem_rdata;
    wire dmem_err;

    rv32i_core #(
        .XLEN(XLEN),
        .RESET_PC(RESET_PC),
        .ADDER_IMPL(ADDER_IMPL),
        .SHIFTER_IMPL(SHIFTER_IMPL)
    ) u_core (
        .clk(aclk),
        .rst_n(aresetn),
        .irq_external(irq_external),
        .imem_valid(imem_valid),
        .imem_addr(imem_addr),
        .imem_cancel(imem_cancel),
        .imem_ready(imem_ready),
        .imem_rdata(imem_rdata),
        .imem_err(imem_err),
        .dmem_valid(dmem_valid),
        .dmem_we(dmem_we),
        .dmem_be(dmem_be),
        .dmem_addr(dmem_addr),
        .dmem_wdata(dmem_wdata),
        .dmem_ready(dmem_ready),
        .dmem_rdata(dmem_rdata),
        .dmem_err(dmem_err),
        .debug_halted(debug_halted),
        .debug_pc(debug_pc),
        .debug_instr(debug_instr)
    );

    imem_axi_lite_adapter u_imem_axi (
        .clk(aclk), .rst_n(aresetn),
        .core_valid(imem_valid), .core_addr(imem_addr), .core_cancel(imem_cancel),
        .core_ready(imem_ready), .core_rdata(imem_rdata), .core_err(imem_err),
        .m_axi_awaddr(m_axi_imem_awaddr), .m_axi_awprot(m_axi_imem_awprot),
        .m_axi_awvalid(m_axi_imem_awvalid), .m_axi_awready(m_axi_imem_awready),
        .m_axi_wdata(m_axi_imem_wdata), .m_axi_wstrb(m_axi_imem_wstrb),
        .m_axi_wvalid(m_axi_imem_wvalid), .m_axi_wready(m_axi_imem_wready),
        .m_axi_bresp(m_axi_imem_bresp), .m_axi_bvalid(m_axi_imem_bvalid),
        .m_axi_bready(m_axi_imem_bready),
        .m_axi_araddr(m_axi_imem_araddr), .m_axi_arprot(m_axi_imem_arprot),
        .m_axi_arvalid(m_axi_imem_arvalid), .m_axi_arready(m_axi_imem_arready),
        .m_axi_rdata(m_axi_imem_rdata), .m_axi_rresp(m_axi_imem_rresp),
        .m_axi_rvalid(m_axi_imem_rvalid), .m_axi_rready(m_axi_imem_rready)
    );

    dmem_axi_lite_adapter u_dmem_axi (
        .clk(aclk), .rst_n(aresetn),
        .core_valid(dmem_valid), .core_we(dmem_we), .core_be(dmem_be),
        .core_addr(dmem_addr), .core_wdata(dmem_wdata),
        .core_ready(dmem_ready), .core_rdata(dmem_rdata), .core_err(dmem_err),
        .m_axi_awaddr(m_axi_dmem_awaddr), .m_axi_awprot(m_axi_dmem_awprot),
        .m_axi_awvalid(m_axi_dmem_awvalid), .m_axi_awready(m_axi_dmem_awready),
        .m_axi_wdata(m_axi_dmem_wdata), .m_axi_wstrb(m_axi_dmem_wstrb),
        .m_axi_wvalid(m_axi_dmem_wvalid), .m_axi_wready(m_axi_dmem_wready),
        .m_axi_bresp(m_axi_dmem_bresp), .m_axi_bvalid(m_axi_dmem_bvalid),
        .m_axi_bready(m_axi_dmem_bready),
        .m_axi_araddr(m_axi_dmem_araddr), .m_axi_arprot(m_axi_dmem_arprot),
        .m_axi_arvalid(m_axi_dmem_arvalid), .m_axi_arready(m_axi_dmem_arready),
        .m_axi_rdata(m_axi_dmem_rdata), .m_axi_rresp(m_axi_dmem_rresp),
        .m_axi_rvalid(m_axi_dmem_rvalid), .m_axi_rready(m_axi_dmem_rready)
    );
endmodule
