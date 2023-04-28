library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_timing_only is
   port(
			pclock	:  in		std_logic;
			reset		:  in  	std_logic;
			vga_hs	:  out 	std_logic;
			vga_vs	:  out   std_logic
		);
end;

architecture DE1_SoC of vga_timing_only is
begin
   process(pclock, reset) is
      variable hcount : integer range 0 to 800;
      variable vcount : integer range 0 to 525;
   begin
      if(reset = '1') then
         hcount := 0;         vcount := 0;
         vga_hs <= '1';       vga_vs <= '1';
      elsif(pclock'event and pclock = '1') then		
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
	
	   if(hcount = 656) then	vga_hs <= '0';
         elsif(hcount = 752) then	vga_hs <= '1';
         end if;

         if(vcount = 490) then	vga_vs <= '0';
         elsif(vcount = 492) then	vga_vs <= '1';
         end if;
      end if;
   end process;

end DE1_SoC;
