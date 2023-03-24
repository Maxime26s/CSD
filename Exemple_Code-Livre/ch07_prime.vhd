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


------------------------------------------------------------------------
-- prime - Figure 7.2
--   input   - 4 bit binary number
--   isprime - true if "input" is a prime number 1,2,3,5,7,11, or 13
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity prime is
  port( input : in std_logic_vector(3 downto 0);
        isprime : out std_logic );
end prime;

architecture case_impl of prime is
begin
  process(input) begin
    case input is
      when x"1" | x"2" | x"3" | x"5" | x"7" | x"b" | x"d" => isprime <= '1';
      when others => isprime <= '0';
    end case;
  end process;
end case_impl;
------------------------------------------------------------------------
architecture mcase_impl of prime is
begin
  process(all) begin
    case? input is
      when "0--1" => isprime <= '1';
      when "0010" => isprime <= '1';
      when "1011" => isprime <= '1';
      when "1101" => isprime <= '1';
      when others => isprime <= '0';
    end case?;
  end process;
end mcase_impl;
------------------------------------------------------------------------
architecture if_impl of prime is
begin
  process(all) begin
    if input = 4d"1" then isprime <= '1';
    elsif input = 4d"2" then isprime <= '1';
    elsif input = 4d"3" then isprime <= '1';
    elsif input = 4d"5" then isprime <= '1';
    elsif input = 4d"7" then isprime <= '1';
    elsif input = 4d"11" then isprime <= '1';
    elsif input = 4d"13" then isprime <= '1';
    else isprime <= '0';
    end if;
  end process;
end if_impl;
------------------------------------------------------------------------
architecture logic_impl of prime is
begin
  isprime <= (input(0) AND (NOT input(3))) OR 
             (input(1) AND (NOT input(2)) AND (NOT input(3))) OR 
             (input(0) AND (NOT input(1)) AND input(2)) OR
             (input(0) AND input(1) AND NOT input(2)) ;
end logic_impl;
------------------------------------------------------------------------
architecture select_impl of prime is
begin
  with input select 
    isprime <= '1' when 4d"1" | 4d"2" | 4d"3" | 4d"5" | 4d"7" | 4d"11" | 4d"13",
               '0' when others;
end select_impl;
------------------------------------------------------------------------
architecture cond_impl of prime is
begin
  isprime <= '1' when input = 4d"1" else
             '1' when input = 4d"2" else
             '1' when input = 4d"3" else
             '1' when input = 4d"5" else
             '1' when input = 4d"7" else
             '1' when input = 4d"11" else
             '1' when input = 4d"13" else
             '0';
end cond_impl;
------------------------------------------------------------------------
architecture struct_impl of prime is
  component and_gate is
    port( a, b, c  : in std_logic := '1'; y : out std_logic );
  end component;
  signal a1, a2, a3, a4, n1, n2, n3: std_logic;
begin
  -- Note that the order in which component instantiations and 
  -- concurrent assignment statements appear has no effect.
  AND1: and_gate port map( input(1), n2, n3, a1 ); -- positional association
  AND2: and_gate port map( y=>a2, a=>input(0), b=>n3 ); -- named association
  AND3: and_gate port map( y=>a3, a=>input(0), b=>n1, c=>input(2) );
  AND4: and_gate port map( y=>a4, a=>input(0), b=>input(1), c=>n2 );
  isprime <= a1 or a2 or a3 or a4;
  n1 <= not input(1);
  n2 <= not input(2);
  n3 <= not input(3);
end struct_impl;

-- Each entity declaration must include packages used in its architecture bodies.
library ieee;
use ieee.std_logic_1164.all;

entity and_gate is
  port( a, b, c : in std_logic := '1'; y : out std_logic );
end and_gate;

architecture logic_impl of and_gate is
begin
  y <= a and b and c;
end logic_impl;

architecture alt_impl of and_gate is
begin
  y <= not (not a or not b or not c);
end alt_impl;

