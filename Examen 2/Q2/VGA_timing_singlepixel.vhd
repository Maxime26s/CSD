library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_timing_singlepixel is
	port(	CLOCK_50 : in std_logic;
			KEY : in std_logic_vector(3 downto 0);
			SW: in std_logic_vector(9 downto 0);
			VGA_R, VGA_G, VGA_B : out std_logic_vector(7 downto 0);
			VGA_CLK : out std_logic;
			VGA_BLANK_N : out std_logic;
			VGA_HS : out std_logic;
			VGA_VS : out std_logic
			);
end entity;

architecture DE1_SoC of VGA_timing_singlepixel is
	signal x : std_logic_vector(9 downto 0);
	signal y : std_logic_vector(8 downto 0);
	signal sx, mx : unsigned(9 downto 0);
	signal sy, my : unsigned(8 downto 0);
	signal mclock : std_logic;

begin
	vga : work.vga_basic port map( 
		clock => clock_50,
		reset => not key(0),	
		vga_hs => vga_hs,	
		vga_vs => vga_vs,
		pclock => VGA_CLK,
		blank => VGA_BLANK_N,
		X => x,
		Y => y
		);
	sx <= unsigned(x);	sy <= unsigned(y);
	
	VGA_R <= SW(9 downto 6) & "0000" when (sx = mx and sy = my)
				else (others => '0'); 
	VGA_G <= SW(5 downto 3) & "00000" when (sx = mx and sy = my)
				else (others => '0'); 
	VGA_B <= SW(2 downto 0) & "00000" when (sx = mx and sy = my)
				else (others => '0');

	move_clock: process(clock_50, KEY(0))
		variable loopcount : integer range 0 to 2000000;
	begin
		if(KEY(0) = '0') then		
			loopcount := 0;
			mclock <= '0';
		elsif(clock_50'event AND clock_50 = '1') then
			if(loopcount >= 1999999) then
				loopcount := 0;
				mclock <= not mclock;
			else
				loopcount := loopcount + 1;
			end if;
		end if;		
	end process;
	
	Move_X_Y: process(mclock, key(0))
	begin
		if(key(0) = '0') then			
			mx <= to_unsigned(0, 10);		--initialization
			my <= to_unsigned(0, 9);		-- x=0 and y=0
		elsif(mclock'event AND mclock = '1') then
			if(mx = 639) then mx <= to_unsigned(0, 10);
				else mx <= mx + 1; end if;
			if(my = 479) then my <= to_unsigned(0, 9);
				else my <= my + 1; end if;
		end if;		
	end process;
end DE1_SoC;
