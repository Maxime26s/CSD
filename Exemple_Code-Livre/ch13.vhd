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
package ch13 is
  use ieee.std_logic_1164.all;

  component float2fix is
    port( float: in std_logic_vector(7 downto 0);
          fixed: out std_logic_vector(11 downto 0) );
  end component;

  component fix2float is
    port( fixed: in std_logic_vector(11 downto 0); 
          float: out std_logic_vector(7 downto 0) );
  end component;
end package;

--Figure 13.2
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity complex_mult is
  port( a_real, a_img, b_real, b_img : in std_logic_vector(15 downto 0);
        x_real, x_img : out std_logic_vector(15 downto 0) );
end complex_mult;

architecture impl of complex_mult is
  signal overflow_pos_real, overflow_pos_img : std_logic;
  signal overflow_neg_real, overflow_neg_img : std_logic;
  signal no_overflow_real, no_overflow_img : std_logic;
  signal p_ar_br, p_ai_bi, p_ai_br, p_ar_bi : std_logic_vector(31 downto 0);
  signal s_real, s_img : std_logic_vector(31 downto 0);
  signal s_real_rnd, s_img_rnd: std_logic_vector(17 downto 0);
begin
  -- s2.28
  p_ar_br <= a_real * b_real;
  p_ai_bi <= a_img * b_img;
  p_ai_br <= a_img * b_real;
  p_ar_bi <= a_real * b_img;
  
  -- s3.28
  s_real <= p_ar_br - p_ai_bi;
  s_img <= p_ar_bi + p_ai_br;

  -- Round up on half, s3.14
  s_real_rnd <= s_real(31 downto 14) + s_real(13);
  s_img_rnd <= s_img(31 downto 14) + s_img(13);

  -- check for overflow & clamp  (bits 17, 16, 15 not equal)
  overflow_pos_real <= (not s_real_rnd(17)) and (s_real_rnd(16) or s_real_rnd(15));
  overflow_neg_real <= (s_real_rnd(17)) and not(s_real_rnd(16) and s_real_rnd(15));
  no_overflow_real <= not (overflow_pos_real or overflow_neg_real);

  overflow_pos_img <= (not s_img_rnd(17)) and (s_img_rnd(16) or s_img_rnd(15));
  overflow_neg_img <= (s_img_rnd(17)) and not(s_img_rnd(16) and s_img_rnd(15));
  no_overflow_img <=  not (overflow_pos_img or overflow_neg_img);

  x_real <= ((15 downto 0 => overflow_pos_real) and x"7fff") or
            ((15 downto 0 => overflow_neg_real) and x"8000") or
            ((15 downto 0 => no_overflow_real) and s_real_rnd(15 downto 0));

  x_img <= ((15 downto 0 => overflow_pos_img) and x"7fff") or
           ((15 downto 0 => overflow_neg_img) and x"8000") or 
           ((15 downto 0 => no_overflow_img) and s_img_rnd(15 downto 0));
end impl;

--Figure 13.8
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity fix2float is
  port( fixed: in std_logic_vector(11 downto 0); 
        float: out std_logic_vector(7 downto 0) );
end fix2float;

architecture impl of fix2float is
  signal exp, shift: std_logic_vector(2 downto 0);
  signal mag: std_logic_vector(10 downto 0);
  signal mant_lng: std_logic_vector(10 downto 0);
  signal mant: std_logic_vector(4 downto 0);
  signal new_exp: std_logic_vector(3 downto 0);
  signal sign: std_logic;
