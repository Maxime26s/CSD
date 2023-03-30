library ieee;
use ieee.std_logic_1164.all;

package alu_constants is
	component alu is
		GENERIC 	(n : INTEGER := 9);
		PORT (
			a, b : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			mode : in std_logic_vector(2 downto 0);
			c : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
		);
	end component;
end package;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.ch8.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

ENTITY alu IS
	GENERIC 	(n : INTEGER := 9);
	PORT (
		a, b : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		mode : in std_logic_vector(2 downto 0);
		c : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
	);
END alu;


ARCHITECTURE arch OF alu IS
BEGIN
	calculate : process(a, b, mode)
	begin
		case mode is
			when "010" => 	c <= std_logic_vector(unsigned(a) + unsigned(b));
			when "011" => 	c <= std_logic_vector(unsigned(a) - unsigned(b));
			when "100" => 	c <= std_logic_vector(resize(unsigned(a) * unsigned(b), a'length));
			when "101" => 	c <= std_logic_vector(unsigned(a) / unsigned(b));
			when "110" => 	c <= std_logic_vector(to_unsigned(to_integer(unsigned(a)) ** 2, n));
			when others => 	c <= std_logic_vector(unsigned(a) + unsigned(b));
		end case;
	end process calculate;
END arch;