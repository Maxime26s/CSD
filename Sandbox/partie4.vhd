library ieee;
use ieee.std_logic_1164.all;

package lab1_4 is
	component partie4 is
		PORT (
			SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			HEX0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	end component;
	
	subtype sseg_type is std_logic_vector(6 downto 0);

  constant SS_A : sseg_type := 7b"0001000"; 
  constant SS_B : sseg_type := 7b"0000011"; 
  constant SS_C : sseg_type := 7b"0100111";
  constant SS_D : sseg_type := 7b"0100001"; 
  constant SOFF : sseg_type := 7b"1111111";
  
	component sseg_letter is
		port(
			bin : in std_logic_vector(1 downto 0); 
			segs : out sseg_type
		);  
	end component;
end package;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.lab1_4.all;

ENTITY partie4 IS
	PORT (
		SW : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END partie4;

ARCHITECTURE arch OF partie4 IS
BEGIN
	sseg0: sseg_letter port map(SW, HEX0);
END arch;
------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.lab1_4.all;

entity sseg_letter is
	port(
		bin : in std_logic_vector(1 downto 0); 
		segs : out sseg_type
		);  
end sseg_letter;
architecture impl of sseg_letter is
begin
  process(all) begin
    case bin is
      when 2d"0" => segs <= SS_A;
      when 2d"1" => segs <= SS_B;
      when 2d"2" => segs <= SS_C;
      when 2d"3" => segs <= SS_D;
      when others => segs <= SOFF;
    end case;
  end process;
end impl;