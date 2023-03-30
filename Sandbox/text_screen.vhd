LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned;

PACKAGE text_screen_constants IS
	COMPONENT text_screen IS
		PORT (
			CLOCK_50 : IN STD_LOGIC;
			KEY : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			VGA_R, VGA_G, VGA_B : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			VGA_HS : OUT STD_LOGIC;
			VGA_VS : OUT STD_LOGIC;

			cpu_clk : IN STD_LOGIC;
			reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, din : IN STD_LOGIC_VECTOR(8 DOWNTO 0)
		);
	END COMPONENT;
END PACKAGE;

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned;
USE work.digit_converter_constants.ALL;

ENTITY text_screen IS
	PORT (
		CLOCK_50 : IN STD_LOGIC;
		KEY : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		VGA_R, VGA_G, VGA_B : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		VGA_HS : OUT STD_LOGIC;
		VGA_VS : OUT STD_LOGIC;

		cpu_clk : IN STD_LOGIC;
		reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, din : IN STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
END text_screen;

ARCHITECTURE DE1 OF text_screen IS

	FUNCTION ascii_to_vector(input_num : INTEGER) RETURN STD_LOGIC_VECTOR IS
	BEGIN
		RETURN STD_LOGIC_VECTOR(to_unsigned(input_num, 7));
	END FUNCTION ascii_to_vector;

	FUNCTION ternary_to_ascii(input_vec : STD_LOGIC_VECTOR(2 DOWNTO 0)) RETURN INTEGER IS
	BEGIN
		RETURN to_integer(to_unsigned(to_integer(unsigned(input_vec)), 7) + 48);
	END FUNCTION ternary_to_ascii;

	FUNCTION nibble_to_ascii(input_vec : STD_LOGIC_VECTOR(3 DOWNTO 0)) RETURN INTEGER IS
	BEGIN
		RETURN to_integer(to_unsigned(to_integer(unsigned(input_vec)), 7) + 48);
	END FUNCTION nibble_to_ascii;

	ALIAS clock : STD_LOGIC IS Clock_50;
	ALIAS reset : STD_LOGIC IS KEY(1);
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

	SIGNAL reg0h, reg0t, reg0u : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL reg1h, reg1t, reg1u : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL reg2h, reg2t, reg2u : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL reg3h, reg3t, reg3u : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL reg4h, reg4t, reg4u : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL reg5h, reg5t, reg5u : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL reg6h, reg6t, reg6u : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL reg7h, reg7t, reg7u : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

	dc0 : digit_converter PORT MAP(reg0, reg0h, reg0t, reg0u);
	dc1 : digit_converter PORT MAP(reg1, reg1h, reg1t, reg1u);
	dc2 : digit_converter PORT MAP(reg2, reg2h, reg2t, reg2u);
	dc3 : digit_converter PORT MAP(reg3, reg3h, reg3t, reg3u);
	dc4 : digit_converter PORT MAP(reg4, reg4h, reg4t, reg4u);
	dc5 : digit_converter PORT MAP(reg5, reg5h, reg5t, reg5u);
	dc6 : digit_converter PORT MAP(reg6, reg6h, reg6t, reg6u);
	dc7 : digit_converter PORT MAP(reg7, reg7h, reg7t, reg7u);

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
	screen_test : PROCESS (clock, reset, cpu_clk)
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
									curr_char <= ascii_to_vector(78);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(83);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(84);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(82);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(85);
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(67);
								WHEN to_unsigned(8, 7) =>
									curr_char <= ascii_to_vector(84);
								WHEN to_unsigned(9, 7) =>
									curr_char <= ascii_to_vector(73);
								WHEN to_unsigned(10, 7) =>
									curr_char <= ascii_to_vector(79);
								WHEN to_unsigned(11, 7) =>
									curr_char <= ascii_to_vector(78);
								WHEN to_unsigned(12, 7) =>
									curr_char <= ascii_to_vector(83);
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN to_unsigned(3, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(77);
								WHEN to_unsigned(2, 7) =>
									curr_char <= ascii_to_vector(86);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(32);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(32);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(48);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(48);
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(48);
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN to_unsigned(4, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(77);
								WHEN to_unsigned(2, 7) =>
									curr_char <= ascii_to_vector(86);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(73);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(32);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(48);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(48);
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(49);
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN to_unsigned(5, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(65);
								WHEN to_unsigned(2, 7) =>
									curr_char <= ascii_to_vector(68);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(68);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(32);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(48);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(49);
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(48);
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN to_unsigned(6, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(83);
								WHEN to_unsigned(2, 7) =>
									curr_char <= ascii_to_vector(85);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(66);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(32);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(48);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(49);
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(49);
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN to_unsigned(7, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(77);
								WHEN to_unsigned(2, 7) =>
									curr_char <= ascii_to_vector(85);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(76);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(32);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(49);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(48);
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(48);
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN to_unsigned(8, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(68);
								WHEN to_unsigned(2, 7) =>
									curr_char <= ascii_to_vector(73);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(86);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(32);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(49);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(48);
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(49);
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN to_unsigned(9, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(80);
								WHEN to_unsigned(2, 7) =>
									curr_char <= ascii_to_vector(79);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(87);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(32);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(49);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(49);
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(48);
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN to_unsigned(10, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(67);
								WHEN to_unsigned(2, 7) =>
									curr_char <= ascii_to_vector(76);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(82);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(32);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(49);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(49);
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(49);
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN to_unsigned(12, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(95);
								WHEN to_unsigned(2, 7) =>
									curr_char <= ascii_to_vector(95);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(95);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(95);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(95);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(95);
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(95);
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN to_unsigned(15, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(82);
								WHEN to_unsigned(2, 7) =>
									curr_char <= ascii_to_vector(69);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(71);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(73);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(83);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(84);
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(82);
								WHEN to_unsigned(8, 7) =>
									curr_char <= ascii_to_vector(69);
								WHEN to_unsigned(9, 7) =>
									curr_char <= ascii_to_vector(83);
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN to_unsigned(17, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(82);
								WHEN to_unsigned(2, 7) =>
									curr_char <= ascii_to_vector(69);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(71);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(48);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(32);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg0h));
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg0t));
								WHEN to_unsigned(8, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg0u));
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN to_unsigned(18, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(82);
								WHEN to_unsigned(2, 7) =>
									curr_char <= ascii_to_vector(69);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(71);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(49);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(32);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg1h));
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg1t));
								WHEN to_unsigned(8, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg1u));
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN to_unsigned(19, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(82);
								WHEN to_unsigned(2, 7) =>
									curr_char <= ascii_to_vector(69);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(71);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(50);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(32);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg2h));
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg2t));
								WHEN to_unsigned(8, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg2u));
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN to_unsigned(20, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(82);
								WHEN to_unsigned(2, 7) =>
									curr_char <= ascii_to_vector(69);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(71);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(51);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(32);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg3h));
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg3t));
								WHEN to_unsigned(8, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg3u));
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN to_unsigned(21, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(82);
								WHEN to_unsigned(2, 7) =>
									curr_char <= ascii_to_vector(69);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(71);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(52);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(32);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg4h));
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg4t));
								WHEN to_unsigned(8, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg4u));
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN to_unsigned(22, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(82);
								WHEN to_unsigned(2, 7) =>
									curr_char <= ascii_to_vector(69);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(71);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(53);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(32);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg5t));
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg5h));
								WHEN to_unsigned(8, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg5u));
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN to_unsigned(23, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(82);
								WHEN to_unsigned(2, 7) =>
									curr_char <= ascii_to_vector(69);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(71);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(54);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(32);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg6h));
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg6t));
								WHEN to_unsigned(8, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg6u));
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN to_unsigned(24, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(82);
								WHEN to_unsigned(2, 7) =>
									curr_char <= ascii_to_vector(69);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(71);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(55);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(32);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg7h));
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg7t));
								WHEN to_unsigned(8, 7) =>
									curr_char <= ascii_to_vector(nibble_to_ascii(reg7u));
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN to_unsigned(26, 6) =>
							CASE x IS
								WHEN to_unsigned(1, 7) =>
									curr_char <= ascii_to_vector(68);
								WHEN to_unsigned(2, 7) =>
									curr_char <= ascii_to_vector(73);
								WHEN to_unsigned(3, 7) =>
									curr_char <= ascii_to_vector(78);
								WHEN to_unsigned(4, 7) =>
									curr_char <= ascii_to_vector(32);
								WHEN to_unsigned(5, 7) =>
									curr_char <= ascii_to_vector(32);
								WHEN to_unsigned(6, 7) =>
									curr_char <= ascii_to_vector(ternary_to_ascii(din(8 DOWNTO 6)));
								WHEN to_unsigned(7, 7) =>
									curr_char <= ascii_to_vector(ternary_to_ascii(din(5 DOWNTO 3)));
								WHEN to_unsigned(8, 7) =>
									curr_char <= ascii_to_vector(ternary_to_ascii(din(2 DOWNTO 0)));
								WHEN OTHERS => curr_char <= ascii_to_vector(32);
							END CASE;
						WHEN OTHERS => curr_char <= ascii_to_vector(32);
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
					IF cpu_clk = '1' THEN
						SV <= clean0;
					END IF;
				WHEN OTHERS =>
					SV <= clean0;
			END CASE;
		END IF;
	END PROCESS;
END ARCHITECTURE DE1;