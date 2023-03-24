library ieee;
use ieee.std_logic_1164.all;

package q2 is
	component multipleDe3 is
		PORT (
			a : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- vector 3 downto 0 pour avoir 4 bits d'entrée
			res : OUT STD_LOGIC -- 1 bit pour le résultat (0 n'est pas un multiple de 3, 1 est un multiple de 3)
		);
	end component;
end package;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY multipleDe3 IS
	PORT (
			a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			res : OUT STD_LOGIC
	);
END multipleDe3;

ARCHITECTURE arch OF multipleDe3 IS
BEGIN

	-- si c'est un cas où A est un multiple de 3, on assigne 1 au signal res, sinon on assigne 0
	
  process(all) begin
    case a is
      when 4d"3" => res <= '1';
      when 4d"6" => res <= '1';
      when 4d"9" => res <= '1';
      when 4d"12" => res <= '1';
		when 4d"15" => res <= '1';
      when others => res <= '0';
    end case;
  end process;
END arch;