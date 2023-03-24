LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE lab1_5 IS
	COMPONENT partie5 IS
		PORT (
			SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			HEX0, HEX1, HEX2, HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;
END PACKAGE;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.lab1_4.ALL;
USE work.lab1_3c.ALL;

ENTITY partie5 IS
	PORT (
		SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0, HEX1, HEX2, HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END partie5;

ARCHITECTURE arch OF partie5 IS
	SIGNAL choix : STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN
	inst_partie3c : partie3c PORT MAP(SW, choix);

	sseg3 : sseg_letter PORT MAP(2d"0" XOR choix, HEX3);
	sseg2 : sseg_letter PORT MAP(2d"1" XOR choix, HEX2);
	sseg1 : sseg_letter PORT MAP(2d"2" XOR choix, HEX1);
	sseg0 : sseg_letter PORT MAP(2d"3" XOR choix, HEX0);
END arch;