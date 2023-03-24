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
package ch8 is
  use ieee.std_logic_1164.all;

  component Dec is
    generic( n : integer := 2; m : integer := 4 );
    port( a : in std_logic_vector(n-1 downto 0); 
          b : out std_logic_vector(m-1 downto 0) );
  end component;

  component Dec4to16 is
    port( a: in std_logic_vector(3 downto 0); 
          b: out std_logic_vector(15 downto 0) );
  end component;

  component Mux3 is
    generic( k : integer := 1 );
    port( a2, a1, a0 : in std_logic_vector( k-1 downto 0 );
          s : in std_logic_vector( 2 downto 0 );
          b : out std_logic_vector( k-1 downto 0 ) );
  end component;

  component Muxb8 is
    generic( k : integer := 1 );
    port( a7, a6, a5, a4, a3, a2, a1, a0 : in std_logic_vector(k-1 downto 0);
          sb: in std_logic_vector(2 downto 0);
          b: out std_logic_vector(k-1 downto 0) );
  end component;

  component Enc42 is
    port( a : in std_logic_vector(3 downto 0);
          b : out std_logic_vector(1 downto 0) );
  end component;

  component Enc42a is
    port( a : in std_logic_vector(3 downto 0);
          b : out std_logic_vector(1 downto 0);
          c : out std_logic );
  end component;

  component Enc83 is
    port( a : in std_logic_vector( 7 downto 0 );
          b : out std_logic_vector( 2 downto 0 ) );
  end component;

  component Enc164 is
    port( a : in std_logic_vector( 15 downto 0 );
          b : out std_logic_vector( 3 downto 0 ) );
  end component;

  component Arb is
    generic( n: integer := 8 );
    port( r: in std_logic_vector(n-1 downto 0); g: out std_logic_vector(n-1 downto 0) );
  end component;

  component RArb is
    generic( n: integer := 8 );
    port( r: in std_logic_vector(n-1 downto 0); g: out std_logic_vector(n-1 downto 0) );
  end component;

  component MagComp is
    generic( k: integer := 8 );
    port( a, b: in std_logic_vector(k-1 downto 0);
          gt: out std_logic );
  end component;

  component Mux2 is
    generic( k: integer := 1 );
    port( a1, a0: in std_logic_vector( k-1 downto 0 );
          s: in std_logic_vector( 1 downto 0 );
          b: out std_logic_vector( k-1 downto 0 ) );
  end component;

  component Mux4 is
    generic( k : integer := 1 );
    port( a3, a2, a1, a0 : in std_logic_vector( k-1 downto 0 );
          s : in std_logic_vector( 3 downto 0 );
          b : out std_logic_vector( k-1 downto 0 ) );
  end component;

  component Mux7 is
    generic( k : integer := 1 );
    port( a6, a5, a4, a3, a2, a1, a0 : in std_logic_vector( k-1 downto 0 );
          s : in std_logic_vector( 6 downto 0 );
          b : out std_logic_vector( k-1 downto 0 ) );
  end component;

  component Encoder is
    generic( k: integer := 8; lk: integer := 3 );
    port( r: in std_logic_vector( k-1 downto 0 );
          b: out std_logic_vector( lk-1 downto 0 ) );
  end component;

  component RevPriorityEncoder is
    generic( k: integer := 8; lk: integer := 3 );
    port( r: in std_logic_vector( k-1 downto 0 );
          b: out std_logic_vector( lk-1 downto 0 ) );
  end component;
end package;

------------------------------------------------------------------------
-- Figure 8.3
-- n -> m  Decoder
-- a - binary input   (n bits wide)
-- b - one hot output (m bits wide)
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Dec is
  generic( n : integer := 2; m : integer := 4 );
  port( a : in std_logic_vector(n-1 downto 0); 
        b : out std_logic_vector(m-1 downto 0) );
end Dec;

architecture impl of Dec is
  signal one: unsigned(m-1 downto 0);
  signal shift: integer;
begin
  one   <= to_unsigned(1,m);
  shift <= to_integer(unsigned(a)); 
  b     <= std_logic_vector(one sll shift);
end impl; 
------------------------------------------------------------------------
-- Figure 8.7
library ieee;
use ieee.std_logic_1164.all;
use work.ch8.all;

entity Primed is
  port( input: in std_logic_vector(2 downto 0); 
        output: out std_logic );
end Primed;

architecture impl of Primed is
  signal b: std_logic_vector( 7 downto 0 );
begin
  -- instantiate a 3->8 decoder
  d: Dec generic map(3,8) port map(input,b);

  -- compute the output as the OR of the required minterms
  output <= b(1) or b(2) or b(3) or b(5) or b(7);
end impl;
------------------------------------------------------------------------
--Figure 8.8
library ieee;
use ieee.std_logic_1164.all;
use work.ch8.all;

