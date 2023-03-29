-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "02/03/2020 19:06:42"
                                                            
-- Vhdl Test Bench template for design  :  VGA_green
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY VGA_green_tb IS
END VGA_green_tb;
ARCHITECTURE VGA_green_arch OF VGA_green_tb IS
-- constants                                                 
-- signals                                                   
SIGNAL CLOCK_50 : STD_LOGIC;
SIGNAL KEY : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL SW : STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL VGA_B : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL VGA_BLANK_N : STD_LOGIC;
SIGNAL VGA_CLK : STD_LOGIC;
SIGNAL VGA_G : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL VGA_HS : STD_LOGIC;
SIGNAL VGA_R : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL VGA_VS : STD_LOGIC;
COMPONENT VGA_green
	PORT (
	CLOCK_50 : IN STD_LOGIC;
	KEY : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
	VGA_B : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	VGA_BLANK_N : OUT STD_LOGIC;
	VGA_CLK : INOUT STD_LOGIC;
	VGA_G : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	VGA_HS : OUT STD_LOGIC;
	VGA_R : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	VGA_VS : OUT STD_LOGIC
	);
END COMPONENT;

CONSTANT clock_period : TIME := 20 ns;

BEGIN
	i1 : VGA_green
	PORT MAP (
-- list connections between master ports and signals
	CLOCK_50 => CLOCK_50,
	KEY => KEY,
	SW => SW,
	VGA_B => VGA_B,
	VGA_BLANK_N => VGA_BLANK_N,
	VGA_CLK => VGA_CLK,
	VGA_G => VGA_G,
	VGA_HS => VGA_HS,
	VGA_R => VGA_R,
	VGA_VS => VGA_VS
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        KEY(0) <= '0';
		  wait for 20 ns;
        KEY(0) <= '1';
		  wait for 20 ns;
			
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                                                               
BEGIN                                                         
        CLOCK_50 <= '0';
        WAIT FOR 10 ns;
        CLOCK_50 <= '1';
        WAIT FOR 10 ns;
		  
END PROCESS always;                                          
END VGA_green_arch;
