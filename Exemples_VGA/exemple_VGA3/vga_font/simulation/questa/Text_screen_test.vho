-- Copyright (C) 2022  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 22.1std.0 Build 915 10/25/2022 SC Lite Edition"

-- DATE "03/21/2023 16:21:34"

-- 
-- Device: Altera 10M50DAF484C6GES Package FBGA484
-- 

-- 
-- This VHDL file should be used for Questa Intel FPGA (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY FIFTYFIVENM;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE FIFTYFIVENM.FIFTYFIVENM_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	Text_screen_test IS
    PORT (
	CLOCK_50 : IN std_logic;
	KEY : IN std_logic_vector(1 DOWNTO 0);
	VGA_R : OUT std_logic_vector(3 DOWNTO 0);
	VGA_G : OUT std_logic_vector(3 DOWNTO 0);
	VGA_B : OUT std_logic_vector(3 DOWNTO 0);
	VGA_HS : OUT std_logic;
	VGA_VS : OUT std_logic
	);
END Text_screen_test;

-- Design Ports Information
-- KEY[1]	=>  Location: PIN_A7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- VGA_R[0]	=>  Location: PIN_AA1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- VGA_R[1]	=>  Location: PIN_V1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- VGA_R[2]	=>  Location: PIN_Y2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- VGA_R[3]	=>  Location: PIN_Y1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- VGA_G[0]	=>  Location: PIN_W1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- VGA_G[1]	=>  Location: PIN_T2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- VGA_G[2]	=>  Location: PIN_R2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- VGA_G[3]	=>  Location: PIN_R1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- VGA_B[0]	=>  Location: PIN_P1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- VGA_B[1]	=>  Location: PIN_T1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- VGA_B[2]	=>  Location: PIN_P4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- VGA_B[3]	=>  Location: PIN_N2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- VGA_HS	=>  Location: PIN_N3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- VGA_VS	=>  Location: PIN_N1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- KEY[0]	=>  Location: PIN_B8,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- CLOCK_50	=>  Location: PIN_P11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default


ARCHITECTURE structure OF Text_screen_test IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_CLOCK_50 : std_logic;
SIGNAL ww_KEY : std_logic_vector(1 DOWNTO 0);
SIGNAL ww_VGA_R : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_VGA_G : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_VGA_B : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_VGA_HS : std_logic;
SIGNAL ww_VGA_VS : std_logic;
SIGNAL \vga|font_table|altsyncram_component|auto_generated|ram_block1a0_PORTAADDR_bus\ : std_logic_vector(9 DOWNTO 0);
SIGNAL \vga|font_table|altsyncram_component|auto_generated|ram_block1a0_PORTADATAOUT_bus\ : std_logic_vector(8 DOWNTO 0);
SIGNAL \vga|pll|altpll_component|auto_generated|pll1_INCLK_bus\ : std_logic_vector(1 DOWNTO 0);
SIGNAL \vga|pll|altpll_component|auto_generated|pll1_CLK_bus\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a0_PORTADATAIN_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAIN_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a0_PORTAADDR_bus\ : std_logic_vector(12 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a0_PORTBADDR_bus\ : std_logic_vector(12 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a0_PORTADATAOUT_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a1_PORTADATAIN_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a1_PORTBDATAIN_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a1_PORTAADDR_bus\ : std_logic_vector(12 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a1_PORTBADDR_bus\ : std_logic_vector(12 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a1_PORTADATAOUT_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a2_PORTADATAIN_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a2_PORTBDATAIN_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a2_PORTAADDR_bus\ : std_logic_vector(12 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a2_PORTBADDR_bus\ : std_logic_vector(12 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a2_PORTADATAOUT_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a3_PORTADATAIN_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a3_PORTBDATAIN_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a3_PORTAADDR_bus\ : std_logic_vector(12 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a3_PORTBADDR_bus\ : std_logic_vector(12 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a3_PORTADATAOUT_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a4_PORTADATAIN_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a4_PORTBDATAIN_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a4_PORTAADDR_bus\ : std_logic_vector(12 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a4_PORTBADDR_bus\ : std_logic_vector(12 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a4_PORTADATAOUT_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a5_PORTADATAIN_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a5_PORTBDATAIN_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a5_PORTAADDR_bus\ : std_logic_vector(12 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a5_PORTBADDR_bus\ : std_logic_vector(12 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a5_PORTADATAOUT_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a6_PORTADATAIN_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a6_PORTBDATAIN_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a6_PORTAADDR_bus\ : std_logic_vector(12 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a6_PORTBADDR_bus\ : std_logic_vector(12 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a6_PORTADATAOUT_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \~QUARTUS_CREATED_ADC1~_CHSEL_bus\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \~QUARTUS_CREATED_ADC2~_CHSEL_bus\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \CLOCK_50~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \KEY[1]~input_o\ : std_logic;
SIGNAL \~QUARTUS_CREATED_UNVM~~busy\ : std_logic;
SIGNAL \~ALTERA_TMS~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_TMS~~padout\ : std_logic;
SIGNAL \~ALTERA_TCK~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_TCK~~padout\ : std_logic;
SIGNAL \~ALTERA_TDI~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_TDI~~padout\ : std_logic;
SIGNAL \~ALTERA_TDO~~padout\ : std_logic;
SIGNAL \~ALTERA_CONFIG_SEL~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_CONFIG_SEL~~padout\ : std_logic;
SIGNAL \~ALTERA_nCONFIG~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_nCONFIG~~padout\ : std_logic;
SIGNAL \~ALTERA_nSTATUS~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_nSTATUS~~padout\ : std_logic;
SIGNAL \~ALTERA_CONF_DONE~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_CONF_DONE~~padout\ : std_logic;
SIGNAL \~QUARTUS_CREATED_ADC1~~eoc\ : std_logic;
SIGNAL \~QUARTUS_CREATED_ADC2~~eoc\ : std_logic;
SIGNAL \~ALTERA_TDO~~obuf_o\ : std_logic;
SIGNAL \KEY[0]~input_o\ : std_logic;
SIGNAL \CLOCK_50~input_o\ : std_logic;
SIGNAL \vga|pll|altpll_component|auto_generated|wire_pll1_fbout\ : std_logic;
SIGNAL \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\ : std_logic;
SIGNAL \vga|Add1~0_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:hcount[0]~q\ : std_logic;
SIGNAL \vga|X[0]~feeder_combout\ : std_logic;
SIGNAL \vga|Add1~1\ : std_logic;
SIGNAL \vga|Add1~2_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:hcount[1]~q\ : std_logic;
SIGNAL \vga|Add1~3\ : std_logic;
SIGNAL \vga|Add1~4_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:hcount[2]~q\ : std_logic;
SIGNAL \vga|Add1~5\ : std_logic;
SIGNAL \vga|Add1~6_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:hcount[3]~q\ : std_logic;
SIGNAL \vga|Add1~7\ : std_logic;
SIGNAL \vga|Add1~8_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:hcount[4]~q\ : std_logic;
SIGNAL \vga|Add1~9\ : std_logic;
SIGNAL \vga|Add1~10_combout\ : std_logic;
SIGNAL \vga|hcount~0_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:hcount[5]~q\ : std_logic;
SIGNAL \vga|Equal0~1_combout\ : std_logic;
SIGNAL \vga|Add1~11\ : std_logic;
SIGNAL \vga|Add1~12_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:hcount[6]~q\ : std_logic;
SIGNAL \vga|Add1~13\ : std_logic;
SIGNAL \vga|Add1~14_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:hcount[7]~q\ : std_logic;
SIGNAL \vga|Add1~15\ : std_logic;
SIGNAL \vga|Add1~16_combout\ : std_logic;
SIGNAL \vga|hcount~2_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:hcount[8]~q\ : std_logic;
SIGNAL \vga|Equal0~0_combout\ : std_logic;
SIGNAL \vga|Equal0~2_combout\ : std_logic;
SIGNAL \vga|Add1~17\ : std_logic;
SIGNAL \vga|Add1~18_combout\ : std_logic;
SIGNAL \vga|hcount~1_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:hcount[9]~q\ : std_logic;
SIGNAL \vga|Equal1~0_combout\ : std_logic;
SIGNAL \vga|Add0~0_combout\ : std_logic;
SIGNAL \vga|vcount~5_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:vcount[0]~q\ : std_logic;
SIGNAL \vga|Equal1~1_combout\ : std_logic;
SIGNAL \vga|Add0~1\ : std_logic;
SIGNAL \vga|Add0~2_combout\ : std_logic;
SIGNAL \vga|vcount~6_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:vcount[1]~q\ : std_logic;
SIGNAL \vga|Equal1~2_combout\ : std_logic;
SIGNAL \vga|Add0~3\ : std_logic;
SIGNAL \vga|Add0~4_combout\ : std_logic;
SIGNAL \vga|vcount~0_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:vcount[2]~q\ : std_logic;
SIGNAL \vga|Add0~5\ : std_logic;
SIGNAL \vga|Add0~6_combout\ : std_logic;
SIGNAL \vga|vcount~9_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:vcount[3]~q\ : std_logic;
SIGNAL \vga|Add0~7\ : std_logic;
SIGNAL \vga|Add0~8_combout\ : std_logic;
SIGNAL \vga|vcount~4_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:vcount[4]~q\ : std_logic;
SIGNAL \vga|Add0~9\ : std_logic;
SIGNAL \vga|Add0~10_combout\ : std_logic;
SIGNAL \vga|vcount~3_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:vcount[5]~q\ : std_logic;
SIGNAL \vga|Add0~11\ : std_logic;
SIGNAL \vga|Add0~12_combout\ : std_logic;
SIGNAL \vga|vcount~2_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:vcount[6]~q\ : std_logic;
SIGNAL \vga|Add0~13\ : std_logic;
SIGNAL \vga|Add0~14_combout\ : std_logic;
SIGNAL \vga|vcount~7_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:vcount[7]~q\ : std_logic;
SIGNAL \vga|Add0~15\ : std_logic;
SIGNAL \vga|Add0~16_combout\ : std_logic;
SIGNAL \vga|vcount~1_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:vcount[8]~q\ : std_logic;
SIGNAL \vga|Add0~17\ : std_logic;
SIGNAL \vga|Add0~18_combout\ : std_logic;
SIGNAL \vga|vcount~8_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit:vcount[9]~q\ : std_logic;
SIGNAL \vga|Timing_Circuit~0_combout\ : std_logic;
SIGNAL \vga|LessThan3~0_combout\ : std_logic;
SIGNAL \vga|X[2]~0_combout\ : std_logic;
SIGNAL \vga|Y[0]~feeder_combout\ : std_logic;
SIGNAL \vga|FY[0]~feeder_combout\ : std_logic;
SIGNAL \vga|Y[1]~feeder_combout\ : std_logic;
SIGNAL \vga|FY[1]~feeder_combout\ : std_logic;
SIGNAL \vga|Y[2]~feeder_combout\ : std_logic;
SIGNAL \vga|FY[2]~feeder_combout\ : std_logic;
SIGNAL \CLOCK_50~inputclkctrl_outclk\ : std_logic;
SIGNAL \x[0]~7_combout\ : std_logic;
SIGNAL \SV.clean1~0_combout\ : std_logic;
SIGNAL \SV.clean1~q\ : std_logic;
SIGNAL \SV.clean2~feeder_combout\ : std_logic;
SIGNAL \SV.clean2~q\ : std_logic;
SIGNAL \x[6]~9_combout\ : std_logic;
SIGNAL \x[0]~8\ : std_logic;
SIGNAL \x[1]~10_combout\ : std_logic;
SIGNAL \x[1]~11\ : std_logic;
SIGNAL \x[2]~12_combout\ : std_logic;
SIGNAL \x[2]~13\ : std_logic;
SIGNAL \x[3]~14_combout\ : std_logic;
SIGNAL \x[3]~15\ : std_logic;
SIGNAL \x[4]~16_combout\ : std_logic;
SIGNAL \x[4]~17\ : std_logic;
SIGNAL \x[5]~18_combout\ : std_logic;
SIGNAL \x[5]~19\ : std_logic;
SIGNAL \x[6]~20_combout\ : std_logic;
SIGNAL \Selector4~0_combout\ : std_logic;
SIGNAL \SV.clean3~feeder_combout\ : std_logic;
SIGNAL \SV.clean3~q\ : std_logic;
SIGNAL \y[0]~5_combout\ : std_logic;
SIGNAL \y[1]~6_combout\ : std_logic;
SIGNAL \y[1]~7\ : std_logic;
SIGNAL \y[2]~8_combout\ : std_logic;
SIGNAL \y[2]~9\ : std_logic;
SIGNAL \y[3]~10_combout\ : std_logic;
SIGNAL \y[3]~11\ : std_logic;
SIGNAL \y[4]~12_combout\ : std_logic;
SIGNAL \y[4]~13\ : std_logic;
SIGNAL \y[5]~14_combout\ : std_logic;
SIGNAL \Selector1~0_combout\ : std_logic;
SIGNAL \x[6]~22_combout\ : std_logic;
SIGNAL \Selector1~1_combout\ : std_logic;
SIGNAL \SV.clean0~q\ : std_logic;
SIGNAL \Selector0~0_combout\ : std_logic;
SIGNAL \mem_wr~q\ : std_logic;
SIGNAL \~GND~combout\ : std_logic;
SIGNAL \vga|X[3]~feeder_combout\ : std_logic;
SIGNAL \vga|X[4]~feeder_combout\ : std_logic;
SIGNAL \vga|X[5]~feeder_combout\ : std_logic;
SIGNAL \vga|X[6]~feeder_combout\ : std_logic;
SIGNAL \vga|X[7]~feeder_combout\ : std_logic;
SIGNAL \vga|X[8]~feeder_combout\ : std_logic;
SIGNAL \vga|X[9]~feeder_combout\ : std_logic;
SIGNAL \vga|Y[3]~feeder_combout\ : std_logic;
SIGNAL \vga|Y[4]~feeder_combout\ : std_logic;
SIGNAL \vga|Y[5]~feeder_combout\ : std_logic;
SIGNAL \vga|Y[6]~feeder_combout\ : std_logic;
SIGNAL \vga|Y[7]~feeder_combout\ : std_logic;
SIGNAL \vga|Y[8]~feeder_combout\ : std_logic;
SIGNAL \data[0]~6_combout\ : std_logic;
SIGNAL \mem_in[0]~feeder_combout\ : std_logic;
SIGNAL \mem_in[0]~0_combout\ : std_logic;
SIGNAL \data[1]~7_combout\ : std_logic;
SIGNAL \mem_in[1]~feeder_combout\ : std_logic;
SIGNAL \data[1]~8\ : std_logic;
SIGNAL \data[2]~9_combout\ : std_logic;
SIGNAL \mem_in[2]~feeder_combout\ : std_logic;
SIGNAL \data[2]~10\ : std_logic;
SIGNAL \data[3]~11_combout\ : std_logic;
SIGNAL \mem_in[3]~feeder_combout\ : std_logic;
SIGNAL \data[3]~12\ : std_logic;
SIGNAL \data[4]~13_combout\ : std_logic;
SIGNAL \mem_in[4]~feeder_combout\ : std_logic;
SIGNAL \data[4]~14\ : std_logic;
SIGNAL \data[5]~15_combout\ : std_logic;
SIGNAL \mem_in[5]~feeder_combout\ : std_logic;
SIGNAL \data[5]~16\ : std_logic;
SIGNAL \data[6]~17_combout\ : std_logic;
SIGNAL \mem_in[6]~feeder_combout\ : std_logic;
SIGNAL \vga|X[1]~feeder_combout\ : std_logic;
SIGNAL \vga|FX1[1]~feeder_combout\ : std_logic;
SIGNAL \vga|Mux0~0_combout\ : std_logic;
SIGNAL \vga|Mux0~1_combout\ : std_logic;
SIGNAL \vga|Mux0~2_combout\ : std_logic;
SIGNAL \vga|Mux0~3_combout\ : std_logic;
SIGNAL \vga|Timing_Circuit~1_combout\ : std_logic;
SIGNAL \vga|b1~q\ : std_logic;
SIGNAL \vga|b2~feeder_combout\ : std_logic;
SIGNAL \vga|b2~q\ : std_logic;
SIGNAL \vga|blank~q\ : std_logic;
SIGNAL \vga|X[2]~feeder_combout\ : std_logic;
SIGNAL \vga|FX1[2]~feeder_combout\ : std_logic;
SIGNAL \vga|FX2[2]~feeder_combout\ : std_logic;
SIGNAL \vga|r~0_combout\ : std_logic;
SIGNAL \vga|r[0]~feeder_combout\ : std_logic;
SIGNAL \vga|r[1]~feeder_combout\ : std_logic;
SIGNAL \vga|r[2]~feeder_combout\ : std_logic;
SIGNAL \vga|r[3]~feeder_combout\ : std_logic;
SIGNAL \vga|g[0]~feeder_combout\ : std_logic;
SIGNAL \vga|g[1]~feeder_combout\ : std_logic;
SIGNAL \vga|g[2]~feeder_combout\ : std_logic;
SIGNAL \vga|g[3]~feeder_combout\ : std_logic;
SIGNAL \vga|b[0]~feeder_combout\ : std_logic;
SIGNAL \vga|b[1]~feeder_combout\ : std_logic;
SIGNAL \vga|b[2]~feeder_combout\ : std_logic;
SIGNAL \vga|b[3]~feeder_combout\ : std_logic;
SIGNAL \vga|Equal2~1_combout\ : std_logic;
SIGNAL \vga|Equal2~0_combout\ : std_logic;
SIGNAL \vga|Equal2~2_combout\ : std_logic;
SIGNAL \vga|hs1~0_combout\ : std_logic;
SIGNAL \vga|hs1~q\ : std_logic;
SIGNAL \vga|hs2~feeder_combout\ : std_logic;
SIGNAL \vga|hs2~q\ : std_logic;
SIGNAL \vga|hs3~feeder_combout\ : std_logic;
SIGNAL \vga|hs3~q\ : std_logic;
SIGNAL \vga|vga_hs~0_combout\ : std_logic;
SIGNAL \vga|vga_hs~q\ : std_logic;
SIGNAL \vga|Equal4~0_combout\ : std_logic;
SIGNAL \vga|Equal4~1_combout\ : std_logic;
SIGNAL \vga|Equal4~3_combout\ : std_logic;
SIGNAL \vga|Equal4~2_combout\ : std_logic;
SIGNAL \vga|Equal4~4_combout\ : std_logic;
SIGNAL \vga|vs1~0_combout\ : std_logic;
SIGNAL \vga|vs1~q\ : std_logic;
SIGNAL \vga|vs2~feeder_combout\ : std_logic;
SIGNAL \vga|vs2~q\ : std_logic;
SIGNAL \vga|vs3~feeder_combout\ : std_logic;
SIGNAL \vga|vs3~q\ : std_logic;
SIGNAL \vga|vga_vs~0_combout\ : std_logic;
SIGNAL \vga|vga_vs~q\ : std_logic;
SIGNAL \vga|g\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \vga|font_table|altsyncram_component|auto_generated|q_a\ : std_logic_vector(7 DOWNTO 0);
SIGNAL \vga|FX2\ : std_logic_vector(2 DOWNTO 0);
SIGNAL \vga|pll|altpll_component|auto_generated|wire_pll1_clk\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \vga|Video_RAM|altsyncram_component|auto_generated|q_a\ : std_logic_vector(6 DOWNTO 0);
SIGNAL x : std_logic_vector(6 DOWNTO 0);
SIGNAL \vga|b\ : std_logic_vector(3 DOWNTO 0);
SIGNAL y : std_logic_vector(5 DOWNTO 0);
SIGNAL data : std_logic_vector(6 DOWNTO 0);
SIGNAL \vga|r\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \vga|FY\ : std_logic_vector(2 DOWNTO 0);
SIGNAL \vga|FX1\ : std_logic_vector(2 DOWNTO 0);
SIGNAL \vga|Y\ : std_logic_vector(8 DOWNTO 0);
SIGNAL \vga|X\ : std_logic_vector(9 DOWNTO 0);
SIGNAL mem_in : std_logic_vector(6 DOWNTO 0);
SIGNAL \ALT_INV_KEY[0]~input_o\ : std_logic;
SIGNAL \vga|ALT_INV_vga_vs~q\ : std_logic;
SIGNAL \vga|ALT_INV_vga_hs~q\ : std_logic;

BEGIN

ww_CLOCK_50 <= CLOCK_50;
ww_KEY <= KEY;
VGA_R <= ww_VGA_R;
VGA_G <= ww_VGA_G;
VGA_B <= ww_VGA_B;
VGA_HS <= ww_VGA_HS;
VGA_VS <= ww_VGA_VS;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\vga|font_table|altsyncram_component|auto_generated|ram_block1a0_PORTAADDR_bus\ <= (\vga|Video_RAM|altsyncram_component|auto_generated|q_a\(6) & \vga|Video_RAM|altsyncram_component|auto_generated|q_a\(5) & 
\vga|Video_RAM|altsyncram_component|auto_generated|q_a\(4) & \vga|Video_RAM|altsyncram_component|auto_generated|q_a\(3) & \vga|Video_RAM|altsyncram_component|auto_generated|q_a\(2) & \vga|Video_RAM|altsyncram_component|auto_generated|q_a\(1) & 
\vga|Video_RAM|altsyncram_component|auto_generated|q_a\(0) & \vga|FY\(2) & \vga|FY\(1) & \vga|FY\(0));

\vga|font_table|altsyncram_component|auto_generated|q_a\(0) <= \vga|font_table|altsyncram_component|auto_generated|ram_block1a0_PORTADATAOUT_bus\(0);
\vga|font_table|altsyncram_component|auto_generated|q_a\(1) <= \vga|font_table|altsyncram_component|auto_generated|ram_block1a0_PORTADATAOUT_bus\(1);
\vga|font_table|altsyncram_component|auto_generated|q_a\(2) <= \vga|font_table|altsyncram_component|auto_generated|ram_block1a0_PORTADATAOUT_bus\(2);
\vga|font_table|altsyncram_component|auto_generated|q_a\(3) <= \vga|font_table|altsyncram_component|auto_generated|ram_block1a0_PORTADATAOUT_bus\(3);
\vga|font_table|altsyncram_component|auto_generated|q_a\(4) <= \vga|font_table|altsyncram_component|auto_generated|ram_block1a0_PORTADATAOUT_bus\(4);
\vga|font_table|altsyncram_component|auto_generated|q_a\(5) <= \vga|font_table|altsyncram_component|auto_generated|ram_block1a0_PORTADATAOUT_bus\(5);
\vga|font_table|altsyncram_component|auto_generated|q_a\(6) <= \vga|font_table|altsyncram_component|auto_generated|ram_block1a0_PORTADATAOUT_bus\(6);
\vga|font_table|altsyncram_component|auto_generated|q_a\(7) <= \vga|font_table|altsyncram_component|auto_generated|ram_block1a0_PORTADATAOUT_bus\(7);

\vga|pll|altpll_component|auto_generated|pll1_INCLK_bus\ <= (gnd & \CLOCK_50~input_o\);

\vga|pll|altpll_component|auto_generated|wire_pll1_clk\(0) <= \vga|pll|altpll_component|auto_generated|pll1_CLK_bus\(0);
\vga|pll|altpll_component|auto_generated|wire_pll1_clk\(1) <= \vga|pll|altpll_component|auto_generated|pll1_CLK_bus\(1);
\vga|pll|altpll_component|auto_generated|wire_pll1_clk\(2) <= \vga|pll|altpll_component|auto_generated|pll1_CLK_bus\(2);
\vga|pll|altpll_component|auto_generated|wire_pll1_clk\(3) <= \vga|pll|altpll_component|auto_generated|pll1_CLK_bus\(3);
\vga|pll|altpll_component|auto_generated|wire_pll1_clk\(4) <= \vga|pll|altpll_component|auto_generated|pll1_CLK_bus\(4);

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a0_PORTADATAIN_bus\(0) <= \~GND~combout\;

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAIN_bus\(0) <= mem_in(0);

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a0_PORTAADDR_bus\ <= (\vga|Y\(8) & \vga|Y\(7) & \vga|Y\(6) & \vga|Y\(5) & \vga|Y\(4) & \vga|Y\(3) & \vga|X\(9) & \vga|X\(8) & \vga|X\(7) & \vga|X\(6) & \vga|X\(5) & 
\vga|X\(4) & \vga|X\(3));

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a0_PORTBADDR_bus\ <= (y(5) & y(4) & y(3) & y(2) & y(1) & y(0) & x(6) & x(5) & x(4) & x(3) & x(2) & x(1) & x(0));

\vga|Video_RAM|altsyncram_component|auto_generated|q_a\(0) <= \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a0_PORTADATAOUT_bus\(0);

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a1_PORTADATAIN_bus\(0) <= \~GND~combout\;

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a1_PORTBDATAIN_bus\(0) <= mem_in(1);

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a1_PORTAADDR_bus\ <= (\vga|Y\(8) & \vga|Y\(7) & \vga|Y\(6) & \vga|Y\(5) & \vga|Y\(4) & \vga|Y\(3) & \vga|X\(9) & \vga|X\(8) & \vga|X\(7) & \vga|X\(6) & \vga|X\(5) & 
\vga|X\(4) & \vga|X\(3));

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a1_PORTBADDR_bus\ <= (y(5) & y(4) & y(3) & y(2) & y(1) & y(0) & x(6) & x(5) & x(4) & x(3) & x(2) & x(1) & x(0));

\vga|Video_RAM|altsyncram_component|auto_generated|q_a\(1) <= \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a1_PORTADATAOUT_bus\(0);

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a2_PORTADATAIN_bus\(0) <= \~GND~combout\;

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a2_PORTBDATAIN_bus\(0) <= mem_in(2);

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a2_PORTAADDR_bus\ <= (\vga|Y\(8) & \vga|Y\(7) & \vga|Y\(6) & \vga|Y\(5) & \vga|Y\(4) & \vga|Y\(3) & \vga|X\(9) & \vga|X\(8) & \vga|X\(7) & \vga|X\(6) & \vga|X\(5) & 
\vga|X\(4) & \vga|X\(3));

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a2_PORTBADDR_bus\ <= (y(5) & y(4) & y(3) & y(2) & y(1) & y(0) & x(6) & x(5) & x(4) & x(3) & x(2) & x(1) & x(0));

\vga|Video_RAM|altsyncram_component|auto_generated|q_a\(2) <= \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a2_PORTADATAOUT_bus\(0);

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a3_PORTADATAIN_bus\(0) <= \~GND~combout\;

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a3_PORTBDATAIN_bus\(0) <= mem_in(3);

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a3_PORTAADDR_bus\ <= (\vga|Y\(8) & \vga|Y\(7) & \vga|Y\(6) & \vga|Y\(5) & \vga|Y\(4) & \vga|Y\(3) & \vga|X\(9) & \vga|X\(8) & \vga|X\(7) & \vga|X\(6) & \vga|X\(5) & 
\vga|X\(4) & \vga|X\(3));

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a3_PORTBADDR_bus\ <= (y(5) & y(4) & y(3) & y(2) & y(1) & y(0) & x(6) & x(5) & x(4) & x(3) & x(2) & x(1) & x(0));

\vga|Video_RAM|altsyncram_component|auto_generated|q_a\(3) <= \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a3_PORTADATAOUT_bus\(0);

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a4_PORTADATAIN_bus\(0) <= \~GND~combout\;

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a4_PORTBDATAIN_bus\(0) <= mem_in(4);

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a4_PORTAADDR_bus\ <= (\vga|Y\(8) & \vga|Y\(7) & \vga|Y\(6) & \vga|Y\(5) & \vga|Y\(4) & \vga|Y\(3) & \vga|X\(9) & \vga|X\(8) & \vga|X\(7) & \vga|X\(6) & \vga|X\(5) & 
\vga|X\(4) & \vga|X\(3));

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a4_PORTBADDR_bus\ <= (y(5) & y(4) & y(3) & y(2) & y(1) & y(0) & x(6) & x(5) & x(4) & x(3) & x(2) & x(1) & x(0));

\vga|Video_RAM|altsyncram_component|auto_generated|q_a\(4) <= \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a4_PORTADATAOUT_bus\(0);

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a5_PORTADATAIN_bus\(0) <= \~GND~combout\;

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a5_PORTBDATAIN_bus\(0) <= mem_in(5);

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a5_PORTAADDR_bus\ <= (\vga|Y\(8) & \vga|Y\(7) & \vga|Y\(6) & \vga|Y\(5) & \vga|Y\(4) & \vga|Y\(3) & \vga|X\(9) & \vga|X\(8) & \vga|X\(7) & \vga|X\(6) & \vga|X\(5) & 
\vga|X\(4) & \vga|X\(3));

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a5_PORTBADDR_bus\ <= (y(5) & y(4) & y(3) & y(2) & y(1) & y(0) & x(6) & x(5) & x(4) & x(3) & x(2) & x(1) & x(0));

\vga|Video_RAM|altsyncram_component|auto_generated|q_a\(5) <= \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a5_PORTADATAOUT_bus\(0);

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a6_PORTADATAIN_bus\(0) <= \~GND~combout\;

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a6_PORTBDATAIN_bus\(0) <= mem_in(6);

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a6_PORTAADDR_bus\ <= (\vga|Y\(8) & \vga|Y\(7) & \vga|Y\(6) & \vga|Y\(5) & \vga|Y\(4) & \vga|Y\(3) & \vga|X\(9) & \vga|X\(8) & \vga|X\(7) & \vga|X\(6) & \vga|X\(5) & 
\vga|X\(4) & \vga|X\(3));

\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a6_PORTBADDR_bus\ <= (y(5) & y(4) & y(3) & y(2) & y(1) & y(0) & x(6) & x(5) & x(4) & x(3) & x(2) & x(1) & x(0));

\vga|Video_RAM|altsyncram_component|auto_generated|q_a\(6) <= \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a6_PORTADATAOUT_bus\(0);

\~QUARTUS_CREATED_ADC1~_CHSEL_bus\ <= (\~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\);

\~QUARTUS_CREATED_ADC2~_CHSEL_bus\ <= (\~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\);

\vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \vga|pll|altpll_component|auto_generated|wire_pll1_clk\(0));

\CLOCK_50~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \CLOCK_50~input_o\);
\ALT_INV_KEY[0]~input_o\ <= NOT \KEY[0]~input_o\;
\vga|ALT_INV_vga_vs~q\ <= NOT \vga|vga_vs~q\;
\vga|ALT_INV_vga_hs~q\ <= NOT \vga|vga_hs~q\;

-- Location: IOOBUF_X18_Y0_N30
\VGA_R[0]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \vga|r\(0),
	devoe => ww_devoe,
	o => ww_VGA_R(0));

-- Location: IOOBUF_X0_Y12_N9
\VGA_R[1]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \vga|r\(1),
	devoe => ww_devoe,
	o => ww_VGA_R(1));

-- Location: IOOBUF_X16_Y0_N16
\VGA_R[2]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \vga|r\(2),
	devoe => ww_devoe,
	o => ww_VGA_R(2));

-- Location: IOOBUF_X16_Y0_N23
\VGA_R[3]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \vga|r\(3),
	devoe => ww_devoe,
	o => ww_VGA_R(3));

-- Location: IOOBUF_X0_Y9_N2
\VGA_G[0]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \vga|g\(0),
	devoe => ww_devoe,
	o => ww_VGA_G(0));

-- Location: IOOBUF_X0_Y15_N9
\VGA_G[1]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \vga|g\(1),
	devoe => ww_devoe,
	o => ww_VGA_G(1));

-- Location: IOOBUF_X0_Y3_N9
\VGA_G[2]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \vga|g\(2),
	devoe => ww_devoe,
	o => ww_VGA_G(2));

-- Location: IOOBUF_X0_Y3_N2
\VGA_G[3]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \vga|g\(3),
	devoe => ww_devoe,
	o => ww_VGA_G(3));

-- Location: IOOBUF_X0_Y13_N2
\VGA_B[0]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \vga|b\(0),
	devoe => ww_devoe,
	o => ww_VGA_B(0));

-- Location: IOOBUF_X0_Y15_N2
\VGA_B[1]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \vga|b\(1),
	devoe => ww_devoe,
	o => ww_VGA_B(1));

-- Location: IOOBUF_X0_Y23_N2
\VGA_B[2]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \vga|b\(2),
	devoe => ww_devoe,
	o => ww_VGA_B(2));

-- Location: IOOBUF_X0_Y18_N9
\VGA_B[3]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \vga|b\(3),
	devoe => ww_devoe,
	o => ww_VGA_B(3));

-- Location: IOOBUF_X0_Y18_N2
\VGA_HS~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \vga|ALT_INV_vga_hs~q\,
	devoe => ww_devoe,
	o => ww_VGA_HS);

