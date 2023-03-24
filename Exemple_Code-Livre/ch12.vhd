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

-- this file requires modules from ch10.vhd

library ieee;
package ch12 is
  use ieee.std_logic_1164.all;

  component Cla8 is
  port( a, b: in std_logic_vector(7 downto 0);
        ci: in std_logic;
        co: out std_logic_vector(8 downto 0) );
  end component;

  component PG4 is
    port( pi, gi: in std_logic_vector(3 downto 0);
          po, go: out std_logic );
  end component;

  component Carry4 is
    port( ci: in std_logic; p, g: in std_logic_vector(2 downto 0); 
          co: out std_logic_vector(2 downto 0) );
  end component;

  component Recode4  is
    port( b: in std_logic_vector(2 downto 0);
          d: out std_logic_vector(2 downto 0) );
  end component;
end package;

-- Figure 12.4
-- 8-bit carry look ahead 
-- takes 8-bit inputs a and b, ci and produces co ;
-- this module generates many unused signals which the synthesizer optimizes away
library ieee;
use ieee.std_logic_1164.all;

entity Cla8 is
  port( a, b: in std_logic_vector(7 downto 0);
        ci: in std_logic;
        co: out std_logic_vector(8 downto 0) );
end Cla8;

architecture impl of Cla8 is
  signal p, g, p2, g2, p4, g4, p8, g8: std_logic_vector(7 downto 0);
  signal coi: std_logic_vector(8 downto 0);
begin
  -- input stage of PG cells
  p <= a xor b;
  g <= a and b;

  -- p and g across multiple bits
  -- px(i)/gx(i) is propagate/generate across x bits strating at bit i
  p2 <= p and ('0' & p(7 downto 1)); -- across pairs - only 0,2,4,6 used
  g2 <= ('0' & g(7 downto 1)) or (g and ('0' & p(7 downto 1))); 
  p4 <= p2 and ("00" & p2(7 downto 2)); -- across nybbles - only 0,4 used
  g4 <= ("00" & g2(7 downto 2)) or (g2 and ("00" & p2(7 downto 2)));
  p8 <= p4 and ("0000" & p4(7 downto 4)); -- across byte - only 0 used
  g8 <= ("0000" & g4(7 downto 4)) or (g4 and ("0000" & p4(7 downto 4)));

  -- first level of output, derived from ci      
  coi(0) <= ci;
  coi(8) <= g8(0) or (ci and p8(0));
  coi(4) <= g4(0) or (ci and p4(0));
  coi(2) <= g2(0) or (ci and p2(0));
  coi(1) <= g(0) or (ci and p(0));

  -- second level of output, derived from first level
  coi(6) <= g2(4) or (coi(4) and p2(4));
  coi(5) <= g(4) or (coi(4) and p(4));
  coi(3) <= g(2) or (coi(2) and p(2));

  -- final level of output derived from second level
  coi(7) <= g(6) or (coi(6) and p(6));
  co <= coi;
end impl;


library ieee;
use ieee.std_logic_1164.all;
use work.ch12.all;

entity ClaAdder8 is
  port( a, b: in std_logic_vector(7 downto 0);
        ci: in std_logic;
        s: out std_logic_vector(7 downto 0);
        co: out std_logic );
end ClaAdder8;

architecture impl of ClaAdder8 is
  signal c: std_logic_vector(8 downto 0);
begin
  CLA: Cla8 port map(a,b,ci,c);
  SUM: for i in 0 to 7 generate
         s(i) <= a(i) xor b(i) xor c(i);
  end generate;
  co <= c(8);
end impl;


-- Figure 12.7
-- four-bit PG module
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
entity PG4 is
  port( pi, gi: in std_logic_vector(3 downto 0);
        po, go: out std_logic );
end PG4;
architecture impl of PG4 is
begin
  po <= and_reduce(pi);
  go <= gi(3) or (gi(2) and pi(3)) or (gi(1) and pi(3) and pi(2)) or 
	(gi(0) and pi(3) and pi(2) and pi(1));
end impl;
------------------------------------------------------------------------
-- four-bit carry module
library ieee;
use ieee.std_logic_1164.all;
entity Carry4 is
  port( ci: in std_logic; p, g: in std_logic_vector(2 downto 0); 
        co: out std_logic_vector(2 downto 0) );
end Carry4;
architecture impl of Carry4 is
  signal gg: std_logic_vector(3 downto 0);