begin
   
  mag <= (not fixed(10 downto 0))+1 when fixed(11)='1' else fixed(10 downto 0);
  sign <= fixed(11);
  
  process(all) begin
    case? mag(10 downto 4) is
      when "1------" => exp <= "111"; shift <= "110";
      when "01-----" => exp <= "110"; shift <= "101";
      when "001----" => exp <= "101"; shift <= "100";
      when "0001---" => exp <= "100"; shift <= "011";
      when "00001--" => exp <= "011"; shift <= "010";
      when "000001-" => exp <= "010"; shift <= "001";
      when "0000001" => exp <= "001"; shift <= "000";
      when "0000000" => exp <= "000"; shift <= "000";
      when others    => exp <= "---"; shift <= "---";
    end case?;
  end process;

  -- Shift the mantissa and round
  mant_lng <= std_logic_vector(shift_right(unsigned(mag(9 downto 0) & '0'), to_integer(unsigned(shift))));
  mant <= ('0' & mant_lng(4 downto 1)) + mant_lng(0);

  -- Check for round overflow
  new_exp <= ('0' & exp) + mant(4);

  -- If the exponent overflowed, saturate
  float <= (sign & "1111111") when new_exp(3) = '1' else (sign & new_exp(2 downto 0) & mant(3 downto 0));
  -- Using mant(3 downto 0) is correct even with the round overflow,
  -- since in that case mant(4 downto 1)=mant(3 downto 0)="0000"
end impl;

--Figure 13.10
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity float2fix is
  port( float: in std_logic_vector(7 downto 0);
        fixed: out std_logic_vector(11 downto 0) );
end float2fix;

architecture impl of float2fix is
  signal sign, implied_one: std_logic;
  signal exponent, shift: std_logic_vector(2 downto 0);
  signal mant: std_logic_vector(3 downto 0);
  signal mag: std_logic_vector(11 downto 0);
begin
  sign <= float(7);
  exponent <= float(6 downto 4);
  mant <= float(3 downto 0);

  shift <= "000" when exponent = "000" else exponent-1;
  implied_one <= '1' when not (exponent = "000") else '0';

  mag <= std_logic_vector( shift_left(unsigned("0000000" & implied_one & mant), to_integer(unsigned(shift))) );
  fixed <= (not mag)+1 when sign='1' else mag;
end impl;

-- Figure 13.12
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use work.ch13.all;

entity fir is
  -- A four input floating point FIR filter
  port( x0, x1, x2, x3: in std_logic_vector(7 downto 0);
        -- The output will only be an error if any of the 4 inputs are an error code
        -- As the weights are restricted to be no greater than one
        w0, w1, w2, w3: in std_logic_vector(4 downto 0);
        -- In 1.4 format, max value = 16/16
        output: out std_logic_vector(7 downto 0) );
end fir;

architecture impl of fir is
  signal fix0, fix1, fix2, fix3, fixed_out: std_logic_vector(11 downto 0);
  -- The weighted floating point numbers, s11.4
  signal weighted0, weighted1, weighted2, weighted3, shift1: std_logic_vector(16 downto 0);
  signal w_sum: std_logic_vector(16 downto 0);
  signal float_out: std_logic_vector(7 downto 0);
  signal err: std_logic;
begin
  CONV0: float2fix port map(x0, fix0);
  CONV1: float2fix port map(x1, fix1);
  CONV2: float2fix port map(x2, fix2);
  CONV3: float2fix port map(x3, fix3);
 
  weighted0 <= fix0 * w0;
  weighted1 <= fix1 * w1;
  weighted2 <= fix2 * w2;
  weighted3 <= fix3 * w3;

  w_sum <= weighted0 + weighted1 + weighted2 + weighted3;
  fixed_out <= w_sum(15 downto 4)+w_sum(3);

  CONVOUT: fix2float port map(fixed_out,float_out);

  err <= '1' when (x0 = x"80") or (x1 = x"80") or (x2 = x"80") or (x3 = x"80") else '0';
  output <= x"80" when err = '1' else float_out;
end impl;

--------------------------------------------------------------------------------

-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;

entity testbench_fir is
end testbench_fir;

architecture test of testbench_fir is
  signal x0, x1, x2, x3: std_logic_vector(7 downto 0) := x"00";
  signal w0, w1, w2, w3: std_logic_vector(4 downto 0) := "00000";
  signal output: std_logic_vector(7 downto 0) := x"00";
begin
  DUT: entity work.fir(impl) port map(x0,x1,x2,x3,w0,w1,w2,w3,output);

  w0 <= "00111";
  w1 <= "01111";
  w2 <= "10011";
  w3 <= "01010";

  process begin
    x0 <= x"76"; 
    x1 <= x"56";
    x2 <= x"23";
    x3 <= x"90";

    wait for 10 ns;

    report "done";
    wait;
  end process;
