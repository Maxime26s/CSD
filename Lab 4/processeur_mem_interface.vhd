LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.sseg_constants.ALL;
USE work.processeur_constants.ALL;
USE work.ff.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.inst_mem;
USE work.registre_constants.ALL;

ENTITY processeur_mem_interface IS
	PORT (
		SW : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		KEY : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		CLOCK_50 : IN STD_LOGIC;
		LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END processeur_mem_interface;

ARCHITECTURE arch OF processeur_mem_interface IS
	SIGNAL clk, rst : STD_LOGIC := '0';
	SIGNAL buswire, din : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL done : STD_LOGIC;
	SIGNAL address, nextAddress : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000";
BEGIN
	d_key0 : ENTITY work.debounce PORT MAP(CLOCK_50, KEY(0), clk);
	d_key1 : ENTITY work.debounce PORT MAP(CLOCK_50, KEY(1), rst);

	processeur0 : processeur PORT MAP(SW(0), clk, rst, din, buswire, done);

	LEDR <= "000000000" & done;

	sseg0 : sseg PORT MAP(buswire(3 DOWNTO 0), HEX0);
	sseg1 : sseg PORT MAP(buswire(7 DOWNTO 4), HEX1);
	sseg2 : sseg PORT MAP("000" & buswire(8), HEX2);
	sseg3 : sseg PORT MAP("0" & din(2 DOWNTO 0), HEX3);
	sseg4 : sseg PORT MAP("0" & din(5 DOWNTO 3), HEX4);
	sseg5 : sseg PORT MAP("0" & din(8 DOWNTO 6), HEX5);

	nextAddress <= address + "00001";
	counter : registre GENERIC MAP(5) PORT MAP(nextAddress, clk, done, address);
	mem : inst_mem PORT MAP(address, clk, din);
END arch;