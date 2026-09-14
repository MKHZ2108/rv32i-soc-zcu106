-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
-- Date        : Fri Jul 31 16:44:22 2026
-- Host        : Ngoclaptop running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub {c:/Users/Dell/Desktop/RISCV_RV32I/RISCV-
--               RV32I.gen/sources_1/bd/rv32i_bd/ip/rv32i_bd_rv32i_axi_integratio_0_2/rv32i_bd_rv32i_axi_integratio_0_2_stub.vhdl}
-- Design      : rv32i_bd_rv32i_axi_integratio_0_2
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu7ev-ffvc1156-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rv32i_bd_rv32i_axi_integratio_0_2 is
  Port ( 
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    irq_external : in STD_LOGIC;
    debug_halted : out STD_LOGIC;
    debug_pc : out STD_LOGIC_VECTOR ( 31 downto 0 );
    debug_instr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_imem_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_imem_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_imem_awvalid : out STD_LOGIC;
    m_axi_imem_awready : in STD_LOGIC;
    m_axi_imem_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_imem_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_imem_wvalid : out STD_LOGIC;
    m_axi_imem_wready : in STD_LOGIC;
    m_axi_imem_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_imem_bvalid : in STD_LOGIC;
    m_axi_imem_bready : out STD_LOGIC;
    m_axi_imem_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_imem_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_imem_arvalid : out STD_LOGIC;
    m_axi_imem_arready : in STD_LOGIC;
    m_axi_imem_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_imem_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_imem_rvalid : in STD_LOGIC;
    m_axi_imem_rready : out STD_LOGIC;
    m_axi_dmem_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_dmem_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_dmem_awvalid : out STD_LOGIC;
    m_axi_dmem_awready : in STD_LOGIC;
    m_axi_dmem_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_dmem_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_dmem_wvalid : out STD_LOGIC;
    m_axi_dmem_wready : in STD_LOGIC;
    m_axi_dmem_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_dmem_bvalid : in STD_LOGIC;
    m_axi_dmem_bready : out STD_LOGIC;
    m_axi_dmem_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_dmem_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_dmem_arvalid : out STD_LOGIC;
    m_axi_dmem_arready : in STD_LOGIC;
    m_axi_dmem_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_dmem_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_dmem_rvalid : in STD_LOGIC;
    m_axi_dmem_rready : out STD_LOGIC
  );

  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of rv32i_bd_rv32i_axi_integratio_0_2 : entity is "rv32i_bd_rv32i_axi_integratio_0_2,rv32i_axi_integration_top,{}";
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of rv32i_bd_rv32i_axi_integratio_0_2 : entity is "rv32i_bd_rv32i_axi_integratio_0_2,rv32i_axi_integration_top,{x_ipProduct=Vivado 2025.2,x_ipVendor=xilinx.com,x_ipLibrary=user,x_ipName=rv32i_axi_integration_top,x_ipVersion=1.0,x_ipCoreRevision=3,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,XLEN=32,RESET_PC=0x00000000,ADDER_IMPL=0,SHIFTER_IMPL=0}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of rv32i_bd_rv32i_axi_integratio_0_2 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of rv32i_bd_rv32i_axi_integratio_0_2 : entity is "package_project";
end rv32i_bd_rv32i_axi_integratio_0_2;

