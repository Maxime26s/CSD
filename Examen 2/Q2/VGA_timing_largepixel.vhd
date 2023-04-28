library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_timing_largepixel is
	port(	CLOCK_50 : in std_logic; -- horloge interne
			KEY : in std_logic_vector(3 downto 0); -- bouton
			SW: in std_logic_vector(9 downto 0); -- switch
			VGA_R, VGA_G, VGA_B : out std_logic_vector(7 downto 0); -- signaux RGB du ADV7123
			VGA_CLK : inout std_logic; -- signaux du ADV7123
			VGA_BLANK_N : out std_logic;-- signaux du ADV7123
			VGA_HS : out std_logic;-- signaux du ADV7123
			VGA_VS : out std_logic-- signaux du ADV7123
	);
end entity;

architecture DE1_SoC of VGA_timing_largepixel is
--	signal x : std_logic_vector(9 downto 0);
--	signal y : std_logic_vector(8 downto 0);
--	signal sx, mx : unsigned(9 downto 0);
--	signal sy, my : unsigned(8 downto 0);
--	signal mclock : std_logic;

begin
	
	--pclock	:  buffer	std_logic;
----------------------------------------------------------------
	pll : entity work.vga_pll port map (
		refclk 		=> CLOCK_50,
		rst 			=> not KEY(0),
		outclk_0	 	=> VGA_CLK
	);
	
----------------------------------------------------------------
	VGA_R <= "11111111";
	VGA_G <= "11111111";
	VGA_B <= "00000000";

----------------------------------------------------------------
   process(VGA_CLK, KEY(0)) is
      variable hcount : integer range 0 to 800;
      variable vcount : integer range 0 to 525;
   begin
	
		-- RESET
      if(KEY(0) = '0') then
         hcount := 0;
         vcount := 0;
         vga_hs <= '1';
         vga_vs <= '1';
			VGA_BLANK_N  <= '0';
			
		
      elsif(VGA_CLK'event and VGA_CLK = '1') then	
		
			-- Blank si à l'extérieur de la zone
         if(hcount >= 0 and hcount <= 639 and vcount >= 0 and vcount <= 479) then
            --X <= std_logic_vector(to_unsigned(hcount, 10));
            --Y <= std_logic_vector(to_unsigned(vcount, 9));
				VGA_BLANK_N <= '1'; -- don't blank the screen when in the zone
				
         else
            VGA_BLANK_N <= '0'; -- blank the screen when not in range
				
			end if;

			-- Incrémente les compteurs hcount / vcount
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
	
			-- Définit le sync pulse horizontal
			if(hcount = 656) then		vga_hs <= '0';
			elsif(hcount = 752) then	vga_hs <= '1';
			end if;

			-- Définit le sync pulse vertical
			if(vcount = 490) then		vga_vs <= '0';
			elsif(vcount = 492) then	vga_vs <= '1';
			end if;
			
			
      end if;
   end process;
	
end DE1_SoC;
