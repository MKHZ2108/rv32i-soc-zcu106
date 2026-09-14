//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
//Date        : Fri Jul 31 16:42:02 2026
//Host        : Ngoclaptop running 64-bit major release  (build 9200)
//Command     : generate_target rv32i_bd_wrapper.bd
//Design      : rv32i_bd_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module rv32i_bd_wrapper
   (clk_in1_n_0,
    clk_in1_p_0,
    clk_out,
    ext_reset_in_0,
    interconnect_aresetn,
    peripheral_aresetn,
    pll_locked,
    rx_0,
    tx_0);
  input clk_in1_n_0;
  input clk_in1_p_0;
  output clk_out;
  input ext_reset_in_0;
  output [0:0]interconnect_aresetn;
  output [0:0]peripheral_aresetn;
  output pll_locked;
  input rx_0;
  output tx_0;

  wire clk_in1_n_0;
  wire clk_in1_p_0;
  wire clk_out;
  wire ext_reset_in_0;
  wire [0:0]interconnect_aresetn;
  wire [0:0]peripheral_aresetn;
  wire pll_locked;
  wire rx_0;
  wire tx_0;

  rv32i_bd rv32i_bd_i
       (.clk_in1_n_0(clk_in1_n_0),
        .clk_in1_p_0(clk_in1_p_0),
        .clk_out(clk_out),
        .ext_reset_in_0(ext_reset_in_0),
        .interconnect_aresetn(interconnect_aresetn),
        .peripheral_aresetn(peripheral_aresetn),
        .pll_locked(pll_locked),
        .rx_0(rx_0),
        .tx_0(tx_0));
endmodule
