LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use work.addsub_constants.all;

entity addsub_tb is
end addsub_tb;

architecture test of addsub_tb is
  signal a, b, c: std_logic_vector(8 downto 0);
  signal mode: std_logic;
begin
  DUT: addsub port map (a, b, mode, c);

  process
  begin
    report "Testbench starting...";

    a <= "000000000";
    b <= "000000000";
    mode <= '0';
    wait for 10 ns;

    a <= "000000001";
    b <= "000000001";
    mode <= '0';
    wait for 10 ns;

    a <= "111111111";
    b <= "000000001";
    mode <= '0';
    wait for 10 ns;

    a <= "000000001";
    b <= "111111111";
    mode <= '1';
    wait for 10 ns;

    a <= "111111111";
    b <= "000000001";
    mode <= '1';
    wait for 10 ns;

    a <= "111111111";
    b <= "111111111";
    mode <= '1';
    wait for 10 ns;

    a <= "000000001";
    b <= "000000001";
    mode <= '1';
    wait for 10 ns;

    wait;
  end process;
end architecture test;
