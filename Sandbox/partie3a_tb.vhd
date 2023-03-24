LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
USE work.lab1_3a.all;

entity partie3a_tb is
end partie3a_tb;

architecture test of partie3a_tb is
	signal SW : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal HEX0 : STD_LOGIC_VECTOR(6 DOWNTO 0);
begin
	DUT: partie3a port map(SW, HEX0);
	process begin
		report "Testbench starting...";
		for i in 0 to 255 loop
			SW <= std_logic_vector(to_unsigned(i, SW'length));
			wait for 10 ns;
			report "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0);
		end loop;
		wait;
	end process;
end architecture test;