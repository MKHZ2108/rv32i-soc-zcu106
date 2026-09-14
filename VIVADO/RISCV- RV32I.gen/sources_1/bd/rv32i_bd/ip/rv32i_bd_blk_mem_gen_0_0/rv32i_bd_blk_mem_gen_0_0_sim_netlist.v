// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Fri Jul 17 14:23:41 2026
// Host        : Ngoclaptop running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top rv32i_bd_blk_mem_gen_0_0 -prefix
//               rv32i_bd_blk_mem_gen_0_0_ rv32i_bd_blk_mem_gen_0_0_sim_netlist.v
// Design      : rv32i_bd_blk_mem_gen_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu7ev-ffvc1156-2-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "rv32i_bd_blk_mem_gen_0_0,blk_mem_gen_v8_4_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_12,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module rv32i_bd_blk_mem_gen_0_0
   (clka,
    rsta,
    ena,
    wea,
    addra,
    dina,
    douta,
    rsta_busy);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE BRAM_CTRL, READ_WRITE_MODE READ_WRITE, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA RST" *) input rsta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [3:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [31:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;
  output rsta_busy;

  wire [31:0]addra;
  wire clka;
  wire [31:0]dina;
  wire [31:0]douta;
  wire ena;
  wire rsta;
  wire rsta_busy;
  wire [3:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [31:0]NLW_U0_doutb_UNCONNECTED;
  wire [31:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "32" *) 
  (* C_ADDRB_WIDTH = "32" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "8" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "2" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "1" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "1" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     3.867232 mW" *) 
  (* C_FAMILY = "zynquplus" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "1" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "NONE" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "2048" *) 
  (* C_READ_DEPTH_B = "2048" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "1" *) 
  (* C_USE_BYTE_WEA = "1" *) 
  (* C_USE_BYTE_WEB = "1" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "4" *) 
  (* C_WEB_WIDTH = "4" *) 
  (* C_WRITE_DEPTH_A = "2048" *) 
  (* C_WRITE_DEPTH_B = "2048" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  rv32i_bd_blk_mem_gen_0_0_blk_mem_gen_v8_4_12 U0
       (.addra({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,addra[12:2],1'b0,1'b0}),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[31:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[31:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(rsta),
        .rsta_busy(rsta_busy),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[31:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web({1'b0,1'b0,1'b0,1'b0}));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2025.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
YqH9kwIC39+qbZg4PSfFsXuB9k9wnuxNryS/CfnEri6Ci9fSC6fsrQ/T/hnt3u/yolbJ8DJa1Qu6
Qnm24A9jLbA+fu3Nsmm6/rM6a4vU6OfVl/gTFd/CiWDutv6Dhn6Lim4uUNPahoOR/A2Yc4Zo2tdI
kMLO9gn9WlH2l3O2oXs=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XJYO2VHd/cnMxQd3i7/2qRhl57dl+doEKuhAunQyv3vpGRG/jlNxj8PqrgLoF0HMdqE3qJUVE/oq
kBSapqjVjLDMOrNGQ+Tc6VGsKMZH8FE/TXHQJ/IM5Iuiu2eozEwwVUomF+7cfqn+9OsVsqCONQ1M
g0oRlangiqasJDhhMfnlGGqwAwmgWRGQA6dmhTuua1s8zdvIv540zY6p5au8cAKVhqyyKK7wbxEE
SGuFqX+NYoyRV+rfWCcWM+hJEmnWS8LNAKkd13YE2+17sPYzUdZ23DmTxXK6KlAxKFW27CBySUfg
qdNXp2DSs2KAQYih27pBNMuHfGbM/ATFPWFvxg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
lYoEi/e8HsDTz6N11EDe/B/iitERmeYndlCklmCluwgb0N4W80JUGVlkd7NlRZHRNhxaNBJPkcjC
n61nO0tb17NwsMwjbY5TF8JWRYTNw1JXCFacvQYrdKv4/7QNQEtwVGiCLxFhOA8aHlWMZIrc2fri
VRMVWaEBcPwCGorlVIM=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QEw9fEsWFbdX0OQLvYs/gl+zyEOW3ak9TdQVaq+0AXXOT3LIqF7wDxJ6ZBnlf9mNbdsUVH5tAz1o
H8u7ihJl1L3THEvugW+TS8hkvVbEA9rKO2vV15KAj4Lla7UdFT/xDfe79RFarlLI7yGrubjgdoRi
QWy//UKsffG7IWNwmoSuppWiWB4ZHJtkunNyIkm70JPGyZF62VxJg1MTT+5LUbZG5vZjjuHZud9w
xJaKv1tFP/x8RVqLU5gPOqGqTW7/nKO2S+450Vo4D9vAmBVVcXpaL1EbSmCvQ+qJmcQKtf9qYFRV
Zko08hbpHjPxstqvTDro01jRzB8592m4xU2TWA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TC7q853CWBPPJgbRfgDV1lmjUwSAtliljShAyNFg8sfRfwDzchthzoSPH1UCHV++E2JXacEKq1lB
UWsNP92U4Xh0/Gu+6esOI0pJb8I+TRTxyBN1I4cRQEfQHcwfhbSdeH3yX9OV3opLEqYmT37hWU+J
zCawYnxVESI0FtRzEXve9gdEWlrKKckrT/hp4mvxxOjvOkOSQBvy0elgUOqh6mEOZl+JnUbsR+Wm
CoZLE1eefMZy3FnVmyDNPv3JPXi88aLXMyimal0MYFkTiS4XJiGT3eAIMIbksehXY+eYi/KFpZWQ
GHpX+lG3UmiWWLwyPakFwKEHbrBc70AlJ2eV9g==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2025.1-2029.x", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
j9nmCKgjPWNChPbpSW6EWLrMA6oCG2JGPoum8px09v0PEAh0DRXZi0J8HPzXUsZgOEMcKpA7X54u
YFcDDCLAQ+urha/eSPbQYHQh4yGCursxAQ1C6LEyNQ2wJ0eLlO2bJeAl/gof06zqsYVM2lLJVNv5
wao1k2bmgPdfpfY3c9vPD0fSMuZPS41EoRS0cQhO5GTZnKdjxm6tEUL3GnTjB8ynSCIbCJUsMtAX
4FRHNa52gudx5B5fagR+lXgFhE7e++rWTJELr7SYB+r5Es8qZLTpCH8TrQxEkV0rY/+e4sAjNE2D
gHw8GD7VcUtc15B8y1BbVmh29qc8Nd3V2i/miA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UkCD6I/Vye4qNoNoa3hIexBXG3xyKUJPAHAjIo7UcNVCDXpMQiYEtPDqExZMfiPlJn2nswCYIfIJ
FYWqMCloKSQyyI/7yZ2EtbyWEklb/P5IyZyvGi6hhFUo/JFTb12b4bK0gZPr+bCDdlVQKTx5GVHz
wptdUJO2omSj8axVMPbLRRtVzlJIZ29dTJ2ATXVXAcBxPnFfHRAMnYYKLeeLExX61vQvpqrkLQHm
XG7hpVzJi56gYKAzxa2BLq072OCVpVS70bfWlhlSTVcSlCrUf+EcarEk4FD8+Ih2NCvrqremG6yn
TtcBn8Xr8M/6zhOYvLi6AD6eArDMKA8n+Ccv8A==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
A5y5QVZU8yjPexRVPioSiAGohCHD5DX5FVobuMyhcgQRExLUhPvnnS8HOtxTj/2IapEcz68gFMGG
Hpi+m725u85/om/Vze9pGIW9Mn328Kz2FIg3W5EvGstfGwY+48LiAGAmTR269JS4lJGVYWYOz7Xk
S8cEsFd2m7j8iyKtARJzD90+UdXq/cIIh725jC9i8nbgxB364zddvm1Z/DF3JRw1qFp6GGcuRai1
KNcJ1j8c9wtIgktpsteU3e5+bxHEw8NT3gWXUFYjm00NDq97Jals8Jjktmum2nQxoF7ivPacfEey
gnSF6jRMkTsZObzc30hAhs0CEtc33hZLhPLHSn8pQ0WyvKJLHdd5s2yckgTZtqxC1Sbwe7WEgNXe
ZMX3pIkz+aoXsAL7GBLyVBMVQcyMoF0w8QGAaTe8sqatABwPqXidYRqNROTf62IYcMpV89XYgaTv
EwIn/oni9KOFd2BFVxRZbFGGC4IjvigsTBUijI+Dk6kVnDh240clGcc4

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Omtp+lCaqUx7Z4qdFj2zrN8LpCkit2eX4hlMtig+ielGm/x4FSZkpjoFmiqdKFPi2eg0pg09MSai
XyGH68UzAR7Xrj8f1jlIoUmMKp4GcxfdqfTeuu7kWGOJEP6cvgTjSJFj2gawDv7f4yZcltnK2x0L
e4GW/rBTmGvZtKWb2ahjINLxPuh3dDaSaWdb+zVgbtyrI5FrjxBkq+aOxSjyNsqnCx1L0uWbxnkl
88NbXN3dTaECXHNm/fsleayM5hKis7kTv9BFajJMGy+BhQlmIYpE+F5zchnTTFUFJZCz1sX9Fc8e
HcY7irB8mR3ajdzjUZLBQEMktp096Nheq3U75A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
hpeBLwN9x2ZFDwroYLlUe5GjjDepHik2l0c2s3/6S7JPCRkzQSyt2V1Ad/JewAs/QNp5SXSbYYB4
rQl0My1LDMF3xw43r0g2IbcyHVpPhGp0W5msuQdF67afnsRv90iJYWLMI3QkYGCTWAzl4HrLxFSg
3z8XZRK670IcxznOrlvgHmIKsvubZrBkuc1EynrVb9Nw16QnIx2rc4WgcEXeFf+4i1RoYLDd3gXK
NFCNMdtaRYUThunFP6Z4ViZ5UnDmKq+IMhd31jTaqIlWOBDxPI1+v5RJYxIyTbn4rxlKR2fNbl5/
z4OUjBTd+1GH3I2OXlqmAOvIhpe2Z2HH7nZu/A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Mt2RhTSUwEIEWeNARbyL+EdfS1UF6nPaL/fKl/7oO2gina93egwCWDLl1fbBtkfaPco0cu4MJ9K3
OraAsyHRlY+MNShmJ1LzAIA1LjZx4y55lu9dlQqSUXR7AW7wVbkg1864mK+hM/1XygU0jvebKNW9
B7xSER+asLO6pxi0mt7uC2PHxLPAYEszFhmnap82TtbDGdQ2qtyekY+ngs+N2fAdsblxVwJruiMl
e6XJ127M8N1mYwhWU2HtRpBOSnnKoHgD9fG51XK/rhk8DxT66QnX9uLPB+H25eDupBJGi1Y5o6x8
hOwZiSUVlBLh7brfzevh7+eRn+7es6wBas0+3w==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 57616)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
