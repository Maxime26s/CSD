library ieee;
use ieee.std_logic_1164.all;

package addsub_constants is
	component addsub is
		GENERIC 	(n : INTEGER := 9);
		PORT (
			a, b : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			mode : in std_logic;
			c : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
		);
	end component;
end package;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.ch8.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY addsub IS
	GENERIC 	(n : INTEGER := 9);
	PORT (
		a, b : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		mode : in std_logic;
		c : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
	);
END addsub;

ARCHITECTURE arch OF addsub IS
BEGIN
	c <= a + b when mode else a - b;
END arch;