entity Dec4to16 is
  port( a: in std_logic_vector(3 downto 0); 
        b: out std_logic_vector(15 downto 0) );
end Dec4to16;

architecture impl of Dec4to16 is
  signal x, y : std_logic_vector(3 downto 0); -- output of pre-decoders
begin
  -- instantiate pre-decoders
  d0: Dec port map(a(1 downto 0),x);
  d1: Dec port map(a(3 downto 2),y);

  -- combine pre-decoder outputs with AND gates
  b(3 downto 0)   <= x and (3 downto 0 => y(0));
  b(7 downto 4)   <= x and (3 downto 0 => y(1));
  b(11 downto 8)  <= x and (3 downto 0 => y(2));
  b(15 downto 12) <= x and (3 downto 0 => y(3));
end impl;
------------------------------------------------------------------------
-- Figure 8.11
-- three input mux with one-hot select (arbitrary width)
library ieee;
use ieee.std_logic_1164.all;

entity Mux3 is
  generic( k : integer := 1 );
  port( a2, a1, a0 : in std_logic_vector( k-1 downto 0 ); -- inputs
        s : in std_logic_vector( 2 downto 0 ); -- one-hot select
        b : out std_logic_vector( k-1 downto 0 ) );
end Mux3;

architecture logic_impl of Mux3 is
begin
  b <= ((k-1 downto 0 => s(2)) and a2) or
       ((k-1 downto 0 => s(1)) and a1) or
       ((k-1 downto 0 => s(0)) and a0);
end logic_impl;
------------------------------------------------------------------------
-- Figure 8.12
-- three input mux with one-hot select (arbitrary width)
library ieee;
use ieee.std_logic_1164.all;

entity Mux3a is
  generic( k : integer := 1 );
  port( a2, a1, a0 : in std_logic_vector( k-1 downto 0 ); -- inputs
        s : in std_logic_vector( 2 downto 0 ); -- one-hot select
        b : out std_logic_vector( k-1 downto 0 ) );
end Mux3a;

architecture case_impl of Mux3a is
begin
  process(all) begin
    case s is
      when "001" => b <= a0;
      when "010" => b <= a1;
      when "100" => b <= a2;
      when others => b <= (others => '-');
    end case;
  end process;
end case_impl;
------------------------------------------------------------------------
architecture select_impl of Mux3a is
begin
  with s select
    b <= a0 when "001",
         a1 when "010",
         a2 when "100",
         (others => '-') when others;
end select_impl;
------------------------------------------------------------------------
-- Figure 8.15
-- 3:1 multiplexer with binary select (arbitrary width)
library ieee;
use ieee.std_logic_1164.all;
use work.ch8.all;

entity Muxb3 is
  generic( k : integer := 1 );
  port( a2, a1, a0 : in std_logic_vector( k-1 downto 0 ); -- inputs
        sb : in std_logic_vector( 1 downto 0 ); -- binary select
        b : out std_logic_vector( k-1 downto 0 ) );
end Muxb3;

architecture struct_impl of Muxb3 is
  signal s: std_logic_vector(2 downto 0);
begin
  -- decoder converts binary to one-hot
  d: Dec generic map(2,3) port map(sb,s);
  -- multiplexer selects input
  mx: Mux3 generic map(k) port map(a2,a1,a0,s,b);
end struct_impl;
------------------------------------------------------------------------
-- Figure 8.17
architecture case_impl of Muxb3 is
begin
  process(all) begin
    case sb is
      when "00" => b <= a0;
      when "01" => b <= a1;
      when "10" => b <= a2;
      when others => b <= (others => '-');
    end case;
  end process;
end case_impl;
------------------------------------------------------------------------
architecture select_impl of Muxb3 is
begin
  with sb select
    b <= a0 when "00",
         a1 when "01",
         a2 when "10",
        (others => '-') when others;
end select_impl;
------------------------------------------------------------------------

--Figure 8.19
library ieee;
use ieee.std_logic_1164.all;
use work.ch8.all;

entity Mux6a is
  generic( k : integer := 1 );
  port( a5, a4, a3, a2, a1, a0 : in std_logic_vector(k-1 downto 0);
        s: in std_logic_vector(5 downto 0); -- one-hot select
        b: out std_logic_vector(k-1 downto 0) );
end Mux6a;

architecture impl of Mux6a is
  signal bb, ba : std_logic_vector(k-1 downto 0);
begin
  b <= ba or bb;
  MA: Mux3 generic map(k) port map(a2,a1,a0, s(2 downto 0), ba);
  MB: Mux3 generic map(k) port map(a5,a4,a3, s(5 downto 3), bb);
end impl;

--Figure 8.22, including required 8:1 binary select mux and test bench
library ieee;
use ieee.std_logic_1164.all;

