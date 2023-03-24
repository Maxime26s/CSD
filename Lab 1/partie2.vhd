LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE lab1_2 IS
	COMPONENT partie2 IS
		PORT (
			SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			LEDR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
	END COMPONENT;
END PACKAGE;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY partie2 IS
	PORT (
		SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		LEDR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END partie2;

ARCHITECTURE arch OF partie2 IS
BEGIN
	PROCESS (ALL) BEGIN
		CASE ? sw IS
			WHEN "1-------" => LEDR <= 3d"7";
			WHEN "01------" => LEDR <= 3d"6";
			WHEN "001-----" => LEDR <= 3d"5";
			WHEN "0001----" => LEDR <= 3d"4";
			WHEN "00001---" => LEDR <= 3d"3";
			WHEN "000001--" => LEDR <= 3d"2";
			WHEN "0000001-" => LEDR <= 3d"1";
			WHEN "0000000-" => LEDR <= 3d"0";
			WHEN OTHERS => LEDR <= 3d"0";
		END CASE?;
	END PROCESS;
END arch;