LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.lab1_1.ALL;

ENTITY partie1_tb IS
END partie1_tb;

ARCHITECTURE test OF partie1_tb IS
	SIGNAL SW : STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL LEDR : STD_LOGIC_VECTOR(9 DOWNTO 0);
BEGIN
	DUT : partie1 PORT MAP(SW, LEDR);
	PROCESS BEGIN
		REPORT "Testbench starting...";
		FOR i IN 0 TO 1023 LOOP
			SW <= STD_LOGIC_VECTOR(to_unsigned(i, SW'length));
			WAIT FOR 10 ns;
			IF SW /= LEDR THEN
				REPORT "SW = " & to_string(SW) & "; LEDR = " & to_string(LEDR);
			END IF;
		END LOOP;
		WAIT;
	END PROCESS;
END ARCHITECTURE test;