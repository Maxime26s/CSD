LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
USE work.lab1_1.all;

ENTITY partie1_tb IS
END partie1_tb;

ARCHITECTURE test OF partie1_tb IS
    SIGNAL SW : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL LEDR : STD_LOGIC_VECTOR(9 DOWNTO 0);
BEGIN
	DUT : partie1 PORT MAP(SW, LEDR);
	PROCESS BEGIN
		report "Testbench starting...";
		for i in 0 to 1023 loop
			SW <= std_logic_vector(to_unsigned(i, SW'length));
			WAIT FOR 10 ns;
			if SW /= LEDR then
				REPORT "SW = " & to_string(SW) & "; LEDR = " & to_string(LEDR);
			end if;
		end loop;
		WAIT;
	END PROCESS;
END ARCHITECTURE test;