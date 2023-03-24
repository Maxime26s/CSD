LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
use work.fsm_constants.all;

entity fsm_tb is
end fsm_tb;

architecture test of fsm_tb is
	signal i : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal xReg, yReg : std_logic_vector(7 downto 0);
	signal run, clk, rst : std_logic;
	signal inControl : std_logic_vector(10 downto 0);
	signal outControl : std_logic_vector(9 downto 0);
	signal state : State_type;
begin
	DUT: fsm port map(i, xReg, yReg, run, clk, rst, inControl, outControl, state);
	process begin
		report "Testbench starting...";
		
		run <= '1';
		i <= "010";
		xReg <= "00000000";
		yReg <= "00000001";
		clk <= '0';
		rst <= '0';
		wait for 10 ns;
		rst <= '1';
		clk <= '1';
		wait for 10 ns;
		--report "run = " & to_string(run) & ";clk = " & to_string(clk) & "; rst = " & to_string(rst) & "; i = " & to_string(i) & "; xReg = " & to_string(xReg) & "; yReg = " & to_string(yReg) & ";";
		rst <= '0';
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		--report "clk = " & to_string(clk) & "; rst = " & to_string(rst) & "; w = " & to_string(w) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		--report "clk = " & to_string(clk) & "; rst = " & to_string(rst) & "; w = " & to_string(w) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		--report "clk = " & to_string(clk) & "; rst = " & to_string(rst) & "; w = " & to_string(w) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		--report "clk = " & to_string(clk) & "; rst = " & to_string(rst) & "; w = " & to_string(w) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		--report "clk = " & to_string(clk) & "; rst = " & to_string(rst) & "; w = " & to_string(w) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		--report "clk = " & to_string(clk) & "; rst = " & to_string(rst) & "; w = " & to_string(w) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		--report "clk = " & to_string(clk) & "; rst = " & to_string(rst) & "; w = " & to_string(w) & "; state = " & to_string(state) & ";";
		clk <= '0';
		wait for 10 ns;
		rst <= '1';
		clk <= '1';
		wait for 10 ns;
		--report "clk = " & to_string(clk) & "; rst = " & to_string(rst) & "; w = " & to_string(w) & "; state = " & to_string(state) & ";";
		rst <= '0';
		
		wait;
	end process;
end architecture test;