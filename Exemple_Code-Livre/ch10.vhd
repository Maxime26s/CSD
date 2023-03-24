-- Copyright (C) Tor M. Aamodt, UBC
-- synthesis VHDL_INPUT_VERSION VHDL_2008
-- Ensure your CAD synthesis tool/compiler is configured for VHDL-2008.


/*******************************************************************************
Copyright (c) 2012, Stanford University
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. All advertising materials mentioning features or use of this software
   must display the following acknowledgement:
   This product includes software developed at Stanford University.
4. Neither the name of Stanford Univerity nor the
   names of its contributors may be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY STANFORD UNIVERSITY ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*******************************************************************************/

library ieee;
use ieee.std_logic_1164.all;

package ch10 is

  component HalfAdder is
    port( a, b: in std_logic; 
          c, s: out std_logic ); -- carry and sum
  end component;

  component FullAdder is
    port( a, b, cin: std_logic; 
          cout, s: out std_logic ); -- carry and sum
  end component;

  component Adder is
    generic( n: integer := 8 );
    port( a, b : in std_logic_vector(n-1 downto 0);
          cin: in std_logic;
          cout: out std_logic; 
          s: out std_logic_vector(n-1 downto 0));
  end component;

  component AddSub is
    generic( n: integer := 8 );
    port( a, b: in std_logic_vector(n-1 downto 0);
          sub: in std_logic; -- subtract if sub=1, otherwise add
          s: out std_logic_vector(n-1 downto 0);
          ovf: out std_logic ); -- 1 if overflow
  end component;

  component Mul4 is
    port( a, b: in std_logic_vector(3 downto 0);
          p: out std_logic_vector(7 downto 0) );
  end component;
end package;

-- Figure 10.4
------------------------------------------------------------------------
-- half adder
library ieee;
use ieee.std_logic_1164.all;
entity HalfAdder is
  port( a, b: in std_logic; 
        c, s: out std_logic ); -- carry and sum
end HalfAdder;
architecture impl of HalfAdder is
begin
  s <= a xor b;
  c <= a and b;
end impl;
------------------------------------------------------------------------
-- full adder - from half adders
library ieee;
use ieee.std_logic_1164.all;
use work.ch10.all;
entity FullAdder is
  port( a, b, cin: in std_logic; 
        cout, s: out std_logic ); -- carry and sum
end FullAdder;
architecture impl of FullAdder is
  signal g, p: std_logic; -- generate and propagate
  signal cp: std_logic;
begin
  HA1: HalfAdder port map(a,b,g,p);
  HA2: HalfAdder port map(cin,p,cp,s);
  cout <= g or cp;
end impl;
-- full adder - logical
architecture logical_impl of FullAdder is
begin
  s <= a xor b xor cin;
  cout <= (a and b) or (a and cin) or (b and cin);
end logical_impl;


-- Figure 10.7
-- multi-bit adder - behavioral
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Adder is
  generic( n: integer := 8 );
  port( a, b : in std_logic_vector(n-1 downto 0);
        cin: in std_logic;
        cout: out std_logic; 
        s: out std_logic_vector(n-1 downto 0));
end Adder;

architecture impl of Adder is
  signal sum: std_logic_vector(n downto 0);
begin
  sum <= ('0' & a) + ('0' & b) + cin;
  cout <= sum(n);
  s <= sum(n-1 downto 0);
end impl;

-- Figure 10.8
-- multi-bit adder - bit-by-bit logical
architecture ripple_carry_impl of Adder is
  signal p, g: std_logic_vector(n-1 downto 0);
  signal c: std_logic_vector(n downto 0);
begin
  p <= a xor b; -- propagate
  g <= a and b; -- generate
  c <= (g or (p and c(n-1 downto 0))) & cin; -- carry = g or (p and c)
  s <= p xor c(n-1 downto 0); -- sum
  cout <= c(n);
end ripple_carry_impl;

-- Figure 10.13
-- add a+b or subtract a-b, check for overflow
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for behavioral_impl
use work.ch10.all;

entity AddSub is
  generic( n: integer := 8 );
  port( a, b: in std_logic_vector(n-1 downto 0);
        sub: in std_logic; -- subtract if sub=1, otherwise add
        s: out std_logic_vector(n-1 downto 0);
        ovf: out std_logic ); -- 1 if overflow
end AddSub;

architecture structural_impl of AddSub is
  signal c1, c2: std_logic; -- carry out of last two bits