entity Muxb8 is
  generic( k : integer := 1 );
  port( a7, a6, a5, a4, a3, a2, a1, a0 : in std_logic_vector(k-1 downto 0);
        sb: in std_logic_vector(2 downto 0); -- binary select
        b: out std_logic_vector(k-1 downto 0) );
end Muxb8;

architecture impl of Muxb8 is 
begin
  process(all) begin
    case sb is
      when 3d"0" => b <= a0 ;
      when 3d"1" => b <= a1 ;
      when 3d"2" => b <= a2 ;
      when 3d"3" => b <= a3 ;
      when 3d"4" => b <= a4 ;
      when 3d"5" => b <= a5 ;
      when 3d"6" => b <= a6 ;
      when 3d"7" => b <= a7 ;
      when others =>  b <=  (others => '-');
    end case;
  end process;
end impl;

library ieee;
use ieee.std_logic_1164.all;
use work.ch8.all;

entity Primem is
  port( input : in std_logic_vector(2 downto 0);
        isprime : out std_logic );
end Primem;

architecture impl of Primem is
  signal b : std_logic_vector(0 downto 0);
begin
  M: Muxb8 generic map(1) port map("1","0","1","0","1","1","1","0",input,b);
  isprime <= b(0);
end impl;

-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity tb_Primem is
end tb_Primem;

architecture test of tb_Primem is
  signal input: std_logic_vector(2 downto 0);
  signal output: std_logic;
begin
  DUT: entity work.Primem(impl) port map(input, output);
  process begin
    for i in 0 to 7 loop
      input <= conv_std_logic_vector(i,3);
      wait for 10 ns;
      report to_string(input) & "->" & to_string(output);
    end loop;
  end process;
end test;
-- pragma translate_on

--------------------------------------------------------------------------

-- Figure 8.25
-- 4:2 encoder
library ieee;
use ieee.std_logic_1164.all;
entity Enc42 is
  port( a : in std_logic_vector(3 downto 0);
        b : out std_logic_vector(1 downto 0) );
end Enc42;
architecture impl of Enc42 is
begin
  b <= (a(3) or a(2)) & (a(3) or a(1));
end impl;

--Figure 8.26
-- 4:2 encoder
library ieee;
use ieee.std_logic_1164.all;

entity Enc42b is
  port( a : in std_logic_vector( 3 downto 0 );
        b : out std_logic_vector( 1 downto 0 ) );
end Enc42b;

architecture impl of Enc42b is
begin
  process(all) begin
    case a is
      when "0001" => b <= "00";
      when "0010" => b <= "01";
      when "0100" => b <= "10";
      when "1000" => b <= "11";
      when "0000" => b <= "00"; -- to facilitate large encoders
      when others => b <= "--";
    end case;
  end process;
end impl;
--------------------------------------------------------------------------
--Figure 8.28
-- 4 to 2 encoder - with summary output
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity Enc42a is
  port( a : in std_logic_vector(3 downto 0);
        b : out std_logic_vector(1 downto 0);
        c : out std_logic );
end Enc42a;

architecture impl of Enc42a is
begin
  b <= (a(3) or a(2)) & (a(3) or a(1));
  c <= or_reduce(a);
end impl;

-- factored encoder
library ieee;
use ieee.std_logic_1164.all;
use work.ch8.all; -- for Enc42a component declaration

entity Enc164 is
  port( a : in std_logic_vector( 15 downto 0 );
        b : out std_logic_vector( 3 downto 0 ) );
end Enc164;

architecture impl of Enc164 is
  signal c: std_logic_vector(7 downto 0); -- intermediate result of first stage
  signal d: std_logic_vector(3 downto 0); -- if any set in group of four
begin
 --  four LSB encoders each include 4-bits of the input
 E0: Enc42a port map( a(3 downto 0), c(1 downto 0), d(0) );
 E1: Enc42a port map( a(7 downto 4), c(3 downto 2), d(1) );
 E2: Enc42a port map( a(11 downto 8), c(5 downto 4), d(2) );
 E3: Enc42a port map( a(15 downto 12), c(7 downto 6), d(3) ); 

 --  MSB encoder takes summaries and gives msb of output
 E4: Enc42 port map( d(3 downto 0), b(3 downto 2) );

 --  two OR gates combine output of LSB encoders
 b(1) <= c(1) or c(3) or c(5) or c(7);
 b(0) <= c(0) or c(2) or c(4) or c(6);
end impl;
--------------------------------------------------------------------------

--Figure 8.29
library ieee;
use ieee.std_logic_1164.all;

entity ThermometerEncoder is
  port( a: in std_logic_vector(3 downto 0); -- thermometer coded input
        b: out std_logic_vector(2 downto 0)); -- # of 1s in input (if legal)
end ThermometerEncoder;

