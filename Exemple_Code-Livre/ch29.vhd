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

library ieee;
package ch29 is
  use ieee.std_logic_1164.all;

  component DP_RAM is 
    generic( n: integer :=8; -- width of RAM
             m: integer := 8; -- depth of RAM (number of words)
             lgm: integer := 3 ); -- log of m - width of address field
    port( clk, wr: in std_logic;
          inaddr, outaddr: in std_logic_vector(lgm-1 downto 0);
          input: in std_logic_vector(n-1 downto 0);
          output: out std_logic_vector(n-1 downto 0) );
  end component;

  component BFSync is 
    generic( n: integer := 8 );
    port( clk: in std_logic;
          input: in std_logic_vector(n-1 downto 0);
          output: out std_logic_vector(n-1 downto 0) );
  end component;

  component GrayInc3 is
    port(input: in std_logic_vector(2 downto 0);
         output: out std_logic_vector(2 downto 0) );
  end component;
end package;

--Figure 29.4
library ieee;
use ieee.std_logic_1164.all;
use work.ff.all;

entity GrayCount4 is
  port(clk, rst: in std_logic; 
       output: buffer std_logic_vector(3 downto 0) );
end GrayCount4;

architecture impl of GrayCount4 is
  signal nxt: std_logic_vector(3 downto 0);
begin
  COUNT: vDFF generic map(4) port map(clk, nxt, output);

  nxt(0) <= not rst and not (output(1) xor output(2) xor output(3)) ;
  nxt(1) <= '0' when rst else
            not (output(2) xor output(3)) when output(0) else
            output(1);
  nxt(2) <= '0' when rst else
            not output(3) when output(1) and output(0) else
            output(2);
  nxt(3) <= '0' when rst else 
            output(2) when not (output(1) or output(0)) else
            output(3);
end impl; -- GrayCount4

--Figure 29.10, 29.11 and test bench
------------------------------------------------------------------------
-- DP_RAM - one input port and one output port
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DP_RAM is 
  generic( n: integer :=8; -- width of RAM
           m: integer := 8; -- depth of RAM (number of words)
           lgm: integer := 3 ); -- log of m - width of address field
  port( clk, wr: in std_logic;
        inaddr, outaddr: in std_logic_vector(lgm-1 downto 0);
        input: in std_logic_vector(n-1 downto 0);
        output: out std_logic_vector(n-1 downto 0) );
end DP_RAM;

architecture impl of DP_RAM is
  type ram_type is array (0 to m-1) of std_logic_vector(n-1 downto 0);
  signal mem: ram_type;
begin 

  -- write ram on rising edge of clock
  process(clk) begin
    if rising_edge(clk) then
      if wr then 
        mem(to_integer(unsigned(inaddr))) <= input; 
      end if; 
    end if;
  end process;

  output <= mem( to_integer(unsigned(outaddr)) );
end impl;
------------------------------------------------------------------------
-- Brute-force synchronizer
-- Samples async input, in, with clk, resamples after waiting for
-- metastable states to decay
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.ff.all;
entity BFSync is 
  generic( n: integer := 8 );
  port( clk: in std_logic;
        input: in std_logic_vector(n-1 downto 0);
        output: out std_logic_vector(n-1 downto 0) );
end BFSync;
architecture impl of BFSync is
  signal meta: std_logic_vector(n-1 downto 0);
begin
  A: vDFF generic map(n) port map(clk, input, meta) ;
  B: vDFF generic map(n) port map(clk, meta, output) ;
end impl; 
------------------------------------------------------------------------
-- 3-bit Gray-code increment
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity GrayInc3 is
  port(input: in std_logic_vector(2 downto 0);
       output: out std_logic_vector(2 downto 0) );
end GrayInc3;
architecture impl of GrayInc3 is
begin
  output(0) <= not (input(1) xor input(2));
  output(1) <= not input(2) when input(0) else input(1);
  output(2) <= input(1) when not input(0) else input(2);
