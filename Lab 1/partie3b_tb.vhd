LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.lab1_3b.ALL;

ENTITY partie3b_tb IS
END partie3b_tb;

ARCHITECTURE test OF partie3b_tb IS
	SIGNAL SW : STD_LOGIC_VECTOR (8 DOWNTO 0);
	SIGNAL LEDR : STD_LOGIC_VECTOR (3 DOWNTO 0);
BEGIN
	DUT : partie3b PORT MAP(SW, LEDR);
	PROCESS BEGIN
		REPORT "Testbench starting...";
		FOR i IN 0 TO 511 LOOP
			SW <= STD_LOGIC_VECTOR(to_unsigned(i, SW'length));
			WAIT FOR 10 ns;
			IF SW(8) = '0' THEN
				IF LEDR /= SW(7 DOWNTO 4) THEN
					REPORT "SW = " & to_string(SW) & "; LEDR = " & to_string(LEDR);
				END IF;
			ELSIF SW(8) = '1' THEN
				IF LEDR /= SW(3 DOWNTO 0) THEN
					REPORT "SW = " & to_string(SW) & "; LEDR = " & to_string(LEDR);
				END IF;
			END IF;
		END LOOP;
		WAIT;
	END PROCESS;
END ARCHITECTURE test;