begin
  gg <= g & ci;
  co <= gg(3 downto 1) or (gg(2 downto 0) and p) or 
        ((gg(1 downto 0) & '0') and p and (p(1 downto 0) & '0')) or
        ((gg(0) & "00") and p and (p(1 downto 0)&'0') and (p(0) & "00"));
end impl;

-- Figure 12.6
-- 16-bit radix-4 carry look ahead
library ieee;
use ieee.std_logic_1164.all;
use work.ch12.all;

entity Cla16 is
  port( a, b: in std_logic_vector(15 downto 0);
        ci: in std_logic;
        co: out std_logic_vector(16 downto 0) );
end Cla16;

architecture impl of Cla16 is
  signal p, g: std_logic_vector(15 downto 0);
  signal p4, g4: std_logic_vector(3 downto 0);
  signal p16, g16: std_logic;
  signal co1284: std_logic_vector(2 downto 0);
begin
  -- input stage of PG cells
  p <= a xor b;
  g <= a and b;

  --  input PG stage
  PG10: PG4 port map(p(3 downto 0),g(3 downto 0),p4(0),g4(0));
  PG11: PG4 port map(p(7 downto 4),g(7 downto 4),p4(1),g4(1));
  PG12: PG4 port map(p(11 downto 8),g(11 downto 8),p4(2),g4(2));
  PG13: PG4 port map(p(15 downto 12),g(15 downto 12),p4(3),g4(3));

  -- p and g across 16-bits 
  PG2: PG4 port map(p4, g4, p16, g16);

  -- MSB and LSB of carry
  co(16) <= g16 or (ci and p16);
  co(0) <= ci;

  -- first level of carry
  C10: Carry4 port map(ci,p4(2 downto 0), g4(2 downto 0),co1284);
  co(12) <= co1284(2);
  co(8) <= co1284(1);
  co(4) <= co1284(0);

  -- second level of carry
  C20: Carry4 port map(ci,p(2 downto 0),g(2 downto 0),co(3 downto 1));
  C21: Carry4 port map(co1284(0),p(6 downto 4),g(6 downto 4),co(7 downto 5));
  C22: Carry4 port map(co1284(1),p(10 downto 8),g(10 downto 8),co(11 downto 9));
  C23: Carry4 port map(co1284(2),p(14 downto 12),g(14 downto 12),co(15 downto 13));
end impl;

--
library ieee;
use ieee.std_logic_1164.all;

entity ClaAdder16 is
  port( a, b: in std_logic_vector(15 downto 0);
        ci: in std_logic;
        s: out std_logic_vector(15 downto 0);
        co: out std_logic );
end ClaAdder16;

architecture impl of ClaAdder16 is
  signal c: std_logic_vector(16 downto 0);
begin
  CLA: entity work.Cla16(impl) port map(a,b,ci,c);
  SUM: for i in 0 to 15 generate
         s(i) <= a(i) xor b(i) xor c(i);
  end generate;
  co <= c(16);
end impl;

------------------------------------------------------------------------
-- Figure 12.11
-- Radix-4 recode block
-- Output is invert, select 2, select 1.
library ieee;
use ieee.std_logic_1164.all;

entity Recode4  is
  port( b: in std_logic_vector(2 downto 0);
        d: out std_logic_vector(2 downto 0) );
end Recode4;

architecture impl of Recode4 is
begin
  process(all) begin
    case b is
      when "000" | "111" => d <= "000"; -- no select, no invert
      when "001" | "010" => d <= "001"; -- select 1
      when "011"         => d <= "010"; -- select 2
      when "100"         => d <= "110"; -- select 2, invert
      when "101" | "110" => d <= "101"; -- select 1, invert
      when others        => d <= "000"; -- should never be selected
    end case;
  end process;
end impl;

-- Figure 12.10
-- 6-bit x 4-bit radix 4 Booth multiplier
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use work.ch12.all;

entity R4Mult64 is
  port( a: in std_logic_vector(3 downto 0);
        b: in std_logic_vector(5 downto 0);
        s: out std_logic_vector(9 downto 0) );
end R4Mult64;

architecture impl of R4Mult64 is
  -- recoded digits - {negate, select2, select1}
  signal d2, d1, d0: std_logic_vector(2 downto 0);
  signal pp0, pp1, pp2: std_logic_vector(4 downto 0);
  signal ps0, ps1, ps2: std_logic_vector(5 downto 0);
  signal bi: std_logic_vector(6 downto 0);
