LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.mediane_constants.all;
use work.sseg_constants.all;

ENTITY mediane_interface IS
	PORT (
		SW : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END mediane_interface;

ARCHITECTURE arch OF mediane_interface IS
	signal val_mediane : std_logic_vector(2 downto 0);
BEGIN
	mediane0: mediane port map(SW(2 downto 0), SW(5 downto 3), SW(8 downto 6), val_mediane);
	sseg0: sseg port map("0" & val_mediane, HEX0);
END arch;