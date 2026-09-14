// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Fri Jul 31 16:44:22 2026
// Host        : Ngoclaptop running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {c:/Users/Dell/Desktop/RISCV_RV32I/RISCV-
//               RV32I.gen/sources_1/bd/rv32i_bd/ip/rv32i_bd_rv32i_axi_integratio_0_2/rv32i_bd_rv32i_axi_integratio_0_2_stub.v}
// Design      : rv32i_bd_rv32i_axi_integratio_0_2
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu7ev-ffvc1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "rv32i_bd_rv32i_axi_integratio_0_2,rv32i_axi_integration_top,{}" *) (* CORE_GENERATION_INFO = "rv32i_bd_rv32i_axi_integratio_0_2,rv32i_axi_integration_top,{x_ipProduct=Vivado 2025.2,x_ipVendor=xilinx.com,x_ipLibrary=user,x_ipName=rv32i_axi_integration_top,x_ipVersion=1.0,x_ipCoreRevision=3,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,XLEN=32,RESET_PC=0x00000000,ADDER_IMPL=0,SHIFTER_IMPL=0}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) 
(* IP_DEFINITION_SOURCE = "package_project" *) (* X_CORE_INFO = "rv32i_axi_integration_top,Vivado 2025.2" *) 
module rv32i_bd_rv32i_axi_integratio_0_2(aclk, aresetn, irq_external, debug_halted, 
  debug_pc, debug_instr, m_axi_imem_awaddr, m_axi_imem_awprot, m_axi_imem_awvalid, 
  m_axi_imem_awready, m_axi_imem_wdata, m_axi_imem_wstrb, m_axi_imem_wvalid, 
  m_axi_imem_wready, m_axi_imem_bresp, m_axi_imem_bvalid, m_axi_imem_bready, 
  m_axi_imem_araddr, m_axi_imem_arprot, m_axi_imem_arvalid, m_axi_imem_arready, 
  m_axi_imem_rdata, m_axi_imem_rresp, m_axi_imem_rvalid, m_axi_imem_rready, 
  m_axi_dmem_awaddr, m_axi_dmem_awprot, m_axi_dmem_awvalid, m_axi_dmem_awready, 
  m_axi_dmem_wdata, m_axi_dmem_wstrb, m_axi_dmem_wvalid, m_axi_dmem_wready, 
  m_axi_dmem_bresp, m_axi_dmem_bvalid, m_axi_dmem_bready, m_axi_dmem_araddr, 
  m_axi_dmem_arprot, m_axi_dmem_arvalid, m_axi_dmem_arready, m_axi_dmem_rdata, 
  m_axi_dmem_rresp, m_axi_dmem_rvalid, m_axi_dmem_rready)
/* synthesis syn_black_box black_box_pad_pin="aresetn,irq_external,debug_halted,debug_pc[31:0],debug_instr[31:0],m_axi_imem_awaddr[31:0],m_axi_imem_awprot[2:0],m_axi_imem_awvalid,m_axi_imem_awready,m_axi_imem_wdata[31:0],m_axi_imem_wstrb[3:0],m_axi_imem_wvalid,m_axi_imem_wready,m_axi_imem_bresp[1:0],m_axi_imem_bvalid,m_axi_imem_bready,m_axi_imem_araddr[31:0],m_axi_imem_arprot[2:0],m_axi_imem_arvalid,m_axi_imem_arready,m_axi_imem_rdata[31:0],m_axi_imem_rresp[1:0],m_axi_imem_rvalid,m_axi_imem_rready,m_axi_dmem_awaddr[31:0],m_axi_dmem_awprot[2:0],m_axi_dmem_awvalid,m_axi_dmem_awready,m_axi_dmem_wdata[31:0],m_axi_dmem_wstrb[3:0],m_axi_dmem_wvalid,m_axi_dmem_wready,m_axi_dmem_bresp[1:0],m_axi_dmem_bvalid,m_axi_dmem_bready,m_axi_dmem_araddr[31:0],m_axi_dmem_arprot[2:0],m_axi_dmem_arvalid,m_axi_dmem_arready,m_axi_dmem_rdata[31:0],m_axi_dmem_rresp[1:0],m_axi_dmem_rvalid,m_axi_dmem_rready" */
/* synthesis syn_force_seq_prim="aclk" */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF M_AXI_IMEM:M_AXI_DMEM, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN rv32i_bd_clk_wiz_1_0_clk_out1, INSERT_VIP 0" *) input aclk /* synthesis syn_isclock = 1 */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 irq_external INTERRUPT" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME irq_external, SENSITIVITY LEVEL_HIGH, PortWidth 1" *) input irq_external;
  output debug_halted;
  output [31:0]debug_pc;
  output [31:0]debug_instr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM AWADDR" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXI_IMEM, PROTOCOL AXI4LITE, ADDR_WIDTH 32, DATA_WIDTH 32, READ_WRITE_MODE READ_ONLY, FREQ_HZ 100000000, ID_WIDTH 0, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN rv32i_bd_clk_wiz_1_0_clk_out1, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) output [31:0]m_axi_imem_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM AWPROT" *) output [2:0]m_axi_imem_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM AWVALID" *) output m_axi_imem_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM AWREADY" *) input m_axi_imem_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM WDATA" *) output [31:0]m_axi_imem_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM WSTRB" *) output [3:0]m_axi_imem_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM WVALID" *) output m_axi_imem_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM WREADY" *) input m_axi_imem_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM BRESP" *) input [1:0]m_axi_imem_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM BVALID" *) input m_axi_imem_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM BREADY" *) output m_axi_imem_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM ARADDR" *) output [31:0]m_axi_imem_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM ARPROT" *) output [2:0]m_axi_imem_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM ARVALID" *) output m_axi_imem_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM ARREADY" *) input m_axi_imem_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM RDATA" *) input [31:0]m_axi_imem_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM RRESP" *) input [1:0]m_axi_imem_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM RVALID" *) input m_axi_imem_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IMEM RREADY" *) output m_axi_imem_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM AWADDR" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXI_DMEM, PROTOCOL AXI4LITE, ADDR_WIDTH 32, DATA_WIDTH 32, READ_WRITE_MODE READ_WRITE, FREQ_HZ 100000000, ID_WIDTH 0, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN rv32i_bd_clk_wiz_1_0_clk_out1, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) output [31:0]m_axi_dmem_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM AWPROT" *) output [2:0]m_axi_dmem_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM AWVALID" *) output m_axi_dmem_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM AWREADY" *) input m_axi_dmem_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM WDATA" *) output [31:0]m_axi_dmem_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM WSTRB" *) output [3:0]m_axi_dmem_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM WVALID" *) output m_axi_dmem_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM WREADY" *) input m_axi_dmem_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM BRESP" *) input [1:0]m_axi_dmem_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM BVALID" *) input m_axi_dmem_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM BREADY" *) output m_axi_dmem_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM ARADDR" *) output [31:0]m_axi_dmem_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM ARPROT" *) output [2:0]m_axi_dmem_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM ARVALID" *) output m_axi_dmem_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM ARREADY" *) input m_axi_dmem_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM RDATA" *) input [31:0]m_axi_dmem_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM RRESP" *) input [1:0]m_axi_dmem_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM RVALID" *) input m_axi_dmem_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DMEM RREADY" *) output m_axi_dmem_rready;
endmodule