begin
  bi <= b & '0';
  -- Recoders
  R0: Recode4 port map(bi(2 downto 0), d0);
  R1: Recode4 port map(bi(4 downto 2), d1);
  R2: Recode4 port map(bi(6 downto 4), d2);

  -- Selectors - in equation form - sign extend on select 1 (d(0))
  pp0 <= (4 downto 0 => d0(2)) xor (((4 downto 0 => d0(1)) and (a & '0'))
           or ((4 downto 0 => d0(0)) and (a(3) & a)));
  pp1 <= (4 downto 0 => d1(2)) xor (((4 downto 0 => d1(1)) and (a & '0'))
           or ((4 downto 0 => d1(0)) and (a(3) & a)));
  pp2 <= (4 downto 0 => d2(2)) xor (((4 downto 0 => d2(1)) and (a & '0'))
           or ((4 downto 0 => d2(0)) and (a(3) & a)));
   
  -- Adders - behavioral - sign extend partial sums
  ps0 <= (pp0(4) & pp0) + ("0000" & d0(2));
  ps1 <= (pp1(4) & pp1) + ((2 downto 0 => ps0(5)) & ps0(4 downto 2)) 
           + ("0000" & d1(2)); -- second row of adders
  ps2 <= (pp2(4) & pp2) + ((2 downto 0 => ps1(5)) & ps1(4 downto 2))
           + ("0000" & d2(2)); -- third row of adders

  -- Output
  s <= ps2 & ps1(1 downto 0) & ps0(1 downto 0);
end impl;

-- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use work.ch10.all;

entity MultiAdder_FA_Tree is
  port(	in0, in1, in2, in3, in4, in5: in std_logic_vector(3 downto 0);
        output: out std_logic_vector(6 downto 0) );
end MultiAdder_FA_Tree;

architecture impl of MultiAdder_FA_Tree is
  signal se_in0, se_in1, se_in2, se_in3, se_in4, se_in5: std_logic_vector(6 downto 0);
  signal s00, s01, s10, s20: std_logic_vector(6 downto 0); -- s(level)(unit)
  signal c00, c01, c10, c20: std_logic_vector(6 downto 0); -- c(level)(unit)
  signal toss: std_logic_vector(3 downto 0); -- outputs thrown away as bit 7 not needed
begin
  -- sign extend the inputs
  se_in0 <= in0(3) & in0(3) & in0(3) & in0;
  se_in1 <= in1(3) & in1(3) & in1(3) & in1;
  se_in2 <= in2(3) & in2(3) & in2(3) & in2;
  se_in3 <= in3(3) & in3(3) & in3(3) & in3;
  se_in4 <= in4(3) & in4(3) & in4(3) & in4;
  se_in5 <= in5(3) & in5(3) & in5(3) & in5;

  --  Set lower bit carry ins to 0
  c00(0) <= '0'; c01(0) <= '0';
  c10(0) <= '0'; c20(0) <= '0';

  FA01_0: FullAdder port map(se_in0(0),se_in1(0),se_in2(0),c00(1),s00(0));
  FA02_0: FullAdder port map(se_in3(0),se_in4(0),se_in5(0),c01(1),s01(0));
  FA10_0: FullAdder port map(s00(0),c00(0),c01(0),c10(1),s10(0));
  FA20_0: FullAdder port map(s01(0),s10(0),c10(0),c20(1),s20(0));

  -- Array adders for bits 1, 2, 3, 4, 5 to reduce code length
  FAA: for i in 1 to 5 generate
    FA00i: FullAdder port map(se_in0(i),se_in1(i),se_in2(i),c00(i+1),s00(i));
    FA01i: FullAdder port map(se_in3(i),se_in4(i),se_in5(i),c01(i+1),s01(i));
    FA10i: FullAdder port map(s00(i),c00(i),c01(i),c10(i+1),s10(i));
    FA20i: FullAdder port map(s01(i),s10(i),c10(i),c20(i+1),s20(i));
  end generate;

  FA01_6: FullAdder port map(se_in0(6),se_in1(6),se_in2(6),toss(0),s00(6));
  FA02_6: FullAdder port map(se_in3(6),se_in4(6),se_in5(6),toss(1),s01(6));
  FA10_6: FullAdder port map(s00(6),c00(6),c01(6),toss(2),s10(6));
  FA20_6: FullAdder port map(s01(6),s10(6),c10(6),toss(3),s20(6));

  output <= s20 + c20;
end impl;
------------------------------------------------------------------------

-- pragma translate_off

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity testbench_6Adder is
end testbench_6Adder;

