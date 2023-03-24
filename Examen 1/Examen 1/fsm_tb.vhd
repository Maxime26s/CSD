LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
USE work.q3.all;

entity fsm_tb is
end fsm_tb;

architecture test of fsm_tb is
	signal w, clk, rst, z	: std_logic;
	signal state : STD_LOGIC_VECTOR(4 DOWNTO 0);
begin
	DUT: fsm port map(w, clk, rst, z, state);
	
	-- test la suite suivante: w = [0,0,0,1,1,1,0,1,1]
	-- affiche l'état de clock, la valeur d'entrée W, la valeur de sortie Z et l'état actuel (format ABCDE)
	
	process begin
		report "Testbench starting...";
		
		w <= '0';
		clk <= '0';
		rst <= '0';
		wait for 10 ns;
		rst <= '1';
		wait for 10 ns;
		report "clk = " & to_string(clk) & "; w = " & to_string(w) & "; z = " & to_string(z) & "; state = " & to_string(state) & ";";
		rst <= '0';
		wait for 10 ns;
		w <= '0';
		clk <= '1';
		wait for 10 ns;
		report "clk = " & to_string(clk) & "; w = " & to_string(w) & "; z = " & to_string(z) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		w <= '0';
		clk <= '1';
		wait for 10 ns;
		report "clk = " & to_string(clk) & "; w = " & to_string(w) & "; z = " & to_string(z) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		w <= '0';
		clk <= '1';
		wait for 10 ns;
		report "clk = " & to_string(clk) & "; w = " & to_string(w) & "; z = " & to_string(z) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		w <= '1';
		clk <= '1';
		wait for 10 ns;
		report "clk = " & to_string(clk) & "; w = " & to_string(w) & "; z = " & to_string(z) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		w <= '1';
		clk <= '1';
		wait for 10 ns;
		report "clk = " & to_string(clk) & "; w = " & to_string(w) & "; z = " & to_string(z) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		w <= '1';
		clk <= '1';
		wait for 10 ns;
		report "clk = " & to_string(clk) & "; w = " & to_string(w) & "; z = " & to_string(z) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		w <= '0';
		clk <= '1';
		wait for 10 ns;
		report "clk = " & to_string(clk) & "; w = " & to_string(w) & "; z = " & to_string(z) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		w <= '1';
		clk <= '1';
		wait for 10 ns;
		report "clk = " & to_string(clk) & "; w = " & to_string(w) & "; z = " & to_string(z) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		w <= '1';
		clk <= '1';
		wait for 10 ns;
		report "clk = " & to_string(clk) & "; w = " & to_string(w) & "; z = " & to_string(z) & "; state = " & to_string(state) & ";";
		
		wait;
	end process;
end architecture test;