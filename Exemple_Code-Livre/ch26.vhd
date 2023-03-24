-- Copyright (C) Tor M. Aamodt, UBC

library ieee;
use ieee.std_logic_1164.all;

entity Div3 is
  port( rst, a: in std_logic;
        q: out std_logic );
end Div3;

architecture impl of Div3 is
  signal r, s: std_logic;
begin
  q <= not rst and ((not r and q) or (not r and a) or (q and a));
  r <= not rst and ((s and a) or ( s and r) or (a and r));
  s <= not rst and ((s and not a) or (s and q) or (q and not a));
end impl; -- Div3
