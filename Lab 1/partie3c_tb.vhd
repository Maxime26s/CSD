LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.lab1_3c.ALL;

ENTITY partie3c_tb IS
END partie3c_tb;

ARCHITECTURE test OF partie3c_tb IS
	SIGNAL SW : STD_LOGIC_VECTOR (9 DOWNTO 0);
	SIGNAL LEDR : STD_LOGIC_VECTOR (1 DOWNTO 0);
BEGIN
	DUT : partie3c PORT MAP(SW, LEDR);
	PROCESS BEGIN
		REPORT "Testbench starting...";
		FOR i IN 0 TO 511 LOOP
			SW <= STD_LOGIC_VECTOR(to_unsigned(i, SW'length));
			WAIT FOR 10 ns;
			IF SW(9 DOWNTO 8) = "00" THEN
				IF LEDR /= SW(7 DOWNTO 6) THEN
					REPORT "SW = " & to_string(SW) & "; LEDR = " & to_string(LEDR);
				END IF;
			ELSIF SW(9 DOWNTO 8) = "01" THEN
				IF LEDR /= SW(5 DOWNTO 4) THEN
					REPORT "SW = " & to_string(SW) & "; LEDR = " & to_string(LEDR);
				END IF;
			ELSIF SW(9 DOWNTO 8) = "10" THEN
				IF LEDR /= SW(3 DOWNTO 1) THEN
					REPORT "SW = " & to_string(SW) & "; LEDR = " & to_string(LEDR);
				END IF;
			ELSIF SW(9 DOWNTO 8) = "11" THEN
				IF LEDR /= SW(1 DOWNTO 0) THEN
					REPORT "SW = " & to_string(SW) & "; LEDR = " & to_string(LEDR);
				END IF;
			END IF;
		END LOOP;
		WAIT;
	END PROCESS;
END ARCHITECTURE test;