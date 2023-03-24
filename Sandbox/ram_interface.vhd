LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.sseg_constants.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.ram32x4;

ENTITY ram_interface IS
	PORT (
		SW : in std_logic_vector(9 downto 0);
		KEY : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		CLOCK_50 : in std_logic;
		HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out std_logic_vector(6 downto 0)
	);
END ram_interface;

ARCHITECTURE arch OF ram_interface IS
	signal clk, rst : std_logic;
	signal address : std_logic_vector(4 downto 0);
	signal data_in, data_out : std_logic_vector(3 downto 0);
	signal w : std_logic;
BEGIN
	d_key0 : entity work.debounce port map(CLOCK_50, KEY(0), clk);
	
	address <= SW(4 downto 0);
	data_in <= SW(8 downto 5);
	w <= SW(9);
	
	--ram0: ram32x4 PORT MAP (address, clk, data_in, w, data_out);
	
	sseg0 : sseg port map(data_out, HEX0);
	sseg1 : sseg port map("0000", HEX1);
	sseg2 : sseg port map(data_in, HEX2);
	sseg3 : sseg port map("0000", HEX3);
	sseg4 : sseg port map(address(3 downto 0), HEX4);
	sseg5 : sseg port map("000" & address(4), HEX5);
END arch;