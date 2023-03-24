library ieee;
use ieee.std_logic_1164.all;

package magcomp_constants is
	component magcomp_b is
	  generic( k: integer := 8 );
	  port( a, b: in std_logic_vector(k-1 downto 0);
			  gt: out std_logic );
	end component;
end package;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity magcomp_b is
  generic( k: integer := 8 );
  port( a, b: in std_logic_vector(k-1 downto 0);
        gt: out std_logic );
end magcomp_b;

architecture impl of magcomp_b is
begin
  gt <= '1' when a > b else '0';
end impl;
