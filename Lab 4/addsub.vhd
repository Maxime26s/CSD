LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE addsub_constants IS
	COMPONENT addsub IS
		GENERIC (n : INTEGER := 9);
		PORT (
			a, b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			mode : IN STD_LOGIC;
			c : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
		);
	END COMPONENT;
END PACKAGE;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.ch8.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY addsub IS
	GENERIC (n : INTEGER := 9);
	PORT (
		a, b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
		mode : IN STD_LOGIC;
		c : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
	);
END addsub;

ARCHITECTURE arch OF addsub IS
BEGIN
	c <= a + b WHEN mode ELSE
		a - b;
END arch;