-- Location: IOOBUF_X0_Y13_N9
\VGA_VS~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \vga|ALT_INV_vga_vs~q\,
	devoe => ww_devoe,
	o => ww_VGA_VS);

-- Location: IOIBUF_X46_Y54_N29
\KEY[0]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_KEY(0),
	o => \KEY[0]~input_o\);

-- Location: IOIBUF_X34_Y0_N29
\CLOCK_50~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_CLOCK_50,
	o => \CLOCK_50~input_o\);

-- Location: PLL_1
\vga|pll|altpll_component|auto_generated|pll1\ : fiftyfivenm_pll
-- pragma translate_off
GENERIC MAP (
	auto_settings => "false",
	bandwidth_type => "medium",
	c0_high => 13,
	c0_initial => 1,
	c0_low => 12,
	c0_mode => "odd",
	c0_ph => 0,
	c1_high => 0,
	c1_initial => 0,
	c1_low => 0,
	c1_mode => "bypass",
	c1_ph => 0,
	c1_use_casc_in => "off",
	c2_high => 0,
	c2_initial => 0,
	c2_low => 0,
	c2_mode => "bypass",
	c2_ph => 0,
	c2_use_casc_in => "off",
	c3_high => 0,
	c3_initial => 0,
	c3_low => 0,
	c3_mode => "bypass",
	c3_ph => 0,
	c3_use_casc_in => "off",
	c4_high => 0,
	c4_initial => 0,
	c4_low => 0,
	c4_mode => "bypass",
	c4_ph => 0,
	c4_use_casc_in => "off",
	charge_pump_current_bits => 1,
	clk0_counter => "c0",
	clk0_divide_by => 125,
	clk0_duty_cycle => 50,
	clk0_multiply_by => 63,
	clk0_phase_shift => "0",
	clk1_counter => "unused",
	clk1_divide_by => 0,
	clk1_duty_cycle => 50,
	clk1_multiply_by => 0,
	clk1_phase_shift => "0",
	clk2_counter => "unused",
	clk2_divide_by => 0,
	clk2_duty_cycle => 50,
	clk2_multiply_by => 0,
	clk2_phase_shift => "0",
	clk3_counter => "unused",
	clk3_divide_by => 0,
	clk3_duty_cycle => 50,
	clk3_multiply_by => 0,
	clk3_phase_shift => "0",
	clk4_counter => "unused",
	clk4_divide_by => 0,
	clk4_duty_cycle => 50,
	clk4_multiply_by => 0,
	clk4_phase_shift => "0",
	compensate_clock => "clock0",
	inclk0_input_frequency => 20000,
	inclk1_input_frequency => 0,
	loop_filter_c_bits => 0,
	loop_filter_r_bits => 16,
	m => 63,
	m_initial => 1,
	m_ph => 0,
	n => 5,
	operation_mode => "normal",
	pfd_max => 200000,
	pfd_min => 3076,
	self_reset_on_loss_lock => "off",
	simulation_type => "functional",
	switch_over_type => "auto",
	vco_center => 1538,
	vco_divide_by => 0,
	vco_frequency_control => "auto",
	vco_max => 3333,
	vco_min => 1538,
	vco_multiply_by => 0,
	vco_phase_shift_step => 198,
	vco_post_scale => 2)
