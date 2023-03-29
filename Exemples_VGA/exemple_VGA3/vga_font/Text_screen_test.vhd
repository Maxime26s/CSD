LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned;

ENTITY Text_screen_test IS
	PORT (
		CLOCK_50 : IN STD_LOGIC;
		KEY : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		VGA_R, VGA_G, VGA_B : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		VGA_HS : OUT STD_LOGIC;
		VGA_VS : OUT STD_LOGIC
	);
END Text_screen_test;

ARCHITECTURE DE1 OF Text_screen_test IS
	ALIAS clock : STD_LOGIC IS Clock_50;
	ALIAS reset : STD_LOGIC IS KEY(0);
	CONSTANT screen_width : INTEGER := 80;
	CONSTANT screen_height : INTEGER := 60;

	SIGNAL mem_in, mem_out : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL mem_adr : STD_LOGIC_VECTOR(12 DOWNTO 0);
	SIGNAL mem_wr : STD_LOGIC;
	SIGNAL x : unsigned(6 DOWNTO 0);
	SIGNAL y : unsigned(5 DOWNTO 0);

	TYPE state IS (clean0, clean1, clean2, clean3, done);
	SIGNAL SV : state;

	-- Define a signal for the current character to write to the screen
	SIGNAL curr_char : STD_LOGIC_VECTOR(6 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(32, 7));
	
	signal din : std_logic_vector(8 downto 0) := "101010101";
	
	function ascii_to_vector(input_num : integer) return std_logic_vector is
begin
  return std_logic_vector(to_unsigned(input_num, 7));
end function ascii_to_vector;

function ternary_to_ascii(input_vec : std_logic_vector(2 downto 0)) return integer is
begin
  return to_integer(to_unsigned(to_integer(unsigned(input_vec)),7) + 48);
end function ternary_to_ascii;

BEGIN
	vga : ENTITY work.vga_font PORT MAP(--VGA with font table. 
		clock => clock,
		reset => NOT reset,
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
	mem_adr <= STD_LOGIC_VECTOR(y) & STD_LOGIC_VECTOR(x);

	screen_test : PROCESS (clock, reset)
	BEGIN
		IF (reset = '0') THEN
			mem_wr <= '0'; -----------------
			x <= to_unsigned(0, 7); --initialization
			y <= to_unsigned(0, 6); -- x=0 and y=0
			SV <= clean0;
		ELSIF (clock'event AND clock = '1') THEN
			CASE SV IS
				WHEN clean0 =>
					mem_wr <= '1';
					mem_in <= curr_char;

					CASE y IS
						WHEN to_unsigned(1, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(73);
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(78, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(83, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(84, 7));
								WHEN to_unsigned(5, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(82, 7));
								WHEN to_unsigned(6, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(85, 7));
								WHEN to_unsigned(7, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(67, 7));
								WHEN to_unsigned(8, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(84, 7));
								WHEN to_unsigned(9, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(73, 7));
								WHEN to_unsigned(10, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(79, 7));
								WHEN to_unsigned(11, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(78, 7));
								WHEN to_unsigned(12, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(83, 7));
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN to_unsigned(3, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(77, 7));
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(86, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
								WHEN to_unsigned(5, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(48, 7));
								WHEN to_unsigned(6, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(48, 7));
								WHEN to_unsigned(7, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(48, 7));
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN to_unsigned(4, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(77, 7));
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(86, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(73, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
								WHEN to_unsigned(5, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(48, 7));
								WHEN to_unsigned(6, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(48, 7));
								WHEN to_unsigned(7, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(49, 7));
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN to_unsigned(5, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(65, 7));
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(68, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(68, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
								WHEN to_unsigned(5, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(48, 7));
								WHEN to_unsigned(6, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(49, 7));
								WHEN to_unsigned(7, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(48, 7));
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN to_unsigned(6, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(83, 7));
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(85, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(66, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
								WHEN to_unsigned(5, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(48, 7));
								WHEN to_unsigned(6, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(49, 7));
								WHEN to_unsigned(7, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(49, 7));
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN to_unsigned(7, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(77, 7));
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(85, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(76, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
								WHEN to_unsigned(5, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(49, 7));
								WHEN to_unsigned(6, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(48, 7));
								WHEN to_unsigned(7, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(48, 7));
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN to_unsigned(8, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(68, 7));
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(73, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(86, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
								WHEN to_unsigned(5, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(49, 7));
								WHEN to_unsigned(6, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(48, 7));
								WHEN to_unsigned(7, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(49, 7));
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN to_unsigned(9, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(80, 7));
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(79, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(87, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
								WHEN to_unsigned(5, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(49, 7));
								WHEN to_unsigned(6, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(49, 7));
								WHEN to_unsigned(7, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(48, 7));
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN to_unsigned(10, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(67, 7));
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(76, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(82, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
								WHEN to_unsigned(5, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(49, 7));
								WHEN to_unsigned(6, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(49, 7));
								WHEN to_unsigned(7, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(49, 7));
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN to_unsigned(12, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(95, 7));
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(95, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(95, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(95, 7));
								WHEN to_unsigned(5, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(95, 7));
								WHEN to_unsigned(6, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(95, 7));
								WHEN to_unsigned(7, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(95, 7));
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN to_unsigned(15, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(82, 7));
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(69, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(71, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(73, 7));
								WHEN to_unsigned(5, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(83, 7));
								WHEN to_unsigned(6, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(84, 7));
								WHEN to_unsigned(7, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(82, 7));
								WHEN to_unsigned(8, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(69, 7));
								WHEN to_unsigned(9, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(83, 7));
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN to_unsigned(17, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(82, 7));
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(69, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(71, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(48, 7));
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN to_unsigned(18, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(82, 7));
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(69, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(71, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(49, 7));
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN to_unsigned(19, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(82, 7));
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(69, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(71, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(50, 7));
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN to_unsigned(20, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(82, 7));
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(69, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(71, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(51, 7));
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN to_unsigned(21, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(82, 7));
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(69, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(71, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(52, 7));
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN to_unsigned(22, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(82, 7));
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(69, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(71, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(53, 7));
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN to_unsigned(23, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(82, 7));
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(69, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(71, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(54, 7));
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN to_unsigned(24, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(82, 7));
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(69, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(71, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(55, 7));
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN to_unsigned(26, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(68, 7));
								WHEN to_unsigned(2, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(73, 7));
								WHEN to_unsigned(3, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(78, 7));
								WHEN to_unsigned(4, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
								WHEN to_unsigned(5, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(ternary_to_ascii(din(8 downto 6)));--STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(din(8 downto 6))),7) + 48);
								WHEN to_unsigned(7, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(din(5 downto 3))),7) + 48);
								WHEN to_unsigned(8, 7) =>
									curr_char <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(din(2 downto 0))),7) + 48);
								WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
							END CASE;
						WHEN OTHERS => curr_char <= STD_LOGIC_VECTOR(to_unsigned(32, 7));
					END CASE;
					SV <= clean1;
				WHEN clean1 =>
					x <= x + 1;
					SV <= clean2;
				WHEN clean2 =>
					mem_wr <= '0';
					IF (x > screen_width - 1) THEN
						x <= to_unsigned(0, 7);
						y <= y + 1;
						SV <= clean3;
					ELSE
						SV <= clean0;
					END IF;
				WHEN clean3 =>
					IF (y > screen_height - 1) THEN
						SV <= done;
					ELSE
						SV <= clean0;
					END IF;
				WHEN done =>
					NULL;
				WHEN OTHERS =>
					SV <= clean0;
			END CASE;
		END IF;
	END PROCESS;
END ARCHITECTURE DE1;