architecture impl of ThermometerEncoder is
begin
  process(all) begin
    case a is
      when "0000" => b <= 3d"0";
      when "0001" => b <= 3d"1";
      when "0011" => b <= 3d"2";
      when "0111" => b <= 3d"3";
      when "1111" => b <= 3d"4";
      when others => b <= "---";
    end case;
  end process;
end impl;

-- Figure 8.33
-- arbiter (arbitrary width) - LSB is highest priority
library ieee;
use ieee.std_logic_1164.all;
entity Arb is
  generic( n: integer := 8 );
  port( r: in std_logic_vector(n-1 downto 0); g: out std_logic_vector(n-1 downto 0) );
end Arb;
architecture impl of Arb is
  signal c : std_logic_vector(n-1 downto 0);
begin
  c <= (not r(n-2 downto 0) and c(n-2 downto 0)) & '1';
  g <= r and c;
end impl;  

-- Figure 8.33
-- arbiter (arbitrary width) - MSB is highest priority
library ieee;
use ieee.std_logic_1164.all;
entity RArb is
  generic( n: integer := 8 );
  port( r: in std_logic_vector(n-1 downto 0); g: out std_logic_vector(n-1 downto 0) );
end RArb;
architecture impl of RArb is
  signal c : std_logic_vector(n-1 downto 0);
begin
  c <= '1' & (not r(n-1 downto 1) and c(n-1 downto 1));
  g <= r and c;
end impl;  

-- Figure 8.34
-- arbiter 4-bits wide - LSB is highest priority
library ieee;
use ieee.std_logic_1164.all;

entity Arb_4b is
  port( r : in std_logic_vector( 3 downto 0 );
        g : out std_logic_vector( 3 downto 0 ) );
end Arb_4b;

architecture impl of Arb_4b is
begin
  process(r) begin
    case? r is
      when "0000" => g <= "0000";
      when "---1" => g <= "0001";
      when "--10" => g <= "0010";
      when "-100" => g <= "0100";
      when "1000" => g <= "1000";
      when others => g <= "----";
    end case?;
  end process;
end impl;

-- encoder for Figure 8.36
library ieee;
use ieee.std_logic_1164.all;

entity Enc83 is
  port( a : in std_logic_vector( 7 downto 0 );
        b : out std_logic_vector( 2 downto 0 ) );
end Enc83;

architecture impl of Enc83 is
begin
  b <= (a(7) or a(6) or a(5) or a(4)) & 
       (a(7) or a(6) or a(3) or a(2)) & 
       (a(7) or a(5) or a(3) or a(1));
end impl;

-- Figure 8.36
-- 8:3 priority encoder 
library ieee;
use ieee.std_logic_1164.all;
use work.ch8.all;

entity PriorityEncoder83 is
  port( r: in std_logic_vector(7 downto 0);
        b: out std_logic_vector(2 downto 0) );
end PriorityEncoder83;

architecture impl of PriorityEncoder83 is
  signal g: std_logic_vector(7 downto 0);
begin
  A: Arb port map(r,g);
  E: Enc83 port map(g,b);
end impl;

-- 8:3 priority encoder 
library ieee;
use ieee.std_logic_1164.all;

entity PriorityEncoder83b is
  port( r: in std_logic_vector( 7 downto 0 );
        b: out std_logic_vector( 2 downto 0 ) );
end PriorityEncoder83b;

architecture impl of PriorityEncoder83b is
begin
  process(all) begin
    case? r is
      when "-------1" => b <= 3d"0";
      when "------10" => b <= 3d"1";
      when "-----100" => b <= 3d"2";
      when "----1000" => b <= 3d"3";
      when "---10000" => b <= 3d"4";
      when "--100000" => b <= 3d"5";
      when "-1000000" => b <= 3d"6";
      when "10000000" => b <= 3d"7";
      when others => b <= (others => '-');
    end case?;
  end process;
end impl;

--
library ieee;
use ieee.std_logic_1164.all;

entity ProgPriorityEncoder is
  generic( n: integer := 8 );
  port( r, p: in std_logic_vector(n-1 downto 0);
        g: out std_logic_vector(n-1 downto 0) );
end ProgPriorityEncoder;

architecture impl of ProgPriorityEncoder is
  signal c : std_logic_vector(2*n-1 downto 0);
begin
  c <= (not (r(n-2 downto 0) & r & r(n-1)) and (c(2*n-2 downto 0) & '0')) or  
       ((n-1 downto 0 => '0') & p);
  g <= r and (c(2*n-1 downto n) or c(n-1 downto 0));
end impl;

-- Figure 8.40
-- Equality comparator
library ieee;
use ieee.std_logic_1164.all;

entity EqComp is
  generic( k: integer := 8 );
  port( a, b: in std_logic_vector(k-1 downto 0);
        eq: out std_logic );
end EqComp;

architecture impl of EqComp is
begin
  eq <= '1' when a = b else '0';
end impl;

-- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity EqComp1 is
  generic( k: integer := 8 );
  port( a, b: in std_logic_vector(k-1 downto 0);
        eq: out std_logic );
end EqComp1;

architecture impl of EqComp1 is
begin
  eq <= and_reduce(a xnor b);
end impl;


-- Figure 8.43
library ieee;
use ieee.std_logic_1164.all;

entity MagComp is
  generic( k: integer := 8 );
  port( a, b: in std_logic_vector(k-1 downto 0);
        gt: out std_logic );
end MagComp;

architecture impl of MagComp is
  signal eqi, gti : std_logic_vector(k-1 downto 0);
  signal gtb: std_logic_vector(k downto 0);
begin
  eqi <= a xnor b;
  gti <= a and not b;
  gtb <= (gti or (eqi and gtb(k-1 downto 0))) & '0';
  gt <= gtb(k);
end impl;

-- Figure 8.44
-- Behavioral Magnitude comparator
library ieee;
use ieee.std_logic_1164.all;

entity MagComp_b is
  generic( k: integer := 8 );
  port( a, b: in std_logic_vector(k-1 downto 0);
        gt: out std_logic );
end MagComp_b;

architecture impl of MagComp_b is
begin
  gt <= '1' when a > b else '0';
end impl;

--
library ieee;
use ieee.std_logic_1164.all;

entity ThreeEq is
  generic( k: integer := 8 );
  port( a, b, c: in std_logic_vector(k-1 downto 0);
        eq: out std_logic );
end ThreeEq;

architecture impl of ThreeEq is
begin
  eq <= '1' when (a = b) and (a = c) else '0';
end impl;


--Figure 8.45
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ShiftLeft is
  generic( k: integer := 8; lk : integer := 3 );
  port( n: in std_logic_vector(lk-1 downto 0); -- how much to shift
        a: in std_logic_vector(k-1 downto 0); -- number to shift
        b: out std_logic_vector(2*k-2 downto 0) ); -- the output
end ShiftLeft;

architecture impl of ShiftLeft is
  signal input: unsigned(2*k-2 downto 0);
  signal shift: integer;
begin
  input <= unsigned((2*k-2 downto k => '0') & a);
  shift <= to_integer(unsigned(n));
  b <= std_logic_vector( input sll shift );
end impl;

--Figure 8.46
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BarrelShift is
  generic( k: integer := 8; lk: integer := 3 );
  port( n: in std_logic_vector(lk-1 downto 0); -- how much to shift
        a: in std_logic_vector(k-1 downto 0); -- number to shift
        b: out std_logic_vector(k-1 downto 0) ); -- the output
end BarrelShift;

architecture impl of BarrelShift is
  signal shift_amt: integer; -- amount to shift
  signal input: unsigned(2*k-2 downto 0); -- zero padded input
  signal shift_out: std_logic_vector(2*k-2 downto 0); -- output before wrapping
begin
  input <= unsigned( (2*k-2 downto k => '0') & a );
  shift_amt <= to_integer(unsigned(n));
  shift_out <= std_logic_vector( input sll shift_amt );
  b <= shift_out(k-1 downto 0) or ('0' & shift_out(2*k-2 downto k));
end impl;

--Figure 8.50
-- rom(fixed width) built with a case statement
library ieee;
use ieee.std_logic_1164.all;

entity rom_case is
  port( a : in std_logic_vector(3 downto 0);
        d : out std_logic_vector(7 downto 0) );
end rom_case;

architecture impl of rom_case is
begin
  process(all) begin
    case a is
      when x"0" => d <= x"00";
      when x"1" => d <= x"11";
      when x"2" => d <= x"22";
      when x"3" => d <= x"33";
      when x"4" => d <= x"44";
      when x"5" => d <= x"12";
      when x"6" => d <= x"34";
      when x"7" => d <= x"56";
      when x"8" => d <= x"78";
      when x"9" => d <= x"9a";
      when x"a" => d <= x"bc";
      when x"b" => d <= x"de";
      when x"c" => d <= x"f0";
      when x"d" => d <= x"12";
      when x"e" => d <= x"34";
      when x"f" => d <= x"56";
      when others => d <=x"00";
    end case;
  end process;
end impl;


------------------------------------------------------------------------
-- Bonus modules

library ieee;
use ieee.std_logic_1164.all;

entity Mux2 is
  generic( k : integer := 1 );
  port( a1, a0 : in std_logic_vector( k-1 downto 0 );
        s : in std_logic_vector( 1 downto 0 );
        b : out std_logic_vector( k-1 downto 0 ) );
end Mux2;

architecture impl of Mux2 is
begin
  b <= ((k-1 downto 0 => s(1)) and a1) or
       ((k-1 downto 0 => s(0)) and a0);
end impl;

library ieee;
use ieee.std_logic_1164.all;