architecture stub of rv32i_bd_rv32i_axi_integratio_0_2 is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "aclk,aresetn,irq_external,debug_halted,debug_pc[31:0],debug_instr[31:0],m_axi_imem_awaddr[31:0],m_axi_imem_awprot[2:0],m_axi_imem_awvalid,m_axi_imem_awready,m_axi_imem_wdata[31:0],m_axi_imem_wstrb[3:0],m_axi_imem_wvalid,m_axi_imem_wready,m_axi_imem_bresp[1:0],m_axi_imem_bvalid,m_axi_imem_bready,m_axi_imem_araddr[31:0],m_axi_imem_arprot[2:0],m_axi_imem_arvalid,m_axi_imem_arready,m_axi_imem_rdata[31:0],m_axi_imem_rresp[1:0],m_axi_imem_rvalid,m_axi_imem_rready,m_axi_dmem_awaddr[31:0],m_axi_dmem_awprot[2:0],m_axi_dmem_awvalid,m_axi_dmem_awready,m_axi_dmem_wdata[31:0],m_axi_dmem_wstrb[3:0],m_axi_dmem_wvalid,m_axi_dmem_wready,m_axi_dmem_bresp[1:0],m_axi_dmem_bvalid,m_axi_dmem_bready,m_axi_dmem_araddr[31:0],m_axi_dmem_arprot[2:0],m_axi_dmem_arvalid,m_axi_dmem_arready,m_axi_dmem_rdata[31:0],m_axi_dmem_rresp[1:0],m_axi_dmem_rvalid,m_axi_dmem_rready";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of aclk : signal is "xilinx.com:signal:clock:1.0 aclk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of aclk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of aclk : signal is "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF M_AXI_IMEM:M_AXI_DMEM, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN rv32i_bd_clk_wiz_1_0_clk_out1, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of aresetn : signal is "xilinx.com:signal:reset:1.0 aresetn RST";
  attribute X_INTERFACE_MODE of aresetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of aresetn : signal is "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of irq_external : signal is "xilinx.com:signal:interrupt:1.0 irq_external INTERRUPT";
  attribute X_INTERFACE_MODE of irq_external : signal is "slave";
  attribute X_INTERFACE_PARAMETER of irq_external : signal is "XIL_INTERFACENAME irq_external, SENSITIVITY LEVEL_HIGH, PortWidth 1";
  attribute X_INTERFACE_INFO of m_axi_imem_awaddr : signal is "xilinx.com:interface:aximm:1.0 M_AXI_IMEM AWADDR";
  attribute X_INTERFACE_MODE of m_axi_imem_awaddr : signal is "master";
  attribute X_INTERFACE_PARAMETER of m_axi_imem_awaddr : signal is "XIL_INTERFACENAME M_AXI_IMEM, PROTOCOL AXI4LITE, ADDR_WIDTH 32, DATA_WIDTH 32, READ_WRITE_MODE READ_ONLY, FREQ_HZ 100000000, ID_WIDTH 0, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN rv32i_bd_clk_wiz_1_0_clk_out1, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m_axi_imem_awprot : signal is "xilinx.com:interface:aximm:1.0 M_AXI_IMEM AWPROT";
  attribute X_INTERFACE_INFO of m_axi_imem_awvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_IMEM AWVALID";
  attribute X_INTERFACE_INFO of m_axi_imem_awready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_IMEM AWREADY";
  attribute X_INTERFACE_INFO of m_axi_imem_wdata : signal is "xilinx.com:interface:aximm:1.0 M_AXI_IMEM WDATA";
  attribute X_INTERFACE_INFO of m_axi_imem_wstrb : signal is "xilinx.com:interface:aximm:1.0 M_AXI_IMEM WSTRB";
  attribute X_INTERFACE_INFO of m_axi_imem_wvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_IMEM WVALID";
  attribute X_INTERFACE_INFO of m_axi_imem_wready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_IMEM WREADY";
  attribute X_INTERFACE_INFO of m_axi_imem_bresp : signal is "xilinx.com:interface:aximm:1.0 M_AXI_IMEM BRESP";
  attribute X_INTERFACE_INFO of m_axi_imem_bvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_IMEM BVALID";
  attribute X_INTERFACE_INFO of m_axi_imem_bready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_IMEM BREADY";
  attribute X_INTERFACE_INFO of m_axi_imem_araddr : signal is "xilinx.com:interface:aximm:1.0 M_AXI_IMEM ARADDR";
  attribute X_INTERFACE_INFO of m_axi_imem_arprot : signal is "xilinx.com:interface:aximm:1.0 M_AXI_IMEM ARPROT";
  attribute X_INTERFACE_INFO of m_axi_imem_arvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_IMEM ARVALID";
  attribute X_INTERFACE_INFO of m_axi_imem_arready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_IMEM ARREADY";
  attribute X_INTERFACE_INFO of m_axi_imem_rdata : signal is "xilinx.com:interface:aximm:1.0 M_AXI_IMEM RDATA";
  attribute X_INTERFACE_INFO of m_axi_imem_rresp : signal is "xilinx.com:interface:aximm:1.0 M_AXI_IMEM RRESP";
  attribute X_INTERFACE_INFO of m_axi_imem_rvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_IMEM RVALID";
  attribute X_INTERFACE_INFO of m_axi_imem_rready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_IMEM RREADY";
  attribute X_INTERFACE_INFO of m_axi_dmem_awaddr : signal is "xilinx.com:interface:aximm:1.0 M_AXI_DMEM AWADDR";
  attribute X_INTERFACE_MODE of m_axi_dmem_awaddr : signal is "master";
  attribute X_INTERFACE_PARAMETER of m_axi_dmem_awaddr : signal is "XIL_INTERFACENAME M_AXI_DMEM, PROTOCOL AXI4LITE, ADDR_WIDTH 32, DATA_WIDTH 32, READ_WRITE_MODE READ_WRITE, FREQ_HZ 100000000, ID_WIDTH 0, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN rv32i_bd_clk_wiz_1_0_clk_out1, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m_axi_dmem_awprot : signal is "xilinx.com:interface:aximm:1.0 M_AXI_DMEM AWPROT";
  attribute X_INTERFACE_INFO of m_axi_dmem_awvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_DMEM AWVALID";
  attribute X_INTERFACE_INFO of m_axi_dmem_awready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_DMEM AWREADY";
  attribute X_INTERFACE_INFO of m_axi_dmem_wdata : signal is "xilinx.com:interface:aximm:1.0 M_AXI_DMEM WDATA";
  attribute X_INTERFACE_INFO of m_axi_dmem_wstrb : signal is "xilinx.com:interface:aximm:1.0 M_AXI_DMEM WSTRB";
  attribute X_INTERFACE_INFO of m_axi_dmem_wvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_DMEM WVALID";
  attribute X_INTERFACE_INFO of m_axi_dmem_wready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_DMEM WREADY";
  attribute X_INTERFACE_INFO of m_axi_dmem_bresp : signal is "xilinx.com:interface:aximm:1.0 M_AXI_DMEM BRESP";
  attribute X_INTERFACE_INFO of m_axi_dmem_bvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_DMEM BVALID";
  attribute X_INTERFACE_INFO of m_axi_dmem_bready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_DMEM BREADY";
  attribute X_INTERFACE_INFO of m_axi_dmem_araddr : signal is "xilinx.com:interface:aximm:1.0 M_AXI_DMEM ARADDR";
  attribute X_INTERFACE_INFO of m_axi_dmem_arprot : signal is "xilinx.com:interface:aximm:1.0 M_AXI_DMEM ARPROT";
  attribute X_INTERFACE_INFO of m_axi_dmem_arvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_DMEM ARVALID";
  attribute X_INTERFACE_INFO of m_axi_dmem_arready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_DMEM ARREADY";
  attribute X_INTERFACE_INFO of m_axi_dmem_rdata : signal is "xilinx.com:interface:aximm:1.0 M_AXI_DMEM RDATA";
  attribute X_INTERFACE_INFO of m_axi_dmem_rresp : signal is "xilinx.com:interface:aximm:1.0 M_AXI_DMEM RRESP";
  attribute X_INTERFACE_INFO of m_axi_dmem_rvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_DMEM RVALID";
  attribute X_INTERFACE_INFO of m_axi_dmem_rready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_DMEM RREADY";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of stub : architecture is "rv32i_axi_integration_top,Vivado 2025.2";
begin
end;
