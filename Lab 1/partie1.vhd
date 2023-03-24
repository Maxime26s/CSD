LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE lab1_1 IS
	COMPONENT partie1 IS
		PORT (
			SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
		);
	END COMPONENT;
END PACKAGE;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY partie1 IS
	PORT (
		SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END partie1;

ARCHITECTURE Behavior OF partie1 IS
BEGIN
	LEDR <= SW;
END Behavior;