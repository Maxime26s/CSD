LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.ff.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY cours4 IS
	PORT (
		KEY : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		sw : in std_logic_vector(2 downto 0);
		CLOCK_50 : in std_logic;
		adder : BUFFER STD_LOGIC_VECTOR(2 DOWNTO 0);
		LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END cours4;

ARCHITECTURE arch OF cours4 IS
	signal D : std_logic_vector(2 downto 0);
	SIGNAL key0 : std_logic; 
BEGIN

	D <= adder + SW;

	d_key0 : entity work.debounce port map(CLOCK_50, KEY(0), key0);
	
	ff0: vDFF generic map(3) port map(key0, D, adder);
	
	LEDR <= "0000000" & adder;

END arch;