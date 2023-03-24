LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.lab1_5.ALL;

ENTITY partie5_tb IS
END partie5_tb;

ARCHITECTURE test OF partie5_tb IS
	SIGNAL SW : STD_LOGIC_VECTOR (9 DOWNTO 0);
	SIGNAL HEX0, HEX1, HEX2, HEX3 : STD_LOGIC_VECTOR (6 DOWNTO 0);
BEGIN
	DUT : partie5 PORT MAP(SW, HEX0, HEX1, HEX2, HEX3);
	PROCESS BEGIN
		REPORT "Testbench starting...";

		SW <= "0000000000";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0) & "; HEX1 = " & to_string(HEX1) & "; HEX2 = " & to_string(HEX2) & "; HEX3 = " & to_string(HEX3);

		SW <= "0001000000";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0) & "; HEX1 = " & to_string(HEX1) & "; HEX2 = " & to_string(HEX2) & "; HEX3 = " & to_string(HEX3);

		SW <= "0010000000";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0) & "; HEX1 = " & to_string(HEX1) & "; HEX2 = " & to_string(HEX2) & "; HEX3 = " & to_string(HEX3);

		SW <= "0011000000";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0) & "; HEX1 = " & to_string(HEX1) & "; HEX2 = " & to_string(HEX2) & "; HEX3 = " & to_string(HEX3);

		SW <= "0100000000";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0) & "; HEX1 = " & to_string(HEX1) & "; HEX2 = " & to_string(HEX2) & "; HEX3 = " & to_string(HEX3);

		SW <= "0100010000";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0) & "; HEX1 = " & to_string(HEX1) & "; HEX2 = " & to_string(HEX2) & "; HEX3 = " & to_string(HEX3);

		SW <= "0100100000";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0) & "; HEX1 = " & to_string(HEX1) & "; HEX2 = " & to_string(HEX2) & "; HEX3 = " & to_string(HEX3);

		SW <= "0100110000";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; HEX0 = " & to_string(HEX0) & "; HEX1 = " & to_string(HEX1) & "; HEX2 = " & to_string(HEX2) & "; HEX3 = " & to_string(HEX3);

		WAIT;
	END PROCESS;
END ARCHITECTURE test;