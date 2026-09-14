//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
//Date        : Fri Jul 31 16:42:02 2026
//Host        : Ngoclaptop running 64-bit major release  (build 9200)
//Command     : generate_target rv32i_bd.bd
//Design      : rv32i_bd
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "rv32i_bd,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=rv32i_bd,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=12,numReposBlks=12,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_clkrst_cnt=3,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "rv32i_bd.hwdef" *) 
module rv32i_bd
   (clk_in1_n_0,
    clk_in1_p_0,
    clk_out,
    ext_reset_in_0,
    interconnect_aresetn,
    peripheral_aresetn,
    pll_locked,
    rx_0,
    tx_0);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_IN1_N_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_IN1_N_0, CLK_DOMAIN rv32i_bd_clk_in1_n_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk_in1_n_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_IN1_P_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_IN1_P_0, CLK_DOMAIN rv32i_bd_clk_in1_p_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk_in1_p_0;
  output clk_out;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.EXT_RESET_IN_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.EXT_RESET_IN_0, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) input ext_reset_in_0;
  output [0:0]interconnect_aresetn;
  output [0:0]peripheral_aresetn;
  output pll_locked;
  input rx_0;
  output tx_0;

  wire [12:0]axi_bram_ctrl_0_BRAM_PORTA_ADDR;
  wire axi_bram_ctrl_0_BRAM_PORTA_CLK;
  wire [31:0]axi_bram_ctrl_0_BRAM_PORTA_DIN;
  wire [31:0]axi_bram_ctrl_0_BRAM_PORTA_DOUT;
  wire axi_bram_ctrl_0_BRAM_PORTA_EN;
  wire axi_bram_ctrl_0_BRAM_PORTA_RST;
  wire [3:0]axi_bram_ctrl_0_BRAM_PORTA_WE;
  wire [12:0]axi_bram_ctrl_1_BRAM_PORTA_ADDR;
  wire axi_bram_ctrl_1_BRAM_PORTA_CLK;
  wire [31:0]axi_bram_ctrl_1_BRAM_PORTA_DIN;
  wire [31:0]axi_bram_ctrl_1_BRAM_PORTA_DOUT;
  wire axi_bram_ctrl_1_BRAM_PORTA_EN;
  wire axi_bram_ctrl_1_BRAM_PORTA_RST;
  wire [3:0]axi_bram_ctrl_1_BRAM_PORTA_WE;
  wire axi_intc_0_irq;
  wire axi_uartlite_0_interrupt;
  wire clk_in1_n_0;
  wire clk_in1_p_0;
  wire clk_out;
  wire ext_reset_in_0;
  wire [0:0]interconnect_aresetn;
  wire [31:0]jtag_axi_0_M_AXI_ARADDR;
  wire [2:0]jtag_axi_0_M_AXI_ARPROT;
  wire jtag_axi_0_M_AXI_ARREADY;
  wire jtag_axi_0_M_AXI_ARVALID;
  wire [31:0]jtag_axi_0_M_AXI_AWADDR;
  wire [2:0]jtag_axi_0_M_AXI_AWPROT;
  wire jtag_axi_0_M_AXI_AWREADY;
  wire jtag_axi_0_M_AXI_AWVALID;
  wire jtag_axi_0_M_AXI_BREADY;
  wire [1:0]jtag_axi_0_M_AXI_BRESP;
  wire jtag_axi_0_M_AXI_BVALID;
  wire [31:0]jtag_axi_0_M_AXI_RDATA;
  wire jtag_axi_0_M_AXI_RREADY;
  wire [1:0]jtag_axi_0_M_AXI_RRESP;
  wire jtag_axi_0_M_AXI_RVALID;
  wire [31:0]jtag_axi_0_M_AXI_WDATA;
  wire jtag_axi_0_M_AXI_WREADY;
  wire [3:0]jtag_axi_0_M_AXI_WSTRB;
  wire jtag_axi_0_M_AXI_WVALID;
  wire [0:0]peripheral_aresetn;
  wire pll_locked;
  wire [31:0]rv32i_axi_integratio_0_M_AXI_DMEM_ARADDR;
  wire [2:0]rv32i_axi_integratio_0_M_AXI_DMEM_ARPROT;
  wire rv32i_axi_integratio_0_M_AXI_DMEM_ARREADY;
  wire rv32i_axi_integratio_0_M_AXI_DMEM_ARVALID;
  wire [31:0]rv32i_axi_integratio_0_M_AXI_DMEM_AWADDR;
  wire [2:0]rv32i_axi_integratio_0_M_AXI_DMEM_AWPROT;
  wire rv32i_axi_integratio_0_M_AXI_DMEM_AWREADY;
  wire rv32i_axi_integratio_0_M_AXI_DMEM_AWVALID;
  wire rv32i_axi_integratio_0_M_AXI_DMEM_BREADY;
  wire [1:0]rv32i_axi_integratio_0_M_AXI_DMEM_BRESP;
  wire rv32i_axi_integratio_0_M_AXI_DMEM_BVALID;
  wire [31:0]rv32i_axi_integratio_0_M_AXI_DMEM_RDATA;
  wire rv32i_axi_integratio_0_M_AXI_DMEM_RREADY;
  wire [1:0]rv32i_axi_integratio_0_M_AXI_DMEM_RRESP;
  wire rv32i_axi_integratio_0_M_AXI_DMEM_RVALID;
  wire [31:0]rv32i_axi_integratio_0_M_AXI_DMEM_WDATA;
  wire rv32i_axi_integratio_0_M_AXI_DMEM_WREADY;
  wire [3:0]rv32i_axi_integratio_0_M_AXI_DMEM_WSTRB;
  wire rv32i_axi_integratio_0_M_AXI_DMEM_WVALID;
  wire [31:0]rv32i_axi_integratio_0_M_AXI_IMEM_ARADDR;
  wire [2:0]rv32i_axi_integratio_0_M_AXI_IMEM_ARPROT;
  wire rv32i_axi_integratio_0_M_AXI_IMEM_ARREADY;
  wire rv32i_axi_integratio_0_M_AXI_IMEM_ARVALID;
  wire [31:0]rv32i_axi_integratio_0_M_AXI_IMEM_RDATA;
  wire rv32i_axi_integratio_0_M_AXI_IMEM_RREADY;
  wire [1:0]rv32i_axi_integratio_0_M_AXI_IMEM_RRESP;
  wire rv32i_axi_integratio_0_M_AXI_IMEM_RVALID;
  wire rx_0;
  wire [12:0]smartconnect_0_M00_AXI_ARADDR;
  wire [2:0]smartconnect_0_M00_AXI_ARPROT;
  wire smartconnect_0_M00_AXI_ARREADY;
  wire smartconnect_0_M00_AXI_ARVALID;
  wire [12:0]smartconnect_0_M00_AXI_AWADDR;
  wire [2:0]smartconnect_0_M00_AXI_AWPROT;
  wire smartconnect_0_M00_AXI_AWREADY;
  wire smartconnect_0_M00_AXI_AWVALID;
  wire smartconnect_0_M00_AXI_BREADY;
  wire [1:0]smartconnect_0_M00_AXI_BRESP;
  wire smartconnect_0_M00_AXI_BVALID;
  wire [31:0]smartconnect_0_M00_AXI_RDATA;
  wire smartconnect_0_M00_AXI_RREADY;
  wire [1:0]smartconnect_0_M00_AXI_RRESP;
  wire smartconnect_0_M00_AXI_RVALID;
  wire [31:0]smartconnect_0_M00_AXI_WDATA;
  wire smartconnect_0_M00_AXI_WREADY;
  wire [3:0]smartconnect_0_M00_AXI_WSTRB;
  wire smartconnect_0_M00_AXI_WVALID;
  wire [12:0]smartconnect_0_M01_AXI_ARADDR;
  wire [2:0]smartconnect_0_M01_AXI_ARPROT;
  wire smartconnect_0_M01_AXI_ARREADY;
  wire smartconnect_0_M01_AXI_ARVALID;
  wire [12:0]smartconnect_0_M01_AXI_AWADDR;
  wire [2:0]smartconnect_0_M01_AXI_AWPROT;
  wire smartconnect_0_M01_AXI_AWREADY;
  wire smartconnect_0_M01_AXI_AWVALID;
  wire smartconnect_0_M01_AXI_BREADY;
  wire [1:0]smartconnect_0_M01_AXI_BRESP;
  wire smartconnect_0_M01_AXI_BVALID;
  wire [31:0]smartconnect_0_M01_AXI_RDATA;
  wire smartconnect_0_M01_AXI_RREADY;
  wire [1:0]smartconnect_0_M01_AXI_RRESP;
  wire smartconnect_0_M01_AXI_RVALID;
  wire [31:0]smartconnect_0_M01_AXI_WDATA;
  wire smartconnect_0_M01_AXI_WREADY;
  wire [3:0]smartconnect_0_M01_AXI_WSTRB;
  wire smartconnect_0_M01_AXI_WVALID;
  wire [3:0]smartconnect_0_M02_AXI_ARADDR;
  wire smartconnect_0_M02_AXI_ARREADY;
  wire smartconnect_0_M02_AXI_ARVALID;
  wire [3:0]smartconnect_0_M02_AXI_AWADDR;
  wire smartconnect_0_M02_AXI_AWREADY;
  wire smartconnect_0_M02_AXI_AWVALID;
  wire smartconnect_0_M02_AXI_BREADY;
  wire [1:0]smartconnect_0_M02_AXI_BRESP;
  wire smartconnect_0_M02_AXI_BVALID;
  wire [31:0]smartconnect_0_M02_AXI_RDATA;
  wire smartconnect_0_M02_AXI_RREADY;
  wire [1:0]smartconnect_0_M02_AXI_RRESP;
  wire smartconnect_0_M02_AXI_RVALID;
  wire [31:0]smartconnect_0_M02_AXI_WDATA;
  wire smartconnect_0_M02_AXI_WREADY;
  wire [3:0]smartconnect_0_M02_AXI_WSTRB;
  wire smartconnect_0_M02_AXI_WVALID;
  wire [8:0]smartconnect_0_M03_AXI_ARADDR;
  wire smartconnect_0_M03_AXI_ARREADY;
  wire smartconnect_0_M03_AXI_ARVALID;
  wire [8:0]smartconnect_0_M03_AXI_AWADDR;
  wire smartconnect_0_M03_AXI_AWREADY;
  wire smartconnect_0_M03_AXI_AWVALID;
  wire smartconnect_0_M03_AXI_BREADY;
  wire [1:0]smartconnect_0_M03_AXI_BRESP;
  wire smartconnect_0_M03_AXI_BVALID;
  wire [31:0]smartconnect_0_M03_AXI_RDATA;
  wire smartconnect_0_M03_AXI_RREADY;
  wire [1:0]smartconnect_0_M03_AXI_RRESP;
  wire smartconnect_0_M03_AXI_RVALID;
  wire [31:0]smartconnect_0_M03_AXI_WDATA;
  wire smartconnect_0_M03_AXI_WREADY;
  wire [3:0]smartconnect_0_M03_AXI_WSTRB;
  wire smartconnect_0_M03_AXI_WVALID;
  wire tx_0;
  wire [0:0]xlconstant_1_dout;

  rv32i_bd_axi_bram_ctrl_0_0 axi_bram_ctrl_0
       (.bram_addr_a(axi_bram_ctrl_0_BRAM_PORTA_ADDR),
        .bram_clk_a(axi_bram_ctrl_0_BRAM_PORTA_CLK),
        .bram_en_a(axi_bram_ctrl_0_BRAM_PORTA_EN),
        .bram_rddata_a(axi_bram_ctrl_0_BRAM_PORTA_DOUT),
        .bram_rst_a(axi_bram_ctrl_0_BRAM_PORTA_RST),
        .bram_we_a(axi_bram_ctrl_0_BRAM_PORTA_WE),
        .bram_wrdata_a(axi_bram_ctrl_0_BRAM_PORTA_DIN),
        .s_axi_aclk(clk_out),
        .s_axi_araddr(smartconnect_0_M00_AXI_ARADDR),
        .s_axi_aresetn(peripheral_aresetn),
        .s_axi_arprot(smartconnect_0_M00_AXI_ARPROT),
        .s_axi_arready(smartconnect_0_M00_AXI_ARREADY),
        .s_axi_arvalid(smartconnect_0_M00_AXI_ARVALID),
        .s_axi_awaddr(smartconnect_0_M00_AXI_AWADDR),
        .s_axi_awprot(smartconnect_0_M00_AXI_AWPROT),
        .s_axi_awready(smartconnect_0_M00_AXI_AWREADY),
        .s_axi_awvalid(smartconnect_0_M00_AXI_AWVALID),
        .s_axi_bready(smartconnect_0_M00_AXI_BREADY),
        .s_axi_bresp(smartconnect_0_M00_AXI_BRESP),
        .s_axi_bvalid(smartconnect_0_M00_AXI_BVALID),
        .s_axi_rdata(smartconnect_0_M00_AXI_RDATA),
        .s_axi_rready(smartconnect_0_M00_AXI_RREADY),
        .s_axi_rresp(smartconnect_0_M00_AXI_RRESP),
        .s_axi_rvalid(smartconnect_0_M00_AXI_RVALID),
        .s_axi_wdata(smartconnect_0_M00_AXI_WDATA),
        .s_axi_wready(smartconnect_0_M00_AXI_WREADY),
        .s_axi_wstrb(smartconnect_0_M00_AXI_WSTRB),
        .s_axi_wvalid(smartconnect_0_M00_AXI_WVALID));
  rv32i_bd_axi_bram_ctrl_0_1 axi_bram_ctrl_1
       (.bram_addr_a(axi_bram_ctrl_1_BRAM_PORTA_ADDR),
        .bram_clk_a(axi_bram_ctrl_1_BRAM_PORTA_CLK),
        .bram_en_a(axi_bram_ctrl_1_BRAM_PORTA_EN),
        .bram_rddata_a(axi_bram_ctrl_1_BRAM_PORTA_DOUT),
        .bram_rst_a(axi_bram_ctrl_1_BRAM_PORTA_RST),
        .bram_we_a(axi_bram_ctrl_1_BRAM_PORTA_WE),
        .bram_wrdata_a(axi_bram_ctrl_1_BRAM_PORTA_DIN),
        .s_axi_aclk(clk_out),
        .s_axi_araddr(smartconnect_0_M01_AXI_ARADDR),
        .s_axi_aresetn(peripheral_aresetn),
        .s_axi_arprot(smartconnect_0_M01_AXI_ARPROT),
        .s_axi_arready(smartconnect_0_M01_AXI_ARREADY),
        .s_axi_arvalid(smartconnect_0_M01_AXI_ARVALID),
        .s_axi_awaddr(smartconnect_0_M01_AXI_AWADDR),
        .s_axi_awprot(smartconnect_0_M01_AXI_AWPROT),
        .s_axi_awready(smartconnect_0_M01_AXI_AWREADY),
        .s_axi_awvalid(smartconnect_0_M01_AXI_AWVALID),
        .s_axi_bready(smartconnect_0_M01_AXI_BREADY),
        .s_axi_bresp(smartconnect_0_M01_AXI_BRESP),
        .s_axi_bvalid(smartconnect_0_M01_AXI_BVALID),
        .s_axi_rdata(smartconnect_0_M01_AXI_RDATA),
        .s_axi_rready(smartconnect_0_M01_AXI_RREADY),
        .s_axi_rresp(smartconnect_0_M01_AXI_RRESP),
        .s_axi_rvalid(smartconnect_0_M01_AXI_RVALID),
        .s_axi_wdata(smartconnect_0_M01_AXI_WDATA),
        .s_axi_wready(smartconnect_0_M01_AXI_WREADY),
        .s_axi_wstrb(smartconnect_0_M01_AXI_WSTRB),
        .s_axi_wvalid(smartconnect_0_M01_AXI_WVALID));
  rv32i_bd_axi_intc_0_0 axi_intc_0
       (.intr(axi_uartlite_0_interrupt),
        .irq(axi_intc_0_irq),
        .s_axi_aclk(clk_out),
        .s_axi_araddr(smartconnect_0_M03_AXI_ARADDR),
        .s_axi_aresetn(interconnect_aresetn),
        .s_axi_arready(smartconnect_0_M03_AXI_ARREADY),
        .s_axi_arvalid(smartconnect_0_M03_AXI_ARVALID),
        .s_axi_awaddr(smartconnect_0_M03_AXI_AWADDR),
        .s_axi_awready(smartconnect_0_M03_AXI_AWREADY),
        .s_axi_awvalid(smartconnect_0_M03_AXI_AWVALID),
        .s_axi_bready(smartconnect_0_M03_AXI_BREADY),
        .s_axi_bresp(smartconnect_0_M03_AXI_BRESP),
        .s_axi_bvalid(smartconnect_0_M03_AXI_BVALID),
        .s_axi_rdata(smartconnect_0_M03_AXI_RDATA),
        .s_axi_rready(smartconnect_0_M03_AXI_RREADY),
        .s_axi_rresp(smartconnect_0_M03_AXI_RRESP),
        .s_axi_rvalid(smartconnect_0_M03_AXI_RVALID),
        .s_axi_wdata(smartconnect_0_M03_AXI_WDATA),
        .s_axi_wready(smartconnect_0_M03_AXI_WREADY),
        .s_axi_wstrb(smartconnect_0_M03_AXI_WSTRB),
        .s_axi_wvalid(smartconnect_0_M03_AXI_WVALID));
  rv32i_bd_axi_uartlite_0_0 axi_uartlite_0
       (.interrupt(axi_uartlite_0_interrupt),
        .rx(rx_0),
        .s_axi_aclk(clk_out),
        .s_axi_araddr(smartconnect_0_M02_AXI_ARADDR),
        .s_axi_aresetn(peripheral_aresetn),
        .s_axi_arready(smartconnect_0_M02_AXI_ARREADY),
        .s_axi_arvalid(smartconnect_0_M02_AXI_ARVALID),
        .s_axi_awaddr(smartconnect_0_M02_AXI_AWADDR),
        .s_axi_awready(smartconnect_0_M02_AXI_AWREADY),
        .s_axi_awvalid(smartconnect_0_M02_AXI_AWVALID),
        .s_axi_bready(smartconnect_0_M02_AXI_BREADY),
        .s_axi_bresp(smartconnect_0_M02_AXI_BRESP),
        .s_axi_bvalid(smartconnect_0_M02_AXI_BVALID),
        .s_axi_rdata(smartconnect_0_M02_AXI_RDATA),
        .s_axi_rready(smartconnect_0_M02_AXI_RREADY),
        .s_axi_rresp(smartconnect_0_M02_AXI_RRESP),
        .s_axi_rvalid(smartconnect_0_M02_AXI_RVALID),
        .s_axi_wdata(smartconnect_0_M02_AXI_WDATA),
        .s_axi_wready(smartconnect_0_M02_AXI_WREADY),
        .s_axi_wstrb(smartconnect_0_M02_AXI_WSTRB),
        .s_axi_wvalid(smartconnect_0_M02_AXI_WVALID),
        .tx(tx_0));
  rv32i_bd_blk_mem_gen_0_0 blk_mem_gen_0
       (.addra({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,axi_bram_ctrl_0_BRAM_PORTA_ADDR}),
        .clka(axi_bram_ctrl_0_BRAM_PORTA_CLK),
        .dina(axi_bram_ctrl_0_BRAM_PORTA_DIN),
        .douta(axi_bram_ctrl_0_BRAM_PORTA_DOUT),
        .ena(axi_bram_ctrl_0_BRAM_PORTA_EN),
        .rsta(axi_bram_ctrl_0_BRAM_PORTA_RST),
        .wea(axi_bram_ctrl_0_BRAM_PORTA_WE));
  rv32i_bd_blk_mem_gen_0_1 blk_mem_gen_1
       (.addra({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,axi_bram_ctrl_1_BRAM_PORTA_ADDR}),
        .clka(axi_bram_ctrl_1_BRAM_PORTA_CLK),
        .dina(axi_bram_ctrl_1_BRAM_PORTA_DIN),
        .douta(axi_bram_ctrl_1_BRAM_PORTA_DOUT),
        .ena(axi_bram_ctrl_1_BRAM_PORTA_EN),
        .rsta(axi_bram_ctrl_1_BRAM_PORTA_RST),
        .wea(axi_bram_ctrl_1_BRAM_PORTA_WE));
  rv32i_bd_clk_wiz_1_0 clk_wiz_1
       (.clk_in1_n(clk_in1_n_0),
        .clk_in1_p(clk_in1_p_0),
        .clk_out1(clk_out),
        .locked(pll_locked),
        .reset(xlconstant_1_dout));
  rv32i_bd_jtag_axi_0_0 jtag_axi_0
       (.aclk(clk_out),
        .aresetn(peripheral_aresetn),
        .m_axi_araddr(jtag_axi_0_M_AXI_ARADDR),
        .m_axi_arprot(jtag_axi_0_M_AXI_ARPROT),
        .m_axi_arready(jtag_axi_0_M_AXI_ARREADY),
        .m_axi_arvalid(jtag_axi_0_M_AXI_ARVALID),
        .m_axi_awaddr(jtag_axi_0_M_AXI_AWADDR),
        .m_axi_awprot(jtag_axi_0_M_AXI_AWPROT),
        .m_axi_awready(jtag_axi_0_M_AXI_AWREADY),
        .m_axi_awvalid(jtag_axi_0_M_AXI_AWVALID),
        .m_axi_bready(jtag_axi_0_M_AXI_BREADY),
        .m_axi_bresp(jtag_axi_0_M_AXI_BRESP),
        .m_axi_bvalid(jtag_axi_0_M_AXI_BVALID),
        .m_axi_rdata(jtag_axi_0_M_AXI_RDATA),
        .m_axi_rready(jtag_axi_0_M_AXI_RREADY),
        .m_axi_rresp(jtag_axi_0_M_AXI_RRESP),
        .m_axi_rvalid(jtag_axi_0_M_AXI_RVALID),
        .m_axi_wdata(jtag_axi_0_M_AXI_WDATA),
        .m_axi_wready(jtag_axi_0_M_AXI_WREADY),
        .m_axi_wstrb(jtag_axi_0_M_AXI_WSTRB),
        .m_axi_wvalid(jtag_axi_0_M_AXI_WVALID));
  rv32i_bd_proc_sys_reset_0_0 proc_sys_reset_0
       (.aux_reset_in(1'b1),
        .dcm_locked(pll_locked),
        .ext_reset_in(ext_reset_in_0),
        .interconnect_aresetn(interconnect_aresetn),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(peripheral_aresetn),
        .slowest_sync_clk(clk_out));
  rv32i_bd_rv32i_axi_integratio_0_2 rv32i_axi_integratio_0
       (.aclk(clk_out),
        .aresetn(peripheral_aresetn),
        .irq_external(axi_intc_0_irq),
        .m_axi_dmem_araddr(rv32i_axi_integratio_0_M_AXI_DMEM_ARADDR),
        .m_axi_dmem_arprot(rv32i_axi_integratio_0_M_AXI_DMEM_ARPROT),
        .m_axi_dmem_arready(rv32i_axi_integratio_0_M_AXI_DMEM_ARREADY),
        .m_axi_dmem_arvalid(rv32i_axi_integratio_0_M_AXI_DMEM_ARVALID),
        .m_axi_dmem_awaddr(rv32i_axi_integratio_0_M_AXI_DMEM_AWADDR),
        .m_axi_dmem_awprot(rv32i_axi_integratio_0_M_AXI_DMEM_AWPROT),
        .m_axi_dmem_awready(rv32i_axi_integratio_0_M_AXI_DMEM_AWREADY),
        .m_axi_dmem_awvalid(rv32i_axi_integratio_0_M_AXI_DMEM_AWVALID),
        .m_axi_dmem_bready(rv32i_axi_integratio_0_M_AXI_DMEM_BREADY),
        .m_axi_dmem_bresp(rv32i_axi_integratio_0_M_AXI_DMEM_BRESP),
        .m_axi_dmem_bvalid(rv32i_axi_integratio_0_M_AXI_DMEM_BVALID),
        .m_axi_dmem_rdata(rv32i_axi_integratio_0_M_AXI_DMEM_RDATA),
        .m_axi_dmem_rready(rv32i_axi_integratio_0_M_AXI_DMEM_RREADY),
        .m_axi_dmem_rresp(rv32i_axi_integratio_0_M_AXI_DMEM_RRESP),
        .m_axi_dmem_rvalid(rv32i_axi_integratio_0_M_AXI_DMEM_RVALID),
        .m_axi_dmem_wdata(rv32i_axi_integratio_0_M_AXI_DMEM_WDATA),
        .m_axi_dmem_wready(rv32i_axi_integratio_0_M_AXI_DMEM_WREADY),
        .m_axi_dmem_wstrb(rv32i_axi_integratio_0_M_AXI_DMEM_WSTRB),
        .m_axi_dmem_wvalid(rv32i_axi_integratio_0_M_AXI_DMEM_WVALID),
        .m_axi_imem_araddr(rv32i_axi_integratio_0_M_AXI_IMEM_ARADDR),
        .m_axi_imem_arprot(rv32i_axi_integratio_0_M_AXI_IMEM_ARPROT),
        .m_axi_imem_arready(rv32i_axi_integratio_0_M_AXI_IMEM_ARREADY),
        .m_axi_imem_arvalid(rv32i_axi_integratio_0_M_AXI_IMEM_ARVALID),
        .m_axi_imem_awready(1'b0),
        .m_axi_imem_bresp({1'b0,1'b0}),
        .m_axi_imem_bvalid(1'b0),
        .m_axi_imem_rdata(rv32i_axi_integratio_0_M_AXI_IMEM_RDATA),
        .m_axi_imem_rready(rv32i_axi_integratio_0_M_AXI_IMEM_RREADY),
        .m_axi_imem_rresp(rv32i_axi_integratio_0_M_AXI_IMEM_RRESP),
        .m_axi_imem_rvalid(rv32i_axi_integratio_0_M_AXI_IMEM_RVALID),
        .m_axi_imem_wready(1'b0));
  rv32i_bd_smartconnect_0_0 smartconnect_0
       (.M00_AXI_araddr(smartconnect_0_M00_AXI_ARADDR),
        .M00_AXI_arprot(smartconnect_0_M00_AXI_ARPROT),
        .M00_AXI_arready(smartconnect_0_M00_AXI_ARREADY),
        .M00_AXI_arvalid(smartconnect_0_M00_AXI_ARVALID),
        .M00_AXI_awaddr(smartconnect_0_M00_AXI_AWADDR),
        .M00_AXI_awprot(smartconnect_0_M00_AXI_AWPROT),
        .M00_AXI_awready(smartconnect_0_M00_AXI_AWREADY),
        .M00_AXI_awvalid(smartconnect_0_M00_AXI_AWVALID),
        .M00_AXI_bready(smartconnect_0_M00_AXI_BREADY),
        .M00_AXI_bresp(smartconnect_0_M00_AXI_BRESP),
        .M00_AXI_bvalid(smartconnect_0_M00_AXI_BVALID),
        .M00_AXI_rdata(smartconnect_0_M00_AXI_RDATA),
        .M00_AXI_rready(smartconnect_0_M00_AXI_RREADY),
        .M00_AXI_rresp(smartconnect_0_M00_AXI_RRESP),
        .M00_AXI_rvalid(smartconnect_0_M00_AXI_RVALID),
        .M00_AXI_wdata(smartconnect_0_M00_AXI_WDATA),
        .M00_AXI_wready(smartconnect_0_M00_AXI_WREADY),
        .M00_AXI_wstrb(smartconnect_0_M00_AXI_WSTRB),
        .M00_AXI_wvalid(smartconnect_0_M00_AXI_WVALID),
        .M01_AXI_araddr(smartconnect_0_M01_AXI_ARADDR),
        .M01_AXI_arprot(smartconnect_0_M01_AXI_ARPROT),
        .M01_AXI_arready(smartconnect_0_M01_AXI_ARREADY),
        .M01_AXI_arvalid(smartconnect_0_M01_AXI_ARVALID),
        .M01_AXI_awaddr(smartconnect_0_M01_AXI_AWADDR),
        .M01_AXI_awprot(smartconnect_0_M01_AXI_AWPROT),
        .M01_AXI_awready(smartconnect_0_M01_AXI_AWREADY),
        .M01_AXI_awvalid(smartconnect_0_M01_AXI_AWVALID),
        .M01_AXI_bready(smartconnect_0_M01_AXI_BREADY),
        .M01_AXI_bresp(smartconnect_0_M01_AXI_BRESP),
        .M01_AXI_bvalid(smartconnect_0_M01_AXI_BVALID),
        .M01_AXI_rdata(smartconnect_0_M01_AXI_RDATA),
        .M01_AXI_rready(smartconnect_0_M01_AXI_RREADY),
        .M01_AXI_rresp(smartconnect_0_M01_AXI_RRESP),
        .M01_AXI_rvalid(smartconnect_0_M01_AXI_RVALID),
        .M01_AXI_wdata(smartconnect_0_M01_AXI_WDATA),
        .M01_AXI_wready(smartconnect_0_M01_AXI_WREADY),
        .M01_AXI_wstrb(smartconnect_0_M01_AXI_WSTRB),
        .M01_AXI_wvalid(smartconnect_0_M01_AXI_WVALID),
        .M02_AXI_araddr(smartconnect_0_M02_AXI_ARADDR),
        .M02_AXI_arready(smartconnect_0_M02_AXI_ARREADY),
        .M02_AXI_arvalid(smartconnect_0_M02_AXI_ARVALID),
        .M02_AXI_awaddr(smartconnect_0_M02_AXI_AWADDR),
        .M02_AXI_awready(smartconnect_0_M02_AXI_AWREADY),
        .M02_AXI_awvalid(smartconnect_0_M02_AXI_AWVALID),
        .M02_AXI_bready(smartconnect_0_M02_AXI_BREADY),
        .M02_AXI_bresp(smartconnect_0_M02_AXI_BRESP),
        .M02_AXI_bvalid(smartconnect_0_M02_AXI_BVALID),
        .M02_AXI_rdata(smartconnect_0_M02_AXI_RDATA),
        .M02_AXI_rready(smartconnect_0_M02_AXI_RREADY),
        .M02_AXI_rresp(smartconnect_0_M02_AXI_RRESP),
        .M02_AXI_rvalid(smartconnect_0_M02_AXI_RVALID),
        .M02_AXI_wdata(smartconnect_0_M02_AXI_WDATA),
        .M02_AXI_wready(smartconnect_0_M02_AXI_WREADY),
        .M02_AXI_wstrb(smartconnect_0_M02_AXI_WSTRB),
        .M02_AXI_wvalid(smartconnect_0_M02_AXI_WVALID),
        .M03_AXI_araddr(smartconnect_0_M03_AXI_ARADDR),
        .M03_AXI_arready(smartconnect_0_M03_AXI_ARREADY),
        .M03_AXI_arvalid(smartconnect_0_M03_AXI_ARVALID),
        .M03_AXI_awaddr(smartconnect_0_M03_AXI_AWADDR),
        .M03_AXI_awready(smartconnect_0_M03_AXI_AWREADY),
        .M03_AXI_awvalid(smartconnect_0_M03_AXI_AWVALID),
        .M03_AXI_bready(smartconnect_0_M03_AXI_BREADY),
        .M03_AXI_bresp(smartconnect_0_M03_AXI_BRESP),
        .M03_AXI_bvalid(smartconnect_0_M03_AXI_BVALID),
        .M03_AXI_rdata(smartconnect_0_M03_AXI_RDATA),
        .M03_AXI_rready(smartconnect_0_M03_AXI_RREADY),
        .M03_AXI_rresp(smartconnect_0_M03_AXI_RRESP),
        .M03_AXI_rvalid(smartconnect_0_M03_AXI_RVALID),
        .M03_AXI_wdata(smartconnect_0_M03_AXI_WDATA),
        .M03_AXI_wready(smartconnect_0_M03_AXI_WREADY),
        .M03_AXI_wstrb(smartconnect_0_M03_AXI_WSTRB),
        .M03_AXI_wvalid(smartconnect_0_M03_AXI_WVALID),
        .S00_AXI_araddr(rv32i_axi_integratio_0_M_AXI_IMEM_ARADDR),
        .S00_AXI_arprot(rv32i_axi_integratio_0_M_AXI_IMEM_ARPROT),
        .S00_AXI_arready(rv32i_axi_integratio_0_M_AXI_IMEM_ARREADY),
        .S00_AXI_arvalid(rv32i_axi_integratio_0_M_AXI_IMEM_ARVALID),
        .S00_AXI_rdata(rv32i_axi_integratio_0_M_AXI_IMEM_RDATA),
        .S00_AXI_rready(rv32i_axi_integratio_0_M_AXI_IMEM_RREADY),
        .S00_AXI_rresp(rv32i_axi_integratio_0_M_AXI_IMEM_RRESP),
        .S00_AXI_rvalid(rv32i_axi_integratio_0_M_AXI_IMEM_RVALID),
        .S01_AXI_araddr(rv32i_axi_integratio_0_M_AXI_DMEM_ARADDR),
        .S01_AXI_arprot(rv32i_axi_integratio_0_M_AXI_DMEM_ARPROT),
        .S01_AXI_arready(rv32i_axi_integratio_0_M_AXI_DMEM_ARREADY),
        .S01_AXI_arvalid(rv32i_axi_integratio_0_M_AXI_DMEM_ARVALID),
        .S01_AXI_awaddr(rv32i_axi_integratio_0_M_AXI_DMEM_AWADDR),
        .S01_AXI_awprot(rv32i_axi_integratio_0_M_AXI_DMEM_AWPROT),
        .S01_AXI_awready(rv32i_axi_integratio_0_M_AXI_DMEM_AWREADY),
        .S01_AXI_awvalid(rv32i_axi_integratio_0_M_AXI_DMEM_AWVALID),
        .S01_AXI_bready(rv32i_axi_integratio_0_M_AXI_DMEM_BREADY),
        .S01_AXI_bresp(rv32i_axi_integratio_0_M_AXI_DMEM_BRESP),
        .S01_AXI_bvalid(rv32i_axi_integratio_0_M_AXI_DMEM_BVALID),
        .S01_AXI_rdata(rv32i_axi_integratio_0_M_AXI_DMEM_RDATA),
        .S01_AXI_rready(rv32i_axi_integratio_0_M_AXI_DMEM_RREADY),
        .S01_AXI_rresp(rv32i_axi_integratio_0_M_AXI_DMEM_RRESP),
        .S01_AXI_rvalid(rv32i_axi_integratio_0_M_AXI_DMEM_RVALID),
        .S01_AXI_wdata(rv32i_axi_integratio_0_M_AXI_DMEM_WDATA),
        .S01_AXI_wready(rv32i_axi_integratio_0_M_AXI_DMEM_WREADY),
        .S01_AXI_wstrb(rv32i_axi_integratio_0_M_AXI_DMEM_WSTRB),
        .S01_AXI_wvalid(rv32i_axi_integratio_0_M_AXI_DMEM_WVALID),
        .S02_AXI_araddr(jtag_axi_0_M_AXI_ARADDR),
        .S02_AXI_arprot(jtag_axi_0_M_AXI_ARPROT),
        .S02_AXI_arready(jtag_axi_0_M_AXI_ARREADY),
        .S02_AXI_arvalid(jtag_axi_0_M_AXI_ARVALID),
        .S02_AXI_awaddr(jtag_axi_0_M_AXI_AWADDR),
        .S02_AXI_awprot(jtag_axi_0_M_AXI_AWPROT),
        .S02_AXI_awready(jtag_axi_0_M_AXI_AWREADY),
        .S02_AXI_awvalid(jtag_axi_0_M_AXI_AWVALID),
        .S02_AXI_bready(jtag_axi_0_M_AXI_BREADY),
        .S02_AXI_bresp(jtag_axi_0_M_AXI_BRESP),
        .S02_AXI_bvalid(jtag_axi_0_M_AXI_BVALID),
        .S02_AXI_rdata(jtag_axi_0_M_AXI_RDATA),
        .S02_AXI_rready(jtag_axi_0_M_AXI_RREADY),
        .S02_AXI_rresp(jtag_axi_0_M_AXI_RRESP),
        .S02_AXI_rvalid(jtag_axi_0_M_AXI_RVALID),
        .S02_AXI_wdata(jtag_axi_0_M_AXI_WDATA),
        .S02_AXI_wready(jtag_axi_0_M_AXI_WREADY),
        .S02_AXI_wstrb(jtag_axi_0_M_AXI_WSTRB),
        .S02_AXI_wvalid(jtag_axi_0_M_AXI_WVALID),
        .aclk(clk_out),
        .aresetn(interconnect_aresetn));
  rv32i_bd_xlconstant_1_0 xlconstant_1
       (.dout(xlconstant_1_dout));
endmodule