-- pragma translate_on
PORT MAP (
	areset => \ALT_INV_KEY[0]~input_o\,
	fbin => \vga|pll|altpll_component|auto_generated|wire_pll1_fbout\,
	inclk => \vga|pll|altpll_component|auto_generated|pll1_INCLK_bus\,
	fbout => \vga|pll|altpll_component|auto_generated|wire_pll1_fbout\,
	clk => \vga|pll|altpll_component|auto_generated|pll1_CLK_bus\);

-- Location: CLKCTRL_G18
\vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl\ : fiftyfivenm_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\);

-- Location: LCCOMB_X31_Y26_N6
\vga|Add1~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add1~0_combout\ = \vga|Timing_Circuit:hcount[0]~q\ $ (VCC)
-- \vga|Add1~1\ = CARRY(\vga|Timing_Circuit:hcount[0]~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010110101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Timing_Circuit:hcount[0]~q\,
	datad => VCC,
	combout => \vga|Add1~0_combout\,
	cout => \vga|Add1~1\);

-- Location: FF_X31_Y26_N7
\vga|Timing_Circuit:hcount[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|Add1~0_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:hcount[0]~q\);

-- Location: LCCOMB_X32_Y26_N30
\vga|X[0]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|X[0]~feeder_combout\ = \vga|Timing_Circuit:hcount[0]~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \vga|Timing_Circuit:hcount[0]~q\,
	combout => \vga|X[0]~feeder_combout\);

-- Location: LCCOMB_X31_Y26_N8
\vga|Add1~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add1~2_combout\ = (\vga|Timing_Circuit:hcount[1]~q\ & (!\vga|Add1~1\)) # (!\vga|Timing_Circuit:hcount[1]~q\ & ((\vga|Add1~1\) # (GND)))
-- \vga|Add1~3\ = CARRY((!\vga|Add1~1\) # (!\vga|Timing_Circuit:hcount[1]~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga|Timing_Circuit:hcount[1]~q\,
	datad => VCC,
	cin => \vga|Add1~1\,
	combout => \vga|Add1~2_combout\,
	cout => \vga|Add1~3\);

-- Location: FF_X31_Y26_N9
\vga|Timing_Circuit:hcount[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|Add1~2_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:hcount[1]~q\);