architecture test of testbench_6Adder is
  signal i0,i1,i2,i3,i4,i5 : std_logic_vector(3 downto 0);
  signal output: std_logic_vector(6 downto 0);
  signal err : std_logic;
begin
  DUT: entity work.MultiAdder_FA_Tree(impl) port map(i0,i1,i2,i3,i4,i5,output);

  process
    variable sum: std_logic_vector(6 downto 0);
  begin
    err <= '0';
    report "starting";
    for j0 in -8 to 7 loop
     for j1 in -8 to 7 loop 
      for j2 in 0 to 1 loop 
       for j3 in 6 to 7 loop 
        for j4 in -1 to 0 loop 
         for j5 in -1 to 1 loop 

          i0 <= std_logic_vector(to_signed(j0,4));
          i1 <= std_logic_vector(to_signed(j1,4));
          i2 <= std_logic_vector(to_signed(j2,4));
          i3 <= std_logic_vector(to_signed(j3,4));
          i4 <= std_logic_vector(to_signed(j4,4));
          i5 <= std_logic_vector(to_signed(j5,4));

          wait for 1 ns;
          sum := std_logic_vector(to_signed(j0+j1+j2+j3+j4+j5,7));

          if sum /= output then
            report "ERROR ** i0=" & to_string(i0) & "; i1=" & to_string(i1) &
                   "i2=" & to_string(i2) & "; i3=" & to_string(i3) &
                   "i4=" & to_string(i4) & "; i5=" & to_string(i5) &
                   "; o=" & to_string(output);
            err <= '1';
          end if;
         end loop;
        end loop;
       end loop;
      end loop;
     end loop;
    end loop;
    if err = '0' then report "PASSED"; else report "FAILED"; end if;
    wait;
  end process;
end test;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity testbench_ClaAdder8 is
end testbench_ClaAdder8;

architecture test of testbench_ClaAdder8 is
  signal a, b, s : std_logic_vector(7 downto 0);
  signal co, err : std_logic;
begin
  DUT: entity work.ClaAdder8(impl) port map(a,b,'0',s,co);

  process
    variable sum: std_logic_vector(7 downto 0);
  begin
    err <= '0';
    for i in 0 to 255 loop 
      for j in 0 to 255 loop 
        a <= std_logic_vector(to_unsigned(i,8));
        b <= std_logic_vector(to_unsigned(j,8));
        wait for 1 ns;
        sum := a+b;
        if not (sum = s) then
          err <= '1';
        end if;
      end loop;
    end loop;
    if err = '0' then report "PASSED"; end if;
    wait;
  end process;
end test;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity testbench_ClaAdder16 is
end testbench_ClaAdder16;

architecture test of testbench_ClaAdder16 is
  signal a, b, s : std_logic_vector(15 downto 0);
  signal co, err : std_logic;
begin
  DUT: entity work.ClaAdder16(impl) port map(a,b,'0',s,co);

  process
    variable sum: std_logic_vector(15 downto 0);
  begin
    err <= '0';
    for i in 0 to 4095 loop 
      for j in 0 to 15 loop 
        a <= std_logic_vector(to_unsigned(i,16));
        b <= std_logic_vector(to_unsigned(j,16));
        wait for 1 ns;
        sum := a+b;
        if not (sum = s) then
          err <= '1';
        end if;
      end loop;
    end loop;
    if err = '0' then report "PASSED"; end if;
    wait;
  end process;
end test;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity testbench_R4Mult64 is
end testbench_R4Mult64;

architecture test of testbench_R4Mult64 is
  signal a : std_logic_vector(3 downto 0);
  signal b : std_logic_vector(5 downto 0);
  signal s : std_logic_vector(9 downto 0);
  signal err : std_logic;
begin
  DUT: entity work.R4Mult64(impl) port map(a,b,s);

  process
    variable prod: std_logic_vector(9 downto 0);
  begin
    err <= '0';
    for i in 0 to 15 loop 
      for j in 0 to 63 loop 
        a <= std_logic_vector(to_unsigned(i,4));
        b <= std_logic_vector(to_unsigned(j,6));
        wait for 1 ns;
        prod := a*b;
        if prod /= s then
          report "ERROR ** a=" & to_string(a) & "; b=" & to_string(b) & "; s=" & to_string(s) & "; prod=" & to_string(prod);
          err <= '1';
        end if;
      end loop;
    end loop;
    if err = '0' then report "PASSED"; else report "FAILED"; end if;
    wait;
  end process;
end test;

-- pragma translate_on
