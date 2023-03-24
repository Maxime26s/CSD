LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.lab1_2.ALL;

ENTITY partie2_tb IS
END partie2_tb;

ARCHITECTURE test OF partie2_tb IS
	SIGNAL SW : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL position : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
	DUT : partie2 PORT MAP(SW, position);
	PROCESS BEGIN
		REPORT "Testbench starting...";

		SW <= "00000001";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; position = " & to_string(position);

		SW <= "00000010";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; position = " & to_string(position);

		SW <= "00000100";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; position = " & to_string(position);

		SW <= "00001000";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; position = " & to_string(position);

		SW <= "00010000";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; position = " & to_string(position);

		SW <= "00100000";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; position = " & to_string(position);

		SW <= "01000000";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; position = " & to_string(position);

		SW <= "10000000";
		WAIT FOR 10 ns;
		REPORT "SW = " & to_string(SW) & "; position = " & to_string(position);

		WAIT;
	END PROCESS;
END ARCHITECTURE test;