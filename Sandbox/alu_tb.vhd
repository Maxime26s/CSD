LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use work.alu_constants.all;

entity alu_tb is
end alu_tb;

architecture test of alu_tb is
  signal a, b, c: std_logic_vector(8 downto 0);
  signal mode: std_logic_vector(2 downto 0);
begin
  DUT: alu port map (a, b, mode, c);

  process
  begin
    report "Testbench starting...";

    a <= "000000000";
    b <= "000000000";
    mode <= "000";
    wait for 10 ns;

    a <= "000000001";
    b <= "000000001";
    mode <= "010";
    wait for 10 ns;

    a <= "111111111";
    b <= "000000001";
    mode <= "010";
    wait for 10 ns;

    a <= "000000001";
    b <= "111111111";
    mode <= "010";
    wait for 10 ns;

    a <= "111111111";
    b <= "000000001";
    mode <= "011";
    wait for 10 ns;

    a <= "111111111";
    b <= "111111111";
    mode <= "011";
    wait for 10 ns;

    a <= "000000001";
    b <= "000000001";
    mode <= "011";
    wait for 10 ns;

	 a <= "000001010";
    b <= "000000010";
    mode <= "100";
    wait for 10 ns;
	 
	 a <= "000001010";
    b <= "000000010";
    mode <= "101";
    wait for 10 ns;
	 
	 a <= "000001010";
    mode <= "110";
    wait for 10 ns;
    wait;
  end process;
end architecture test;
