library ieee;
use ieee.std_logic_1164.all;

package muxb10_constants is
	component Muxb10 is
		generic( n : integer := 9 );
		port(
			a9, a8, a7, a6, a5, a4, a3, a2, a1, a0 : in std_logic_vector(n-1 downto 0);
			sb: in std_logic_vector(3 downto 0);
			b: out std_logic_vector(n-1 downto 0)
		);
	end component;
end package;
------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity Muxb10 is
	generic( n : integer := 9 );
		port( a9, a8, a7, a6, a5, a4, a3, a2, a1, a0 : in std_logic_vector(n-1 downto 0);
		sb: in std_logic_vector(3 downto 0); -- binary select
		b: out std_logic_vector(n-1 downto 0)
	);
end Muxb10;

architecture impl of Muxb10 is 
begin
	process(all) begin
		case sb is
			when 4d"0" => b <= a0 ;
			when 4d"1" => b <= a1 ;
			when 4d"2" => b <= a2 ;
			when 4d"3" => b <= a3 ;
			when 4d"4" => b <= a4 ;
			when 4d"5" => b <= a5 ;
			when 4d"6" => b <= a6 ;
			when 4d"7" => b <= a7 ;
			when 4d"8" => b <= a8 ;
			when 4d"9" => b <= a9 ;
			when others =>  b <=  (others => '0');
		end case;
	end process;
end impl;