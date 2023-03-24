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

--Code for figures 3.7, 3.8 and example 3.9 (pages 50, 51)

library ieee;
use ieee.std_logic_1164.all;

entity majority is
	port( a, b, c : in std_logic; 
        output : out std_logic );
end majority;

architecture impl of majority is
begin
   output <= (a and b) or (a and c) or (b and c);
end impl;
--------------------------------------------------------------------------------
-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test_maj is
end test_maj;

architecture test of test_maj is
  component majority is
    port( a, b, c : in std_logic; 
          output : out std_logic );
  end component;
  signal count: std_logic_vector(2 downto 0); -- input (three bit counter)
  signal output: std_logic; -- output of majority
begin
  -- instantiate the gate
  DUT: majority port map(count(0), count(1), count(2), output);

  -- generate all eight input patterns
  process begin
    count <= "000";
    for i in 0 to 7 loop
      wait for 10 ns;
      report "count = " & to_string(count) & ", output = " & to_string(output);
      count <= count + 1;
    end loop;
    std.env.stop(0);
  end process;
end test;
-- pragma translate_on
