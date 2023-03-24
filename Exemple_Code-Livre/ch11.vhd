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

-- this file uses modules from ch08.vhd and ch10.vhd

--Figure 11.2
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ch10.all;

entity FP_Mul is
  generic( e: integer := 3 );
  port( ae, be: in std_logic_vector(e-1 downto 0); -- input exponents
        am, bm: in std_logic_vector(3 downto 0); -- input mantissas
        ce: out std_logic_vector(e-1 downto 0); -- result exponent
        cm: out std_logic_vector(3 downto 0); -- result mantissa
        ovf: out std_logic ); -- overflow indicator
end FP_Mul;

architecture impl of FP_Mul is
  signal pm: std_logic_vector(7 downto 0); -- result of initial multiply
  signal sm: std_logic_vector(3 downto 0); -- after shift
  signal xm: std_logic_vector(4 downto 0); -- after inc
  signal rnd: std_logic; -- true if MSB shifted off was one
  signal oece: std_logic_vector(e+1 downto 0); -- to detect exponent ovf
begin
  -- multiply am and bm
  MULT: Mul4 port map(am,bm,pm);

  -- Shift/Round: if MSB is 1 select bits 7:4 otherwise 6:3
  sm <= pm(7 downto 4) when pm(7) else pm(6 downto 3);
  rnd <= pm(3) when pm(7) else pm(2);

  -- Increment
  xm <= ('0' & sm) + ("000" & rnd);

  -- Final shift/round
  cm <= xm(4 downto 1) when xm(4) else xm(3 downto 0);

  -- Exponent add
  oece <= ("00" & ae) + be + (pm(7) or xm(4)) - 1;

  ce <= oece(e-1 downto 0);
  ovf <= oece(e-1) or oece(e-2);
end impl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.ch8.all;

entity FP_Add is
  generic( e: integer := 3; m: integer := 5 );
  port( ae, be: in std_logic_vector(e-1 downto 0); -- input exponents
        am, bm: in std_logic_vector(m-1 downto 0); -- input mantissas
        ce: out std_logic_vector(e-1 downto 0); -- result exponent
        cm: out std_logic_vector(m-1 downto 0); -- result mantissa
        ovf: out std_logic );
end FP_Add;

architecture impl of FP_Add is
  signal ge, le, de, sc: std_logic_vector(e-1 downto 0);
  signal gm, lm, alm: std_logic_vector(m-1 downto 0);
  signal sm, nmrnd: std_logic_vector(m downto 0);
  signal ovfce: std_logic_vector(e downto 0);
  signal agtb: std_logic;
begin
  -- input exponent logic
  agtb <= '1' when ae >= be else '0';
  ge <= ae when agtb else be;
  le <= be when agtb else ae;
  de <= ge - le; 
  
  -- select input mantissa
  gm <= am when agtb else bm;
  lm <= bm when agtb else am;
  
  -- shift mantissa to align
  alm <= std_logic_vector(shift_right(unsigned(lm),to_integer(signed(de)))); 

  -- add 
  sm <= ('0' & gm) + ('0' & alm);

  -- find first one
  FF1: RevPriorityEncoder generic map(6,3) port map(sm, sc);

  -- shift first 1 to MSB
  nmrnd <= std_logic_vector(shift_left(unsigned(sm),to_integer(signed(sc))));

  -- adjust exponent
  ovfce <= ('0' & ge) - ('0' & sc) + 1;
  ovf <= ovfce(e);

  -- round result
  cm <= nmrnd(m downto 1) + ((m-1 downto 1 => '0') & nmrnd(0));
end impl;

--------------------------------------------------------------------------------

-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;

entity testbench_FP_Mul is
end testbench_FP_Mul;

architecture test of testbench_FP_Mul is
  signal ae, be: std_logic_vector(2 downto 0); -- input exponents
  signal am, bm: std_logic_vector(3 downto 0); -- input mantissas
  signal ce: std_logic_vector(2 downto 0); -- result exponent
  signal cm: std_logic_vector(3 downto 0); -- result mantissa
  signal ovf: std_logic; -- overflow indicator
begin

  DUT: entity work.FP_Mul(impl) port map(ae,be,am,bm,ce,cm,ovf);

  process begin
    -- 12/16 x 2^2 = 3
    am <= "1100";
    ae <= "010";

    -- 12/16 x 2^6 = 48 
    bm <= "1100";
    be <= "110";

    -- result = 144
    -- 9/16 x 2^4 = 9
    wait;
  end process;
end test;
-- pragma translate_on
