LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use work.digit_converter_constants.all;

entity digit_converter_tb is
end digit_converter_tb;

architecture test of digit_converter_tb is
			signal data : std_logic_vector(8 downto 0);
			signal hundred, ten, unit : std_logic_vector(3 downto 0);
begin
  DUT: digit_converter port map (data, hundred, ten, unit);

  process
  begin
    report "Testbench starting...";

    data <= "000000001";
    wait for 10 ns;

    data <= "000001000";
    wait for 10 ns;
	 
	 data <= "001000000";
	 wait for 10 ns;
	 
	 data <= "100000000";
	 wait for 10 ns;
    wait;
  end process;
end architecture test;
