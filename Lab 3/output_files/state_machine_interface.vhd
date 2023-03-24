LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.sseg_constants.all;
use work.state_machine_constants.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY state_machine_interface IS
	PORT (
		SW : in std_logic_vector(0 downto 0);
		KEY : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		CLOCK_50 : in std_logic;
		current_value : buffer std_logic_vector(3 downto 0);
		LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0 : out std_logic_vector(6 downto 0)
	);
END state_machine_interface;

ARCHITECTURE arch OF state_machine_interface IS
	signal clk, rst : std_logic;
	signal state : std_logic_vector(8 downto 0);
BEGIN
	d_key0 : entity work.debounce port map(CLOCK_50, KEY(0), clk);
	d_key1 : entity work.debounce port map(CLOCK_50, KEY(1), rst);
	
	fsm0: state_machine PORT MAP (SW(0), clk, rst, w, state);
	LEDR <= "0" & state;
	
	next_value <= current_value + "0001" when ((d and w) or (h and not w)) and not rst else "0000";
	ffcounter : vDFF generic map(4) port map(clk or rst, next_value, current_value);
	sseg0 : sseg port map(current_value, HEX0);
END arch;