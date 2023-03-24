LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
USE work.state_machine_constants.all;

entity state_machine_tb is
end state_machine_tb;

architecture test of state_machine_tb is
	signal w, clk, rst	: std_logic;
	signal state : STD_LOGIC_VECTOR(8 DOWNTO 0);
begin
	DUT: state_machine port map(w, clk, rst, state);
	process begin
		report "Testbench starting...";
		
		w <= '0';
		clk <= '0';
		rst <= '0';
		wait for 10 ns;
		rst <= '1';
		wait for 10 ns;
		report "clk = " & to_string(clk) & "; rst = " & to_string(rst) & "; w = " & to_string(w) & "; state = " & to_string(state) & ";";
		rst <= '0';
		wait for 10 ns;
		w <= '1';
		clk <= '1';
		wait for 10 ns;
		report "clk = " & to_string(clk) & "; rst = " & to_string(rst) & "; w = " & to_string(w) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		w <= '1';
		clk <= '1';
		wait for 10 ns;
		report "clk = " & to_string(clk) & "; rst = " & to_string(rst) & "; w = " & to_string(w) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		w <= '0';
		clk <= '1';
		wait for 10 ns;
		report "clk = " & to_string(clk) & "; rst = " & to_string(rst) & "; w = " & to_string(w) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		w <= '0';
		clk <= '1';
		wait for 10 ns;
		report "clk = " & to_string(clk) & "; rst = " & to_string(rst) & "; w = " & to_string(w) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		w <= '0';
		clk <= '1';
		wait for 10 ns;
		report "clk = " & to_string(clk) & "; rst = " & to_string(rst) & "; w = " & to_string(w) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		w <= '0';
		clk <= '1';
		wait for 10 ns;
		report "clk = " & to_string(clk) & "; rst = " & to_string(rst) & "; w = " & to_string(w) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		w <= '0';
		clk <= '1';
		wait for 10 ns;
		report "clk = " & to_string(clk) & "; rst = " & to_string(rst) & "; w = " & to_string(w) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		rst <= '1';
		wait for 10 ns;
		report "clk = " & to_string(clk) & "; rst = " & to_string(rst) & "; w = " & to_string(w) & "; state = " & to_string(state) & ";";
		rst <= '0';
		
		wait;
	end process;
end architecture test;