end test;    

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity testbench_cmul is
end testbench_cmul;

architecture test of testbench_cmul is
  signal a_real, a_img, b_real, b_img : std_logic_vector(15 downto 0) := x"0000";
  signal x_real, x_img : std_logic_vector(15 downto 0) := x"0000";
begin
  DUT: entity work.complex_mult(impl) port map(a_real,a_img,b_real,b_img,x_real,x_img);

  process begin
   a_img  <= x"2000";
   a_real <= x"0000";
   b_img  <= x"6000";
   b_real <= x"0000";

   wait for 10 ns; 

   report "a=" & to_hstring(a_real) & ",i" & to_hstring(a_img) &
          ";b=" & to_hstring(b_real) & ",i" & to_hstring(b_img) &
          ";x=" & to_hstring(x_real) & ",i" & to_hstring(x_img);
   wait;
  end process;
end test;

library ieee;
package test_utility is
use ieee.std_logic_1164.all;
function test_f2f (fixed: in std_logic_vector(11 downto 0); 
                   actual: in std_logic_vector(7 downto 0); 
		   expected: in std_logic_vector(7 downto 0);
	           fixed2: in std_logic_vector(11 downto 0);
	           expected2: in std_logic_vector(11 downto 0) ) return std_logic;
end package;

package body test_utility is
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_signed.all;
  function test_f2f (fixed: in std_logic_vector(11 downto 0); 
                     actual: in std_logic_vector(7 downto 0); 
                     expected: in std_logic_vector(7 downto 0); 
                     fixed2: in std_logic_vector(11 downto 0);
                     expected2: in std_logic_vector(11 downto 0) ) return std_logic is 
    variable result: std_logic;
  begin
    result := '0';
    if actual /= expected then
      report "ERROR ** fixed = "&to_hstring(fixed)&"; float = "&to_hstring(actual)&" expected = "&to_hstring(expected);
      result := '1';
    end if;
    if fixed2 /= expected2 then
      report "ERROR ** fixed = "&to_hstring(fixed)&"; fixed2 = "&to_hstring(fixed2)&" expected = "&to_hstring(expected2);
      result := '1';
    end if;
    return result;
  end function;
end package body;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use work.test_utility.all;

entity testbench_fixed2float is
end testbench_fixed2float;

architecture test of testbench_fixed2float is
  signal fixed,fixed2: std_logic_vector(11 downto 0); 
  signal float: std_logic_vector(7 downto 0);
  signal err: std_logic;
begin
  DUT1: entity work.fix2float(impl) port map(fixed,float);
  DUT2: entity work.float2fix(impl) port map(float,fixed2);

  process begin
   fixed <= x"000"; wait for 1 ns;
   err <= test_f2f(fixed,float,x"00",fixed2,x"000");

   fixed <= x"003"; wait for 1 ns;
   err <= test_f2f(fixed,float,x"03",fixed2,x"003");

   fixed <= x"00f"; wait for 1 ns;
   err <= test_f2f(fixed,float,x"0f",fixed2,x"00f");

   fixed <= x"011"; wait for 1 ns;
   err <= test_f2f(fixed,float,x"11",fixed2,x"011");

   fixed <= x"0de"; wait for 1 ns;
   err <= test_f2f(fixed,float,x"4c",fixed2,x"0e0");

   fixed <= x"59d"; wait for 1 ns;
   err <= test_f2f(fixed,float,x"76",fixed2,x"580");

   fixed <= x"7ff"; wait for 1 ns;
   err <= test_f2f(fixed,float,x"7f",fixed2,x"7c0");

   fixed <= x"fff"; wait for 1 ns;
   err <= test_f2f(fixed,float,x"81",fixed2,x"fff");

   wait for 1 ns;
   if err = '0' then report "TEST PASSED"; else report "TEST FAILED"; end if;

   wait;
 end process;
end test;

-- pragma translate_on
