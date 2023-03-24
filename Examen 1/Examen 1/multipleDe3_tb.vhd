LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
USE work.q2.all;

entity multipleDe3_tb is
end multipleDe3_tb;

architecture test of multipleDe3_tb is
	signal a : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal res : STD_LOGIC;
begin
	DUT: multipleDe3 port map(a, res);
	process begin
		report "Testbench starting...";
		
		-- on boucle de 0 à 15 (toutes les valeurs d'un vecteur de 4 bits) et on report le résultat
		
		for i in 0 to 15 loop
			a <= std_logic_vector(to_unsigned(i, a'length));
			wait for 10 ns;
			report "value = " & to_string(a) & "; result = " & to_string(res);
		end loop;
		wait;
	end process;
end architecture test;