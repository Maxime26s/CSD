LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

package lab1_1 is
	component partie1 is
		PORT (
			SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
		);
	end component;
end package;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY partie1 IS
    PORT (
        SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );
END partie1;

ARCHITECTURE Behavior OF partie1 IS
BEGIN
    LEDR <= SW;
END Behavior;
