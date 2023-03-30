LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.sseg_constants.ALL;
USE work.processeur_constants.ALL;
USE work.ff.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY processeur_interface IS
	PORT (
		SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		KEY : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		CLOCK_50 : IN STD_LOGIC;
		LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END processeur_interface;

ARCHITECTURE arch OF processeur_interface IS
	SIGNAL clk, rst : STD_LOGIC;
	SIGNAL buswire : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL done : STD_LOGIC;
BEGIN
	d_key0 : ENTITY work.debounce PORT MAP(CLOCK_50, KEY(0), clk);
	d_key1 : ENTITY work.debounce PORT MAP(CLOCK_50, KEY(1), rst);

	processeur0 : processeur PORT MAP(SW(0), clk, rst, SW(9 DOWNTO 1), buswire, done);

	LEDR <= buswire & done;

	sseg0 : sseg PORT MAP(buswire(3 DOWNTO 0), HEX0);
	sseg1 : sseg PORT MAP(buswire(7 DOWNTO 4), HEX1);
	sseg2 : sseg PORT MAP("000" & buswire(8), HEX2);
	sseg3 : sseg PORT MAP("0" & SW(3 DOWNTO 1), HEX3);
	sseg4 : sseg PORT MAP("0" & SW(6 DOWNTO 4), HEX4);
	sseg5 : sseg PORT MAP("0" & SW(9 DOWNTO 7), HEX5);

END arch;