LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.registre_constants.ALL;

ENTITY registre_tb IS
END registre_tb;

ARCHITECTURE test OF registre_tb IS
	SIGNAL rin : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL clk, activated : STD_LOGIC;
	SIGNAL rout : STD_LOGIC_VECTOR(8 DOWNTO 0);
BEGIN
	DUT : registre PORT MAP(rin, clk, activated, rout);
	PROCESS BEGIN
		REPORT "Testbench starting...";

		rin <= 9d"0";
		clk <= '0';
		activated <= '0';
		WAIT FOR 10 ns;
		clk <= '1';
		WAIT FOR 10 ns;
		clk <= '0';
		WAIT FOR 10 ns;
		-- test sans activated
		rin <= 9d"3";
		clk <= '1';
		WAIT FOR 10 ns;
		clk <= '0';
		WAIT FOR 10 ns;
		-- test avec activated
		activated <= '1';
		clk <= '1';
		WAIT FOR 10 ns;
		clk <= '0';
		WAIT;
	END PROCESS;
END ARCHITECTURE test;