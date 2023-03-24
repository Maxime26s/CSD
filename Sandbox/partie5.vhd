library ieee;
use ieee.std_logic_1164.all;

package lab1_5 is
	component partie5 is
		PORT (
			SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			HEX0, HEX1, HEX2, HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	end component;
end package;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.lab1_4.all;
use work.lab1_3c.all;

ENTITY partie5 IS
	PORT (
		SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0, HEX1, HEX2, HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END partie5;

ARCHITECTURE arch OF partie5 IS
	signal choix: std_logic_vector(1 downto 0);
BEGIN
	inst_partie3c: partie3c port map(SW, choix); 
	
	sseg3: sseg_letter port map(2d"0" xor choix, HEX3);
	sseg2: sseg_letter port map(2d"1" xor choix, HEX2);
	sseg1: sseg_letter port map(2d"2" xor choix, HEX1);
	sseg0: sseg_letter port map(2d"3" xor choix, HEX0);
END arch;