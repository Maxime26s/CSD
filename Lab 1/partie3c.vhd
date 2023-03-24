LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE lab1_3c IS
	COMPONENT partie3c IS
		PORT (
			SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			LEDR : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
	END COMPONENT;
END PACKAGE;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY partie3c IS
	PORT (
		SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		LEDR : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END partie3c;

ARCHITECTURE arch OF partie3c IS
	SIGNAL s, u, v, w, x : STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN
	s <= SW(9 DOWNTO 8);
	u <= SW(7 DOWNTO 6);
	v <= SW(5 DOWNTO 4);
	w <= SW(3 DOWNTO 2);
	x <= SW(1 DOWNTO 0);
	WITH s SELECT
		LEDR <= u WHEN 2d"0", v WHEN 2d"1", w WHEN 2d"2", x WHEN 2d"3", 2d"0" WHEN OTHERS;
END arch;