library ieee;
use ieee.std_logic_1164.all;

package lab1_3c is
	component partie3c is
		PORT (
			SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			LEDR : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
	end component;
end package;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY partie3c IS
	PORT (
		SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		LEDR : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END partie3c;

ARCHITECTURE arch OF partie3c IS
signal s, u, v, w, x: std_logic_vector(1 downto 0);
BEGIN
	s <= SW(9 downto 8);
	u <= SW(7 downto 6);
	v <= SW(5 downto 4);
	w <= SW(3 downto 2);
	x <= SW(1 downto 0);
	with s select
		LEDR <= u when 2d"0", v when 2d"1", w when 2d"2", x when 2d"3", 2d"0" when others;
END arch;