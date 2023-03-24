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

-- this file requires flip-flops defined in ff.vhd

--Figure 14.14
library ieee;
use ieee.std_logic_1164.all;

package Traffic_Light_Codes is 
  -----------------------------------------------
  -- define state assignment - binary
  -----------------------------------------------
  constant SWIDTH: integer := 2;
  subtype state_type is std_logic_vector(SWIDTH-1 downto 0);
  constant GNS: state_type := "00";
  constant YNS: state_type := "01";
  constant GEW: state_type := "11";
  constant YEW: state_type := "10";
  -----------------------------------------------
  -- define output codes
  -----------------------------------------------
  subtype lights_type is std_logic_vector(5 downto 0);
  constant GNSL: lights_type := "100001";
  constant YNSL: lights_type := "010001";
  constant GEWL: lights_type := "001100";
  constant YEWL: lights_type := "001010";
end package;

--------------------------------------------------------
-- Figure 14.13
-- Traffic_Light
-- Inputs:
--   clk - system clock
--   rst - reset - high true
--   carew - car east/west - true when car is waiting in east-west direction
-- Outputs:
--   lights - (6 bits) {gns, yns, rns, gew, yew, rew}
-- Waits in state GNS until carew is true, then sequences YNS, GEW, YEW
-- and back to GNS.
--------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.Traffic_Light_Codes.all;
use work.ff.all;

entity Traffic_Light is
  port( clk, rst, carew: in std_logic; 
        lights: out lights_type );
end Traffic_Light;

architecture impl of Traffic_Light is
  signal current_state, next_state, next1: state_type;
begin
  -- instantiate state register
  STATE_REG: vDFF generic map(SWIDTH) port map(clk,next_state,current_state);

  -- next state and output equations - this is combinational logic
  process(all) begin
    case current_state is
      when GNS => 
        if carew then next1 <= YNS; 
        else next1 <= GNS; end if;
        lights <= GNSL; 
      when YNS => next1 <= GEW; lights <= YNSL;
      when GEW => next1 <= YEW; lights <= GEWL;
      when YEW => next1 <= GNS; lights <= YEWL;
      when others => 
        next1 <= std_logic_vector'(SWIDTH-1 downto 0 => '-'); 
        lights <= "------";
    end case;
  end process;

  -- add reset
  next_state <= GNS when rst else next1;
end impl;

--Figure 14.17
-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;
use work.Traffic_Light_Codes.all;

entity Test_Fsm1 is
end Test_Fsm1;

architecture test of Test_Fsm1 is
  signal clk, rst, carew: std_logic;
  signal lights: std_logic_vector(5 downto 0);
begin
  DUT: entity work.Traffic_Light(impl) port map(clk,rst,carew,lights);

  -- clock with period of 10 ns
  process begin
    clk <= '1'; wait for 5 ns;
    clk <= '0'; wait for 5 ns;
    report to_string(rst) & " " & to_string(carew) & " " & 
           to_string( <<signal DUT.current_state: state_type>> ) & " " & 
           to_string(lights);
  end process;

  -- input stimuli
  process begin
    rst <= '0'; carew <= '0';     -- start w/o reset to show x state
    wait for 15 ns; rst <= '1';   -- reset
    wait for 10 ns; rst <= '0';   -- remove reset
    wait for 20 ns; carew <= '1'; -- wait 2 cycles, then car arrives
    wait for 30 ns; carew <= '0'; -- car leaves after 3 cycles (green)
    wait for 20 ns; carew <= '1'; -- wait 2 cycles then car comes and stays
    wait for 60 ns;
    std.env.stop(0);
  end process;
end test; 
-- pragma translate_on

------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.ff.all;

entity PulseFiller is
  port( clk, rst, a: in std_logic;
        q: out std_logic );
end PulseFiller;

architecture impl of PulseFiller is
  constant SWIDTH: integer := 3;
  constant SR: std_logic_vector(SWIDTH-1 downto 0) := "000";
  constant S1: std_logic_vector(SWIDTH-1 downto 0) := "001";
  constant S2: std_logic_vector(SWIDTH-1 downto 0) := "011";
  constant S3: std_logic_vector(SWIDTH-1 downto 0) := "010";
  constant S4: std_logic_vector(SWIDTH-1 downto 0) := "110";
  constant S5: std_logic_vector(SWIDTH-1 downto 0) := "111";
  constant SM: std_logic_vector(SWIDTH-1 downto 0) := "101";
  constant SL: std_logic_vector(SWIDTH-1 downto 0) := "100";
  constant SX: std_logic_vector(SWIDTH-1 downto 0) := "---";

  signal state, nxt: std_logic_vector(SWIDTH-1 downto 0);
begin
  sreg: vDFF generic map(SWIDTH) port map(clk, nxt, state);

  process(all) begin
    case? rst & a & state is
      when '1' & '-' & SX => q <= '0'; nxt <= SR;
      when '0' & '0' & SR => q <= '0'; nxt <= SR;
      when '0' & '1' & SR => q <= '0'; nxt <= S1;
      when '0' & '-' & S1 => q <= '1'; nxt <= S2;
      when '0' & '-' & S2 => q <= '0'; nxt <= S3;
      when '0' & '-' & S3 => q <= '0'; nxt <= S4;
      when '0' & '0' & S4 => q <= '0'; nxt <= S5;
      when '0' & '1' & S4 => q <= '0'; nxt <= S1;
      when '0' & '0' & S5 => q <= '0'; nxt <= SM;
      when '0' & '1' & S5 => q <= '0'; nxt <= S1;
      when '0' & '0' & SM => q <= '1'; nxt <= S2;
      when '0' & '1' & SM => q <= '1'; nxt <= SL;
      when '0' & '-' & SL => q <= '0'; nxt <= S2;
      when others => q <= '-'; nxt <= SX;
    end case?;
  end process;
end impl;
------------------------------------------------------------------------

-- pragma translate_off

library ieee;
use ieee.std_logic_1164.all;
use std.env.all;

entity testbench_pulsefiller is
end testbench_pulsefiller;

architecture test of testbench_pulsefiller is
  signal clk, rst, a, q: std_logic; 
begin
  DUT: entity work.PulseFiller port map(clk,rst,a,q);
  
  process begin
    clk <= '1'; wait for 5 ns;
    clk <= '0'; wait for 5 ns;
    report "a=" & to_string(a) & "; q=" & to_string(q);
  end process;

  process begin
    a <= '0'; rst <= '1'; wait for 15 ns;
    rst <= '0'; wait for 10 ns;
    a <= '1'; wait for 10 ns;
    a <= '0'; wait for 40 ns;
    a <= '1'; wait for 10 ns;
    a <= '0'; wait for 80 ns;
    a <= '1'; wait for 10 ns;
    a <= '0'; wait for 40 ns; 
    stop(0);
  end process;
end test;  

-- pragma translate_on
