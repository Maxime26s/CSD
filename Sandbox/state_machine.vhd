library ieee;
use ieee.std_logic_1164.all;

package state_machine_constants is
	component state_machine is
	PORT (
		w, clk, rst : in std_logic;
		state : out std_logic_vector(8 downto 0)
	);
	end component;
end package;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.ff.all;
use work.sseg_constants.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY state_machine IS
	PORT (
		w, clk, rst : in std_logic;
		state : out std_logic_vector(8 downto 0)
	);
END state_machine;

ARCHITECTURE arch OF state_machine IS
	signal a,b,c,d,e,f,g,h,idle,reseted : std_logic;
BEGIN
	idle <= not a and not b and not c and not d and not e and not f and not g and not h and not reseted;
	ffrst: sDFF port map(clk or rst, rst, reseted);
	ffa: sDFF port map(clk or rst, (idle or reseted or e or f or g or h) and w and not rst, a);
	ffb: sDFF port map(clk or rst, a and w and not idle and not rst, b);
	ffc: sDFF port map(clk or rst, b and w and not idle and not rst, c);
	ffd: sDFF port map(clk or rst, (c or d) and w and not a and not rst, d);
	ffe: sDFF port map(clk or rst, (idle or reseted or a or b or c or d) and not w and not rst, e);
	fff: sDFF port map(clk or rst, e and not w and not idle and not rst, f);
	ffg: sDFF port map(clk or rst, f and not w and not idle and not rst, g);
	ffh: sDFF port map(clk or rst, (g or h) and not w and not idle and not rst, h);
	state <= h & g & f & e & d & c & b & a & (idle or reseted);	
END arch;