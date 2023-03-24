library ieee;
use ieee.std_logic_1164.all;

package lab1_2 is
	component partie2 is
		PORT (
			SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			LEDR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
	end component;
end package;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY partie2 IS
	PORT (
		SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		LEDR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END partie2;

ARCHITECTURE arch OF partie2 IS
BEGIN
	process(all) begin
		case? sw is
			when "1-------" => LEDR <= 3d"7";
			when "01------" => LEDR <= 3d"6";
			when "001-----" => LEDR <= 3d"5";
			when "0001----" => LEDR <= 3d"4";
			when "00001---" => LEDR <= 3d"3";
			when "000001--" => LEDR <= 3d"2";
			when "0000001-" => LEDR <= 3d"1";
			when "0000000-" => LEDR <= 3d"0";
			when others => LEDR <= 3d"0";
		end case?;
	end process;
END arch;