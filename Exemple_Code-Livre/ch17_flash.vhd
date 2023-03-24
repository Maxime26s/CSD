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

-- requires modules defined in ff.vhd

--Modules for Section 17.1, includes testbenches
-- define states for flash1
library ieee;
use ieee.std_logic_1164.all;

package flash_declarations is
  -- define states for flash1
  constant SWIDTH: integer := 3;
  constant S_OFF: std_logic_vector(SWIDTH-1 downto 0) := "000";
  constant S_A: std_logic_vector(SWIDTH-1 downto 0) := "001";
  constant S_B: std_logic_vector(SWIDTH-1 downto 0) := "010";
  constant S_C: std_logic_vector(SWIDTH-1 downto 0) := "011";
  constant S_D: std_logic_vector(SWIDTH-1 downto 0) := "100";
  constant S_E: std_logic_vector(SWIDTH-1 downto 0) := "101";

  -- define time intervals 
  -- load 5 for 6-cycle interval 5 to 0.
  constant T_WIDTH: integer := 3;
  constant T_ON: std_logic_vector(T_WIDTH-1 downto 0) := "101";
  constant T_OFF: std_logic_vector(T_WIDTH-1 downto 0) := "011";

  -- constants for pulse counter
  -- load with 3 for four pulses
  constant C_WIDTH: integer := 2;
  constant C_COUNT: std_logic_vector(C_WIDTH-1 downto 0) := 2d"3";

  -- constants for doubly factored states
  constant XWIDTH: integer := 2;
  constant X_OFF: std_logic_vector(XWIDTH-1 downto 0) := "00";
  constant X_FLASH: std_logic_vector(XWIDTH-1 downto 0) := "01";
  constant X_SPACE: std_logic_vector(XWIDTH-1 downto 0) := "10";

  -- master FSM states
  -- these also serve as direction values
  constant MWIDTH: integer := 2;
  constant M_NS: std_logic_vector(MWIDTH-1 downto 0) := "00";
  constant M_EW: std_logic_vector(MWIDTH-1 downto 0) := "01";
  constant M_LT: std_logic_vector(MWIDTH-1 downto 0) := "10";

  -- local component declarations
  component Timer1 is
    generic( n: integer := T_WIDTH );
    port( clk, rst, tload, tsel: in std_logic;
          done_o: out std_logic );
  end component;
  component Counter1 is
    generic( n: integer := C_WIDTH );
    port( clk, rst, cload, cdec: in std_logic;
          cdone: buffer std_logic );
  end component;
  component Flash is
    port( clk, rst, input: in std_logic;
          output: out std_logic );
  end component;
  component Flash2 is
    port( clk, rst, input: in std_logic;
          output: out std_logic );
  end component;
end package;

-- Flash - flashes out three times 6 cycles on, 4 cycles off
--         each time in is asserted.
library ieee;
use ieee.std_logic_1164.all;
use work.ff.all;
use work.flash_declarations.all;

entity Flash is
  port( clk, rst, input: in std_logic; -- input triggers start of flash sequence
        output: out std_logic ); -- output drives LED
end Flash;

architecture impl of Flash is
  type fsm_output_t is record output, tload, tsel : std_logic; end record;
  signal fsm_out : fsm_output_t;
  signal state: std_logic_vector(SWIDTH-1 downto 0); -- current state
  signal nxt, nxt1: std_logic_vector(SWIDTH-1 downto 0); -- next state with and w/o reset
  signal done: std_logic; -- timer output
begin
  -- instantiate state register
  STATE_REG: vDFF generic map(SWIDTH) port map(clk,nxt,state);

  -- instantiate timer
  TIMER: Timer1 port map(clk,rst,fsm_out.tload,fsm_out.tsel,done);

  process(all) begin
    case state is
      when S_OFF => fsm_out <= ('0','1','1');
        if input then nxt1 <= S_A; else nxt1 <= S_OFF; end if;
      when S_A =>   fsm_out <= ('1',done,'0');
        if done then nxt1 <= S_B; else nxt1 <= S_A; end if;
      when S_B =>   fsm_out <= ('0',done,'1');
        if done then nxt1 <= S_C; else nxt1 <= S_B; end if;
      when S_C =>   fsm_out <= ('1',done,'0');
        if done then nxt1 <= S_D; else nxt1 <= S_C; end if;
      when S_D =>   fsm_out <= ('0',done,'1');
        if done then nxt1 <= S_E; else nxt1 <= S_D; end if;
      when S_E =>   fsm_out <= ('1',done,'1');
        if done then nxt1 <= S_OFF; else nxt1 <= S_E; end if;
      when others => fsm_out <= ('1',done,'1');
        if done then nxt1 <= S_OFF; else nxt1 <= S_E; end if;
    end case;
  end process;

  nxt <= S_OFF when rst else nxt1;
  output <= fsm_out.output;
end impl;

-- Timer 1 - reset to done state.  Load time when tload is asserted
--   Load with T_ON if tsel, otherwise T_OFF.  If not being loaded or
--   reset, timer counts down each cycle.  Done is asserted and timing
--   stops when counter reaches 0. 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.ff.all;
use work.flash_declarations.all;

entity Timer1 is
  generic( n: integer := T_WIDTH );
  port( clk, rst, tload, tsel: in std_logic;
        done_o: out std_logic );
