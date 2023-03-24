-- Copyright (C) Tor M. Aamodt, UBC
-- synthesis VHDL_INPUT_VERSION VHDL_2008
-- Ensure your CAD synthesis tool/compiler is configured for VHDL-2008.

--/*******************************************************************************
--Copyright (c) 2012, Stanford University
--All rights reserved.
--
--Redistribution and use in source and binary forms, with or without
--modification, are permitted provided that the following conditions are met:
--1. Redistributions of source code must retain the above copyright
--   notice, this list of conditions and the following disclaimer.
--2. Redistributions in binary form must reproduce the above copyright
--   notice, this list of conditions and the following disclaimer in the
--   documentation and/or other materials provided with the distribution.
--3. All advertising materials mentioning features or use of this software
--   must display the following acknowledgement:
--   This product includes software developed at Stanford University.
--4. Neither the name of Stanford Univerity nor the
--   names of its contributors may be used to endorse or promote products
--   derived from this software without specific prior written permission.
--
--THIS SOFTWARE IS PROVIDED BY STANFORD UNIVERSITY ''AS IS'' AND ANY
--EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
--WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--DISCLAIMED. IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE FOR ANY
--DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
--(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
--ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
--(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--*******************************************************************************/

library ieee;
package ch17_tlc is

use ieee.std_logic_1164.all;

-- Traffic light controller of chapter 17
-- master FSM states
-- these also serve as direction values

constant MWIDTH: integer := 2;
constant M_NS: std_logic_vector(MWIDTH-1 downto 0) := "00";
constant M_EW: std_logic_vector(MWIDTH-1 downto 0) := "01";
constant M_LT: std_logic_vector(MWIDTH-1 downto 0) := "10";

-- light FSM states
constant LWIDTH: integer := 2;
constant L_RED: std_logic_vector(LWIDTH-1 downto 0) := "00";
constant L_GREEN: std_logic_vector(LWIDTH-1 downto 0) := "01";
constant L_YELLOW: std_logic_vector(LWIDTH-1 downto 0) := "10";

-- master timer
constant TWIDTH: integer := 4;
constant T_EXP: std_logic_vector(TWIDTH-1 downto 0) := "1100";

-- light timer
constant LTWIDTH: integer := 4;
constant T_RED: std_logic_vector(LTWIDTH-1 downto 0) := "0011";
constant T_YELLOW: std_logic_vector(LTWIDTH-1 downto 0) := "0100";
constant T_GREEN: std_logic_vector(LTWIDTH-1 downto 0) := "1000";

-- light values
constant RED: std_logic_vector(2 downto 0)    := "100";
constant YELLOW: std_logic_vector(2 downto 0) := "010";
constant GREEN: std_logic_vector(2 downto 0)  := "001";

-- component declarations
component TLC_Light is
  port( clk, rst, gn: in std_logic;
        done: out std_logic;
        light: out std_logic_vector(2 downto 0) );
end component;
component TLC_Master is
  port( clk, rst, car_ew, car_lt, ok: in std_logic;
        dir: out std_logic_vector(1 downto 0) ); -- direction output
end component;
component TLC_Combiner is
  port( clk, rst: in std_logic;
        ok: out std_logic;
        dir: in std_logic_vector( 1 downto 0 );
        lights: out std_logic_vector( 8 downto 0 ) );
end component;

end package;

------------------------------------------------------------------------
--Master FSM
--  car_ew - car waiting on east-west road
--  car_lt - car waiting in left-turn lane
--  ok     - signal that it is ok to request a new direction
--  dir    - output signaling new requested direction
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.ch17_tlc.all;
use work.ff.all;
use work.ch16.all;

entity TLC_Master is
  port( clk, rst, car_ew, car_lt, ok: in std_logic;
        dir: out std_logic_vector(1 downto 0) ); -- direction output
end TLC_Master;

architecture impl of TLC_Master is
  type fsmo_t is record dir: std_logic_vector(1 downto 0); tload: std_logic; end record;
  signal fsmout: fsmo_t;
  signal state, nxt: std_logic_vector(MWIDTH-1 downto 0); -- current and next state
  signal nxt1: std_logic_vector(MWIDTH-1 downto 0); -- next data without reset
  signal tdone: std_logic; -- timer completion
begin
  -- instantiate state register
  STATE_REG: vDFF generic map(MWIDTH) port map(clk, nxt, state);

  -- instantiate timer
  TIMERT: Timer generic map(TWIDTH) port map(clk, rst, fsmout.tload, T_EXP, tdone);

  process(all) begin
    case state is
      when M_NS => fsmout <= (M_NS,'1');
        if not ok then nxt1 <= M_NS;
        elsif car_lt then nxt1 <= M_LT;
        elsif car_ew then nxt1 <= M_EW;
        else nxt1 <= M_NS; end if;
      when M_EW => fsmout <= (M_EW,'0');
        if ok and (not car_ew or tdone) then nxt1 <= M_NS;
        else nxt1 <= M_EW; end if;
      when M_LT => fsmout <= (M_LT,'0');
        if ok and (not car_ew or tdone) then nxt1 <= M_NS;
        else nxt1 <= M_LT; end if;
      when others => fsmout <= (M_NS,'0'); 
        nxt1 <= M_NS;
    end case;
  end process;
  nxt <= M_NS when rst else nxt1;