entity Mux4 is
  generic( k : integer := 1 );
  port( a3, a2, a1, a0 : in std_logic_vector( k-1 downto 0 );
        s : in std_logic_vector( 3 downto 0 );
        b : out std_logic_vector( k-1 downto 0 ) );
end Mux4;

architecture impl of Mux4 is
begin
  process(all) begin
    case s is
      when "0001" => b <= a0;
      when "0010" => b <= a1;
      when "0100" => b <= a2;
      when "1000" => b <= a3;
      when others => b <= (k-1 downto 0 => '-');
    end case;
  end process;
end impl;

library ieee;
use ieee.std_logic_1164.all;

entity Mux7 is
  generic( k : integer := 1 );
  port( a6, a5, a4, a3, a2, a1, a0 : in std_logic_vector( k-1 downto 0 );
        s : in std_logic_vector( 6 downto 0 );
        b : out std_logic_vector( k-1 downto 0 ) );
end Mux7;

architecture impl of Mux7 is
begin
  process(all) begin
    case s is
      when "0000001" => b <= a0;
      when "0000010" => b <= a1;
      when "0000100" => b <= a2;
      when "0001000" => b <= a3;
      when "0010000" => b <= a4;
      when "0100000" => b <= a5;
      when "1000000" => b <= a6;
      when others => b <= (others => '-');
    end case;
  end process;
end impl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity Encoder is
  generic( k: integer := 8; lk: integer := 3 );
  port( r: in std_logic_vector( k-1 downto 0 );
        b: out std_logic_vector( lk-1 downto 0 ) );
end Encoder;

architecture impl of Encoder is
begin
  -- NOTE: The following implementation is actually a priority encoder
  process(all)
    variable index: integer;
  begin
    index := 0;
    for i in 0 to k-1 loop
      if r(i) then
        index := i;
      end if;
    end loop;
    b <= conv_std_logic_vector(index,lk);
  end process;
end impl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ch8.all;

entity RevPriorityEncoder is
  generic( k: integer := 8; lk: integer := 3);
  port( r: in std_logic_vector( k-1 downto 0 );
        b: out std_logic_vector( lk-1 downto 0 ) );
end RevPriorityEncoder;

architecture impl of RevPriorityEncoder is
  signal g: std_logic_vector(k-1 downto 0);
  signal a: std_logic_vector(lk-1 downto 0);
begin
  ra: RArb generic map(k) port map(r,g);
  e: Encoder generic map(k,lk) port map(g, a);
  b <= k-a-1;
end impl;

------------------------------------------------------------------------
-- testbenches for modules above

-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.ch8.all;

entity testbench_Dec is
end testbench_Dec;

architecture test of testbench_Dec is
  signal input : std_logic_vector(3 downto 0);
  signal output : std_logic_vector(9 downto 0);
begin
  DUT: Dec generic map(4,10) port map(input,output);

  process begin
    for i in 0 to 15 loop 
      input <= conv_std_logic_vector(i,4);
      wait for 10 ns;
      report "input = " & to_string(input) & " output = " & to_string(output);
    end loop;
    wait;
  end process;
end test;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity testbench_Primed is
end testbench_Primed;

architecture test of testbench_Primed is
  signal input : std_logic_vector(2 downto 0);
  signal output : std_logic;
begin
  DUT: entity work.Primed(impl) port map(input,output);

  process begin
    for i in 0 to 7 loop 
      input <= conv_std_logic_vector(i,3);
      wait for 10 ns;
      report "input = " & to_string(input) & " output = " & to_string(output);
    end loop;
    wait;
  end process;
end test;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.ch8.all;

entity testbench_Dec4to16 is
end testbench_Dec4to16;

architecture test of testbench_Dec4to16 is
  signal input : std_logic_vector(3 downto 0);
  signal output : std_logic_vector(15 downto 0);
begin
  DUT: Dec4to16 port map(input,output);

  process begin
    for i in 0 to 15 loop 
      input <= conv_std_logic_vector(i,4);
      wait for 10 ns;
      report "input = " & to_string(input) & " output = " & to_string(output);
    end loop;
    wait;
  end process;
end test;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ch8.all;

entity testbench_Mux3 is
end testbench_Mux3;

architecture test of testbench_Mux3 is
  signal a0, a1, a2, b : std_logic_vector(1 downto 0);
  signal sel: std_logic_vector(2 downto 0);
begin
  DUT: Mux3 generic map(2) port map(a2,a1,a0,sel,b);

  process begin
    a0 <= "00"; a1 <= "00"; a2 <= "00"; sel <= "001";
    for i in 0 to 2 loop 
      for j in 0 to 3 loop
        wait for 10 ns;
        report "a0=" & to_string(a0) & "; a1= " & to_string(a1) & "; a2=" & 
          to_string(a2) & "; sel=" & to_string(sel) & "; b=" & to_string(b);
        if i = 0 then a0 <= a0 + 1; end if;
        if i = 1 then a1 <= a1 + 1; end if;
        if i = 2 then a2 <= a2 + 1; end if;
      end loop;
      sel <= sel( 1 downto 0 ) & '0';
      -- uncomment to test Muxb3
      --sel <= sel + 1;
    end loop;
    wait;
  end process;
