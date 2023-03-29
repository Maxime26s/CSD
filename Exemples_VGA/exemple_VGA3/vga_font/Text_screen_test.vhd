library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned;

entity Text_screen_test is
	port( CLOCK_50	: in std_logic;
			KEY		: in std_logic_vector(1 downto 0);
			VGA_R, VGA_G, VGA_B : out std_logic_vector(3 downto 0);
			VGA_HS 	: out std_logic;
			VGA_VS 	: out std_logic
			);
end Text_screen_test;

architecture DE1 of Text_screen_test is 
	alias clock : std_logic is Clock_50;
	alias reset : std_logic is KEY(0);
	constant screen_width:  integer := 80;
	constant screen_height: integer := 60;
	
	signal mem_in, mem_out, data: std_logic_vector(6 downto 0);
	signal mem_adr: std_logic_vector(12 downto 0);
	signal mem_wr: std_logic;
	signal x : unsigned(6 downto 0);
	signal y : unsigned(5 downto 0);
	
	type state is ( clean0, clean1, clean2, clean3, done);
	signal SV : state;
	
	-- Define a signal for the current character to write to the screen
	signal curr_char: std_logic_vector(6 downto 0);
	
begin
	vga : entity work.vga_font port map(	--VGA with font table. 
		clock => clock,
		reset => not reset,
		mem_adr => mem_adr,
		mem_out => mem_out,
		mem_in => mem_in,
		mem_wr => mem_wr,   
		vga_hs => vga_hs,
		vga_vs => vga_vs,
		r => vga_r,
		g => vga_g,
		b => vga_b
	);
	mem_adr <= std_logic_vector(y) & std_logic_vector(x);	
	
	screen_test: process(clock, reset)
	

	begin
		if(reset = '0') then	
			mem_wr <= '0';		-----------------
			x <= to_unsigned(0, 7);	--initialization
			y <= to_unsigned(0, 6);	-- x=0 and y=0
			data <= "0000000";
			SV <= clean0;			
		elsif(clock'event AND clock = '1') then
			case SV is
				when clean0 =>	
					mem_wr <= '1';
					mem_in <= curr_char;
					
					case y is
						when to_unsigned(1,6) =>
							case x is
								when to_unsigned(1,7) =>
									curr_char <= "1000000";
								when to_unsigned(2,7) =>
									curr_char <= 7d"110";
								others => 
									curr_char <= 7d"0";
							end case;
					end case;
					SV <= clean1;	
				when clean1 =>
					x <= x+1;
					SV <= clean2;
				when clean2 =>
					mem_wr <= '0';	
					if(x> screen_width-1) then 
						x<= to_unsigned(0, 7);
						y <= y+1;
						SV <= clean3;
					else
						SV <= clean0;
					end if;
				when clean3 =>
					if(y > screen_height-1) then	
						SV <= done;	
					else
						SV <= clean0;
					end if;
				when done =>
					null;
				when others =>
					SV <= clean0;
			end case;
		end if;		
	end process;
end architecture DE1;
