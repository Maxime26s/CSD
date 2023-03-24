LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
USE work.lab1_2.all;

entity partie2_tb is
end partie2_tb;

architecture test of partie2_tb is
	signal SW : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal position : STD_LOGIC_VECTOR(2 DOWNTO 0);
begin
	DUT: partie2 port map(SW, position);
	process begin
		report "Testbench starting...";
		for i in 0 to 255 loop
			SW <= std_logic_vector(to_unsigned(i, SW'length));
			wait for 10 ns;
			report "SW = " & to_string(SW) & "; position = " & to_string(position);
		end loop;
		wait;
	end process;
end architecture test;