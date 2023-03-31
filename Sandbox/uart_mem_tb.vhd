LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
use work.uart_mem_constants.all;

entity uart_mem_tb is
end uart_mem_tb;

architecture test of uart_mem_tb is
			signal uart_buffer : STD_LOGIC_VECTOR(7 DOWNTO 0);
			signal rst : std_logic;
			signal din : std_logic_vector(8 downto 0);
begin
	DUT: uart_mem port map(uart_buffer, rst, din);
	process begin
		report "Testbench starting...";
		
		rst <= '0';
		uart_buffer <= "00000000";
		wait for 10 ns;
		uart_buffer <= "00110001";
		wait for 10 ns;
		uart_buffer <= "00110010";
		wait for 10 ns;
		uart_buffer <= "00110011";
		wait for 10 ns;
		uart_buffer <= "00110100";
		wait for 10 ns;
		wait;
	end process;
end architecture test;