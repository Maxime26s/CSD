-- Copyright (C) Tor M. Aamodt, UBC
-- synthesis VHDL_INPUT_VERSION VHDL_2008
-- Ensure your CAD synthesis tool/compiler is configured for VHDL-2008.

library ieee;
use ieee.std_logic_1164.all;
use work.ch18.all;
use work.sseg_constants.all;

entity de2_wrapper is
  port( sw : in std_logic_vector(17 downto 0);
        key : in std_logic_vector(3 downto 0);
        clock_50 : in std_logic;
        ledg : out std_logic_vector(7 downto 0);
        ledr : out std_logic_vector(17 downto 0);
        hex0 : out std_logic_vector(6 downto 0);
        hex1 : out std_logic_vector(6 downto 0);
        hex2 : out std_logic_vector(6 downto 0);
        hex3 : out std_logic_vector(6 downto 0);
        hex4 : out std_logic_vector(6 downto 0);
        hex5 : out std_logic_vector(6 downto 0);
        hex6 : out std_logic_vector(6 downto 0);
        hex7 : out std_logic_vector(6 downto 0) );
end de2_wrapper;

architecture test_ucode2 of de2_wrapper is
  signal clk, rst: std_logic;
  signal input: std_logic_vector(1 downto 0); 
  signal output: std_logic_vector(8 downto 0); 
begin
  fsm: ucode2 generic map(p=>"ucode2_2.mif") port map(clk,rst,input,output);

  input <= sw(1 downto 0);
  ledr(8 downto 0) <= output;
  rst <= not key(1);
  clk <= not key(0);
  ledg(0) <= clk;
  ledg(1) <= rst;

  --H0: sseg port map( <<fsm.upc:std_logic_vector>>, hex0 );
  
end test_ucode2; 
