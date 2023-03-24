LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE lab1_3a IS
	COMPONENT partie3a IS
		PORT (
			SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT bit_significatif IS
		PORT (
			SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			LEDR : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;
END PACKAGE;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.sseg_constants.ALL;
USE work.lab1_3a.ALL;

ENTITY partie3a IS
	PORT (
		SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END partie3a;

ARCHITECTURE arch OF partie3a IS
	SIGNAL a : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	bit_significatif1 : bit_significatif PORT MAP(SW, a);
	sseg0 : sseg PORT MAP(a, HEX0);
END arch;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY bit_significatif IS
	PORT (
		SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		LEDR : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END bit_significatif;

ARCHITECTURE arch OF bit_significatif IS
BEGIN
	PROCESS (ALL) BEGIN
		CASE ? sw IS
			WHEN "1-------" => LEDR <= 4d"7";
			WHEN "01------" => LEDR <= 4d"6";
			WHEN "001-----" => LEDR <= 4d"5";
			WHEN "0001----" => LEDR <= 4d"4";
			WHEN "00001---" => LEDR <= 4d"3";
			WHEN "000001--" => LEDR <= 4d"2";
			WHEN "0000001-" => LEDR <= 4d"1";
			WHEN "0000000-" => LEDR <= 4d"0";
			WHEN OTHERS => LEDR <= 4d"0";
		END CASE?;
	END PROCESS;
END arch;