end impl;
------------------------------------------------------------------------
-- Async FIFO Module
-- input port is associated with clkin, output port with clkout
-- separate resets for each port - synchronous
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.ff.all;
use work.ch29.all;
entity AsyncFIFO is
  generic( n: integer := 8; -- width of FIFO
           m: integer := 8; -- depth of FIFO
           lgm: integer := 3 ); -- width of pointer field  
  port( clkin, rstin, clkout, rstout, ivalid, oready: in std_logic;
        iready, ovalid: buffer std_logic;
        input: in std_logic_vector(n-1 downto 0);
        output: out std_logic_vector(n-1 downto 0) );
end AsyncFIFO;
architecture impl of AsyncFIFO is
  signal head, next_head, head_i: std_logic_vector(lgm-1 downto 0);
  signal tail, next_tail, tail_o: std_logic_vector(lgm-1 downto 0);
  signal inc_head, inc_tail : std_logic_vector(lgm-1 downto 0);
begin
  -- words are inserted at tail and removed at head
  -- sync_x is head/tail synchronized to other clock domain
  -- inc_x is head/tail incremented by Gray code

  -- Dual-Port RAM to hold data
  mem: DP_RAM generic map(n,m,lgm) 
        port map(clk => clkin, input => input, inaddr => tail(lgm-1 downto 0), 
                 wr => iready and ivalid, output => output, 
                 outaddr => head(lgm-1 downto 0));

  -- head clocked by output, tail by input
  hp: vDFF generic map(lgm) port map(clkout, next_head, head);
  tp: vDFF generic map(lgm) port map(clkin, next_tail, tail);

  -- synchronizers
  hs: BFSync generic map(lgm) port map(clkin, head, head_i); -- head in tail domain
  ts: BFSync generic map(lgm) port map(clkout, tail, tail_o); -- tail in head domain

  -- Gray code incrementers
  hg: GrayInc3 port map(head, inc_head);
  tg: GrayInc3 port map(tail, inc_tail);

  -- iready if not full, oready if not empty
  -- input clock for full
  -- full when head points one beyond tail
  iready <= '0' when head_i = inc_tail else '1'; 
  -- output clock for empty
  ovalid <= '0' when head = tail_o else '1'; -- output clk

  -- tail increments on successful insert
  next_tail <= (others=>'0') when rstin else
               inc_tail when ivalid and iready else
               tail;

  -- head increments on successful remove
  next_head <= (others=>'0') when rstout else
               inc_head when ovalid and oready else
               head;
end impl;

--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FIFO_Test is
end FIFO_Test;

architecture test of FIFO_Test is
  signal rstin, clkin, rstout, clkout, ivalid, oready: std_logic;
  signal input, output: std_logic_vector(7 downto 0);
  signal iready, ovalid: std_logic;
begin

  f: entity work.AsyncFIFO(impl) 
      generic map(8,8,3) 
      port map(clkin, rstin, clkout, rstout, ivalid, oready, iready, ovalid, input, output);

  -- input clock with period of 10 units
  process begin
    wait for 5 ns; clkin <= '0'; 
    wait for 5 ns; clkin <= '1';
  end process;

  -- output clock with period of 12 units
  process begin
    wait for 6 ns; clkout <= '0'; 
    wait for 6 ns; clkout <= '1';
  end process;

  -- input side
  process begin
    wait for 5 ns; rstin <= '1'; ivalid <= '0'; 
    wait for 30 ns;
    wait for 10 ns; rstin <= '0'; ivalid <= '1'; input <= 8d"1";
    for i in 1 to 15 loop
      wait for 10 ns; 
      input <= input + iready;
    end loop;
    wait for 10 ns; ivalid <= '0';
    wait for 30 ns; ivalid <= '1'; input <= input+iready ;
    for i in 1 to 15 loop
      wait for 10 ns; 
      input <= input + iready;
    end loop;
    wait for 10 ns; ivalid <= '0';
    wait;
  end process;

  -- output side
  process begin
    wait for 6 ns; oready <= '0'; rstout <= '1';
    wait for 36 ns;  
    wait for 12 ns; rstout <= '0'; 
    for i in 1 to 6 loop
      wait for 12 ns; oready <= '0';
    end loop;
    for i in 1 to 4 loop
      wait for 12 ns;
      oready <= '1';
      wait for 12 ns;
      oready <= '0';
    end loop;
    for i in 1 to 8 loop
      wait for 12 ns;
      oready <= '1';
    end loop;
    wait;
  end process; 
end test;
