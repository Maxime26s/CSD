LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
USE work.lab1_3b.all;

entity partie3b_tb is
end partie3b_tb;

architecture test of partie3b_tb is
    signal SW   : std_logic_vector (8 downto 0);
    signal LEDR : std_logic_vector (3 downto 0);
begin
	DUT: partie3b port map(SW, LEDR);
	process begin
		report "Testbench starting...";
		for i in 0 to 511 loop
			SW <= std_logic_vector(to_unsigned(i, SW'length));
			wait for 10 ns;
			if SW(8) = '0' then
				if LEDR /= SW(7 downto 4) then
					report "SW = " & to_string(SW) & "; LEDR = " & to_string(LEDR);
				end if;
			elsif SW(8) = '1' then
				if LEDR /= SW(3 downto 0) then
					report "SW = " & to_string(SW) & "; LEDR = " & to_string(LEDR);
				end if;
			end if;
		end loop;
		wait;
	end process;
end architecture test;