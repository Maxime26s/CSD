library IEEE;
use IEEE.STD_Logic_1164.ALL;
use ieee.numeric_std.all;

entity PS is
	generic(
		baud_rate: integer := 9600;
		freq_clock_de10: integer := 50000000;
		n_bit: integer := 10
	);
	port(
		clk_in: in std_logic;
		clk_out_rx: out std_logic;
		clk_out_tx: out std_logic
	);
end PS;

architecture arch_PS of PS is
	begin
		process (clk_in)
		variable counter:			integer range 0 to 50000 :=0;							
		begin
			if(clk_in'event and clk_in='1') then
				counter := counter+1;
			end if;
			if(counter = (freq_clock_de10/baud_rate)*(n_bit-1)) then
				counter := 0;
				clk_out_rx <= '0';
			end if;
			if(counter = 0 or (counter mod(freq_clock_de10/baud_rate)) = 0) then
				clk_out_rx <= '1';
			end if;
		end process;
end arch_PS;