end impl;
------------------------------------------------------------------------
-- Combiner -
--   dir - direction request from master FSM
--   ok  - acknowledge to master FSM
--   lights - 9-bits to control traffic lights {NS,EW,LT}
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.ch17_tlc.all;
use work.ff.all;

entity TLC_Combiner is
  port( clk, rst: in std_logic;
        ok: out std_logic;
        dir: in std_logic_vector( 1 downto 0 );
        lights: out std_logic_vector( 8 downto 0 ) );
end TLC_Combiner;

architecture impl of TLC_Combiner is
  signal done, gn: std_logic;
  signal light: std_logic_vector(2 downto 0);
  signal cur_dir, next_dir: std_logic_vector(1 downto 0);
begin
  -- current direction register
  DIR_REG: vDFF generic map(2) port map(clk, next_dir, cur_dir);

  -- light FSM
  LT: TLC_Light port map(clk, rst, gn, done, light);

  -- request green from light FSM until direction changes
  gn <= '1' when cur_dir = dir else '0';

  -- update direction when light FSM has made lights red
  next_dir <= "00" when rst else 
              dir  when gn and done else 
              cur_dir;

  -- ok to take another change when light FSM is done
  ok <= gn and done ;

  -- combine cur_dir and light to get lights
  process(all) begin
    case cur_dir is
      when M_NS => lights <= light & RED   & RED;
      when M_EW => lights <= RED   & light & RED;
      when M_LT => lights <= RED   & RED   & light;
      when others => lights <= RED & RED   & RED;
    end case;
  end process;
end impl;
------------------------------------------------------------------------
-- Light FSM
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.ch17_tlc.all;
use work.ff.all;
use work.ch16.all;

entity TLC_Light is
  port( clk, rst, gn: in std_logic;
        done: out std_logic;
        light: out std_logic_vector(2 downto 0) );
end TLC_Light;

architecture impl of TLC_Light is
  type fsm_output_type is record
    tload : std_logic;
    tin   : std_logic_vector(LTWIDTH-1 downto 0);
    light : std_logic_vector(2 downto 0);
    done  : std_logic;
  end record;
  signal fsmo: fsm_output_type;
  signal state, nxt: std_logic_vector(LWIDTH-1 downto 0); -- current state, next state
  signal nxt1: std_logic_vector(LWIDTH-1 downto 0); -- next state w/o reset
  signal tdone: std_logic;
begin
  -- instantiate timer
  TIMERT: Timer port map(clk, rst, fsmo.tload, fsmo.tin, tdone);

  -- instantiate state register
  STATE_REG: vDFF generic map(LWIDTH) port map(clk, nxt, state);

  process(all) begin
    case state is
      when L_RED =>    fsmo <= ((tdone and gn), T_GREEN, RED, not tdone);
        if tdone and gn then nxt1 <= L_GREEN; 
        else nxt1 <= L_RED; end if;
      when L_GREEN =>  fsmo <= ((tdone and not gn), T_YELLOW, GREEN, tdone);
        if tdone and not gn then nxt1 <= L_YELLOW; 
        else nxt1 <= L_GREEN; end if;
      when L_YELLOW => fsmo <= (tdone, T_RED, YELLOW, '1');
        if tdone then nxt1 <= L_RED; else nxt1 <= L_YELLOW; end if;
      when others =>   fsmo <= (tdone, T_RED, YELLOW, '1');
        if tdone then nxt1 <= L_RED; else nxt1 <= L_YELLOW; end if;
    end case;
  end process;

  nxt <= L_RED when rst else nxt1;
  done <= fsmo.done; light <= fsmo.light;
end impl;
------------------------------------------------------------------------
-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;
use work.ch17_tlc.all;

entity TestTLC is 
end TestTLC;

architecture test of TestTLC is
  signal car_ew, car_lt, clk, rst, ok: std_logic;
  signal lights: std_logic_vector(8 downto 0);
  signal dir: std_logic_vector(1 downto 0);
begin

  M: TLC_Master port map(clk, rst, car_ew, car_lt, ok, dir);
  C: TLC_Combiner port map(clk, rst, ok, dir, lights);

  -- clock and display
  process begin
    report to_string(car_ew) & " " & to_string(car_lt) & " " & to_string(lights);
    clk <= '0'; wait for 5 ns;
    clk <= '1'; wait for 5 ns;
  end process;

  process begin
    rst <= '1'; car_ew <= '0'; car_lt <= '0'; wait for 10 ns;
    rst <= '0'; wait for 20 ns;
    car_ew <= '1'; wait for 200 ns;
    car_ew <= '0'; wait for 200 ns;
    car_lt <= '1'; wait for 400 ns;
    assert false report "simulation done" severity failure;
  end process;
end test;
-- pragma translate_on
