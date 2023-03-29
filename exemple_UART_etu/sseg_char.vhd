library IEEE;
use IEEE.STD_Logic_1164.ALL;

entity sseg_char is
	port(
		in_char_binary	: in std_logic_vector(7 downto 0);
		out_sseg_char	: out std_logic_vector(7 downto 0)
	);
end sseg_char;

architecture arch_sseg_char of sseg_char is
	--définition des signaux
begin
	--définition des variables
	process (all)
		begin
			case in_char_binary is
			--table de conversion ASCII
				when 8d"12" => out_sseg_char <= "11000000";
--
				--...(reste de la table ASCII
				when others => out_sseg_char <= "11111111";
			end case;
	end process;		
end arch_sseg_char;