end Timer1;

architecture impl of Timer1 is
  signal done: std_logic;
  signal next_count, count: std_logic_vector(n-1 downto 0);
begin
  -- state register
  STATE: vDFF generic map(n) port map(clk, next_count, count);

  -- signal done
  done <= not or_reduce(count); done_o <= done;

  -- next count logic
  process(all) begin
    case? std_logic_vector'(rst & tload & tsel & done) is
      when "1---" => next_count <= (others => '0');
      when "011-" => next_count <= T_ON;
      when "010-" => next_count <= T_OFF;
      when "00-0" => next_count <= count - '1';
      when "00-1" => next_count <= count;
      when others => next_count <= count;
    end case?;
  end process;
end impl;

-- Counter1 - pulse counter
--   cload - loads counter with C_COUNT
--   cdec  - decrements counter by one if not already zero
--   cdone - signals when count has reached zero
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_unsigned.all;
use work.flash_declarations.all;
use work.ff.all;

entity Counter1 is
  generic( n: integer := C_WIDTH );
  port( clk, rst, cload, cdec: in std_logic;
        cdone: buffer std_logic );
end Counter1;

architecture impl of Counter1 is
  signal count, next_count: std_logic_vector(n-1 downto 0); 
begin
  -- state register
  STATE: vDFF generic map(n) port map(clk, next_count, count);

  -- signal done
  cdone <= not or_reduce(count);

  -- next count logic
  process(all) begin
    case? std_logic_vector'(rst & cload & cdec & cdone) is
      when "1---" => next_count <= (others => '0');
      when "01--" => next_count <= C_COUNT;
      when "0010" => next_count <= count - '1';
      when "00-1" => next_count <= count;
      when others => next_count <= count;
    end case?;
  end process;
end impl;
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.flash_declarations.all;
use work.ff.all;

entity Flash2 is
  port( clk, rst, input: in std_logic; -- in triggers start of flash sequence
        output: out std_logic ); -- out drives LED
end Flash2;

architecture impl of Flash2 is
  type fsm_output_t is record 
    output, tload, tsel, cload, cdec : std_logic; 
  end record;
  signal fsm_out : fsm_output_t;
  signal state, nxt, nxt1: std_logic_vector(XWIDTH-1 downto 0);
  signal tload, tsel, cload, cdec: std_logic;  -- timer and counter inputs
  signal tdone, cdone: std_logic;              -- timer and counter outputs
begin
  -- instantiate timer and counter
  TIMER: Timer1 port map(clk, rst, tload, tsel, tdone);
  COUNTER: Counter1 port map(clk, rst, cload, cdec, cdone);

  -- instantiate state register
  STATE_REG: vDFF generic map(XWIDTH) port map(clk, nxt, state) ;

  process(all) begin
    case state is
      when X_OFF =>   fsm_out <= ('0','1','1','1','0');
        if input then nxt1 <= X_FLASH;
        else nxt1 <= X_OFF; end if;
      when X_FLASH => fsm_out <= ('1',tdone,'0','0','0');
        if not tdone then nxt1 <= X_FLASH;
        elsif not cdone then nxt1 <= X_SPACE;
        else nxt1 <= X_OFF; end if;
      when X_SPACE => fsm_out <= ('0',tdone,'1','0',tdone);
        if not tdone then nxt1 <= X_SPACE; 
        else nxt1 <= X_FLASH; end if;
      when others =>  fsm_out <= ('0',tdone,'1','0',tdone);
        if not tdone then nxt1 <= X_SPACE; 
        else nxt1 <= X_FLASH; end if;
    end case;
  end process;

  nxt <= X_OFF when rst = '1' else nxt1;
end impl;
------------------------------------------------------------------------
-- pragma translate_off

library ieee;
use ieee.std_logic_1164.all;
use work.flash_declarations.all;

entity TestFlash is
end TestFlash;

architecture test of TestFlash is
  signal clk, rst, input, output : std_logic;
begin
  F: Flash port map(clk, rst, input, output) ;  

  -- clock and display
  process begin
    report to_string(input) & " " & to_string(output);
    clk <= '0'; wait for 5 ns;
    clk <= '1'; wait for 5 ns;
  end process;

  -- inputs
  process begin
    rst <= '1'; input <= '0'; wait for 10 ns;
    rst <= '0'; wait for 10 ns;
    input <= '1'; wait for 10 ns;
    input <= '0'; wait for 320 ns;
    input <= '1'; wait for 10 ns;
    input <= '0'; 
    wait;
  end process;
end test;
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.flash_declarations.all;

entity TestFlash2 is
end TestFlash2;

architecture test of TestFlash2 is
  signal clk, rst, input, output: std_logic;
begin
  F: Flash2 port map(clk, rst, input, output) ;  

  -- clock and display
  process begin
    report to_string(input) & " " & to_string(output);
    clk <= '0'; wait for 5 ns;
    clk <= '1'; wait for 5 ns;
  end process;

  -- inputs
  process begin
    rst <= '1'; input <= '0'; wait for 10 ns;
    rst <= '0'; wait for 10 ns;
    input <= '1'; wait for 10 ns;
    input <= '0'; wait for 400 ns;
    input <= '1'; wait;
  end process;
end test;

-- pragma translate_on