-- Location: LCCOMB_X31_Y26_N10
\vga|Add1~4\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add1~4_combout\ = (\vga|Timing_Circuit:hcount[2]~q\ & (\vga|Add1~3\ $ (GND))) # (!\vga|Timing_Circuit:hcount[2]~q\ & (!\vga|Add1~3\ & VCC))
-- \vga|Add1~5\ = CARRY((\vga|Timing_Circuit:hcount[2]~q\ & !\vga|Add1~3\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Timing_Circuit:hcount[2]~q\,
	datad => VCC,
	cin => \vga|Add1~3\,
	combout => \vga|Add1~4_combout\,
	cout => \vga|Add1~5\);

-- Location: FF_X31_Y26_N11
\vga|Timing_Circuit:hcount[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|Add1~4_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:hcount[2]~q\);

-- Location: LCCOMB_X31_Y26_N12
\vga|Add1~6\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add1~6_combout\ = (\vga|Timing_Circuit:hcount[3]~q\ & (!\vga|Add1~5\)) # (!\vga|Timing_Circuit:hcount[3]~q\ & ((\vga|Add1~5\) # (GND)))
-- \vga|Add1~7\ = CARRY((!\vga|Add1~5\) # (!\vga|Timing_Circuit:hcount[3]~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Timing_Circuit:hcount[3]~q\,
	datad => VCC,
	cin => \vga|Add1~5\,
	combout => \vga|Add1~6_combout\,
	cout => \vga|Add1~7\);

-- Location: FF_X31_Y26_N13
\vga|Timing_Circuit:hcount[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|Add1~6_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:hcount[3]~q\);

-- Location: LCCOMB_X31_Y26_N14
\vga|Add1~8\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add1~8_combout\ = (\vga|Timing_Circuit:hcount[4]~q\ & (\vga|Add1~7\ $ (GND))) # (!\vga|Timing_Circuit:hcount[4]~q\ & (!\vga|Add1~7\ & VCC))
-- \vga|Add1~9\ = CARRY((\vga|Timing_Circuit:hcount[4]~q\ & !\vga|Add1~7\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Timing_Circuit:hcount[4]~q\,
	datad => VCC,
	cin => \vga|Add1~7\,
	combout => \vga|Add1~8_combout\,
	cout => \vga|Add1~9\);

-- Location: FF_X31_Y26_N15
\vga|Timing_Circuit:hcount[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|Add1~8_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:hcount[4]~q\);

-- Location: LCCOMB_X31_Y26_N16
\vga|Add1~10\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add1~10_combout\ = (\vga|Timing_Circuit:hcount[5]~q\ & (!\vga|Add1~9\)) # (!\vga|Timing_Circuit:hcount[5]~q\ & ((\vga|Add1~9\) # (GND)))
-- \vga|Add1~11\ = CARRY((!\vga|Add1~9\) # (!\vga|Timing_Circuit:hcount[5]~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga|Timing_Circuit:hcount[5]~q\,
	datad => VCC,
	cin => \vga|Add1~9\,
	combout => \vga|Add1~10_combout\,
	cout => \vga|Add1~11\);

-- Location: LCCOMB_X31_Y26_N2
\vga|hcount~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|hcount~0_combout\ = (\vga|Add1~10_combout\ & !\vga|Equal0~2_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000110000001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \vga|Add1~10_combout\,
	datac => \vga|Equal0~2_combout\,
	combout => \vga|hcount~0_combout\);

-- Location: FF_X31_Y26_N3
\vga|Timing_Circuit:hcount[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|hcount~0_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:hcount[5]~q\);

-- Location: LCCOMB_X31_Y26_N26
\vga|Equal0~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Equal0~1_combout\ = (\vga|Timing_Circuit:hcount[3]~q\ & (!\vga|Timing_Circuit:hcount[5]~q\ & (\vga|Timing_Circuit:hcount[4]~q\ & \vga|Timing_Circuit:hcount[2]~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Timing_Circuit:hcount[3]~q\,
	datab => \vga|Timing_Circuit:hcount[5]~q\,
	datac => \vga|Timing_Circuit:hcount[4]~q\,
	datad => \vga|Timing_Circuit:hcount[2]~q\,
	combout => \vga|Equal0~1_combout\);

-- Location: LCCOMB_X31_Y26_N18
\vga|Add1~12\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add1~12_combout\ = (\vga|Timing_Circuit:hcount[6]~q\ & (\vga|Add1~11\ $ (GND))) # (!\vga|Timing_Circuit:hcount[6]~q\ & (!\vga|Add1~11\ & VCC))
-- \vga|Add1~13\ = CARRY((\vga|Timing_Circuit:hcount[6]~q\ & !\vga|Add1~11\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Timing_Circuit:hcount[6]~q\,
	datad => VCC,
	cin => \vga|Add1~11\,
	combout => \vga|Add1~12_combout\,
	cout => \vga|Add1~13\);

-- Location: FF_X31_Y26_N19
\vga|Timing_Circuit:hcount[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|Add1~12_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:hcount[6]~q\);

-- Location: LCCOMB_X31_Y26_N20
\vga|Add1~14\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add1~14_combout\ = (\vga|Timing_Circuit:hcount[7]~q\ & (!\vga|Add1~13\)) # (!\vga|Timing_Circuit:hcount[7]~q\ & ((\vga|Add1~13\) # (GND)))
-- \vga|Add1~15\ = CARRY((!\vga|Add1~13\) # (!\vga|Timing_Circuit:hcount[7]~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga|Timing_Circuit:hcount[7]~q\,
	datad => VCC,
	cin => \vga|Add1~13\,
	combout => \vga|Add1~14_combout\,
	cout => \vga|Add1~15\);

-- Location: FF_X31_Y26_N21
\vga|Timing_Circuit:hcount[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|Add1~14_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:hcount[7]~q\);

-- Location: LCCOMB_X31_Y26_N22
\vga|Add1~16\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add1~16_combout\ = (\vga|Timing_Circuit:hcount[8]~q\ & (\vga|Add1~15\ $ (GND))) # (!\vga|Timing_Circuit:hcount[8]~q\ & (!\vga|Add1~15\ & VCC))
-- \vga|Add1~17\ = CARRY((\vga|Timing_Circuit:hcount[8]~q\ & !\vga|Add1~15\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga|Timing_Circuit:hcount[8]~q\,
	datad => VCC,
	cin => \vga|Add1~15\,
	combout => \vga|Add1~16_combout\,
	cout => \vga|Add1~17\);

-- Location: LCCOMB_X30_Y26_N24
\vga|hcount~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|hcount~2_combout\ = (!\vga|Equal0~2_combout\ & \vga|Add1~16_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Equal0~2_combout\,
	datad => \vga|Add1~16_combout\,
	combout => \vga|hcount~2_combout\);

-- Location: FF_X30_Y26_N25
\vga|Timing_Circuit:hcount[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|hcount~2_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:hcount[8]~q\);

-- Location: LCCOMB_X31_Y26_N28
\vga|Equal0~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Equal0~0_combout\ = (\vga|Timing_Circuit:hcount[9]~q\ & (\vga|Timing_Circuit:hcount[8]~q\ & (!\vga|Timing_Circuit:hcount[6]~q\ & !\vga|Timing_Circuit:hcount[7]~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Timing_Circuit:hcount[9]~q\,
	datab => \vga|Timing_Circuit:hcount[8]~q\,
	datac => \vga|Timing_Circuit:hcount[6]~q\,
	datad => \vga|Timing_Circuit:hcount[7]~q\,
	combout => \vga|Equal0~0_combout\);

-- Location: LCCOMB_X31_Y26_N4
\vga|Equal0~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Equal0~2_combout\ = (\vga|Equal0~1_combout\ & (\vga|Equal0~0_combout\ & (\vga|Timing_Circuit:hcount[1]~q\ & \vga|Timing_Circuit:hcount[0]~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Equal0~1_combout\,
	datab => \vga|Equal0~0_combout\,
	datac => \vga|Timing_Circuit:hcount[1]~q\,
	datad => \vga|Timing_Circuit:hcount[0]~q\,
	combout => \vga|Equal0~2_combout\);

-- Location: LCCOMB_X31_Y26_N24
\vga|Add1~18\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add1~18_combout\ = \vga|Add1~17\ $ (\vga|Timing_Circuit:hcount[9]~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => \vga|Timing_Circuit:hcount[9]~q\,
	cin => \vga|Add1~17\,
	combout => \vga|Add1~18_combout\);

-- Location: LCCOMB_X30_Y26_N14
\vga|hcount~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|hcount~1_combout\ = (!\vga|Equal0~2_combout\ & \vga|Add1~18_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Equal0~2_combout\,
	datad => \vga|Add1~18_combout\,
	combout => \vga|hcount~1_combout\);

-- Location: FF_X30_Y26_N15
\vga|Timing_Circuit:hcount[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|hcount~1_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:hcount[9]~q\);

-- Location: LCCOMB_X31_Y25_N16
\vga|Equal1~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Equal1~0_combout\ = (!\vga|Timing_Circuit:vcount[8]~q\ & (!\vga|Timing_Circuit:vcount[7]~q\ & (\vga|Timing_Circuit:vcount[9]~q\ & !\vga|Timing_Circuit:vcount[6]~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Timing_Circuit:vcount[8]~q\,
	datab => \vga|Timing_Circuit:vcount[7]~q\,
	datac => \vga|Timing_Circuit:vcount[9]~q\,
	datad => \vga|Timing_Circuit:vcount[6]~q\,
	combout => \vga|Equal1~0_combout\);

-- Location: LCCOMB_X30_Y25_N12
\vga|Add0~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add0~0_combout\ = \vga|Timing_Circuit:vcount[0]~q\ $ (VCC)
-- \vga|Add0~1\ = CARRY(\vga|Timing_Circuit:vcount[0]~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \vga|Timing_Circuit:vcount[0]~q\,
	datad => VCC,
	combout => \vga|Add0~0_combout\,
	cout => \vga|Add0~1\);

-- Location: LCCOMB_X30_Y25_N8
\vga|vcount~5\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|vcount~5_combout\ = (\vga|Equal0~2_combout\ & (\vga|Add0~0_combout\ & ((!\vga|Equal1~2_combout\)))) # (!\vga|Equal0~2_combout\ & (((\vga|Timing_Circuit:vcount[0]~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011000010111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Add0~0_combout\,
	datab => \vga|Equal0~2_combout\,
	datac => \vga|Timing_Circuit:vcount[0]~q\,
	datad => \vga|Equal1~2_combout\,
	combout => \vga|vcount~5_combout\);

-- Location: FF_X30_Y25_N9
\vga|Timing_Circuit:vcount[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|vcount~5_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:vcount[0]~q\);

-- Location: LCCOMB_X30_Y25_N0
\vga|Equal1~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Equal1~1_combout\ = (!\vga|Timing_Circuit:vcount[4]~q\ & (!\vga|Timing_Circuit:vcount[5]~q\ & (\vga|Timing_Circuit:vcount[2]~q\ & \vga|Timing_Circuit:vcount[3]~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Timing_Circuit:vcount[4]~q\,
	datab => \vga|Timing_Circuit:vcount[5]~q\,
	datac => \vga|Timing_Circuit:vcount[2]~q\,
	datad => \vga|Timing_Circuit:vcount[3]~q\,
	combout => \vga|Equal1~1_combout\);

-- Location: LCCOMB_X30_Y25_N14
\vga|Add0~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add0~2_combout\ = (\vga|Timing_Circuit:vcount[1]~q\ & (!\vga|Add0~1\)) # (!\vga|Timing_Circuit:vcount[1]~q\ & ((\vga|Add0~1\) # (GND)))
-- \vga|Add0~3\ = CARRY((!\vga|Add0~1\) # (!\vga|Timing_Circuit:vcount[1]~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga|Timing_Circuit:vcount[1]~q\,
	datad => VCC,
	cin => \vga|Add0~1\,
	combout => \vga|Add0~2_combout\,
	cout => \vga|Add0~3\);

-- Location: LCCOMB_X30_Y25_N2
\vga|vcount~6\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|vcount~6_combout\ = (\vga|Equal0~2_combout\ & (\vga|Add0~2_combout\)) # (!\vga|Equal0~2_combout\ & ((\vga|Timing_Circuit:vcount[1]~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \vga|Add0~2_combout\,
	datac => \vga|Timing_Circuit:vcount[1]~q\,
	datad => \vga|Equal0~2_combout\,
	combout => \vga|vcount~6_combout\);

-- Location: FF_X30_Y25_N3
\vga|Timing_Circuit:vcount[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|vcount~6_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:vcount[1]~q\);

-- Location: LCCOMB_X30_Y25_N10
\vga|Equal1~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Equal1~2_combout\ = (\vga|Equal1~0_combout\ & (!\vga|Timing_Circuit:vcount[0]~q\ & (\vga|Equal1~1_combout\ & !\vga|Timing_Circuit:vcount[1]~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Equal1~0_combout\,
	datab => \vga|Timing_Circuit:vcount[0]~q\,
	datac => \vga|Equal1~1_combout\,
	datad => \vga|Timing_Circuit:vcount[1]~q\,
	combout => \vga|Equal1~2_combout\);

-- Location: LCCOMB_X30_Y25_N16
\vga|Add0~4\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add0~4_combout\ = (\vga|Timing_Circuit:vcount[2]~q\ & (\vga|Add0~3\ $ (GND))) # (!\vga|Timing_Circuit:vcount[2]~q\ & (!\vga|Add0~3\ & VCC))
-- \vga|Add0~5\ = CARRY((\vga|Timing_Circuit:vcount[2]~q\ & !\vga|Add0~3\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga|Timing_Circuit:vcount[2]~q\,
	datad => VCC,
	cin => \vga|Add0~3\,
	combout => \vga|Add0~4_combout\,
	cout => \vga|Add0~5\);

-- Location: LCCOMB_X30_Y25_N4
\vga|vcount~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|vcount~0_combout\ = (\vga|Equal0~2_combout\ & (!\vga|Equal1~2_combout\ & (\vga|Add0~4_combout\))) # (!\vga|Equal0~2_combout\ & (((\vga|Timing_Circuit:vcount[2]~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100010011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Equal1~2_combout\,
	datab => \vga|Add0~4_combout\,
	datac => \vga|Timing_Circuit:vcount[2]~q\,
	datad => \vga|Equal0~2_combout\,
	combout => \vga|vcount~0_combout\);

-- Location: FF_X30_Y25_N5
\vga|Timing_Circuit:vcount[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|vcount~0_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:vcount[2]~q\);

-- Location: LCCOMB_X30_Y25_N18
\vga|Add0~6\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add0~6_combout\ = (\vga|Timing_Circuit:vcount[3]~q\ & (!\vga|Add0~5\)) # (!\vga|Timing_Circuit:vcount[3]~q\ & ((\vga|Add0~5\) # (GND)))
-- \vga|Add0~7\ = CARRY((!\vga|Add0~5\) # (!\vga|Timing_Circuit:vcount[3]~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Timing_Circuit:vcount[3]~q\,
	datad => VCC,
	cin => \vga|Add0~5\,
	combout => \vga|Add0~6_combout\,
	cout => \vga|Add0~7\);

-- Location: LCCOMB_X31_Y25_N14
\vga|vcount~9\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|vcount~9_combout\ = (\vga|Equal0~2_combout\ & (\vga|Add0~6_combout\ & ((!\vga|Equal1~2_combout\)))) # (!\vga|Equal0~2_combout\ & (((\vga|Timing_Circuit:vcount[3]~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101000011011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Equal0~2_combout\,
	datab => \vga|Add0~6_combout\,
	datac => \vga|Timing_Circuit:vcount[3]~q\,
	datad => \vga|Equal1~2_combout\,
	combout => \vga|vcount~9_combout\);

-- Location: FF_X31_Y25_N15
\vga|Timing_Circuit:vcount[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|vcount~9_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:vcount[3]~q\);

-- Location: LCCOMB_X30_Y25_N20
\vga|Add0~8\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add0~8_combout\ = (\vga|Timing_Circuit:vcount[4]~q\ & (\vga|Add0~7\ $ (GND))) # (!\vga|Timing_Circuit:vcount[4]~q\ & (!\vga|Add0~7\ & VCC))
-- \vga|Add0~9\ = CARRY((\vga|Timing_Circuit:vcount[4]~q\ & !\vga|Add0~7\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Timing_Circuit:vcount[4]~q\,
	datad => VCC,
	cin => \vga|Add0~7\,
	combout => \vga|Add0~8_combout\,
	cout => \vga|Add0~9\);

-- Location: LCCOMB_X30_Y25_N6
\vga|vcount~4\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|vcount~4_combout\ = (\vga|Equal0~2_combout\ & (\vga|Add0~8_combout\)) # (!\vga|Equal0~2_combout\ & ((\vga|Timing_Circuit:vcount[4]~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \vga|Add0~8_combout\,
	datac => \vga|Timing_Circuit:vcount[4]~q\,
	datad => \vga|Equal0~2_combout\,
	combout => \vga|vcount~4_combout\);

-- Location: FF_X30_Y25_N7
\vga|Timing_Circuit:vcount[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|vcount~4_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:vcount[4]~q\);

-- Location: LCCOMB_X30_Y25_N22
\vga|Add0~10\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add0~10_combout\ = (\vga|Timing_Circuit:vcount[5]~q\ & (!\vga|Add0~9\)) # (!\vga|Timing_Circuit:vcount[5]~q\ & ((\vga|Add0~9\) # (GND)))
-- \vga|Add0~11\ = CARRY((!\vga|Add0~9\) # (!\vga|Timing_Circuit:vcount[5]~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga|Timing_Circuit:vcount[5]~q\,
	datad => VCC,
	cin => \vga|Add0~9\,
	combout => \vga|Add0~10_combout\,
	cout => \vga|Add0~11\);

-- Location: LCCOMB_X31_Y25_N24
\vga|vcount~3\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|vcount~3_combout\ = (\vga|Equal0~2_combout\ & (\vga|Add0~10_combout\)) # (!\vga|Equal0~2_combout\ & ((\vga|Timing_Circuit:vcount[5]~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100011011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Equal0~2_combout\,
	datab => \vga|Add0~10_combout\,
	datac => \vga|Timing_Circuit:vcount[5]~q\,
	combout => \vga|vcount~3_combout\);

-- Location: FF_X31_Y25_N25
\vga|Timing_Circuit:vcount[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|vcount~3_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:vcount[5]~q\);

-- Location: LCCOMB_X30_Y25_N24
\vga|Add0~12\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add0~12_combout\ = (\vga|Timing_Circuit:vcount[6]~q\ & (\vga|Add0~11\ $ (GND))) # (!\vga|Timing_Circuit:vcount[6]~q\ & (!\vga|Add0~11\ & VCC))
-- \vga|Add0~13\ = CARRY((\vga|Timing_Circuit:vcount[6]~q\ & !\vga|Add0~11\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Timing_Circuit:vcount[6]~q\,
	datad => VCC,
	cin => \vga|Add0~11\,
	combout => \vga|Add0~12_combout\,
	cout => \vga|Add0~13\);

-- Location: LCCOMB_X31_Y25_N30
\vga|vcount~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|vcount~2_combout\ = (\vga|Equal0~2_combout\ & (\vga|Add0~12_combout\)) # (!\vga|Equal0~2_combout\ & ((\vga|Timing_Circuit:vcount[6]~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100011011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Equal0~2_combout\,
	datab => \vga|Add0~12_combout\,
	datac => \vga|Timing_Circuit:vcount[6]~q\,
	combout => \vga|vcount~2_combout\);

-- Location: FF_X31_Y25_N31
\vga|Timing_Circuit:vcount[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|vcount~2_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:vcount[6]~q\);

-- Location: LCCOMB_X30_Y25_N26
\vga|Add0~14\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add0~14_combout\ = (\vga|Timing_Circuit:vcount[7]~q\ & (!\vga|Add0~13\)) # (!\vga|Timing_Circuit:vcount[7]~q\ & ((\vga|Add0~13\) # (GND)))
-- \vga|Add0~15\ = CARRY((!\vga|Add0~13\) # (!\vga|Timing_Circuit:vcount[7]~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Timing_Circuit:vcount[7]~q\,
	datad => VCC,
	cin => \vga|Add0~13\,
	combout => \vga|Add0~14_combout\,
	cout => \vga|Add0~15\);

-- Location: LCCOMB_X31_Y25_N20
\vga|vcount~7\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|vcount~7_combout\ = (\vga|Equal0~2_combout\ & ((\vga|Add0~14_combout\))) # (!\vga|Equal0~2_combout\ & (\vga|Timing_Circuit:vcount[7]~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Equal0~2_combout\,
	datac => \vga|Timing_Circuit:vcount[7]~q\,
	datad => \vga|Add0~14_combout\,
	combout => \vga|vcount~7_combout\);

-- Location: FF_X31_Y25_N21
\vga|Timing_Circuit:vcount[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|vcount~7_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:vcount[7]~q\);

-- Location: LCCOMB_X30_Y25_N28
\vga|Add0~16\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add0~16_combout\ = (\vga|Timing_Circuit:vcount[8]~q\ & (\vga|Add0~15\ $ (GND))) # (!\vga|Timing_Circuit:vcount[8]~q\ & (!\vga|Add0~15\ & VCC))
-- \vga|Add0~17\ = CARRY((\vga|Timing_Circuit:vcount[8]~q\ & !\vga|Add0~15\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga|Timing_Circuit:vcount[8]~q\,
	datad => VCC,
	cin => \vga|Add0~15\,
	combout => \vga|Add0~16_combout\,
	cout => \vga|Add0~17\);

-- Location: LCCOMB_X31_Y25_N26
\vga|vcount~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|vcount~1_combout\ = (\vga|Equal0~2_combout\ & (\vga|Add0~16_combout\)) # (!\vga|Equal0~2_combout\ & ((\vga|Timing_Circuit:vcount[8]~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100011011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Equal0~2_combout\,
	datab => \vga|Add0~16_combout\,
	datac => \vga|Timing_Circuit:vcount[8]~q\,
	combout => \vga|vcount~1_combout\);

-- Location: FF_X31_Y25_N27
\vga|Timing_Circuit:vcount[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|vcount~1_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:vcount[8]~q\);

-- Location: LCCOMB_X30_Y25_N30
\vga|Add0~18\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Add0~18_combout\ = \vga|Add0~17\ $ (\vga|Timing_Circuit:vcount[9]~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => \vga|Timing_Circuit:vcount[9]~q\,
	cin => \vga|Add0~17\,
	combout => \vga|Add0~18_combout\);

-- Location: LCCOMB_X31_Y25_N28
\vga|vcount~8\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|vcount~8_combout\ = (\vga|Equal0~2_combout\ & (\vga|Add0~18_combout\ & ((!\vga|Equal1~2_combout\)))) # (!\vga|Equal0~2_combout\ & (((\vga|Timing_Circuit:vcount[9]~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101000011011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Equal0~2_combout\,
	datab => \vga|Add0~18_combout\,
	datac => \vga|Timing_Circuit:vcount[9]~q\,
	datad => \vga|Equal1~2_combout\,
	combout => \vga|vcount~8_combout\);

-- Location: FF_X31_Y25_N29
\vga|Timing_Circuit:vcount[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|vcount~8_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Timing_Circuit:vcount[9]~q\);

-- Location: LCCOMB_X31_Y26_N0
\vga|Timing_Circuit~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Timing_Circuit~0_combout\ = (\vga|Timing_Circuit:vcount[9]~q\) # ((\vga|Timing_Circuit:hcount[9]~q\ & ((\vga|Timing_Circuit:hcount[8]~q\) # (\vga|Timing_Circuit:hcount[7]~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101011111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Timing_Circuit:hcount[9]~q\,
	datab => \vga|Timing_Circuit:hcount[8]~q\,
	datac => \vga|Timing_Circuit:vcount[9]~q\,
	datad => \vga|Timing_Circuit:hcount[7]~q\,
	combout => \vga|Timing_Circuit~0_combout\);

-- Location: LCCOMB_X31_Y25_N10
\vga|LessThan3~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|LessThan3~0_combout\ = (\vga|Timing_Circuit:vcount[6]~q\ & (\vga|Timing_Circuit:vcount[7]~q\ & (\vga|Timing_Circuit:vcount[8]~q\ & \vga|Timing_Circuit:vcount[5]~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Timing_Circuit:vcount[6]~q\,
	datab => \vga|Timing_Circuit:vcount[7]~q\,
	datac => \vga|Timing_Circuit:vcount[8]~q\,
	datad => \vga|Timing_Circuit:vcount[5]~q\,
	combout => \vga|LessThan3~0_combout\);

-- Location: LCCOMB_X32_Y25_N14
\vga|X[2]~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|X[2]~0_combout\ = (\KEY[0]~input_o\ & (!\vga|Timing_Circuit~0_combout\ & !\vga|LessThan3~0_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \KEY[0]~input_o\,
	datab => \vga|Timing_Circuit~0_combout\,
	datad => \vga|LessThan3~0_combout\,
	combout => \vga|X[2]~0_combout\);

-- Location: FF_X32_Y26_N31
\vga|X[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|X[0]~feeder_combout\,
	ena => \vga|X[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|X\(0));

-- Location: FF_X32_Y25_N15
\vga|FX1[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	asdata => \vga|X\(0),
	sload => VCC,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|FX1\(0));

-- Location: FF_X32_Y25_N19
\vga|FX2[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	asdata => \vga|FX1\(0),
	sload => VCC,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|FX2\(0));

-- Location: LCCOMB_X32_Y25_N16
\vga|Y[0]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Y[0]~feeder_combout\ = \vga|Timing_Circuit:vcount[0]~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \vga|Timing_Circuit:vcount[0]~q\,
	combout => \vga|Y[0]~feeder_combout\);

-- Location: FF_X32_Y25_N17
\vga|Y[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|Y[0]~feeder_combout\,
	ena => \vga|X[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Y\(0));

-- Location: LCCOMB_X32_Y25_N0
\vga|FY[0]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|FY[0]~feeder_combout\ = \vga|Y\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|Y\(0),
	combout => \vga|FY[0]~feeder_combout\);

-- Location: FF_X32_Y25_N1
\vga|FY[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|FY[0]~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|FY\(0));

-- Location: LCCOMB_X32_Y25_N24
\vga|Y[1]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Y[1]~feeder_combout\ = \vga|Timing_Circuit:vcount[1]~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|Timing_Circuit:vcount[1]~q\,
	combout => \vga|Y[1]~feeder_combout\);

-- Location: FF_X32_Y25_N25
\vga|Y[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|Y[1]~feeder_combout\,
	ena => \vga|X[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Y\(1));

-- Location: LCCOMB_X32_Y25_N4
\vga|FY[1]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|FY[1]~feeder_combout\ = \vga|Y\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|Y\(1),
	combout => \vga|FY[1]~feeder_combout\);

-- Location: FF_X32_Y25_N5
\vga|FY[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|FY[1]~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|FY\(1));

-- Location: LCCOMB_X32_Y25_N6
\vga|Y[2]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Y[2]~feeder_combout\ = \vga|Timing_Circuit:vcount[2]~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \vga|Timing_Circuit:vcount[2]~q\,
	combout => \vga|Y[2]~feeder_combout\);

-- Location: FF_X32_Y25_N7
\vga|Y[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|Y[2]~feeder_combout\,
	ena => \vga|X[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Y\(2));

-- Location: LCCOMB_X32_Y25_N10
\vga|FY[2]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|FY[2]~feeder_combout\ = \vga|Y\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|Y\(2),
	combout => \vga|FY[2]~feeder_combout\);

-- Location: FF_X32_Y25_N11
\vga|FY[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|FY[2]~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|FY\(2));

-- Location: CLKCTRL_G19
\CLOCK_50~inputclkctrl\ : fiftyfivenm_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \CLOCK_50~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \CLOCK_50~inputclkctrl_outclk\);

-- Location: LCCOMB_X38_Y30_N0
\x[0]~7\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \x[0]~7_combout\ = x(0) $ (VCC)
-- \x[0]~8\ = CARRY(x(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => x(0),
	datad => VCC,
	combout => \x[0]~7_combout\,
	cout => \x[0]~8\);

-- Location: LCCOMB_X39_Y30_N28
\SV.clean1~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \SV.clean1~0_combout\ = !\SV.clean0~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \SV.clean0~q\,
	combout => \SV.clean1~0_combout\);

-- Location: FF_X39_Y30_N29
\SV.clean1\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \SV.clean1~0_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \SV.clean1~q\);

-- Location: LCCOMB_X39_Y30_N4
\SV.clean2~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \SV.clean2~feeder_combout\ = \SV.clean1~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \SV.clean1~q\,
	combout => \SV.clean2~feeder_combout\);

-- Location: FF_X39_Y30_N5
\SV.clean2\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \SV.clean2~feeder_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \SV.clean2~q\);

-- Location: LCCOMB_X39_Y30_N22
\x[6]~9\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \x[6]~9_combout\ = (\Selector4~0_combout\) # ((\SV.clean1~q\ & !\SV.clean2~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010111010101110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Selector4~0_combout\,
	datab => \SV.clean1~q\,
	datac => \SV.clean2~q\,
	combout => \x[6]~9_combout\);

-- Location: FF_X38_Y30_N1
\x[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \x[0]~7_combout\,
	clrn => \KEY[0]~input_o\,
	sclr => \SV.clean2~q\,
	ena => \x[6]~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => x(0));

-- Location: LCCOMB_X38_Y30_N2
\x[1]~10\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \x[1]~10_combout\ = (x(1) & (!\x[0]~8\)) # (!x(1) & ((\x[0]~8\) # (GND)))
-- \x[1]~11\ = CARRY((!\x[0]~8\) # (!x(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => x(1),
	datad => VCC,
	cin => \x[0]~8\,
	combout => \x[1]~10_combout\,
	cout => \x[1]~11\);

-- Location: FF_X38_Y30_N3
\x[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \x[1]~10_combout\,
	clrn => \KEY[0]~input_o\,
	sclr => \SV.clean2~q\,
	ena => \x[6]~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => x(1));

-- Location: LCCOMB_X38_Y30_N4
\x[2]~12\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \x[2]~12_combout\ = (x(2) & (\x[1]~11\ $ (GND))) # (!x(2) & (!\x[1]~11\ & VCC))
-- \x[2]~13\ = CARRY((x(2) & !\x[1]~11\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => x(2),
	datad => VCC,
	cin => \x[1]~11\,
	combout => \x[2]~12_combout\,
	cout => \x[2]~13\);

-- Location: FF_X38_Y30_N5
\x[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \x[2]~12_combout\,
	clrn => \KEY[0]~input_o\,
	sclr => \SV.clean2~q\,
	ena => \x[6]~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => x(2));

-- Location: LCCOMB_X38_Y30_N6
\x[3]~14\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \x[3]~14_combout\ = (x(3) & (!\x[2]~13\)) # (!x(3) & ((\x[2]~13\) # (GND)))
-- \x[3]~15\ = CARRY((!\x[2]~13\) # (!x(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => x(3),
	datad => VCC,
	cin => \x[2]~13\,
	combout => \x[3]~14_combout\,
	cout => \x[3]~15\);

-- Location: FF_X38_Y30_N7
\x[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \x[3]~14_combout\,
	clrn => \KEY[0]~input_o\,
	sclr => \SV.clean2~q\,
	ena => \x[6]~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => x(3));

-- Location: LCCOMB_X38_Y30_N8
\x[4]~16\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \x[4]~16_combout\ = (x(4) & (\x[3]~15\ $ (GND))) # (!x(4) & (!\x[3]~15\ & VCC))
-- \x[4]~17\ = CARRY((x(4) & !\x[3]~15\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => x(4),
	datad => VCC,
	cin => \x[3]~15\,
	combout => \x[4]~16_combout\,
	cout => \x[4]~17\);

-- Location: FF_X38_Y30_N9
\x[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \x[4]~16_combout\,
	clrn => \KEY[0]~input_o\,
	sclr => \SV.clean2~q\,
	ena => \x[6]~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => x(4));

-- Location: LCCOMB_X38_Y30_N10
\x[5]~18\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \x[5]~18_combout\ = (x(5) & (!\x[4]~17\)) # (!x(5) & ((\x[4]~17\) # (GND)))
-- \x[5]~19\ = CARRY((!\x[4]~17\) # (!x(5)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => x(5),
	datad => VCC,
	cin => \x[4]~17\,
	combout => \x[5]~18_combout\,
	cout => \x[5]~19\);

-- Location: FF_X38_Y30_N11
\x[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \x[5]~18_combout\,
	clrn => \KEY[0]~input_o\,
	sclr => \SV.clean2~q\,
	ena => \x[6]~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => x(5));

-- Location: LCCOMB_X38_Y30_N12
\x[6]~20\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \x[6]~20_combout\ = \x[5]~19\ $ (!x(6))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => x(6),
	cin => \x[5]~19\,
	combout => \x[6]~20_combout\);

-- Location: FF_X38_Y30_N13
\x[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \x[6]~20_combout\,
	clrn => \KEY[0]~input_o\,
	sclr => \SV.clean2~q\,
	ena => \x[6]~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => x(6));

-- Location: LCCOMB_X38_Y30_N14
\Selector4~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Selector4~0_combout\ = (x(6) & (\SV.clean2~q\ & ((x(5)) # (x(4)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010100000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => x(6),
	datab => x(5),
	datac => x(4),
	datad => \SV.clean2~q\,
	combout => \Selector4~0_combout\);

-- Location: LCCOMB_X39_Y30_N2
\SV.clean3~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \SV.clean3~feeder_combout\ = \Selector4~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \Selector4~0_combout\,
	combout => \SV.clean3~feeder_combout\);

-- Location: FF_X39_Y30_N3
\SV.clean3\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \SV.clean3~feeder_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \SV.clean3~q\);

-- Location: LCCOMB_X39_Y30_N10
\y[0]~5\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \y[0]~5_combout\ = y(0) $ (\Selector4~0_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => y(0),
	datad => \Selector4~0_combout\,
	combout => \y[0]~5_combout\);

-- Location: FF_X39_Y30_N11
\y[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \y[0]~5_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => y(0));

-- Location: LCCOMB_X38_Y30_N16
\y[1]~6\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \y[1]~6_combout\ = (y(0) & (y(1) $ (VCC))) # (!y(0) & (y(1) & VCC))
-- \y[1]~7\ = CARRY((y(0) & y(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110011010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => y(0),
	datab => y(1),
	datad => VCC,
	combout => \y[1]~6_combout\,
	cout => \y[1]~7\);

-- Location: FF_X38_Y30_N17
\y[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \y[1]~6_combout\,
	clrn => \KEY[0]~input_o\,
	ena => \Selector4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => y(1));

-- Location: LCCOMB_X38_Y30_N18
\y[2]~8\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \y[2]~8_combout\ = (y(2) & (!\y[1]~7\)) # (!y(2) & ((\y[1]~7\) # (GND)))
-- \y[2]~9\ = CARRY((!\y[1]~7\) # (!y(2)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => y(2),
	datad => VCC,
	cin => \y[1]~7\,
	combout => \y[2]~8_combout\,
	cout => \y[2]~9\);

-- Location: FF_X38_Y30_N19
\y[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \y[2]~8_combout\,
	clrn => \KEY[0]~input_o\,
	ena => \Selector4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => y(2));

-- Location: LCCOMB_X38_Y30_N20
\y[3]~10\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \y[3]~10_combout\ = (y(3) & (\y[2]~9\ $ (GND))) # (!y(3) & (!\y[2]~9\ & VCC))
-- \y[3]~11\ = CARRY((y(3) & !\y[2]~9\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => y(3),
	datad => VCC,
	cin => \y[2]~9\,
	combout => \y[3]~10_combout\,
	cout => \y[3]~11\);

-- Location: FF_X38_Y30_N21
\y[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \y[3]~10_combout\,
	clrn => \KEY[0]~input_o\,
	ena => \Selector4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => y(3));

-- Location: LCCOMB_X38_Y30_N22
\y[4]~12\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \y[4]~12_combout\ = (y(4) & (!\y[3]~11\)) # (!y(4) & ((\y[3]~11\) # (GND)))
-- \y[4]~13\ = CARRY((!\y[3]~11\) # (!y(4)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => y(4),
	datad => VCC,
	cin => \y[3]~11\,
	combout => \y[4]~12_combout\,
	cout => \y[4]~13\);

-- Location: FF_X38_Y30_N23
\y[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \y[4]~12_combout\,
	clrn => \KEY[0]~input_o\,
	ena => \Selector4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => y(4));

-- Location: LCCOMB_X38_Y30_N24
\y[5]~14\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \y[5]~14_combout\ = \y[4]~13\ $ (!y(5))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => y(5),
	cin => \y[4]~13\,
	combout => \y[5]~14_combout\);

-- Location: FF_X38_Y30_N25
\y[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \y[5]~14_combout\,
	clrn => \KEY[0]~input_o\,
	ena => \Selector4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => y(5));

-- Location: LCCOMB_X38_Y30_N26
\Selector1~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Selector1~0_combout\ = (((!y(2)) # (!y(4))) # (!y(3))) # (!y(5))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111111111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => y(5),
	datab => y(3),
	datac => y(4),
	datad => y(2),
	combout => \Selector1~0_combout\);

-- Location: LCCOMB_X39_Y30_N0
\x[6]~22\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \x[6]~22_combout\ = (\SV.clean2~q\ & (((!x(4) & !x(5))) # (!x(6))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011000001110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => x(4),
	datab => x(6),
	datac => \SV.clean2~q\,
	datad => x(5),
	combout => \x[6]~22_combout\);

-- Location: LCCOMB_X39_Y30_N6
\Selector1~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Selector1~1_combout\ = (!\x[6]~22_combout\ & ((!\Selector1~0_combout\) # (!\SV.clean3~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \SV.clean3~q\,
	datac => \Selector1~0_combout\,
	datad => \x[6]~22_combout\,
	combout => \Selector1~1_combout\);

-- Location: FF_X39_Y30_N7
\SV.clean0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \Selector1~1_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \SV.clean0~q\);

-- Location: LCCOMB_X39_Y30_N24
\Selector0~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Selector0~0_combout\ = ((!\SV.clean2~q\ & \mem_wr~q\)) # (!\SV.clean0~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111010101110101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SV.clean0~q\,
	datab => \SV.clean2~q\,
	datac => \mem_wr~q\,
	combout => \Selector0~0_combout\);

-- Location: FF_X39_Y30_N25
mem_wr : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \Selector0~0_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \mem_wr~q\);

-- Location: LCCOMB_X49_Y31_N0
\~GND\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \~GND~combout\ = GND

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	combout => \~GND~combout\);

-- Location: LCCOMB_X32_Y26_N0
\vga|X[3]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|X[3]~feeder_combout\ = \vga|Timing_Circuit:hcount[3]~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \vga|Timing_Circuit:hcount[3]~q\,
	combout => \vga|X[3]~feeder_combout\);

-- Location: FF_X32_Y26_N1
\vga|X[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|X[3]~feeder_combout\,
	ena => \vga|X[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|X\(3));

-- Location: LCCOMB_X32_Y26_N10
\vga|X[4]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|X[4]~feeder_combout\ = \vga|Timing_Circuit:hcount[4]~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|Timing_Circuit:hcount[4]~q\,
	combout => \vga|X[4]~feeder_combout\);

-- Location: FF_X32_Y26_N11
\vga|X[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|X[4]~feeder_combout\,
	ena => \vga|X[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|X\(4));

-- Location: LCCOMB_X32_Y26_N20
\vga|X[5]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|X[5]~feeder_combout\ = \vga|Timing_Circuit:hcount[5]~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|Timing_Circuit:hcount[5]~q\,
	combout => \vga|X[5]~feeder_combout\);

-- Location: FF_X32_Y26_N21
\vga|X[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|X[5]~feeder_combout\,
	ena => \vga|X[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|X\(5));

-- Location: LCCOMB_X32_Y26_N22
\vga|X[6]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|X[6]~feeder_combout\ = \vga|Timing_Circuit:hcount[6]~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|Timing_Circuit:hcount[6]~q\,
	combout => \vga|X[6]~feeder_combout\);

-- Location: FF_X32_Y26_N23
\vga|X[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|X[6]~feeder_combout\,
	ena => \vga|X[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|X\(6));

-- Location: LCCOMB_X32_Y26_N16
\vga|X[7]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|X[7]~feeder_combout\ = \vga|Timing_Circuit:hcount[7]~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|Timing_Circuit:hcount[7]~q\,
	combout => \vga|X[7]~feeder_combout\);

-- Location: FF_X32_Y26_N17
\vga|X[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|X[7]~feeder_combout\,
	ena => \vga|X[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|X\(7));

-- Location: LCCOMB_X32_Y26_N18
\vga|X[8]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|X[8]~feeder_combout\ = \vga|Timing_Circuit:hcount[8]~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \vga|Timing_Circuit:hcount[8]~q\,
	combout => \vga|X[8]~feeder_combout\);

-- Location: FF_X32_Y26_N19
\vga|X[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|X[8]~feeder_combout\,
	ena => \vga|X[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|X\(8));

-- Location: LCCOMB_X32_Y26_N12
\vga|X[9]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|X[9]~feeder_combout\ = \vga|Timing_Circuit:hcount[9]~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \vga|Timing_Circuit:hcount[9]~q\,
	combout => \vga|X[9]~feeder_combout\);

-- Location: FF_X32_Y26_N13
\vga|X[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|X[9]~feeder_combout\,
	ena => \vga|X[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|X\(9));

-- Location: LCCOMB_X32_Y25_N22
\vga|Y[3]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Y[3]~feeder_combout\ = \vga|Timing_Circuit:vcount[3]~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|Timing_Circuit:vcount[3]~q\,
	combout => \vga|Y[3]~feeder_combout\);

-- Location: FF_X32_Y25_N23
\vga|Y[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|Y[3]~feeder_combout\,
	ena => \vga|X[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Y\(3));

-- Location: LCCOMB_X32_Y26_N14
\vga|Y[4]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Y[4]~feeder_combout\ = \vga|Timing_Circuit:vcount[4]~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \vga|Timing_Circuit:vcount[4]~q\,
	combout => \vga|Y[4]~feeder_combout\);

-- Location: FF_X32_Y26_N15
\vga|Y[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|Y[4]~feeder_combout\,
	ena => \vga|X[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Y\(4));

-- Location: LCCOMB_X32_Y25_N28
\vga|Y[5]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Y[5]~feeder_combout\ = \vga|Timing_Circuit:vcount[5]~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|Timing_Circuit:vcount[5]~q\,
	combout => \vga|Y[5]~feeder_combout\);

-- Location: FF_X32_Y25_N29
\vga|Y[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|Y[5]~feeder_combout\,
	ena => \vga|X[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Y\(5));

-- Location: LCCOMB_X32_Y26_N24
\vga|Y[6]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Y[6]~feeder_combout\ = \vga|Timing_Circuit:vcount[6]~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \vga|Timing_Circuit:vcount[6]~q\,
	combout => \vga|Y[6]~feeder_combout\);

-- Location: FF_X32_Y26_N25
\vga|Y[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|Y[6]~feeder_combout\,
	ena => \vga|X[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Y\(6));

-- Location: LCCOMB_X32_Y26_N26
\vga|Y[7]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Y[7]~feeder_combout\ = \vga|Timing_Circuit:vcount[7]~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \vga|Timing_Circuit:vcount[7]~q\,
	combout => \vga|Y[7]~feeder_combout\);

-- Location: FF_X32_Y26_N27
\vga|Y[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|Y[7]~feeder_combout\,
	ena => \vga|X[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Y\(7));

-- Location: LCCOMB_X32_Y26_N28
\vga|Y[8]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Y[8]~feeder_combout\ = \vga|Timing_Circuit:vcount[8]~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|Timing_Circuit:vcount[8]~q\,
	combout => \vga|Y[8]~feeder_combout\);

-- Location: FF_X32_Y26_N29
\vga|Y[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|Y[8]~feeder_combout\,
	ena => \vga|X[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|Y\(8));

-- Location: LCCOMB_X39_Y30_N16
\data[0]~6\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \data[0]~6_combout\ = data(0) $ (\SV.clean1~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => data(0),
	datad => \SV.clean1~q\,
	combout => \data[0]~6_combout\);

-- Location: FF_X39_Y30_N17
\data[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \data[0]~6_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => data(0));

-- Location: LCCOMB_X34_Y29_N24
\mem_in[0]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \mem_in[0]~feeder_combout\ = data(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => data(0),
	combout => \mem_in[0]~feeder_combout\);

-- Location: LCCOMB_X39_Y30_N26
\mem_in[0]~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \mem_in[0]~0_combout\ = (!\SV.clean0~q\ & \KEY[0]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101000001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SV.clean0~q\,
	datac => \KEY[0]~input_o\,
	combout => \mem_in[0]~0_combout\);

-- Location: FF_X34_Y29_N25
\mem_in[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \mem_in[0]~feeder_combout\,
	ena => \mem_in[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => mem_in(0));

-- Location: M9K_X53_Y26_N0
\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a0\ : fiftyfivenm_ram_block
-- pragma translate_off
GENERIC MAP (
	data_interleave_offset_in_bits => 1,
	data_interleave_width_in_bits => 1,
	logical_ram_name => "vga_font:vga|vram:Video_RAM|altsyncram:altsyncram_component|altsyncram_rtq3:auto_generated|ALTSYNCRAM",
	mixed_port_feed_through_mode => "dont_care",
	operation_mode => "bidir_dual_port",
	port_a_address_clear => "none",
	port_a_address_width => 13,
	port_a_byte_enable_clock => "none",
	port_a_data_out_clear => "none",
	port_a_data_out_clock => "none",
	port_a_data_width => 1,
	port_a_first_address => 0,
	port_a_first_bit_number => 0,
	port_a_last_address => 8191,
	port_a_logical_ram_depth => 8192,
	port_a_logical_ram_width => 7,
	port_a_read_during_write_mode => "new_data_with_nbe_read",
	port_b_address_clear => "none",
	port_b_address_clock => "clock1",
	port_b_address_width => 13,
	port_b_data_in_clock => "clock1",
	port_b_data_out_clear => "none",
	port_b_data_out_clock => "none",
	port_b_data_width => 1,
	port_b_first_address => 0,
	port_b_first_bit_number => 0,
	port_b_last_address => 8191,
	port_b_logical_ram_depth => 8192,
	port_b_logical_ram_width => 7,
	port_b_read_during_write_mode => "new_data_with_nbe_read",
	port_b_read_enable_clock => "clock1",
	port_b_write_enable_clock => "clock1",
	ram_block_type => "M9K")
-- pragma translate_on
PORT MAP (
	portawe => GND,
	portare => VCC,
	portbwe => \mem_wr~q\,
	portbre => VCC,
	clk0 => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	clk1 => \CLOCK_50~inputclkctrl_outclk\,
	portadatain => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a0_PORTADATAIN_bus\,
	portbdatain => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAIN_bus\,
	portaaddr => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a0_PORTAADDR_bus\,
	portbaddr => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a0_PORTBADDR_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	portadataout => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a0_PORTADATAOUT_bus\);

-- Location: LCCOMB_X34_Y29_N6
\data[1]~7\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \data[1]~7_combout\ = (data(1) & (data(0) $ (VCC))) # (!data(1) & (data(0) & VCC))
-- \data[1]~8\ = CARRY((data(1) & data(0)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110011010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => data(1),
	datab => data(0),
	datad => VCC,
	combout => \data[1]~7_combout\,
	cout => \data[1]~8\);

-- Location: FF_X34_Y29_N7
\data[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \data[1]~7_combout\,
	clrn => \KEY[0]~input_o\,
	ena => \SV.clean1~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => data(1));

-- Location: LCCOMB_X34_Y29_N2
\mem_in[1]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \mem_in[1]~feeder_combout\ = data(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => data(1),
	combout => \mem_in[1]~feeder_combout\);

-- Location: FF_X34_Y29_N3
\mem_in[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \mem_in[1]~feeder_combout\,
	ena => \mem_in[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => mem_in(1));

-- Location: M9K_X33_Y29_N0
\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a1\ : fiftyfivenm_ram_block
-- pragma translate_off
GENERIC MAP (
	data_interleave_offset_in_bits => 1,
	data_interleave_width_in_bits => 1,
	logical_ram_name => "vga_font:vga|vram:Video_RAM|altsyncram:altsyncram_component|altsyncram_rtq3:auto_generated|ALTSYNCRAM",
	mixed_port_feed_through_mode => "dont_care",
	operation_mode => "bidir_dual_port",
	port_a_address_clear => "none",
	port_a_address_width => 13,
	port_a_byte_enable_clock => "none",
	port_a_data_out_clear => "none",
	port_a_data_out_clock => "none",
	port_a_data_width => 1,
	port_a_first_address => 0,
	port_a_first_bit_number => 1,
	port_a_last_address => 8191,
	port_a_logical_ram_depth => 8192,
	port_a_logical_ram_width => 7,
	port_a_read_during_write_mode => "new_data_with_nbe_read",
	port_b_address_clear => "none",
	port_b_address_clock => "clock1",
	port_b_address_width => 13,
	port_b_data_in_clock => "clock1",
	port_b_data_out_clear => "none",
	port_b_data_out_clock => "none",
	port_b_data_width => 1,
	port_b_first_address => 0,
	port_b_first_bit_number => 1,
	port_b_last_address => 8191,
	port_b_logical_ram_depth => 8192,
	port_b_logical_ram_width => 7,
	port_b_read_during_write_mode => "new_data_with_nbe_read",
	port_b_read_enable_clock => "clock1",
	port_b_write_enable_clock => "clock1",
	ram_block_type => "M9K")
-- pragma translate_on
PORT MAP (
	portawe => GND,
	portare => VCC,
	portbwe => \mem_wr~q\,
	portbre => VCC,
	clk0 => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	clk1 => \CLOCK_50~inputclkctrl_outclk\,
	portadatain => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a1_PORTADATAIN_bus\,
	portbdatain => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a1_PORTBDATAIN_bus\,
	portaaddr => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a1_PORTAADDR_bus\,
	portbaddr => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a1_PORTBADDR_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	portadataout => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a1_PORTADATAOUT_bus\);

-- Location: LCCOMB_X34_Y29_N8
\data[2]~9\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \data[2]~9_combout\ = (data(2) & (!\data[1]~8\)) # (!data(2) & ((\data[1]~8\) # (GND)))
-- \data[2]~10\ = CARRY((!\data[1]~8\) # (!data(2)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => data(2),
	datad => VCC,
	cin => \data[1]~8\,
	combout => \data[2]~9_combout\,
	cout => \data[2]~10\);

-- Location: FF_X34_Y29_N9
\data[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \data[2]~9_combout\,
	clrn => \KEY[0]~input_o\,
	ena => \SV.clean1~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => data(2));

-- Location: LCCOMB_X34_Y29_N4
\mem_in[2]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \mem_in[2]~feeder_combout\ = data(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => data(2),
	combout => \mem_in[2]~feeder_combout\);

-- Location: FF_X34_Y29_N5
\mem_in[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \mem_in[2]~feeder_combout\,
	ena => \mem_in[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => mem_in(2));

-- Location: M9K_X33_Y27_N0
\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a2\ : fiftyfivenm_ram_block
-- pragma translate_off
GENERIC MAP (
	data_interleave_offset_in_bits => 1,
	data_interleave_width_in_bits => 1,
	logical_ram_name => "vga_font:vga|vram:Video_RAM|altsyncram:altsyncram_component|altsyncram_rtq3:auto_generated|ALTSYNCRAM",
	mixed_port_feed_through_mode => "dont_care",
	operation_mode => "bidir_dual_port",
	port_a_address_clear => "none",
	port_a_address_width => 13,
	port_a_byte_enable_clock => "none",
	port_a_data_out_clear => "none",
	port_a_data_out_clock => "none",
	port_a_data_width => 1,
	port_a_first_address => 0,
	port_a_first_bit_number => 2,
	port_a_last_address => 8191,
	port_a_logical_ram_depth => 8192,
	port_a_logical_ram_width => 7,
	port_a_read_during_write_mode => "new_data_with_nbe_read",
	port_b_address_clear => "none",
	port_b_address_clock => "clock1",
	port_b_address_width => 13,
	port_b_data_in_clock => "clock1",
	port_b_data_out_clear => "none",
	port_b_data_out_clock => "none",
	port_b_data_width => 1,
	port_b_first_address => 0,
	port_b_first_bit_number => 2,
	port_b_last_address => 8191,
	port_b_logical_ram_depth => 8192,
	port_b_logical_ram_width => 7,
	port_b_read_during_write_mode => "new_data_with_nbe_read",
	port_b_read_enable_clock => "clock1",
	port_b_write_enable_clock => "clock1",
	ram_block_type => "M9K")
-- pragma translate_on
PORT MAP (
	portawe => GND,
	portare => VCC,
	portbwe => \mem_wr~q\,
	portbre => VCC,
	clk0 => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	clk1 => \CLOCK_50~inputclkctrl_outclk\,
	portadatain => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a2_PORTADATAIN_bus\,
	portbdatain => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a2_PORTBDATAIN_bus\,
	portaaddr => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a2_PORTAADDR_bus\,
	portbaddr => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a2_PORTBADDR_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	portadataout => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a2_PORTADATAOUT_bus\);

-- Location: LCCOMB_X34_Y29_N10
\data[3]~11\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \data[3]~11_combout\ = (data(3) & (\data[2]~10\ $ (GND))) # (!data(3) & (!\data[2]~10\ & VCC))
-- \data[3]~12\ = CARRY((data(3) & !\data[2]~10\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => data(3),
	datad => VCC,
	cin => \data[2]~10\,
	combout => \data[3]~11_combout\,
	cout => \data[3]~12\);

-- Location: FF_X34_Y29_N11
\data[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \data[3]~11_combout\,
	clrn => \KEY[0]~input_o\,
	ena => \SV.clean1~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => data(3));

-- Location: LCCOMB_X34_Y29_N26
\mem_in[3]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \mem_in[3]~feeder_combout\ = data(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => data(3),
	combout => \mem_in[3]~feeder_combout\);

-- Location: FF_X34_Y29_N27
\mem_in[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \mem_in[3]~feeder_combout\,
	ena => \mem_in[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => mem_in(3));

-- Location: M9K_X53_Y29_N0
\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a3\ : fiftyfivenm_ram_block
-- pragma translate_off
GENERIC MAP (
	data_interleave_offset_in_bits => 1,
	data_interleave_width_in_bits => 1,
	logical_ram_name => "vga_font:vga|vram:Video_RAM|altsyncram:altsyncram_component|altsyncram_rtq3:auto_generated|ALTSYNCRAM",
	mixed_port_feed_through_mode => "dont_care",
	operation_mode => "bidir_dual_port",
	port_a_address_clear => "none",
	port_a_address_width => 13,
	port_a_byte_enable_clock => "none",
	port_a_data_out_clear => "none",
	port_a_data_out_clock => "none",
	port_a_data_width => 1,
	port_a_first_address => 0,
	port_a_first_bit_number => 3,
	port_a_last_address => 8191,
	port_a_logical_ram_depth => 8192,
	port_a_logical_ram_width => 7,
	port_a_read_during_write_mode => "new_data_with_nbe_read",
	port_b_address_clear => "none",
	port_b_address_clock => "clock1",
	port_b_address_width => 13,
	port_b_data_in_clock => "clock1",
	port_b_data_out_clear => "none",
	port_b_data_out_clock => "none",
	port_b_data_width => 1,
	port_b_first_address => 0,
	port_b_first_bit_number => 3,
	port_b_last_address => 8191,
	port_b_logical_ram_depth => 8192,
	port_b_logical_ram_width => 7,
	port_b_read_during_write_mode => "new_data_with_nbe_read",
	port_b_read_enable_clock => "clock1",
	port_b_write_enable_clock => "clock1",
	ram_block_type => "M9K")
-- pragma translate_on
PORT MAP (
	portawe => GND,
	portare => VCC,
	portbwe => \mem_wr~q\,
	portbre => VCC,
	clk0 => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	clk1 => \CLOCK_50~inputclkctrl_outclk\,
	portadatain => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a3_PORTADATAIN_bus\,
	portbdatain => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a3_PORTBDATAIN_bus\,
	portaaddr => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a3_PORTAADDR_bus\,
	portbaddr => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a3_PORTBADDR_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	portadataout => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a3_PORTADATAOUT_bus\);

-- Location: LCCOMB_X34_Y29_N12
\data[4]~13\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \data[4]~13_combout\ = (data(4) & (!\data[3]~12\)) # (!data(4) & ((\data[3]~12\) # (GND)))
-- \data[4]~14\ = CARRY((!\data[3]~12\) # (!data(4)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => data(4),
	datad => VCC,
	cin => \data[3]~12\,
	combout => \data[4]~13_combout\,
	cout => \data[4]~14\);

-- Location: FF_X34_Y29_N13
\data[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \data[4]~13_combout\,
	clrn => \KEY[0]~input_o\,
	ena => \SV.clean1~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => data(4));

-- Location: LCCOMB_X34_Y29_N28
\mem_in[4]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \mem_in[4]~feeder_combout\ = data(4)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => data(4),
	combout => \mem_in[4]~feeder_combout\);

-- Location: FF_X34_Y29_N29
\mem_in[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \mem_in[4]~feeder_combout\,
	ena => \mem_in[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => mem_in(4));

-- Location: M9K_X33_Y26_N0
\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a4\ : fiftyfivenm_ram_block
-- pragma translate_off
GENERIC MAP (
	data_interleave_offset_in_bits => 1,
	data_interleave_width_in_bits => 1,
	logical_ram_name => "vga_font:vga|vram:Video_RAM|altsyncram:altsyncram_component|altsyncram_rtq3:auto_generated|ALTSYNCRAM",
	mixed_port_feed_through_mode => "dont_care",
	operation_mode => "bidir_dual_port",
	port_a_address_clear => "none",
	port_a_address_width => 13,
	port_a_byte_enable_clock => "none",
	port_a_data_out_clear => "none",
	port_a_data_out_clock => "none",
	port_a_data_width => 1,
	port_a_first_address => 0,
	port_a_first_bit_number => 4,
	port_a_last_address => 8191,
	port_a_logical_ram_depth => 8192,
	port_a_logical_ram_width => 7,
	port_a_read_during_write_mode => "new_data_with_nbe_read",
	port_b_address_clear => "none",
	port_b_address_clock => "clock1",
	port_b_address_width => 13,
	port_b_data_in_clock => "clock1",
	port_b_data_out_clear => "none",
	port_b_data_out_clock => "none",
	port_b_data_width => 1,
	port_b_first_address => 0,
	port_b_first_bit_number => 4,
	port_b_last_address => 8191,
	port_b_logical_ram_depth => 8192,
	port_b_logical_ram_width => 7,
	port_b_read_during_write_mode => "new_data_with_nbe_read",
	port_b_read_enable_clock => "clock1",
	port_b_write_enable_clock => "clock1",
	ram_block_type => "M9K")
-- pragma translate_on
PORT MAP (
	portawe => GND,
	portare => VCC,
	portbwe => \mem_wr~q\,
	portbre => VCC,
	clk0 => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	clk1 => \CLOCK_50~inputclkctrl_outclk\,
	portadatain => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a4_PORTADATAIN_bus\,
	portbdatain => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a4_PORTBDATAIN_bus\,
	portaaddr => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a4_PORTAADDR_bus\,
	portbaddr => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a4_PORTBADDR_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	portadataout => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a4_PORTADATAOUT_bus\);

-- Location: LCCOMB_X34_Y29_N14
\data[5]~15\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \data[5]~15_combout\ = (data(5) & (\data[4]~14\ $ (GND))) # (!data(5) & (!\data[4]~14\ & VCC))
-- \data[5]~16\ = CARRY((data(5) & !\data[4]~14\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => data(5),
	datad => VCC,
	cin => \data[4]~14\,
	combout => \data[5]~15_combout\,
	cout => \data[5]~16\);

-- Location: FF_X34_Y29_N15
\data[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \data[5]~15_combout\,
	clrn => \KEY[0]~input_o\,
	ena => \SV.clean1~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => data(5));

-- Location: LCCOMB_X34_Y29_N30
\mem_in[5]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \mem_in[5]~feeder_combout\ = data(5)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => data(5),
	combout => \mem_in[5]~feeder_combout\);

-- Location: FF_X34_Y29_N31
\mem_in[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \mem_in[5]~feeder_combout\,
	ena => \mem_in[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => mem_in(5));

-- Location: M9K_X33_Y28_N0
\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a5\ : fiftyfivenm_ram_block
-- pragma translate_off
GENERIC MAP (
	data_interleave_offset_in_bits => 1,
	data_interleave_width_in_bits => 1,
	logical_ram_name => "vga_font:vga|vram:Video_RAM|altsyncram:altsyncram_component|altsyncram_rtq3:auto_generated|ALTSYNCRAM",
	mixed_port_feed_through_mode => "dont_care",
	operation_mode => "bidir_dual_port",
	port_a_address_clear => "none",
	port_a_address_width => 13,
	port_a_byte_enable_clock => "none",
	port_a_data_out_clear => "none",
	port_a_data_out_clock => "none",
	port_a_data_width => 1,
	port_a_first_address => 0,
	port_a_first_bit_number => 5,
	port_a_last_address => 8191,
	port_a_logical_ram_depth => 8192,
	port_a_logical_ram_width => 7,
	port_a_read_during_write_mode => "new_data_with_nbe_read",
	port_b_address_clear => "none",
	port_b_address_clock => "clock1",
	port_b_address_width => 13,
	port_b_data_in_clock => "clock1",
	port_b_data_out_clear => "none",
	port_b_data_out_clock => "none",
	port_b_data_width => 1,
	port_b_first_address => 0,
	port_b_first_bit_number => 5,
	port_b_last_address => 8191,
	port_b_logical_ram_depth => 8192,
	port_b_logical_ram_width => 7,
	port_b_read_during_write_mode => "new_data_with_nbe_read",
	port_b_read_enable_clock => "clock1",
	port_b_write_enable_clock => "clock1",
	ram_block_type => "M9K")
-- pragma translate_on
PORT MAP (
	portawe => GND,
	portare => VCC,
	portbwe => \mem_wr~q\,
	portbre => VCC,
	clk0 => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	clk1 => \CLOCK_50~inputclkctrl_outclk\,
	portadatain => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a5_PORTADATAIN_bus\,
	portbdatain => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a5_PORTBDATAIN_bus\,
	portaaddr => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a5_PORTAADDR_bus\,
	portbaddr => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a5_PORTBADDR_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	portadataout => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a5_PORTADATAOUT_bus\);

-- Location: LCCOMB_X34_Y29_N16
\data[6]~17\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \data[6]~17_combout\ = \data[5]~16\ $ (data(6))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => data(6),
	cin => \data[5]~16\,
	combout => \data[6]~17_combout\);

-- Location: FF_X34_Y29_N17
\data[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \data[6]~17_combout\,
	clrn => \KEY[0]~input_o\,
	ena => \SV.clean1~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => data(6));

-- Location: LCCOMB_X34_Y29_N0
\mem_in[6]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \mem_in[6]~feeder_combout\ = data(6)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => data(6),
	combout => \mem_in[6]~feeder_combout\);

-- Location: FF_X34_Y29_N1
\mem_in[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK_50~inputclkctrl_outclk\,
	d => \mem_in[6]~feeder_combout\,
	ena => \mem_in[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => mem_in(6));

-- Location: M9K_X33_Y30_N0
\vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a6\ : fiftyfivenm_ram_block
-- pragma translate_off
GENERIC MAP (
	data_interleave_offset_in_bits => 1,
	data_interleave_width_in_bits => 1,
	logical_ram_name => "vga_font:vga|vram:Video_RAM|altsyncram:altsyncram_component|altsyncram_rtq3:auto_generated|ALTSYNCRAM",
	mixed_port_feed_through_mode => "dont_care",
	operation_mode => "bidir_dual_port",
	port_a_address_clear => "none",
	port_a_address_width => 13,
	port_a_byte_enable_clock => "none",
	port_a_data_out_clear => "none",
	port_a_data_out_clock => "none",
	port_a_data_width => 1,
	port_a_first_address => 0,
	port_a_first_bit_number => 6,
	port_a_last_address => 8191,
	port_a_logical_ram_depth => 8192,
	port_a_logical_ram_width => 7,
	port_a_read_during_write_mode => "new_data_with_nbe_read",
	port_b_address_clear => "none",
	port_b_address_clock => "clock1",
	port_b_address_width => 13,
	port_b_data_in_clock => "clock1",
	port_b_data_out_clear => "none",
	port_b_data_out_clock => "none",
	port_b_data_width => 1,
	port_b_first_address => 0,
	port_b_first_bit_number => 6,
	port_b_last_address => 8191,
	port_b_logical_ram_depth => 8192,
	port_b_logical_ram_width => 7,
	port_b_read_during_write_mode => "new_data_with_nbe_read",
	port_b_read_enable_clock => "clock1",
	port_b_write_enable_clock => "clock1",
	ram_block_type => "M9K")
-- pragma translate_on
PORT MAP (
	portawe => GND,
	portare => VCC,
	portbwe => \mem_wr~q\,
	portbre => VCC,
	clk0 => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	clk1 => \CLOCK_50~inputclkctrl_outclk\,
	portadatain => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a6_PORTADATAIN_bus\,
	portbdatain => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a6_PORTBDATAIN_bus\,
	portaaddr => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a6_PORTAADDR_bus\,
	portbaddr => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a6_PORTBADDR_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	portadataout => \vga|Video_RAM|altsyncram_component|auto_generated|ram_block1a6_PORTADATAOUT_bus\);

-- Location: M9K_X33_Y25_N0
\vga|font_table|altsyncram_component|auto_generated|ram_block1a0\ : fiftyfivenm_ram_block
-- pragma translate_off
GENERIC MAP (
	mem_init4 => X"7FBFDFEFF7FBFDFEFF00000004C290880000000C0100802020103000040201008040200000030201010040200C001F04010041F000001C0107844221100000001105010141100000000D0944A211080000000604842211080000000E88C422110800000007040203E0804000001F0043C200F000000010080403117000000201",
	mem_init3 => X"07844220F0000020100F044221E00000000F08442210F00000001088442210F0000000128944A250D00000000E02010080406000000905030140904000000C010080400010000004020100800020000010884622E10080001E0087C42210F800000008040203C080441C000F0807E210F00000000F884421F0080400000F88040200F80000001F084423E1008000000F8843E010F000000000000000101818007F8000000000000000000000000210903000000F00804020107800000080808080808000000F04020100807800001F8401004010FC000004020101C11088000010848180C090840000108CC5A2D1088400000604842211088400000F08442211",
	mem_init2 => X"08840000040201008040F800000F0840C18108780000108887C21108F800000E8884A21108780000100807C21108F800000F08442211087800001188C4A29188C40000108845A2D198CC00001F88040201008000001089870281308400000C09008040203800000E020100804070000010884423F1088400000F0844E2010878000010080403E100FC00001F880403E100FC00001E0884221110F000000F0CC60301987800001F084423E108F80000108847E210903000000F8805E2D108780000060001806108780000100600C01030604000000007E001F80000000081830200C01802000C01018000603000000003018000603000000F0043E21108780000",
	mem_init1 => X"0F084421E108780000040201004010FC00000F084423E1007800000F0C4023E100FC0000010087E320701800000F08404061087800001F8803C011087800000F81008140601000000F0C4522511878000010040100401004000006030000000000000000000003F00000001006030000000000000000020103E040200000000A8383E0E0A800000401004020202000000202020100401000000000000080200800000E8882A000E08838001184C10040D0640000020780A0E0A03C0800090487E121F8482400000000012090480000020000804020100000000000000000000000040607E3F0C0200000020187E3F03010000006030183F0F0300000060787E0",
	mem_init0 => X"C06030003F2057A9940A95027E3F20532BD40A95027E00020383E3F9DC6C00000607866330F03000000B0A4422200000000804070542A150000000198482421108780004020784A250900000000E088422111000000006040203E0000000000E088441F0000000100805832110700000000884824121F800000004070542A0E020000401078401E1007800001F8401008080FC0020100B064221100000001185010081800000003F88828080000000000804020100000000000E0887C220E00000010088442210F00000040F0804018020F800000F08038200F00000000F084421E1007800001008060281200C0020100F0443C1107000000D890481A0000000",
	data_interleave_offset_in_bits => 1,
	data_interleave_width_in_bits => 1,
	init_file => "ascii_char_rom.mif",
	init_file_layout => "port_a",
	logical_ram_name => "vga_font:vga|vrom:font_table|altsyncram:altsyncram_component|altsyncram_44s3:auto_generated|ALTSYNCRAM",
	operation_mode => "rom",
	port_a_address_clear => "none",
	port_a_address_width => 10,
	port_a_byte_enable_clock => "none",
	port_a_data_out_clear => "none",
	port_a_data_out_clock => "none",
	port_a_data_width => 9,
	port_a_first_address => 0,
	port_a_first_bit_number => 0,
	port_a_last_address => 1023,
	port_a_logical_ram_depth => 1024,
	port_a_logical_ram_width => 8,
	port_a_read_during_write_mode => "new_data_with_nbe_read",
	port_a_write_enable_clock => "none",
	port_b_address_width => 10,
	port_b_data_width => 9,
	ram_block_type => "M9K")
-- pragma translate_on
PORT MAP (
	portare => VCC,
	clk0 => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	portaaddr => \vga|font_table|altsyncram_component|auto_generated|ram_block1a0_PORTAADDR_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	portadataout => \vga|font_table|altsyncram_component|auto_generated|ram_block1a0_PORTADATAOUT_bus\);

-- Location: LCCOMB_X32_Y26_N8
\vga|X[1]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|X[1]~feeder_combout\ = \vga|Timing_Circuit:hcount[1]~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|Timing_Circuit:hcount[1]~q\,
	combout => \vga|X[1]~feeder_combout\);

-- Location: FF_X32_Y26_N9
\vga|X[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|X[1]~feeder_combout\,
	ena => \vga|X[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|X\(1));

-- Location: LCCOMB_X32_Y25_N20
\vga|FX1[1]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|FX1[1]~feeder_combout\ = \vga|X\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|X\(1),
	combout => \vga|FX1[1]~feeder_combout\);

-- Location: FF_X32_Y25_N21
\vga|FX1[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|FX1[1]~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|FX1\(1));

-- Location: FF_X32_Y25_N13
\vga|FX2[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	asdata => \vga|FX1\(1),
	sload => VCC,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|FX2\(1));

-- Location: LCCOMB_X32_Y25_N12
\vga|Mux0~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Mux0~0_combout\ = (\vga|FX2\(0) & (((\vga|FX2\(1))))) # (!\vga|FX2\(0) & ((\vga|FX2\(1) & ((\vga|font_table|altsyncram_component|auto_generated|q_a\(1)))) # (!\vga|FX2\(1) & (\vga|font_table|altsyncram_component|auto_generated|q_a\(3)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010010100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|FX2\(0),
	datab => \vga|font_table|altsyncram_component|auto_generated|q_a\(3),
	datac => \vga|FX2\(1),
	datad => \vga|font_table|altsyncram_component|auto_generated|q_a\(1),
	combout => \vga|Mux0~0_combout\);

-- Location: LCCOMB_X32_Y25_N8
\vga|Mux0~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Mux0~1_combout\ = (\vga|Mux0~0_combout\ & (((\vga|font_table|altsyncram_component|auto_generated|q_a\(0)) # (!\vga|FX2\(0))))) # (!\vga|Mux0~0_combout\ & (\vga|font_table|altsyncram_component|auto_generated|q_a\(2) & (\vga|FX2\(0))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110101001001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Mux0~0_combout\,
	datab => \vga|font_table|altsyncram_component|auto_generated|q_a\(2),
	datac => \vga|FX2\(0),
	datad => \vga|font_table|altsyncram_component|auto_generated|q_a\(0),
	combout => \vga|Mux0~1_combout\);

-- Location: LCCOMB_X32_Y25_N18
\vga|Mux0~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Mux0~2_combout\ = (\vga|FX2\(0) & (((\vga|font_table|altsyncram_component|auto_generated|q_a\(6)) # (\vga|FX2\(1))))) # (!\vga|FX2\(0) & (\vga|font_table|altsyncram_component|auto_generated|q_a\(7) & ((!\vga|FX2\(1)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|font_table|altsyncram_component|auto_generated|q_a\(7),
	datab => \vga|font_table|altsyncram_component|auto_generated|q_a\(6),
	datac => \vga|FX2\(0),
	datad => \vga|FX2\(1),
	combout => \vga|Mux0~2_combout\);

-- Location: LCCOMB_X32_Y25_N2
\vga|Mux0~3\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Mux0~3_combout\ = (\vga|Mux0~2_combout\ & ((\vga|font_table|altsyncram_component|auto_generated|q_a\(4)) # ((!\vga|FX2\(1))))) # (!\vga|Mux0~2_combout\ & (((\vga|FX2\(1) & \vga|font_table|altsyncram_component|auto_generated|q_a\(5)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011110010001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|font_table|altsyncram_component|auto_generated|q_a\(4),
	datab => \vga|Mux0~2_combout\,
	datac => \vga|FX2\(1),
	datad => \vga|font_table|altsyncram_component|auto_generated|q_a\(5),
	combout => \vga|Mux0~3_combout\);

-- Location: LCCOMB_X32_Y25_N30
\vga|Timing_Circuit~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Timing_Circuit~1_combout\ = (!\vga|Timing_Circuit~0_combout\ & !\vga|LessThan3~0_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \vga|Timing_Circuit~0_combout\,
	datad => \vga|LessThan3~0_combout\,
	combout => \vga|Timing_Circuit~1_combout\);

-- Location: FF_X32_Y25_N31
\vga|b1\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|Timing_Circuit~1_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|b1~q\);

-- Location: LCCOMB_X6_Y15_N4
\vga|b2~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|b2~feeder_combout\ = \vga|b1~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|b1~q\,
	combout => \vga|b2~feeder_combout\);

-- Location: FF_X6_Y15_N5
\vga|b2\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|b2~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|b2~q\);

-- Location: FF_X6_Y15_N13
\vga|blank\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	asdata => \vga|b2~q\,
	sload => VCC,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|blank~q\);

-- Location: LCCOMB_X32_Y25_N26
\vga|X[2]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|X[2]~feeder_combout\ = \vga|Timing_Circuit:hcount[2]~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \vga|Timing_Circuit:hcount[2]~q\,
	combout => \vga|X[2]~feeder_combout\);

-- Location: FF_X32_Y25_N27
\vga|X[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|X[2]~feeder_combout\,
	ena => \vga|X[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|X\(2));

-- Location: LCCOMB_X6_Y15_N16
\vga|FX1[2]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|FX1[2]~feeder_combout\ = \vga|X\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|X\(2),
	combout => \vga|FX1[2]~feeder_combout\);

-- Location: FF_X6_Y15_N17
\vga|FX1[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|FX1[2]~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|FX1\(2));

-- Location: LCCOMB_X6_Y15_N10
\vga|FX2[2]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|FX2[2]~feeder_combout\ = \vga|FX1\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|FX1\(2),
	combout => \vga|FX2[2]~feeder_combout\);

-- Location: FF_X6_Y15_N11
\vga|FX2[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|FX2[2]~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|FX2\(2));

-- Location: LCCOMB_X6_Y15_N12
\vga|r~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|r~0_combout\ = (\vga|blank~q\ & ((\vga|FX2\(2) & (\vga|Mux0~1_combout\)) # (!\vga|FX2\(2) & ((\vga|Mux0~3_combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Mux0~1_combout\,
	datab => \vga|Mux0~3_combout\,
	datac => \vga|blank~q\,
	datad => \vga|FX2\(2),
	combout => \vga|r~0_combout\);

-- Location: LCCOMB_X6_Y15_N0
\vga|r[0]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|r[0]~feeder_combout\ = \vga|r~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|r~0_combout\,
	combout => \vga|r[0]~feeder_combout\);

-- Location: FF_X6_Y15_N1
\vga|r[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|r[0]~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|r\(0));

-- Location: LCCOMB_X6_Y15_N24
\vga|r[1]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|r[1]~feeder_combout\ = \vga|r~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|r~0_combout\,
	combout => \vga|r[1]~feeder_combout\);

-- Location: FF_X6_Y15_N25
\vga|r[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|r[1]~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|r\(1));

-- Location: LCCOMB_X6_Y15_N30
\vga|r[2]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|r[2]~feeder_combout\ = \vga|r~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|r~0_combout\,
	combout => \vga|r[2]~feeder_combout\);

-- Location: FF_X6_Y15_N31
\vga|r[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|r[2]~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|r\(2));

-- Location: LCCOMB_X6_Y15_N2
\vga|r[3]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|r[3]~feeder_combout\ = \vga|r~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|r~0_combout\,
	combout => \vga|r[3]~feeder_combout\);

-- Location: FF_X6_Y15_N3
\vga|r[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|r[3]~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|r\(3));

-- Location: LCCOMB_X6_Y15_N18
\vga|g[0]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|g[0]~feeder_combout\ = \vga|r~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|r~0_combout\,
	combout => \vga|g[0]~feeder_combout\);

-- Location: FF_X6_Y15_N19
\vga|g[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|g[0]~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|g\(0));

-- Location: LCCOMB_X6_Y15_N28
\vga|g[1]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|g[1]~feeder_combout\ = \vga|r~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|r~0_combout\,
	combout => \vga|g[1]~feeder_combout\);

-- Location: FF_X6_Y15_N29
\vga|g[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|g[1]~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|g\(1));

-- Location: LCCOMB_X6_Y15_N20
\vga|g[2]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|g[2]~feeder_combout\ = \vga|r~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|r~0_combout\,
	combout => \vga|g[2]~feeder_combout\);

-- Location: FF_X6_Y15_N21
\vga|g[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|g[2]~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|g\(2));

-- Location: LCCOMB_X6_Y15_N26
\vga|g[3]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|g[3]~feeder_combout\ = \vga|r~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|r~0_combout\,
	combout => \vga|g[3]~feeder_combout\);

-- Location: FF_X6_Y15_N27
\vga|g[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|g[3]~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|g\(3));

-- Location: LCCOMB_X6_Y15_N8
\vga|b[0]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|b[0]~feeder_combout\ = \vga|r~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|r~0_combout\,
	combout => \vga|b[0]~feeder_combout\);

-- Location: FF_X6_Y15_N9
\vga|b[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|b[0]~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|b\(0));

-- Location: LCCOMB_X6_Y15_N6
\vga|b[1]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|b[1]~feeder_combout\ = \vga|r~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|r~0_combout\,
	combout => \vga|b[1]~feeder_combout\);

-- Location: FF_X6_Y15_N7
\vga|b[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|b[1]~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|b\(1));

-- Location: LCCOMB_X6_Y15_N22
\vga|b[2]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|b[2]~feeder_combout\ = \vga|r~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|r~0_combout\,
	combout => \vga|b[2]~feeder_combout\);

