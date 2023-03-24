LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE lab1_3b IS
	COMPONENT partie3b IS
		PORT (
			SW : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
			LEDR : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;
END PACKAGE;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY partie3b IS
	PORT (
		SW : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		LEDR : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END partie3b;

ARCHITECTURE arch OF partie3b IS
	SIGNAL s : STD_LOGIC;
	SIGNAL x, y : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	s <= SW(8);
	x <= SW(7 DOWNTO 4);
	y <= SW(3 DOWNTO 0);
	WITH s SELECT
		LEDR <= x WHEN '0', y WHEN OTHERS;
END arch;