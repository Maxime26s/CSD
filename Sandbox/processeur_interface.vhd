LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.sseg_constants.all;
use work.processeur_constants.all;
use work.ff.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY processeur_interface IS
	PORT (
		SW : in std_logic_vector(9 downto 0);
		KEY : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		CLOCK_50 : in std_logic;
		LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out std_logic_vector(6 downto 0)
	);
END processeur_interface;

ARCHITECTURE arch OF processeur_interface IS
	signal clk, rst : std_logic;
	signal buswire : std_logic_vector(8 downto 0);
	signal done : std_logic;
BEGIN
	d_key0 : entity work.debounce port map(CLOCK_50, KEY(0), clk);
	d_key1 : entity work.debounce port map(CLOCK_50, KEY(1), rst);
	
	processeur0: processeur PORT MAP (SW(0), clk, rst, SW(9 downto 1), buswire, done);
	
	LEDR <= buswire & done;
	
	sseg0 : sseg port map(buswire(3 downto 0), HEX0);
	sseg1 : sseg port map(buswire(7 downto 4), HEX1);
	sseg2 : sseg port map("000" & buswire(8), HEX2);
	sseg3 : sseg port map("0" & SW(3 downto 1), HEX3);
	sseg4 : sseg port map("0" & SW(6 downto 4), HEX4);
	sseg5 : sseg port map("0" & SW(9 downto 7), HEX5);
END arch;