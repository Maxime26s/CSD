LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE registre_constants IS
	COMPONENT registre IS
		GENERIC (n : INTEGER := 9);
		PORT (
			rin : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			clk, activated : IN STD_LOGIC;
			rout : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
		);
	END COMPONENT;
END PACKAGE;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.ff.ALL;
USE work.sseg_constants.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY registre IS
	GENERIC (n : INTEGER := 9);
	PORT (
		rin : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
		clk, activated : IN STD_LOGIC;
		rout : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
	);
END registre;

ARCHITECTURE arch OF registre IS
BEGIN
	PROCESS (ALL) BEGIN
		IF rising_edge(clk) THEN
			IF activated THEN
				rout <= rin;
			END IF;
		END IF;
	END PROCESS;
END arch;