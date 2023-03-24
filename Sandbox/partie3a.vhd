library ieee;
use ieee.std_logic_1164.all;

package lab1_3a is
	component partie3a is
		PORT (
			SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	end component;
	
	component bit_significatif IS
		PORT (
			SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			LEDR : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	end component;
end package;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.sseg_constants.all;
use work.lab1_3a.all;

ENTITY partie3a IS
	PORT (
		SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END partie3a;

ARCHITECTURE arch OF partie3a IS
signal a: std_logic_vector(3 downto 0);
BEGIN
	bit_significatif1: bit_significatif port map(SW, a);
	sseg0: sseg port map(a, HEX0);
END arch;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY bit_significatif IS
	PORT (
		SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		LEDR : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END bit_significatif;

ARCHITECTURE arch OF bit_significatif IS
BEGIN
	process(all) begin
		case? sw is
			when "1-------" => LEDR <= 4d"7";
			when "01------" => LEDR <= 4d"6";
			when "001-----" => LEDR <= 4d"5";
			when "0001----" => LEDR <= 4d"4";
			when "00001---" => LEDR <= 4d"3";
			when "000001--" => LEDR <= 4d"2";
			when "0000001-" => LEDR <= 4d"1";
			when "0000000-" => LEDR <= 4d"0";
			when others => LEDR <= 4d"0";
		end case?;
	end process;
END arch;