-- Location: FF_X6_Y15_N23
\vga|b[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|b[2]~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|b\(2));

-- Location: LCCOMB_X6_Y15_N14
\vga|b[3]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|b[3]~feeder_combout\ = \vga|r~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|r~0_combout\,
	combout => \vga|b[3]~feeder_combout\);

-- Location: FF_X6_Y15_N15
\vga|b[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|b[3]~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|b\(3));

-- Location: LCCOMB_X31_Y26_N30
\vga|Equal2~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Equal2~1_combout\ = (\vga|Add1~14_combout\ & \vga|Add1~8_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Add1~14_combout\,
	datac => \vga|Add1~8_combout\,
	combout => \vga|Equal2~1_combout\);

-- Location: LCCOMB_X32_Y26_N2
\vga|Equal2~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Equal2~0_combout\ = (!\vga|Add1~4_combout\ & (!\vga|Add1~2_combout\ & (!\vga|Add1~0_combout\ & !\vga|Add1~6_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Add1~4_combout\,
	datab => \vga|Add1~2_combout\,
	datac => \vga|Add1~0_combout\,
	datad => \vga|Add1~6_combout\,
	combout => \vga|Equal2~0_combout\);

-- Location: LCCOMB_X30_Y26_N26
\vga|Equal2~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Equal2~2_combout\ = (\vga|Equal2~1_combout\ & (!\vga|hcount~2_combout\ & (\vga|Equal2~0_combout\ & \vga|hcount~1_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Equal2~1_combout\,
	datab => \vga|hcount~2_combout\,
	datac => \vga|Equal2~0_combout\,
	datad => \vga|hcount~1_combout\,
	combout => \vga|Equal2~2_combout\);

-- Location: LCCOMB_X30_Y26_N28
\vga|hs1~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|hs1~0_combout\ = (\vga|Equal2~2_combout\ & ((\vga|Add1~12_combout\ & ((\vga|hs1~q\) # (\vga|hcount~0_combout\))) # (!\vga|Add1~12_combout\ & (\vga|hs1~q\ & \vga|hcount~0_combout\)))) # (!\vga|Equal2~2_combout\ & (((\vga|hs1~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100011010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Equal2~2_combout\,
	datab => \vga|Add1~12_combout\,
	datac => \vga|hs1~q\,
	datad => \vga|hcount~0_combout\,
	combout => \vga|hs1~0_combout\);

-- Location: FF_X30_Y26_N29
\vga|hs1\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|hs1~0_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|hs1~q\);

-- Location: LCCOMB_X30_Y26_N16
\vga|hs2~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|hs2~feeder_combout\ = \vga|hs1~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|hs1~q\,
	combout => \vga|hs2~feeder_combout\);

-- Location: FF_X30_Y26_N17
\vga|hs2\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|hs2~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|hs2~q\);

-- Location: LCCOMB_X30_Y26_N12
\vga|hs3~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|hs3~feeder_combout\ = \vga|hs2~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|hs2~q\,
	combout => \vga|hs3~feeder_combout\);

-- Location: FF_X30_Y26_N13
\vga|hs3\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|hs3~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|hs3~q\);

-- Location: LCCOMB_X30_Y26_N8
\vga|vga_hs~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|vga_hs~0_combout\ = !\vga|hs3~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|hs3~q\,
	combout => \vga|vga_hs~0_combout\);

-- Location: FF_X30_Y26_N9
\vga|vga_hs\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|vga_hs~0_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|vga_hs~q\);

