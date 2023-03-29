library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_basic is
   port(
			clock		:  in			std_logic;
			reset		:  in  		std_logic;
			vga_hs	:  out 		std_logic;
			vga_vs	:  out   	std_logic;
			pclock	:  buffer	std_logic;
			blank		:  out		std_logic;
			X			:  out		std_logic_vector(9 downto 0);
			Y			:  out		std_logic_vector(8 downto 0)
		);
end;

architecture DE1_SoC of vga_basic is



begin
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
---------------------------------------------------------------- 	
  pll : entity work.vga_pll port map (
		refclk 		=> clock,
		rst 			=> reset,
		outclk_0	 	=> pclock
	);
end DE1_SoC;
