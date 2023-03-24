LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.lab1_4.ALL;

ENTITY partie4_tb IS
END partie4_tb;

ARCHITECTURE test OF partie4_tb IS
	SIGNAL SW : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL HEX0 : STD_LOGIC_VECTOR(6 DOWNTO 0);
BEGIN
	DUT : partie4 PORT MAP(SW, HEX0);
	PROCESS BEGIN
		REPORT "Testbench starting...";

		SW <= "00";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0);

		SW <= "01";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0);

		SW <= "10";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0);

		SW <= "11";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0);

		WAIT;
	END PROCESS;
END ARCHITECTURE test;