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
--Figure 7.5
library ieee;
use ieee.std_logic_1164.all;

entity therm is
  port( input: in std_logic_vector(3 downto 0); 
        output: out std_logic );
end therm;

architecture case_impl of therm is
begin
  process(all) begin
    case input is
      when "0000" | "0001" | "0011" | "0111" | "1111" => output <= '1';
      when others => output <= '0';
    end case;
  end process;
end case_impl;


--Figure 7.7
architecture mcase_impl of therm is
begin
  process(all) begin
    case? input is
      when "000-" => output <= '1';
      when "0011" => output <= '1';
      when "-111" => output <= '1';
      when others => output <= '0';
    end case?;
  end process;
end mcase_impl;

--Figure 7.9
architecture assign_impl of therm is
begin
  output <= ((NOT input(3)) AND (NOT input(2)) AND (NOT input(1))) OR
            ((NOT input(3)) AND (NOT input(2)) AND input(1) AND input(0)) OR
            (input(2) AND input(1) AND input(0));
end assign_impl;

--
architecture struct_impl of therm is
  component and_gate is
    port( a, b, c, d  : in std_logic :='1'; Y : out std_logic );
  end component;
  signal i1, i2, i3, t2, t1, t0 : std_logic;
begin
  i1 <= not input(1);
  i2 <= not input(2);
  i3 <= not input(3);
  AND1: and_gate port map(y=>t0, a=>i3, b=>i2, c=>i1 );
  AND2: and_gate port map(y=>t1, a=>i3, b=>i2, c=>input(1), d=>input(0) );
  AND3: and_gate port map(y=>t2, a=>input(2), b=>input(1), c=>input(0) );
  output <= t2 or t1 or t0;
end struct_impl;

library ieee;
use ieee.std_logic_1164.all;

entity and_gate is
  port( a, b, c, d : in std_logic := '1'; y : out std_logic );
end and_gate;

architecture impl of and_gate is
begin
  y <= a and b and c and d;
end impl;

configuration my_config of therm is
  for struct_impl
    for all: and_gate
      use entity work.and_gate(impl);
    end for;
  end for;
end;

--Figure 7.18
-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity therm_test is
end therm_test;

architecture test of therm_test is
  signal count: std_logic_vector(3 downto 0);
  signal t0, t1, t2, t3, check: std_logic; 
begin
  M0: entity work.therm(assign_impl) port map( count, t0 );
  M1: entity work.therm(case_impl)   port map( count, t1 );
  M2: entity work.therm(mcase_impl)  port map( count, t2 );
  M3: entity work.therm(struct_impl) port map( count, t3 );

  process begin
    count <= "0000";
    check <= '0';
    for i in 0 to 15 loop
      wait for 10 ns;
      report "input = " & to_string(count) & " therm = " & to_string(t0);
      if t0 /= t1 then check <= '1'; end if;
      if t0 /= t2 then check <= '1'; end if;
      if t0 /= t3 then check <= '1'; end if;
      count <= count + 1;
    end loop;
    if check = '0' then report "PASS"; 
    else report "FAIL"; end if;
    std.env.stop(0);
  end process;
end test;
-- pragma translate_on
