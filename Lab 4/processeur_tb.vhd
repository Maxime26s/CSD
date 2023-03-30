LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.processeur_constants.ALL;

ENTITY processeur_tb IS
END processeur_tb;

ARCHITECTURE test OF processeur_tb IS
	SIGNAL run, clk, rst : STD_LOGIC;
	SIGNAL din : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL buswire : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL done : STD_LOGIC;
BEGIN
	DUT : processeur PORT MAP(run, clk, rst, din, buswire, done);

	PROCESS
	BEGIN
		REPORT "Testbench starting...";
		run <= '1';
		rst <= '0';
		clk <= '0';
		din <= "000000000";
		WAIT FOR 10 ns;
		rst <= '1';
		clk <= '1';
		WAIT FOR 10 ns;
		rst <= '0';
		clk <= '0';
		WAIT FOR 10 ns;
		-- mvi
		din <= "001001001";
		WAIT FOR 5 ns;
		clk <= '1';
		WAIT FOR 10 ns;
		clk <= '0';
		WAIT FOR 10 ns;
		clk <= '1';
		WAIT FOR 10 ns;
		clk <= '0';
		WAIT FOR 10 ns;
		-- mv
		din <= "000000001";
		WAIT FOR 5 ns;
		clk <= '1';
		WAIT FOR 10 ns;
		clk <= '0';
		WAIT FOR 10 ns;
		clk <= '1';
		WAIT FOR 10 ns;
		clk <= '0';
		WAIT FOR 10 ns;
		-- add
		din <= "010000001";
		WAIT FOR 5 ns;
		clk <= '1';
		WAIT FOR 10 ns;
		clk <= '0';
		WAIT FOR 10 ns;
		clk <= '1';
		WAIT FOR 10 ns;
		clk <= '0';
		WAIT FOR 10 ns;
		clk <= '1';
		WAIT FOR 10 ns;
		clk <= '0';
		WAIT FOR 10 ns;
		clk <= '1';
		WAIT FOR 10 ns;
		clk <= '0';
		WAIT FOR 10 ns;
		-- sub
		din <= "011000001";
		WAIT FOR 5 ns;
		clk <= '1';
		WAIT FOR 10 ns;
		clk <= '0';
		WAIT FOR 10 ns;
		clk <= '1';
		WAIT FOR 10 ns;
		clk <= '0';
		WAIT FOR 10 ns;
		clk <= '1';
		WAIT FOR 10 ns;
		clk <= '0';
		WAIT FOR 10 ns;
		clk <= '1';
		WAIT FOR 10 ns;
		clk <= '0';
		WAIT FOR 10 ns;
		WAIT;
	END PROCESS;
END ARCHITECTURE test;