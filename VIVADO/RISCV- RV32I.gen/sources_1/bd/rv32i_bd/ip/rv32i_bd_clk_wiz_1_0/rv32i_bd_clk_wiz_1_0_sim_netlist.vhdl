-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
-- Date        : Fri Jul 17 15:12:25 2026
-- Host        : Ngoclaptop running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim -rename_top rv32i_bd_clk_wiz_1_0 -prefix
--               rv32i_bd_clk_wiz_1_0_ rv32i_bd_clk_wiz_1_0_sim_netlist.vhdl
-- Design      : rv32i_bd_clk_wiz_1_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xczu7ev-ffvc1156-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rv32i_bd_clk_wiz_1_0_rv32i_bd_clk_wiz_1_0_clk_wiz is
  port (
    clk_out1 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1_p : in STD_LOGIC;
    clk_in1_n : in STD_LOGIC
  );
end rv32i_bd_clk_wiz_1_0_rv32i_bd_clk_wiz_1_0_clk_wiz;

architecture STRUCTURE of rv32i_bd_clk_wiz_1_0_rv32i_bd_clk_wiz_1_0_clk_wiz is
  signal clk_in1_rv32i_bd_clk_wiz_1_0 : STD_LOGIC;
  signal clk_in1_rv32i_bd_clk_wiz_1_0_buf : STD_LOGIC;
  signal clk_out1_rv32i_bd_clk_wiz_1_0 : STD_LOGIC;
  signal NLW_plle4_adv_inst_CLKFBIN_UNCONNECTED : STD_LOGIC;
  signal NLW_plle4_adv_inst_CLKFBOUT_UNCONNECTED : STD_LOGIC;
  signal NLW_plle4_adv_inst_CLKOUT0B_UNCONNECTED : STD_LOGIC;
  signal NLW_plle4_adv_inst_CLKOUT1_UNCONNECTED : STD_LOGIC;
  signal NLW_plle4_adv_inst_CLKOUT1B_UNCONNECTED : STD_LOGIC;
  signal NLW_plle4_adv_inst_CLKOUTPHY_UNCONNECTED : STD_LOGIC;
  signal NLW_plle4_adv_inst_DRDY_UNCONNECTED : STD_LOGIC;
  signal NLW_plle4_adv_inst_DO_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of clkin1_bufg1 : label is "PRIMITIVE";
  attribute XILINX_LEGACY_PRIM : string;
  attribute XILINX_LEGACY_PRIM of clkin1_bufg1 : label is "BUFG";
  attribute XILINX_TRANSFORM_PINMAP : string;
  attribute XILINX_TRANSFORM_PINMAP of clkin1_bufg1 : label is "VCC:CE";
  attribute BOX_TYPE of clkin1_ibufds : label is "PRIMITIVE";
  attribute CAPACITANCE : string;
  attribute CAPACITANCE of clkin1_ibufds : label is "DONT_CARE";
  attribute IBUF_DELAY_VALUE : string;
  attribute IBUF_DELAY_VALUE of clkin1_ibufds : label is "0";
  attribute IFD_DELAY_VALUE : string;
  attribute IFD_DELAY_VALUE of clkin1_ibufds : label is "AUTO";
  attribute BOX_TYPE of clkout1_buf : label is "PRIMITIVE";
  attribute XILINX_LEGACY_PRIM of clkout1_buf : label is "BUFG";
  attribute XILINX_TRANSFORM_PINMAP of clkout1_buf : label is "VCC:CE";
  attribute BOX_TYPE of plle4_adv_inst : label is "PRIMITIVE";
  attribute OPT_MODIFIED : string;
  attribute OPT_MODIFIED of plle4_adv_inst : label is "MLO";
begin
clkin1_bufg1: unisim.vcomponents.BUFGCE
    generic map(
      CE_TYPE => "ASYNC",
      SIM_DEVICE => "ULTRASCALE_PLUS"
    )
        port map (
      CE => '1',
      I => clk_in1_rv32i_bd_clk_wiz_1_0_buf,
      O => clk_in1_rv32i_bd_clk_wiz_1_0
    );
