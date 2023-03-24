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

--Figure 23.10
library ieee;
use ieee.std_logic_1164.all;
use work.ff.all;

entity single_buffer is
  generic( bits: integer := 32 );
  port( rst, clk: in std_logic;
        upstream_data: in std_logic_vector(bits-1 downto 0);
        downstream_ready, upstream_valid: in std_logic; 
        downstream_data: buffer std_logic_vector(bits-1 downto 0);
        upstream_ready, downstream_valid: buffer std_logic );
end single_buffer;

architecture impl of single_buffer is
  signal stall, valid_nxt: std_logic;
  signal data_nxt: std_logic_vector(bits-1 downto 0);
begin
   upstream_ready <= downstream_ready;
   stall <= not upstream_ready;
   
   data_nxt <= (others => '0') when rst else
               downstream_data when stall else
               upstream_data;

   valid_nxt <= '0' when rst else
                downstream_valid when stall else
                upstream_valid;
   
   dataR: vDFF generic map(bits) port map(clk, data_nxt, downstream_data);
   validR: sDFF port map(clk, valid_nxt, downstream_valid);
  
end impl; -- single_buffer

--Figure 23.12
library ieee;
use ieee.std_logic_1164.all;
use work.ff.all;

entity double_buffer is
  generic( bits: integer := 32 );
  port( rst, clk: in std_logic;
        upstream_data: in std_logic_vector(bits-1 downto 0);
        downstream_ready, upstream_valid: in std_logic; 
        downstream_data: buffer std_logic_vector(bits-1 downto 0);
        upstream_ready, downstream_valid: buffer std_logic );
end double_buffer;

architecture impl of double_buffer is
   signal data_a: std_logic_vector(bits-1 downto 0);
   signal data_b: std_logic_vector(bits-1 downto 0);
   signal valid_a, valid_b: std_logic;
   signal data_a_nxt, data_b_nxt: std_logic_vector(bits-1 downto 0);
   signal valid_a_nxt, valid_b_nxt, upstream_ready_nxt: std_logic;
begin
   downstream_data <= data_a;
   downstream_valid <= valid_a;

   data_b_nxt <= (others => '0') when rst else
                 upstream_data when upstream_ready and downstream_ready else
                 data_b; 
   
   data_a_nxt <= (others => '0') when rst else
                 data_a when downstream_ready else
                 upstream_data when upstream_ready else
                 data_b;
   
   valid_b_nxt <= '0' when rst else
                  upstream_valid when upstream_ready and downstream_ready else
                  valid_b;

   valid_a_nxt <= '0' when rst else
                 valid_a when downstream_ready else
                 upstream_valid when upstream_ready else
                 valid_b;

   upstream_ready_nxt <= '1' when rst else downstream_ready;
   
   dataRa:  vDFF generic map(bits) port map(clk, data_a_nxt, data_a);
   dataRb:  vDFF generic map(bits) port map(clk, data_b_nxt, data_b);
   validRa: sDFF port map(clk, valid_a_nxt, valid_a);
   validRb: sDFF port map(clk, valid_b_nxt, valid_b);
   readyR:  sDFF port map(clk, upstream_ready_nxt, upstream_ready);
end impl; -- double_buffer

--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity testbuffer is
end testbuffer;

architecture test of testbuffer is
  signal rst, clk: std_logic;

  constant PIPESTAGES : integer := 4;
  type bus_type is array (0 to PIPESTAGES) of std_logic_vector(7 downto 0);
  subtype s_type is std_logic_vector(0 to PIPESTAGES);

  signal data: bus_type;
  signal ready, valid, stall, ready_in: s_type;
begin
  P: for i in 0 to PIPESTAGES-1 generate
    ready_in(i+1) <= ready(i+1) and not stall(i);
    REG: entity work.double_buffer(impl) 
            generic map(8) port map( rst, clk, data(i), ready_in(i+1), valid(i), data(i+1), ready(i), valid(i+1) );
  end generate;

  process begin
    clk <= '0'; wait for 5 ns;
    clk <= '1'; wait for 5 ns;
  end process;

  process begin
    ready(PIPESTAGES) <= '1'; valid(0) <= '1'; stall <= 5x"0";
    rst <= '1'; data(0) <= 8x"0"; wait for 10 ns;
    rst <= '0';
    data(0) <= 8x"1"; wait for 10 ns;
    data(0) <= 8x"2"; wait for 10 ns;
    data(0) <= 8x"3"; wait for 10 ns;
    data(0) <= 8x"4"; wait for 10 ns;
    stall(3) <= '1'; wait for 10 ns;
    stall(3) <= '0'; 
    data(0) <= 8x"5"; wait for 10 ns;
    data(0) <= 8x"6"; wait for 10 ns;

    wait;
  end process;

end test;