end test;


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity testbench_Mux6a is
end testbench_Mux6a;

architecture test of testbench_Mux6a is
  signal a0, a1, a2, a3, a4, a5, b : std_logic_vector(1 downto 0);
  signal sel: std_logic_vector(5 downto 0);
begin
  DUT: entity work.Mux6a(impl) generic map(2) port map(a5,a4,a3,a2,a1,a0,sel,b);

  process begin
    a0 <= "00"; a1 <= "00"; a2 <= "00"; a3 <= "00"; a4 <= "00"; a5 <= "00";
    sel <= "000001";
    for i in 0 to 5 loop 
      for j in 0 to 3 loop
        wait for 10 ns;
        report "a0=" & to_string(a0) & "; a1= " & to_string(a1) & "; a2=" & to_string(a2) &
               "; a3=" & to_string(a3) & "; a4= " & to_string(a4) & "; a5=" & to_string(a5) &
               "; sel=" & to_string(sel) & "; b=" & to_string(b);
        if i = 0 then a0 <= a0 + 1; end if;
        if i = 1 then a1 <= a1 + 1; end if;
        if i = 2 then a2 <= a2 + 1; end if;
        if i = 3 then a3 <= a3 + 1; end if;
        if i = 4 then a4 <= a4 + 1; end if;
        if i = 5 then a5 <= a5 + 1; end if;
      end loop;
      sel <= sel(4 downto 0) & '0';
    end loop;
    wait;
  end process;
end test;


library ieee;
use ieee.std_logic_1164.all;

entity testbench_Enc42 is
end testbench_Enc42;

architecture test of testbench_Enc42 is
  signal input : std_logic_vector(3 downto 0);
  signal output : std_logic_vector(1 downto 0);
begin
  DUT: entity work.Enc42(impl) port map(input,output);

  process begin
    input <= "0001";
    for i in 0 to 3 loop 
      wait for 10 ns;
      report "input=" & to_string(input) & "; output=" & to_string(output);
      input <= input(2 downto 0) & '0';
    end loop;
    wait;
  end process;
end test;


library ieee;
use ieee.std_logic_1164.all;

entity testbench_Enc164 is
end testbench_Enc164;

architecture test of testbench_Enc164 is
  signal input : std_logic_vector(15 downto 0);
  signal output : std_logic_vector(3 downto 0);
begin
  DUT: entity work.Enc164(impl) port map(input,output);

  process begin
    input <= "0000000000000001";
    for i in 0 to 15 loop 
      wait for 10 ns;
      report "input=" & to_string(input) & "; output=" & to_string(output);
      input <= input(14 downto 0) & '0';
    end loop;
    wait;
  end process;
end test;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity testbench_TE is
end testbench_TE;

architecture test of testbench_TE is
  signal input : std_logic_vector(3 downto 0);
  signal output : std_logic_vector(2 downto 0);
begin
  DUT: entity work.ThermometerEncoder(impl) port map(input,output);

  process begin
    for i in 0 to 15 loop 
      input <= conv_std_logic_vector(i,4);
      wait for 10 ns;
      report "input=" & to_string(input) & "; output=" & to_string(output);
    end loop;
    wait;
  end process;
end test;

library ieee;
use ieee.std_logic_1164.all;

entity testbench_Arb is
end testbench_Arb;

architecture test of testbench_Arb is
  signal input : std_logic_vector(7 downto 0);
  signal output : std_logic_vector(7 downto 0);
begin
  DUT: entity work.Arb(impl) port map(input,output);

  process begin
    input <= "00000000";
    for i in 0 to 8 loop 
      wait for 10 ns;
      report "input=" & to_string(input) & "; output=" & to_string(output);
      input <= "1" & input(7 downto 1);
    end loop;
    wait;
  end process;
end test;


library ieee;
use ieee.std_logic_1164.all;

entity testbench_RArb is
end testbench_RArb;

architecture test of testbench_RArb is
  signal input : std_logic_vector(7 downto 0);
  signal output : std_logic_vector(7 downto 0);
begin
  DUT: entity work.RArb(impl) port map(input,output);

  process begin
    input <= "00000000";
    for i in 0 to 8 loop 
      wait for 10 ns;
      report "input=" & to_string(input) & "; output=" & to_string(output);
      input <= input(6 downto 0) & '1';
    end loop;
    wait;
  end process;
end test;


library ieee;
use ieee.std_logic_1164.all;

entity testbench_Arb_4b is
end testbench_Arb_4b;

