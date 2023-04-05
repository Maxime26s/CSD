LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.sseg_constants.all;
use work.processeur_constants.all;
use work.ff.all;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned;
use work.uart_constants.all;

ENTITY processeur_interface IS
	PORT (
		SW : in std_logic_vector(9 downto 0);
		KEY : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		CLOCK_50 : in std_logic;
		LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out std_logic_vector(6 downto 0);
		
		VGA_R, VGA_G, VGA_B : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		VGA_HS : OUT STD_LOGIC;
		VGA_VS : OUT STD_LOGIC;
		
		rx : in STD_LOGIC;
		tx : out STD_LOGIC
	);
END processeur_interface;

ARCHITECTURE arch OF processeur_interface IS
	FUNCTION ascii_to_ternary(input_vec : STD_LOGIC_VECTOR(7 DOWNTO 0)) RETURN STD_LOGIC_VECTOR IS
	BEGIN
		RETURN STD_LOGIC_VECTOR(unsigned(input_vec) - 48);
	END FUNCTION ascii_to_ternary;

	signal clk, rst : std_logic;
	signal buswire : std_logic_vector(8 downto 0);
	signal done, done_receiving : std_logic;
	signal uart_ascii : std_logic_vector(7 downto 0) := "00000000";
	signal count : std_logic_vector(1 downto 0);
	signal din : std_logic_vector(8 downto 0) := "000000000";
BEGIN
	d_key0 : entity work.debounce port map(CLOCK_50, KEY(0), clk);
	d_key1 : entity work.debounce port map(CLOCK_50, KEY(1), rst);
	
	processeur0: processeur PORT MAP (SW(0), clk, rst, din, buswire, done, CLOCK_50, KEY, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS);
	
	LEDR <= count & "0000000" & done;
	
	sseg0 : sseg port map(buswire(3 downto 0), HEX0);
	sseg1 : sseg port map(buswire(7 downto 4), HEX1);
	sseg2 : sseg port map("000" & buswire(8), HEX2);
	sseg3 : sseg port map("0" & din(2 downto 0), HEX3);
	sseg4 : sseg port map("0" & din(5 downto 3), HEX4);
	sseg5 : sseg port map("0" & din(8 downto 6), HEX5);
	
	uart0 : UART port map(CLOCK_50, rx, tx, done_receiving, uart_ascii, count);
	
	uartoutput : process(count)
	begin
		if done_receiving = '1' then
			if count = "00" then
				din(6) <= ascii_to_ternary(uart_ascii)(0);
				din(7) <= ascii_to_ternary(uart_ascii)(1);
				din(8) <= ascii_to_ternary(uart_ascii)(2);
			elsif count = "01" then
				din(3) <= ascii_to_ternary(uart_ascii)(0);
				din(4) <= ascii_to_ternary(uart_ascii)(1);
				din(5) <= ascii_to_ternary(uart_ascii)(2);
			elsif count = "10" then
				din(0) <= ascii_to_ternary(uart_ascii)(0);
				din(1) <= ascii_to_ternary(uart_ascii)(1);
				din(2) <= ascii_to_ternary(uart_ascii)(2);
			end if;
		end if;
	end process;
END arch;