begin
  ovf <= c1 xor c2; -- overflow if signs don't match

  -- add non sign bits
  Ai: Adder generic map(n-1) 
            port map( a(n-2 downto 0), b(n-2 downto 0) xor (n-2 downto 0 => sub),
                      sub, c1, s(n-2 downto 0) );
  -- add sign bits
  As: Adder generic map(1)
            port map( a(n-1 downto n-1), b(n-1 downto n-1) xor (0 downto 0 => sub),
                      c1, c2, s(n-1 downto n-1) );
end structural_impl;

-- Figure 10.14
-- add a+b or subtract a-b, check for overflow
architecture behavioral_impl of AddSub is
  signal c1, c2: std_logic; -- carry out of last two bits
  signal c1n: std_logic_vector(n-1 downto 0);
  signal c2s: std_logic_vector(1 downto 0);
begin
  -- overflow if signs don't match
  ovf <= c1 xor c2;
  -- add non sign bits
  c1n <= ('0'&a(n-2 downto 0)) + ('0'&(b(n-2 downto 0)xor(n-2 downto 0=>sub))) + sub;
  s(n-2 downto 0) <= c1n(n-2 downto 0);
  c1 <= c1n(n-1);
  -- add sign bits
  c2s <= ('0'&a(n-1)) + ('0'&(b(n-1) xor sub)) + c1; 
  s(n-1) <= c2s(0);
  c2 <= c2s(1);
end behavioral_impl;

-- Figure 10.16
-- 4-bit multiplier
library ieee;
use ieee.std_logic_1164.all;
use work.ch10.all;

entity Mul4 is
  port( a, b: in std_logic_vector(3 downto 0);
        p: out std_logic_vector(7 downto 0) );
end Mul4;

architecture impl of Mul4 is
  signal pp0, pp1, pp2, pp3, s1, s2, s3: std_logic_vector(3 downto 0);
  signal cout1, cout2, cout3: std_logic;
begin
  -- form partial products 
  pp0 <= a and (3 downto 0=>b(0));
  pp1 <= a and (3 downto 0=>b(1));
  pp2 <= a and (3 downto 0=>b(2));
  pp3 <= a and (3 downto 0=>b(3));

  -- sum up partial products
  A1: Adder generic map(4) port map(pp1, '0' & pp0(3 downto 1),'0',cout1,s1);
  A2: Adder generic map(4) port map(pp2,cout1 & s1(3 downto 1),'0',cout2,s2);
  A3: Adder generic map(4) port map(pp3,cout2 & s2(3 downto 1),'0',cout3,s3);

  -- collect the result
  p <= cout3 & s3 & s2(0) & s1(0) & pp0(0); 
end impl;

-- Figure 10.18, with a testbench below
-- Six-bit by three-bit divider
--   At each stage we use an adder to both subtract and compare.
--   The adders start 1-bit wide and grow to 4 bits wide.
--   We check the bits of x to the left of the adder as part of
--   the comparison.
--   Starting with the fourth iteration (that computes q[2]) we
--   drop a bit of the remainder each iteration.  It is guaranteed
--   to be zero.

library ieee;
use ieee.std_logic_1164.all;
use work.ch10.all;

entity Divide is
  port( y: in std_logic_vector( 5 downto 0 ); -- dividend
        x: in std_logic_vector( 2 downto 0 ); -- divisor
        q: buffer std_logic_vector( 5 downto 0 ); -- quotient
        r: out std_logic_vector( 2 downto 0 ) ); -- remainder
end Divide;
architecture impl of Divide is
  signal co5, co4, co3, co2, co1, co0: std_logic;  -- carry out of adders
  signal sum5: std_logic_vector(0 downto 0); -- sum out of adder - stage 1
  signal sum4: std_logic_vector(1 downto 0); -- sum out of adder - stage 2
  signal sum3: std_logic_vector(2 downto 0); -- sum out of adder - stage 3
  signal sum2, sum1, sum0: std_logic_vector(3 downto 0); -- sum out of adder - stage 4, 5, 6
  signal r4, r3, r2: std_logic_vector(5 downto 0);
  signal r1: std_logic_vector(4 downto 0);
  signal r0: std_logic_vector(3 downto 0);
