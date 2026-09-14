// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Fri Jul 17 14:23:41 2026
// Host        : Ngoclaptop running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top rv32i_bd_blk_mem_gen_0_1 -prefix
//               rv32i_bd_blk_mem_gen_0_1_ rv32i_bd_blk_mem_gen_0_0_sim_netlist.v
// Design      : rv32i_bd_blk_mem_gen_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu7ev-ffvc1156-2-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "rv32i_bd_blk_mem_gen_0_0,blk_mem_gen_v8_4_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_12,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module rv32i_bd_blk_mem_gen_0_1
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
  rv32i_bd_blk_mem_gen_0_1_blk_mem_gen_v8_4_12 U0
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
