LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE muxb10_constants IS
	COMPONENT Muxb10 IS
		GENERIC (n : INTEGER := 9);
		PORT (
			a9, a8, a7, a6, a5, a4, a3, a2, a1, a0 : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			sb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			b : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
		);
	END COMPONENT;
END PACKAGE;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Muxb10 IS
	GENERIC (n : INTEGER := 9);
	PORT (
		a9, a8, a7, a6, a5, a4, a3, a2, a1, a0 : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
		sb : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- binary select
		b : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
	);
END Muxb10;

ARCHITECTURE impl OF Muxb10 IS
BEGIN
	PROCESS (ALL) BEGIN
		CASE sb IS
			WHEN 4d"0" => b <= a0;
			WHEN 4d"1" => b <= a1;
			WHEN 4d"2" => b <= a2;
			WHEN 4d"3" => b <= a3;
			WHEN 4d"4" => b <= a4;
			WHEN 4d"5" => b <= a5;
			WHEN 4d"6" => b <= a6;
			WHEN 4d"7" => b <= a7;
			WHEN 4d"8" => b <= a8;
			WHEN 4d"9" => b <= a9;
			WHEN OTHERS => b <= (OTHERS => '0');
		END CASE;
	END PROCESS;
END impl;