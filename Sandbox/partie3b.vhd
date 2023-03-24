library ieee;
use ieee.std_logic_1164.all;

package lab1_3b is
	component partie3b is
		PORT (
			SW : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
			LEDR : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	end component;
end package;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY partie3b IS
	PORT (
		SW : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		LEDR : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END partie3b;

ARCHITECTURE arch OF partie3b IS
signal s: std_logic;
signal x, y: std_logic_vector(3 downto 0);
BEGIN
	s <= SW(8);
	x <= SW(7 downto 4);
	y <= SW(3 downto 0);	
	with s select
		LEDR <= x when '0', y when others;
END arch;