-- Location: LCCOMB_X31_Y25_N18
\vga|Equal4~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Equal4~0_combout\ = (\vga|Equal0~2_combout\ & (!\vga|Equal1~2_combout\)) # (!\vga|Equal0~2_combout\ & (((\vga|Timing_Circuit:vcount[3]~q\ & !\vga|Timing_Circuit:vcount[9]~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101000001011100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Equal1~2_combout\,
	datab => \vga|Timing_Circuit:vcount[3]~q\,
	datac => \vga|Equal0~2_combout\,
	datad => \vga|Timing_Circuit:vcount[9]~q\,
	combout => \vga|Equal4~0_combout\);

-- Location: LCCOMB_X31_Y25_N12
\vga|Equal4~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Equal4~1_combout\ = (\vga|Equal4~0_combout\ & (((\vga|Add0~6_combout\ & !\vga|Add0~18_combout\)) # (!\vga|Equal0~2_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000101010001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Equal4~0_combout\,
	datab => \vga|Add0~6_combout\,
	datac => \vga|Equal0~2_combout\,
	datad => \vga|Add0~18_combout\,
	combout => \vga|Equal4~1_combout\);

-- Location: LCCOMB_X31_Y25_N8
\vga|Equal4~3\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Equal4~3_combout\ = (\vga|vcount~2_combout\ & (!\vga|vcount~4_combout\ & \vga|vcount~3_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|vcount~2_combout\,
	datab => \vga|vcount~4_combout\,
	datad => \vga|vcount~3_combout\,
	combout => \vga|Equal4~3_combout\);

-- Location: LCCOMB_X31_Y25_N22
\vga|Equal4~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Equal4~2_combout\ = (\vga|vcount~1_combout\ & ((\vga|Equal0~2_combout\ & (\vga|Add0~14_combout\)) # (!\vga|Equal0~2_combout\ & ((\vga|Timing_Circuit:vcount[7]~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Add0~14_combout\,
	datab => \vga|Timing_Circuit:vcount[7]~q\,
	datac => \vga|Equal0~2_combout\,
	datad => \vga|vcount~1_combout\,
	combout => \vga|Equal4~2_combout\);

-- Location: LCCOMB_X31_Y25_N2
\vga|Equal4~4\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|Equal4~4_combout\ = (\vga|Equal4~1_combout\ & (\vga|Equal4~3_combout\ & (\vga|Equal4~2_combout\ & !\vga|vcount~5_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|Equal4~1_combout\,
	datab => \vga|Equal4~3_combout\,
	datac => \vga|Equal4~2_combout\,
	datad => \vga|vcount~5_combout\,
	combout => \vga|Equal4~4_combout\);

-- Location: LCCOMB_X31_Y25_N0
\vga|vs1~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|vs1~0_combout\ = (\vga|vcount~6_combout\ & (\vga|vs1~q\ & ((\vga|vcount~0_combout\) # (!\vga|Equal4~4_combout\)))) # (!\vga|vcount~6_combout\ & ((\vga|vs1~q\) # ((\vga|vcount~0_combout\ & \vga|Equal4~4_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101010011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga|vcount~6_combout\,
	datab => \vga|vcount~0_combout\,
	datac => \vga|vs1~q\,
	datad => \vga|Equal4~4_combout\,
	combout => \vga|vs1~0_combout\);

-- Location: FF_X31_Y25_N1
\vga|vs1\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|vs1~0_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|vs1~q\);

-- Location: LCCOMB_X30_Y26_N10
\vga|vs2~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|vs2~feeder_combout\ = \vga|vs1~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \vga|vs1~q\,
	combout => \vga|vs2~feeder_combout\);

-- Location: FF_X30_Y26_N11
\vga|vs2\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|vs2~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|vs2~q\);

-- Location: LCCOMB_X30_Y26_N6
\vga|vs3~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|vs3~feeder_combout\ = \vga|vs2~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|vs2~q\,
	combout => \vga|vs3~feeder_combout\);

-- Location: FF_X30_Y26_N7
\vga|vs3\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|vs3~feeder_combout\,
	ena => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|vs3~q\);

-- Location: LCCOMB_X30_Y26_N18
\vga|vga_vs~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \vga|vga_vs~0_combout\ = !\vga|vs3~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \vga|vs3~q\,
	combout => \vga|vga_vs~0_combout\);

-- Location: FF_X30_Y26_N19
\vga|vga_vs\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \vga|pll|altpll_component|auto_generated|wire_pll1_clk[0]~clkctrl_outclk\,
	d => \vga|vga_vs~0_combout\,
	clrn => \KEY[0]~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga|vga_vs~q\);

