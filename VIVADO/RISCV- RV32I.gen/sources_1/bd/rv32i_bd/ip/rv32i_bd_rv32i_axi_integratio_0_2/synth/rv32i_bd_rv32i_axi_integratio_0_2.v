// (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// (c) Copyright 2022-2026 Advanced Micro Devices, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:user:rv32i_axi_integration_top:1.0
// IP Revision: 3

(* X_CORE_INFO = "rv32i_axi_integration_top,Vivado 2025.2" *)
(* CHECK_LICENSE_TYPE = "rv32i_bd_rv32i_axi_integratio_0_2,rv32i_axi_integration_top,{}" *)
(* CORE_GENERATION_INFO = "rv32i_bd_rv32i_axi_integratio_0_2,rv32i_axi_integration_top,{x_ipProduct=Vivado 2025.2,x_ipVendor=xilinx.com,x_ipLibrary=user,x_ipName=rv32i_axi_integration_top,x_ipVersion=1.0,x_ipCoreRevision=3,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,XLEN=32,RESET_PC=0x00000000,ADDER_IMPL=0,SHIFTER_IMPL=0}" *)
(* IP_DEFINITION_SOURCE = "package_project" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module rv32i_bd_rv32i_axi_integratio_0_2 (
  aclk,
  aresetn,
  irq_external,
  debug_halted,
  debug_pc,
  debug_instr,
  m_axi_imem_awaddr,
  m_axi_imem_awprot,
  m_axi_imem_awvalid,
  m_axi_imem_awready,
  m_axi_imem_wdata,
  m_axi_imem_wstrb,
  m_axi_imem_wvalid,
  m_axi_imem_wready,
  m_axi_imem_bresp,
  m_axi_imem_bvalid,
  m_axi_imem_bready,
  m_axi_imem_araddr,
  m_axi_imem_arprot,
  m_axi_imem_arvalid,
  m_axi_imem_arready,
  m_axi_imem_rdata,
  m_axi_imem_rresp,
  m_axi_imem_rvalid,
  m_axi_imem_rready,
  m_axi_dmem_awaddr,
  m_axi_dmem_awprot,
  m_axi_dmem_awvalid,
  m_axi_dmem_awready,
  m_axi_dmem_wdata,
  m_axi_dmem_wstrb,
  m_axi_dmem_wvalid,
  m_axi_dmem_wready,
  m_axi_dmem_bresp,
  m_axi_dmem_bvalid,
  m_axi_dmem_bready,
  m_axi_dmem_araddr,
  m_axi_dmem_arprot,
  m_axi_dmem_arvalid,
  m_axi_dmem_arready,
  m_axi_dmem_rdata,
  m_axi_dmem_rresp,
  m_axi_dmem_rvalid,
  m_axi_dmem_rready
);

(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF M_AXI_IMEM:M_AXI_DMEM, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN rv32i_bd_clk_wiz_1_0_clk_out1, INSERT_VIP 0" *)
input wire aclk;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
input wire aresetn;
(* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 irq_external INTERRUPT" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME irq_external, SENSITIVITY LEVEL_HIGH, PortWidth 1" *)
input wire irq_external;
output wire debug_halted;
output wire [31 : 0] debug_pc;
output wire [31 : 0] debug_instr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM AWADDR" *)
(* X_INTERFACE_MODE = "master" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXI_IMEM, PROTOCOL AXI4LITE, ADDR_WIDTH 32, DATA_WIDTH 32, READ_WRITE_MODE READ_ONLY, FREQ_HZ 100000000, ID_WIDTH 0, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN rv32i_bd_clk_wiz_1_0_clk_out1, NUM_READ_THREADS 1, NUM_W\
RITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
output wire [31 : 0] m_axi_imem_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM AWPROT" *)
output wire [2 : 0] m_axi_imem_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM AWVALID" *)
output wire m_axi_imem_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM AWREADY" *)
input wire m_axi_imem_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM WDATA" *)
output wire [31 : 0] m_axi_imem_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM WSTRB" *)
output wire [3 : 0] m_axi_imem_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM WVALID" *)
output wire m_axi_imem_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM WREADY" *)
input wire m_axi_imem_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM BRESP" *)
input wire [1 : 0] m_axi_imem_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM BVALID" *)
input wire m_axi_imem_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM BREADY" *)
output wire m_axi_imem_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM ARADDR" *)
output wire [31 : 0] m_axi_imem_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM ARPROT" *)
output wire [2 : 0] m_axi_imem_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM ARVALID" *)
output wire m_axi_imem_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM ARREADY" *)
input wire m_axi_imem_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM RDATA" *)
input wire [31 : 0] m_axi_imem_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM RRESP" *)
input wire [1 : 0] m_axi_imem_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM RVALID" *)
input wire m_axi_imem_rvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM RREADY" *)
output wire m_axi_imem_rready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM AWADDR" *)
(* X_INTERFACE_MODE = "master" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXI_DMEM, PROTOCOL AXI4LITE, ADDR_WIDTH 32, DATA_WIDTH 32, READ_WRITE_MODE READ_WRITE, FREQ_HZ 100000000, ID_WIDTH 0, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN rv32i_bd_clk_wiz_1_0_clk_out1, NUM_READ_THREADS 1, NUM_\
WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
output wire [31 : 0] m_axi_dmem_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM AWPROT" *)
output wire [2 : 0] m_axi_dmem_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM AWVALID" *)
output wire m_axi_dmem_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM AWREADY" *)
input wire m_axi_dmem_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM WDATA" *)
output wire [31 : 0] m_axi_dmem_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM WSTRB" *)
output wire [3 : 0] m_axi_dmem_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM WVALID" *)
output wire m_axi_dmem_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM WREADY" *)
input wire m_axi_dmem_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM BRESP" *)
input wire [1 : 0] m_axi_dmem_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM BVALID" *)
input wire m_axi_dmem_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM BREADY" *)
output wire m_axi_dmem_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM ARADDR" *)
output wire [31 : 0] m_axi_dmem_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM ARPROT" *)
output wire [2 : 0] m_axi_dmem_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM ARVALID" *)
output wire m_axi_dmem_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM ARREADY" *)
input wire m_axi_dmem_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM RDATA" *)
input wire [31 : 0] m_axi_dmem_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM RRESP" *)
input wire [1 : 0] m_axi_dmem_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM RVALID" *)
input wire m_axi_dmem_rvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM RREADY" *)
output wire m_axi_dmem_rready;

  rv32i_axi_integration_top #(
    .XLEN(32),
    .RESET_PC(32'H00000000),
    .ADDER_IMPL(0),
    .SHIFTER_IMPL(0)
  ) inst (
    .aclk(aclk),
    .aresetn(aresetn),
    .irq_external(irq_external),
    .debug_halted(debug_halted),
    .debug_pc(debug_pc),
    .debug_instr(debug_instr),
    .m_axi_imem_awaddr(m_axi_imem_awaddr),
    .m_axi_imem_awprot(m_axi_imem_awprot),
    .m_axi_imem_awvalid(m_axi_imem_awvalid),
    .m_axi_imem_awready(m_axi_imem_awready),
    .m_axi_imem_wdata(m_axi_imem_wdata),
    .m_axi_imem_wstrb(m_axi_imem_wstrb),
    .m_axi_imem_wvalid(m_axi_imem_wvalid),
    .m_axi_imem_wready(m_axi_imem_wready),
    .m_axi_imem_bresp(m_axi_imem_bresp),
    .m_axi_imem_bvalid(m_axi_imem_bvalid),
    .m_axi_imem_bready(m_axi_imem_bready),
    .m_axi_imem_araddr(m_axi_imem_araddr),
    .m_axi_imem_arprot(m_axi_imem_arprot),
    .m_axi_imem_arvalid(m_axi_imem_arvalid),
    .m_axi_imem_arready(m_axi_imem_arready),
    .m_axi_imem_rdata(m_axi_imem_rdata),
    .m_axi_imem_rresp(m_axi_imem_rresp),
    .m_axi_imem_rvalid(m_axi_imem_rvalid),
    .m_axi_imem_rready(m_axi_imem_rready),
    .m_axi_dmem_awaddr(m_axi_dmem_awaddr),
    .m_axi_dmem_awprot(m_axi_dmem_awprot),
    .m_axi_dmem_awvalid(m_axi_dmem_awvalid),
    .m_axi_dmem_awready(m_axi_dmem_awready),
    .m_axi_dmem_wdata(m_axi_dmem_wdata),
    .m_axi_dmem_wstrb(m_axi_dmem_wstrb),
    .m_axi_dmem_wvalid(m_axi_dmem_wvalid),
    .m_axi_dmem_wready(m_axi_dmem_wready),
    .m_axi_dmem_bresp(m_axi_dmem_bresp),
    .m_axi_dmem_bvalid(m_axi_dmem_bvalid),
    .m_axi_dmem_bready(m_axi_dmem_bready),
    .m_axi_dmem_araddr(m_axi_dmem_araddr),
    .m_axi_dmem_arprot(m_axi_dmem_arprot),
    .m_axi_dmem_arvalid(m_axi_dmem_arvalid),
    .m_axi_dmem_arready(m_axi_dmem_arready),
    .m_axi_dmem_rdata(m_axi_dmem_rdata),
    .m_axi_dmem_rresp(m_axi_dmem_rresp),
    .m_axi_dmem_rvalid(m_axi_dmem_rvalid),
    .m_axi_dmem_rready(m_axi_dmem_rready)
  );
endmodule
