library ieee;
use ieee.std_logic_1164.all;

package registre_constants is
	component registre is
	GENERIC 	(n : INTEGER := 9);
	PORT (
		rin : in std_logic_vector(n-1 downto 0);
		clk, activated : in std_logic;
		rout : out std_logic_vector(n-1 downto 0)
	);
	end component;
end package;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.ff.all;
use work.sseg_constants.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY registre IS
	GENERIC 	(n : INTEGER := 9);
	PORT (
		rin : in std_logic_vector(n-1 downto 0);
		clk, activated : in std_logic;
		rout : out std_logic_vector(n-1 downto 0)
	);
END registre;

ARCHITECTURE arch OF registre IS
BEGIN
	process(all) BEGIN	
		if rising_edge(clk) then
			if activated then
				rout <= rin;
			end if;
		end if;
	end process;
END arch;