-- Location: IOIBUF_X49_Y54_N29
\KEY[1]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_KEY(1),
	o => \KEY[1]~input_o\);

-- Location: UNVM_X0_Y40_N40
\~QUARTUS_CREATED_UNVM~\ : fiftyfivenm_unvm
-- pragma translate_off
GENERIC MAP (
	addr_range1_end_addr => -1,
	addr_range1_offset => -1,
	addr_range2_end_addr => -1,
	addr_range2_offset => -1,
	addr_range3_offset => -1,
	is_compressed_image => "false",
	is_dual_boot => "false",
	is_eram_skip => "false",
	max_ufm_valid_addr => -1,
	max_valid_addr => -1,
	min_ufm_valid_addr => -1,
	min_valid_addr => -1,
	part_name => "quartus_created_unvm",
	reserve_block => "true")
-- pragma translate_on
PORT MAP (
	nosc_ena => \~GND~combout\,
	xe_ye => \~GND~combout\,
	se => \~GND~combout\,
	busy => \~QUARTUS_CREATED_UNVM~~busy\);

-- Location: ADCBLOCK_X43_Y52_N0
\~QUARTUS_CREATED_ADC1~\ : fiftyfivenm_adcblock
-- pragma translate_off
GENERIC MAP (
	analog_input_pin_mask => 0,
	clkdiv => 1,
	device_partname_fivechar_prefix => "none",
	is_this_first_or_second_adc => 1,
	prescalar => 0,
	pwd => 1,
	refsel => 0,
	reserve_block => "true",
	testbits => 66,
	tsclkdiv => 1,
	tsclksel => 0)
-- pragma translate_on
PORT MAP (
	soc => \~GND~combout\,
	usr_pwd => VCC,
	tsen => \~GND~combout\,
	chsel => \~QUARTUS_CREATED_ADC1~_CHSEL_bus\,
	eoc => \~QUARTUS_CREATED_ADC1~~eoc\);

-- Location: ADCBLOCK_X43_Y51_N0
\~QUARTUS_CREATED_ADC2~\ : fiftyfivenm_adcblock
-- pragma translate_off
GENERIC MAP (
	analog_input_pin_mask => 0,
	clkdiv => 1,
	device_partname_fivechar_prefix => "none",
	is_this_first_or_second_adc => 2,
	prescalar => 0,
	pwd => 1,
	refsel => 0,
	reserve_block => "true",
	testbits => 66,
	tsclkdiv => 1,
	tsclksel => 0)
-- pragma translate_on
PORT MAP (
	soc => \~GND~combout\,
	usr_pwd => VCC,
	tsen => \~GND~combout\,
	chsel => \~QUARTUS_CREATED_ADC2~_CHSEL_bus\,
	eoc => \~QUARTUS_CREATED_ADC2~~eoc\);
END structure;


