/*library ieee;
use ieee.std_logic_1164.all;

package counter_constants is
	component counter is
	PORT (
		current_val : in std_logic_vector(1 downto 0);
		out_val : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
	end component;
end package;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.ff.all;

ENTITY counter IS
	PORT (
		SW : in std_logic_vector(0 downto 0);
		KEY : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		CLOCK_50 : in std_logic;
		a,b,c,d,e,f,g,h,idle,reseted : buffer std_logic;
		LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END counter;

ARCHITECTURE arch OF counter IS
	signal clk, rst : std_logic;
	signal w : std_logic;
	signal state : std_logic_vector(8 downto 0);
BEGIN
	w <= SW(0);

	d_key0 : entity work.debounce port map(CLOCK_50, KEY(0), clk);
	d_key1 : entity work.debounce port map(CLOCK_50, KEY(1), rst);
	
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
	
	LEDR <= "0" & state;
END arch;*/