architecture test of testbench_Arb_4b is
  signal input : std_logic_vector(3 downto 0);
  signal output : std_logic_vector(3 downto 0);
begin
  DUT: entity work.Arb_4b(impl) port map(input,output);

  process begin
    input <= "0000";
    for i in 0 to 4 loop 
      wait for 10 ns;
      report "input=" & to_string(input) & "; output=" & to_string(output);
      input <= "1" & input(3 downto 1);
    end loop;
    wait;
  end process;
end test;


library ieee;
use ieee.std_logic_1164.all;

entity testbench_PE83 is
end testbench_PE83;

architecture test of testbench_PE83 is
  signal input : std_logic_vector(7 downto 0);
  signal output : std_logic_vector(2 downto 0);
begin
  DUT: entity work.PriorityEncoder83(impl) port map(input,output);

  process begin
    input <= "00000000";
    for i in 0 to 8 loop 
      wait for 10 ns;
      report "input=" & to_string(input) & "; output=" & to_string(output);
      input <= "1" & input(7 downto 1);
    end loop;
    wait;
  end process;
end test;


library ieee;
use ieee.std_logic_1164.all;

entity testbench_PE83b is
end testbench_PE83b;

architecture test of testbench_PE83b is
  signal input : std_logic_vector(7 downto 0);
  signal output : std_logic_vector(2 downto 0);
begin
  DUT: entity work.PriorityEncoder83b(impl) port map(input,output);

  process begin
    input <= "00000000";
    for i in 0 to 8 loop 
      wait for 10 ns;
      report "input=" & to_string(input) & "; output=" & to_string(output);
      input <= "1" & input(7 downto 1);
    end loop;
    wait;
  end process;
end test;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity testbench_PPE is
end testbench_PPE;

architecture test of testbench_PPE is
  signal r, p, g : std_logic_vector(2 downto 0);
begin
  DUT: entity work.ProgPriorityEncoder(impl) generic map(3) port map(r,p,g);

  process begin
    p <= "001";
    r <= "000";
    for ip in 0 to 2 loop 
      for ir in 0 to 7 loop
        wait for 10 ns;
        report "p=" & to_string(p) & "; r=" & to_string(r) & "; g=" & to_string(g);
        r <= r+1;
      end loop;
      p <= p(1 downto 0) & '0';
    end loop;
    wait;
  end process;
end test;


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity testbench_MagComp is
end testbench_MagComp;

architecture test of testbench_MagComp is
  signal a,b : std_logic_vector(3 downto 0);
  signal output : std_logic;
begin
  DUT: entity work.MagComp(impl) generic map(4) port map(a,b,output);

  process begin
    a <= "0000";
    b <= "0101";
    for i in 0 to 15 loop 
      wait for 10 ns;
      report "a=" & to_string(a) & "; b=" & to_string(b) & "; gt=" & to_string(output);
      a <= a + 1;
    end loop;
    wait;
  end process;
end test;


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity testbench_ShiftLeft is
end testbench_ShiftLeft;

architecture test of testbench_ShiftLeft is
  signal a : std_logic_vector(7 downto 0);
  signal b : std_logic_vector(14 downto 0);
  signal n : std_logic_vector(2 downto 0);
begin
  DUT: entity work.ShiftLeft(impl) port map(n,a,b);

  process begin
    a <= "00001101";
    n <= "000";
    for i in 0 to 7 loop 
      wait for 10 ns;
      report "a=" & to_string(a) & "; n=" & to_string(n) & "; b=" & to_string(b);
      n <= n + 1;
    end loop;
    wait;
  end process;
end test;


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity testbench_BarrelShift is
end testbench_BarrelShift;

architecture test of testbench_BarrelShift is
  signal a : std_logic_vector(7 downto 0);
  signal b : std_logic_vector(7 downto 0);
  signal n : std_logic_vector(2 downto 0);
begin
  DUT: entity work.BarrelShift(impl) port map(n,a,b);

  process begin
    a <= "11001010";
    n <= "000";
    for i in 0 to 7 loop 
      wait for 10 ns;
      report "a=" & to_string(a) & "; n=" & to_string(n) & "; b=" & to_string(b);
      n <= n + 1;
    end loop;
    wait;
  end process;
end test;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity tb_Encoder is
end tb_Encoder;

architecture test of tb_Encoder is
  signal x: std_logic_vector(7 downto 0);
  signal y: std_logic_vector(2 downto 0);
begin
  DUT: entity work.Encoder(impl) port map(x,y);

  process begin
    x <= 8x"1";
    for i in 0 to 7 loop
      wait for 1 ns;
      assert y = conv_std_logic_vector(i,3) report "ERROR";
      x <= x(6 downto 0) & '1';
    end loop;

    report "DONE";
    wait;
  end process;
end test;

-- pragma translate_on