begin
  SUB5: Adder generic map(1) port map(y(5 downto 5),not x(0 downto 0),'1',co5,sum5);
  q(5) <= co5 and not (x(2) or x(1)); -- if x<<5 bigger than y, q(5) is 0
  r4 <= (sum5 & y(4 downto 0)) when q(5) else y;

  SUB4: Adder generic map(2) port map(r4(5 downto 4),not x(1 downto 0),'1',co4,sum4);
  q(4) <= co4 and not x(2); -- compare
  r3 <= (sum4 & r4(3 downto 0)) when q(4) else r4;

  SUB3: Adder generic map(3) port map(r3(5 downto 3),not x(2 downto 0),'1',co3,sum3);
  q(3) <= co3; -- compare
  r2 <= (sum3 & r3(2 downto 0)) when q(3) else r3;

  SUB2: Adder generic map(4) port map(r2(5 downto 2),'1' & not x,'1',co2,sum2);
  q(2) <= co2; -- compare
  r1 <= (sum2(2 downto 0) & r2(1 downto 0)) when q(2) else r2(4 downto 0); -- msb is zero, drop it

  SUB1: Adder generic map(4) port map(r1(4 downto 1),'1' & not x,'1',co1,sum1);
  q(1) <= co1; -- compare
  r0 <= (sum1(2 downto 0) & r1(0)) when q(1) else r1(3 downto 0); -- msb is zero, drop it

  SUB0: Adder generic map(4) port map(r0(3 downto 0),'1' & not x,'1',co0,sum0);
  q(0) <= co0; -- compare
  r <= sum0(2 downto 0) when q(0) else r0(2 downto 0); -- msb is zero, drop it
end impl;

------------------------------------------------------------------------
-- testbenches

-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity DivTest is
end DivTest;

architecture test of DivTest is
  signal y: std_logic_vector(5 downto 0);
  signal x: std_logic_vector(2 downto 0);
  signal err: std_logic;
  signal q: std_logic_vector(5 downto 0);
  signal r: std_logic_vector(2 downto 0);
begin
  DUT: entity work.Divide(impl) port map(y, x, q, r);

  process begin
    y <= 6d"1"; x <= 3d"1"; err <= '0';
    for i in 1 to 7 loop
      for j in 1 to 64 loop
        wait for 10 ns;
        report integer'image(to_integer(unsigned(x))) & " " & 
               integer'image(to_integer(unsigned(y))) & " " & 
               integer'image(to_integer(unsigned(q))) & " " & 
               integer'image(to_integer(unsigned(r)));
        if ((x * q) + r) /= y then 
          err <= '1';
          report "ERROR";
        end if;
        y <= y + 1 ;
      end loop;
      x <= x + 1 ;
    end loop;
    if err = '0' then report "PASSED"; else report "FAILED"; end if;
    wait;
  end process;
end test;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity testbench_AddSub is
end testbench_AddSub;

architecture test of testbench_AddSub is
  signal a, b : std_logic_vector(3 downto 0);
  signal s1, s2 : std_logic_vector(3 downto 0);
  signal o1, o2, sub, err : std_logic;
begin
  DUT1: entity work.AddSub(behavioral_impl) generic map(4) port map(a,b,sub,s1,o1);
  DUT2: entity work.AddSub(structural_impl) generic map(4) port map(a,b,sub,s2,o2);

  process
    variable e: std_logic;
  begin
    err <= '0';
    for s in 0 to 1 loop 
      sub <= '0';
      if s = 1 then sub <= '1'; end if;
      for i in 0 to 15 loop 
        a <= conv_std_logic_vector(i,4);
        for j in 0 to 15 loop 
          b <= conv_std_logic_vector(j,4); 
	        e := '0';
          wait for 10 ns;

          report "a=" & to_string(a) & "; b=" & to_string(b) & "; s1=" & to_string(s1) & "; s2=" & to_string(s2);
          if s1 /= s2 then
            e := '1';
          end if;
          if (sub = '0') and (s1 /= (a+b)) then
            e := '1';
          end if;
          if (sub = '1') and (s1 /= (a-b)) then
            e := '1';
          end if;
          if o1 /= o2 then
            e := '1';
          end if;
          if e then
            err <= '1';
          end if;
        end loop;
      end loop;
    end loop;
    if err = '0' then report "PASSED"; end if;
    wait;
  end process;
end test;


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity testbench_Mul4 is
end testbench_Mul4;

architecture test of testbench_Mul4 is
  signal a, b : std_logic_vector(3 downto 0);
  signal output : std_logic_vector(7 downto 0);
  signal err : std_logic;
begin
  DUT: entity work.Mul4(impl) port map(a,b,output);

  process
    variable prod : std_logic_vector(7 downto 0);
  begin
    err <= '0';
    for i in 0 to 15 loop 
      a <= conv_std_logic_vector(i,4);
      for j in 0 to 15 loop 
        b <= conv_std_logic_vector(j,4); 
        wait for 10 ns;
        prod := a * b;

        report "a=" & to_string(a) & "; b=" & to_string(b) & "; prod=" & to_string(output);
        if not (prod = output) then
          err <= '1';
        end if;
      end loop;
    end loop;
    if err = '0' then report "PASSED"; else report "FAILED"; end if;
    wait;
  end process;
end test;

-- pragma translate_on