clkin1_ibufds: unisim.vcomponents.IBUFDS
    generic map(
      DIFF_TERM => false,
      IOSTANDARD => "DEFAULT"
    )
        port map (
      I => clk_in1_p,
      IB => clk_in1_n,
      O => clk_in1_rv32i_bd_clk_wiz_1_0_buf
    );
clkout1_buf: unisim.vcomponents.BUFGCE
    generic map(
      CE_TYPE => "ASYNC",
      SIM_DEVICE => "ULTRASCALE_PLUS"
    )
        port map (
      CE => '1',
      I => clk_out1_rv32i_bd_clk_wiz_1_0,
      O => clk_out1
    );
plle4_adv_inst: unisim.vcomponents.PLLE4_ADV
    generic map(
      CLKFBOUT_MULT => 8,
      CLKFBOUT_PHASE => 0.000000,
      CLKIN_PERIOD => 8.000000,
      CLKOUT0_DIVIDE => 10,
      CLKOUT0_DUTY_CYCLE => 0.500000,
      CLKOUT0_PHASE => 0.000000,
      CLKOUT1_DIVIDE => 1,
      CLKOUT1_DUTY_CYCLE => 0.500000,
      CLKOUT1_PHASE => 0.000000,
      CLKOUTPHY_MODE => "VCO_2X",
      COMPENSATION => "INTERNAL",
      DIVCLK_DIVIDE => 1,
      IS_CLKFBIN_INVERTED => '0',
      IS_CLKIN_INVERTED => '0',
      IS_PWRDWN_INVERTED => '0',
      IS_RST_INVERTED => '0',
      REF_JITTER => 0.010000,
      STARTUP_WAIT => "FALSE"
    )
        port map (
      CLKFBIN => NLW_plle4_adv_inst_CLKFBIN_UNCONNECTED,
      CLKFBOUT => NLW_plle4_adv_inst_CLKFBOUT_UNCONNECTED,
      CLKIN => clk_in1_rv32i_bd_clk_wiz_1_0,
      CLKOUT0 => clk_out1_rv32i_bd_clk_wiz_1_0,
      CLKOUT0B => NLW_plle4_adv_inst_CLKOUT0B_UNCONNECTED,
      CLKOUT1 => NLW_plle4_adv_inst_CLKOUT1_UNCONNECTED,
      CLKOUT1B => NLW_plle4_adv_inst_CLKOUT1B_UNCONNECTED,
      CLKOUTPHY => NLW_plle4_adv_inst_CLKOUTPHY_UNCONNECTED,
      CLKOUTPHYEN => '0',
      DADDR(6 downto 0) => B"0000000",
      DCLK => '0',
      DEN => '0',
      DI(15 downto 0) => B"0000000000000000",
      DO(15 downto 0) => NLW_plle4_adv_inst_DO_UNCONNECTED(15 downto 0),
      DRDY => NLW_plle4_adv_inst_DRDY_UNCONNECTED,
      DWE => '0',
      LOCKED => locked,
      PWRDWN => '0',
      RST => reset
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rv32i_bd_clk_wiz_1_0 is
  port (
    clk_out1 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1_p : in STD_LOGIC;
    clk_in1_n : in STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of rv32i_bd_clk_wiz_1_0 : entity is true;
end rv32i_bd_clk_wiz_1_0;

architecture STRUCTURE of rv32i_bd_clk_wiz_1_0 is
begin
inst: entity work.rv32i_bd_clk_wiz_1_0_rv32i_bd_clk_wiz_1_0_clk_wiz
     port map (
      clk_in1_n => clk_in1_n,
      clk_in1_p => clk_in1_p,
      clk_out1 => clk_out1,
      locked => locked,
      reset => reset
    );
end STRUCTURE;
