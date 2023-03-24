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

-- this file uses modules defined in ff.vhd

--Figure 22.7
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ff.all;

entity deserializer is
  generic( width_in: integer := 1;
           n: integer := 8 );
  port( clk, rst, vin: in std_logic; 
        din: in std_logic_vector(width_in-1 downto 0);
        dout: out std_logic_vector(width_in*n-1 downto 0);
        vout: out std_logic );
end deserializer;
  
architecture impl of deserializer is
  signal en_nxt, en_nxt_rst, en_out, en_out_rst: std_logic_vector(n-1 downto 0);
  signal din_rst: std_logic_vector(width_in-1 downto 0);
  signal vout_nxt: std_logic;
begin
  en_nxt <= std_logic_vector(unsigned(en_out) rol 1) when vin else en_out;
  en_nxt_rst <= (n-1 downto 1 => '0') & '1' when rst else en_nxt;
  en_out_rst <= (others => '1') when rst else en_out;
  din_rst    <= (others => '0') when rst else din;

  cnts: vDFF generic map(n) port map(clk,en_nxt_rst,en_out);

  DATA: for i in n downto 1 generate
    reg: vDFFE generic map(width_in) port map(clk, en_out_rst(i-1), 
                din_rst, dout(width_in*i-1 downto width_in*(i-1)));
  end generate;

  vout_nxt <= en_out(n-1) when not rst else vin;
  vout_r: sDFF port map(clk, vout_nxt, vout);
end impl; -- deserializer

--------------------------------------------------------------------------------

-- pragma translate_off

library ieee;
use ieee.std_logic_1164.all;

entity dsTB is
end dsTB;

architecture test of dsTB is
  signal clk, rst, vin: std_logic; 
  signal din: std_logic_vector(0 downto 0);
  signal dout: std_logic_vector(7 downto 0);
  signal vout: std_logic;
begin
  DUT: entity work.deserializer(impl) port map(clk,rst,vin,din,dout,vout);
  
  process begin
    clk <= '1'; wait for 5 ns; 
    clk <= '0'; wait for 5 ns; 
    report "vin: " & to_string(vin) & " din: " & to_string(din) & " vout: " & to_string(vout) &
      " dout: " & to_string(dout) & " en: " & to_string(<<signal DUT.en_out_rst:std_logic_vector>>);
  end process;

  process begin
    vin <= '0'; din <= "0"; rst <= '1'; wait for 15 ns;
    vin <= '1'; din <= "1"; rst <= '0'; wait for 80 ns;
    din <= "0"; wait for 80 ns;
    din <= "1"; wait for 80 ns;
    wait;
  end process;
end test;

-- pragma translate_on
