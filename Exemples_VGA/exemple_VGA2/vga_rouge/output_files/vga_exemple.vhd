library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_timing_largepixel is
	port(	CLOCK_50 : in std_logic; -- horloge interne
			KEY : in std_logic_vector(3 downto 0); -- bouton
			SW: in std_logic_vector(9 downto 0); -- switch
			VGA_R, VGA_G, VGA_B : out std_logic_vector(7 downto 0); -- signaux RGB du ADV7123
			VGA_CLK : out std_logic; -- signaux du ADV7123
			VGA_BLANK_N : out std_logic;-- signaux du ADV7123
			VGA_HS : out std_logic;-- signaux du ADV7123
			VGA_VS : out std_logic-- signaux du ADV7123
	);
end entity;

architecture DE1_SoC of VGA_timing_largepixel is
	signal x : std_logic_vector(9 downto 0);
	signal y : std_logic_vector(8 downto 0);
	signal sx, mx : unsigned(9 downto 0);
	signal sy, my : unsigned(8 downto 0);
	signal mclock : std_logic;

begin

	sx <= unsigned(x)/8;	sy <= unsigned(y)/8;
	
	VGA_R <= x"FF" when ((sy=my or sy=my+3) and (sx>=mx and sx<=mx+3)) or
							((sx=mx or sx=mx+3) and (sy>my and sy<my+3)) or
							(sx=mx+1 and sy=my+1)
				else (others => '0'); 
	VGA_G <= x"FF" when ((sy=my or sy=my+3) and (sx>=mx and sx<=mx+3)) or
							((sx=mx or sx=mx+3) and (sy>my and sy<my+3)) or
							(sx=mx+2 and sy=my+1) or (sx=mx+1 and sy=my+2)
				else (others => '0'); 
	VGA_B <= x"FF" when (sx=mx+2 and sy=my+2)
				else (others => '0');

		
-----------------------------------------------------------
   process(pclock, reset) is
      variable hcount : integer range 0 to 800;
      variable vcount : integer range 0 to 525;
   begin
      if(reset = '1') then
         hcount := 0;
         vcount := 0;
         vga_hs <= '1';
         vga_vs <= '1';
			blank  <= '0';
      elsif(pclock'event and pclock = '1') then				
         if(hcount >= 0 and hcount <= 639 and vcount >= 0 and vcount <= 479) then
            X <= std_logic_vector(to_unsigned(hcount, 10));
            Y <= std_logic_vector(to_unsigned(vcount, 9));
				blank <= '1'; -- don't blank the screen when in the zone
         else
            blank <= '0'; -- blank the screen when not in range
			end if;

			if(hcount = 799) then
				hcount := 0;
				if(vcount = 524) then	
					vcount := 0;
				else
					vcount := vcount + 1;
				end if;
			else
				hcount := hcount + 1;
			end if;
	
			if(hcount = 656) then		vga_hs <= '0';
			elsif(hcount = 752) then	vga_hs <= '1';
			end if;

			if(vcount = 490) then		vga_vs <= '0';
			elsif(vcount = 492) then	vga_vs <= '1';
			end if;
      end if;
   end process;
	
-----------------------------------------------------------
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
	
-----------------------------------------------------------
	Move_X_Y: process(mclock, key(0))
	begin
		if(key(0) = '0') then			
			mx <= to_unsigned(0, 10);		--initialization
			my <= to_unsigned(0, 9);		-- x=0 and y=0
		elsif(mclock'event AND mclock = '1') then
			if(mx = 79) then mx <= to_unsigned(0, 10);
				else mx <= mx + 1; end if;
			if(my = 59) then my <= to_unsigned(0, 9);
				else my <= my + 1; end if;
		end if;		
	end process;
	
end DE1_SoC;


---------------------------------------------------------------- 	
  pll : entity work.vga_pll port map (
		refclk 		=> CLOCK_50,
		rst 			=> reset,
		outclk_0	 	=> pclock
	);
end DE1_SoC;
