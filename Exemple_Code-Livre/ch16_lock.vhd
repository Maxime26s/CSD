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

-- uses modules defined in ff.vhd and ch16.vhd

------------------------------------------------------------------------
-- Combination Lock Example
-- Figures 16.30 - 16.33, includes test bench
------------------------------------------------------------------------

library ieee;
package comb_lock_codes is
  use ieee.std_logic_1164.all;
  constant TWAIT: std_logic_vector(3 downto 0) := "0100";
  constant LENGTH: std_logic_vector(3 downto 0) := "1000";
  constant SWIDTH: integer := 2;
  constant S_ENTER: std_logic_vector(SWIDTH-1 downto 0) := "00";
  constant S_OPEN: std_logic_vector(SWIDTH-1 downto 0) := "01";
  constant S_WAIT1: std_logic_vector(SWIDTH-1 downto 0) := "10";
  constant S_WAIT2: std_logic_vector(SWIDTH-1 downto 0) := "11";
  constant CWIDTH: integer := 4;
end package;

------------------------------------------------------------------------
-- CombLock
-- Inputs:
--   key - (4-bit) accepts a code digit each time key_valid is true
--   key_valid - signals when a new code digits is on key
--   enter - signals when entire code has been entered 
-- Outputs:
--   busy - asserted after incorrect code word entered during timeout
--   unlock - asserted after correct codeword is entered until enter
--            is pressed again.
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.ff.all;
use work.ch16.all;
use work.comb_lock_codes.all;

entity CombLock is
  generic( n: integer := 4;   -- bits of code length
           m: integer := 4 ); -- bits of timer
  port( clk, rst, key_valid, enter: in std_logic;
        key: in std_logic_vector(3 downto 0);
        busy, unlock: buffer std_logic );
end CombLock;

architecture impl of CombLock is
  signal rstctr: std_logic; -- reset the digital counter
  signal inc: std_logic; -- increment the digit counter 
  signal load: std_logic; -- load the timer
  signal done: std_logic; -- timer done
  signal kmatch, lmatch, senter, swait1: std_logic;
  signal index: std_logic_vector(n-1 downto 0);
  signal code: std_logic_vector(3 downto 0);
  signal state, nxt, nxt1: std_logic_vector(SWIDTH-1 downto 0);
begin
  ----- datapath ----------------------------------------
  CTR: UDL_Count3 generic map(n) 
         port map(clk,rstctr,inc,'0','0',"0000",index);  -- counter
  MEM: ROM generic map(n,4,"comb_lock.txt") port map(index, code);
  TIM: Timer generic map(m) port map(clk,rst,load,TWAIT,done); -- wait timer
  kmatch <= '1' when code = key else '0'; -- key comparator
  lmatch <= '1' when index = LENGTH else '0'; -- length comparator
  ----- control ----------------------------------------
  senter <= '1' when state = S_ENTER else '0'; -- decode state
  unlock <= '1' when state = S_OPEN  else '0';
  busy   <= '1' when state = S_WAIT2 else '0';
  swait1 <= '1' when state = S_WAIT1 else '0';
  rstctr <= rst or unlock or busy;  -- reset before returning to enter
  inc <= senter and key_valid;      -- increment on each key entry
  load <= senter or swait1;         -- load before entering wait2

  SR: vDFF generic map(SWIDTH) port map(clk,nxt,state); -- state register

  process(all) begin
    case? enter & lmatch & key_valid & kmatch & done & state is
      when "--10-" & S_ENTER => nxt1 <= S_WAIT1; -- valid and not kmatch
      when "0-11-" & S_ENTER => nxt1 <= S_ENTER; -- valid and kmatch
      when "110--" & S_ENTER => nxt1 <= S_OPEN;  -- enter and lmatch
      when "100--" & S_ENTER => nxt1 <= S_WAIT2; -- enter and not lmatch
      when "0-0--" & S_ENTER => nxt1 <= S_ENTER; -- not enter and not valid

      when "1----" & S_OPEN  => nxt1 <= S_ENTER; -- enter
      when "0----" & S_OPEN  => nxt1 <= S_OPEN;  -- not enter

      when "1----" & S_WAIT1 => nxt1 <= S_WAIT2; -- enter
      when "0----" & S_WAIT1 => nxt1 <= S_WAIT1; -- not enter

      when "----1" & S_WAIT2 => nxt1 <= S_ENTER; -- done
      when "----0" & S_WAIT2 => nxt1 <= S_WAIT2; -- not done

      when others => nxt1 <= S_ENTER;
    end case?;
  end process;

  nxt <= S_ENTER when rst else nxt1;
end impl;


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity testbench_comblock is
end testbench_comblock;

architecture test of testbench_comblock is
  signal clk, rst, key_valid, enter: std_logic;
  signal key: std_logic_vector(3 downto 0);
  signal busy, unlock: std_logic;
begin
  DUT: entity work.CombLock(impl) port map(clk,rst,key_valid,enter,key,busy,unlock);

  -- clock and display
  process
  begin
    clk <= '0'; wait for 5 ns;
    clk <= '1'; wait for 5 ns;
  end process;

  process
  begin
    rst <= '1'; key <= "0000"; key_valid <= '0'; enter <= '0'; wait for 20 ns;
    rst <= '0'; wait for 10 ns;
    --  first the correct sequence - with some pauses
    key <= "1000"; key_valid <= '1'; wait for 10 ns;
    key <= "0001"; key_valid <= '1'; wait for 10 ns;
    key_valid <= '0'; wait for 10 ns; -- pause
    key <= "0111"; key_valid <= '1'; wait for 10 ns;
    key_valid <= '0'; wait for 10 ns; -- pause for 2
    key <= "0101"; key_valid <= '1'; wait for 10 ns;
    key <= "0010"; key_valid <= '1'; wait for 10 ns;
    key <= "0110"; key_valid <= '1'; wait for 10 ns;
    key <= "0010"; key_valid <= '1'; wait for 10 ns;
    key <= "1000"; key_valid <= '1'; wait for 10 ns;
    enter <= '1'; key_valid <= '0'; wait for 10 ns; -- open lock
    enter <= '0'; wait for 10 ns; -- stay in open state
    enter <= '1'; wait for 10 ns; -- back to enter state
    enter <= '0'; wait for 10 ns;
    -- now wrong code - first key
    key <= "0111"; key_valid <= '1'; wait for 10 ns; -- to wait1 state
    key <= "0111"; key_valid <= '1'; wait for 10 ns; -- this is ignored in wait 1
    enter <= '1'; key_valid <= '0'; wait for 10 ns; -- this goes to wait2 and starts timer
    enter <= '0'; wait for 60 ns; -- in wait2

    -- now wrong length
    key <= "1000"; key_valid <= '1'; wait for 10 ns; -- no fail on early enter
    key_valid <= '0'; enter <= '1'; wait for 10 ns; -- to wait2
    enter <= '0';
    wait;
  end process;
end test;
