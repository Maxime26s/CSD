library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_font is
   port(	clock		:  in       std_logic;
			reset		:  in       std_logic;
			mem_adr	:  in       std_logic_vector(12 downto 0);
			mem_out	:  out      std_logic_vector(6 downto 0);
			mem_in	:  in       std_logic_vector(6 downto 0);
			mem_wr	:  in       std_logic;
			vga_hs	:  out      std_logic;
			vga_vs	:  out      std_logic;
			r, g, b	:  out      std_logic_vector(3 downto 0)
		);
end;

architecture DE1 of vga_font is
   	signal pclock	: std_logic;
		signal char		: std_logic_vector(6 downto 0);
		signal X		: std_logic_vector(9 downto 0);
		signal FX1, FX2	: std_logic_vector(2 downto 0);
		signal Y		: std_logic_vector(8 downto 0);
   	signal FY		: std_logic_vector(2 downto 0);
   	signal font		: std_logic_vector(0 to 7);
		signal b1, b2, blank	: std_logic;
		signal hs1, hs2, hs3, vs1, vs2, vs3	: std_logic;
begin
   Video_RAM: entity work.vram port map(
      address_a => Y(8 downto 3)& X(9 downto 3),
      address_b => mem_adr,
		clock_a => pclock,
      clock_b => clock,
      data_a => (others => '-'),	-- Don't care
      data_b => mem_in,
      wren_a => '0',
      wren_b => mem_wr,
		q_a => char,
      q_b => mem_out
	);
   font_table: entity work.vrom port map(
      clock => pclock,
      address => char & FY,
      q => font
   );

   Timing_Circuit: process(pclock, reset) is
      variable hcount : integer range 0 to 800;
      variable vcount : integer range 0 to 525;
   begin
      if(reset = '1') then
         hcount := 0;         vcount := 0;
         vga_hs <= '1';       vga_vs <= '1';
      elsif(pclock'event and pclock = '1') then
         if(hcount >= 0 and hcount <= 639 and vcount >= 0 and vcount <= 479) then
            X <= std_logic_vector(to_unsigned(hcount, 10));
				Y <= std_logic_vector(to_unsigned(vcount, 9));
            b1 <= '1'; -- don't blank the screen when in the zone 	
         else
            b1 <= '0'; -- blank the screen when not in range
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
	
			if(hcount = 656) then		hs1 <= '0';
			elsif(hcount = 752) then	hs1 <= '1';
			end if;

			if(vcount = 490) then		vs1 <= '0';
			elsif(vcount = 492) then	vs1 <= '1';
			end if;
      	
         FY <= Y(2 downto 0);	FX1 <= X(2 downto 0);
			hs2 <= hs1;	vs2 <= vs1;	b2 <= b1;
			hs3 <= hs2;	vs3 <= vs2; blank <= b2;   FX2 <= FX1;
			vga_hs <= hs3;	vga_vs <= vs3;
			
			if(blank = '1') then			
				r <= (others => font(to_integer(unsigned(FX2))));
				g <= (others => font(to_integer(unsigned(FX2))));
				b <= (others => font(to_integer(unsigned(FX2))));
			else
				r <= (others => '0');
				g <= (others => '0');
				b <= (others => '0');
         end if;  
      end if;
   end process;
  ---------------------------------------------		
  pll : work.VGAPLL PORT MAP (
		inclk0 => clock,
		areset => reset,
		c0	 => pclock
	);
end DE1;
