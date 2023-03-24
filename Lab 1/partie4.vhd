LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE lab1_4 IS
	COMPONENT partie4 IS
		PORT (
			SW : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;

	SUBTYPE sseg_type IS STD_LOGIC_VECTOR(6 DOWNTO 0);

	CONSTANT SS_A : sseg_type := 7b"0001000";
	CONSTANT SS_B : sseg_type := 7b"0000011";
	CONSTANT SS_C : sseg_type := 7b"0100111";
	CONSTANT SS_D : sseg_type := 7b"0100001";
	CONSTANT SOFF : sseg_type := 7b"1111111";

	COMPONENT sseg_letter IS
		PORT (
			bin : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			segs : OUT sseg_type
		);
	END COMPONENT;
END PACKAGE;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.lab1_4.ALL;

ENTITY partie4 IS
	PORT (
		SW : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END partie4;

ARCHITECTURE arch OF partie4 IS
BEGIN
	sseg0 : sseg_letter PORT MAP(SW, HEX0);
END arch;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.lab1_4.ALL;

ENTITY sseg_letter IS
	PORT (
		bin : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		segs : OUT sseg_type
	);
END sseg_letter;
ARCHITECTURE impl OF sseg_letter IS
BEGIN
	PROCESS (ALL) BEGIN
		CASE bin IS
			WHEN 2d"0" => segs <= SS_A;
			WHEN 2d"1" => segs <= SS_B;
			WHEN 2d"2" => segs <= SS_C;
			WHEN 2d"3" => segs <= SS_D;
			WHEN OTHERS => segs <= SOFF;
		END CASE;
	END PROCESS;
END impl;