-- Without the optional configuration declaration below all and_gate component 
-- instantiations in work.prime(struct_impl) will use work.and_gate(alt_impl).
configuration my_config of prime is
  for struct_impl
    for AND1, AND3 : and_gate
      use entity work.and_gate(alt_impl);
    end for;
    for others : and_gate 
      use entity work.and_gate(logic_impl);
    end for;
  end for;
end configuration my_config;
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity prime_dec is
  port( input : in std_logic_vector(3 downto 0);
        isprime : out std_logic );
end prime_dec;

architecture impl of prime_dec is
begin
  process(all) begin
    case input is
      when x"0" | x"4" | x"6" | x"8" | x"9" => isprime <= '0';
      when x"1" | x"2" | x"3" | x"5" | x"7" => isprime <= '1';
      when others => isprime <= '-';
    end case;
  end process;
end impl;

------------------------------------------------------------------------
-- Test bench for 4-bit prime number circuit
------------------------------------------------------------------------
-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity test_prime is
end test_prime;

architecture test of test_prime is
  signal input: std_logic_vector(3 downto 0);
  signal isprime: std_logic;
begin
  -- instantiate module to test
  DUT: entity work.prime(case_impl) port map(input, isprime);

  process begin
    for i in 0 to 15 loop
      input <= std_logic_vector(to_unsigned(i,4));
      wait for 10 ns;
      report "input = " & to_string(to_integer(unsigned(input))) &
             " isprime = " & to_string(isprime);
    end loop;
    std.env.stop(0);
  end process;
end test;
-- pragma translate_on
------------------------------------------------------------------------
-- Test bench for 4-bit prime number circuit
------------------------------------------------------------------------
-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity test_prime_mcase is
end test_prime_mcase;

architecture test of test_prime_mcase is
  signal input: std_logic_vector(3 downto 0);
  signal check: std_logic; -- set to 1 on mismatch
  signal isprime0, isprime1: std_logic ;
begin
  -- instantiate both implementations
  p0: entity work.prime(case_impl) port map(input, isprime0) ;
  p1: entity work.prime(mcase_impl) port map(input, isprime1) ;

  process begin
    check <= '0';
    for i in 0 to 15 loop
      input <= std_logic_vector(to_unsigned(i,4));
      wait for 10 ns; 
      if isprime0 /= isprime1 then 
        check <= '1'; 
      end if;
    end loop;
    wait for 10 ns; 
    if check /= '1' then report "PASS"; else report "FAIL"; end if;
    std.env.stop(0);
  end process;
end test;
-- pragma translate_on

--------------------------------------------------------------------------------

-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity test_primes is
end test_primes;

architecture test of test_primes is
  signal inp: std_logic_vector(3 downto 0);
  signal isp0, isp1, isp2, isp3, isp4, isp5, isp6, ispd: std_logic;
begin
  p0: entity work.prime(case_impl)   port map(inp, isp0);
  p1: entity work.prime(mcase_impl)  port map(inp, isp1);
  p2: entity work.prime(if_impl)     port map(inp, isp2);
  p3: entity work.prime(logic_impl)  port map(inp, isp3);
  p4: entity work.prime(select_impl) port map(inp, isp4);
  p5: entity work.prime(cond_impl)   port map(inp, isp5);
  p6: configuration work.my_config   port map(inp, isp6);
  pd: entity work.prime_dec(impl)    port map(inp, ispd);

  process begin
    for i in 0 to 15 loop
      inp <= std_logic_vector(to_unsigned(i,4));
      wait for 10 ns;
      report to_string(inp) & " " & to_string(isp0) & " " & to_string(isp1) & " " & 
             to_string(isp2) & " " & to_string(isp3) & " " & to_string(isp4) & " " & 
             to_string(isp5) & " " & to_string(isp6) & " " & to_string(ispd);
    end loop;
    std.env.stop(0);
  end process;
end test;
-- pragma translate_on
