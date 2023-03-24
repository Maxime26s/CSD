LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.lab1_3a.ALL;

ENTITY partie3a_tb IS
END partie3a_tb;

ARCHITECTURE test OF partie3a_tb IS
	SIGNAL SW : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL HEX0 : STD_LOGIC_VECTOR(6 DOWNTO 0);
BEGIN
	DUT : partie3a PORT MAP(SW, HEX0);
	PROCESS BEGIN
		REPORT "Testbench starting...";

		SW <= "00000001";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0);

		SW <= "00000010";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0);

		SW <= "00000100";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0);

		SW <= "00001000";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0);

		SW <= "00010000";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0);

		SW <= "00100000";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0);

		SW <= "01000000";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0);

		SW <= "10000000";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0);

		WAIT;
	END PROCESS;
END ARCHITECTURE test;