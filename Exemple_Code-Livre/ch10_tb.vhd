

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fa is
end tb_fa;

architecture test of tb_fa is
  signal a, b, cin, s, cout: std_logic;
begin
  DUT: entity work.FullAdder(logical_impl) port map(a,b,cin,cout,s);
  process begin
    for i in 0 to 7 loop
      (a,b,cin) <= to_unsigned(i,3);
      wait for 1 ns;
      report "(a,b,cin) = " & to_string( std_logic_vector'(a&b&cin) ) & ", (s,cout) = " & to_string(std_logic_vector'(cout,s));
    end loop;
    wait;
  end process;
end test;
