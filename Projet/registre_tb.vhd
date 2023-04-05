LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
use work.registre_constants.all;

entity registre_tb is
end registre_tb;

architecture test of registre_tb is
	signal rin : std_logic_vector(8 downto 0);
	signal clk, activated : std_logic;
	signal rout : std_logic_vector(8 downto 0);
begin
	DUT: registre port map(rin, clk, activated, rout);
	process begin
		report "Testbench starting...";
		
		rin <= 9d"0";
		clk <= '0';
		activated <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		-- test sans activated
		rin <= 9d"3";
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		-- test avec activated
		activated <= '1';
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait;
	end process;
end architecture test;