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

-- uses modules defined in ff.vhd and ch08.vhd

library ieee;
package ch16 is
  use ieee.std_logic_1164.all;

  component Timer is
    generic( n: integer := 4 );
    port( clk, rst, load: in std_logic;
          input: in std_logic_vector(n-1 downto 0);
          done: out std_logic );
  end component;

  component UDL_Count2 is
    generic( n: integer := 4 );
    port( clk, rst, up, down, load: in std_logic;
          input: in std_logic_vector(n-1 downto 0);
          output: out std_logic_vector(n-1 downto 0) );
  end component;

  component UDL_Count3 is
    generic( n: integer := 4 );
    port( clk, rst, up, down, load: in std_logic;
          input: in std_logic_vector(n-1 downto 0);
          output: buffer std_logic_vector(n-1 downto 0) );
  end component;

  component LRL_Shift_Register is
    generic( n: integer := 4 );
    port( clk, rst, left, right, load, sin: std_logic;
          input: in std_logic_vector(n-1 downto 0);
          output: out std_logic_vector(n-1 downto 0) );
  end component;
end package;
--------------------------------------------------------------------------------

--Figure 16.2
library ieee;
use ieee.std_logic_1164.all;
use work.ff.all;

entity Counter1 is
  port( clk, rst: in std_logic;
        count: buffer std_logic_vector(2 downto 0) );
end Counter1;

architecture impl of Counter1 is
  signal nxt: std_logic_vector( 2 downto 0 );
begin
  COUNTER: vDFF generic map(3) port map(clk,nxt,count);

  process(all) begin
    case? rst & count is
      when "1---" => nxt <= 3d"0";
      when  4d"0" => nxt <= 3d"1";
      when  4d"1" => nxt <= 3d"2";
      when  4d"2" => nxt <= 3d"3";
      when  4d"3" => nxt <= 3d"4";
      when  4d"4" => nxt <= 3d"5";
      when  4d"5" => nxt <= 3d"6";
      when  4d"6" => nxt <= 3d"7";
      when others => nxt <= "000";
    end case?;
  end process;
end impl;

--Figure 16.3
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ff.all;

entity Counter is
  generic( n: integer := 5 );
  port( clk, rst: in std_logic;
        count: buffer std_logic_vector(n-1 downto 0) );
end Counter;

architecture impl of Counter is
  signal nxt: std_logic_vector(n-1 downto 0);
begin
  COUNTER: vDFF generic map(n) port map(clk,nxt,count); 

  nxt <= (others => '0') when rst else count+1;
end impl;

--Figure 16.6
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ff.all;

entity UDL_Count1 is
  generic( n: integer := 4 );
  port( clk, rst, up, down, load: in std_logic;
        input: in std_logic_vector(n-1 downto 0);
        output: buffer std_logic_vector(n-1 downto 0) );
end UDL_Count1;

architecture impl of UDL_Count1 is
  signal nxt: std_logic_vector(n-1 downto 0);
begin
  COUNT: vDFF generic map(n) port map(clk,nxt,output);

  process(all) begin
    case? std_logic_vector'(rst & up & down & load) is
      when "1---" => nxt <= (others => '0');
      when "01--" => nxt <= output + 1;
      when "001-" => nxt <= output - 1;
      when "0001" => nxt <= input;
      when others => nxt <= output;
    end case?;
  end process;
end impl;

--Figure 16.7
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ff.all;

entity UDL_Count2 is
  generic( n: integer := 4 );
  port( clk, rst, up, down, load: in std_logic;
        input: in std_logic_vector(n-1 downto 0);
        output: buffer std_logic_vector(n-1 downto 0) );
end UDL_Count2;

architecture impl of UDL_Count2 is
  signal outpm1, nxt: std_logic_vector(n-1 downto 0);
begin
  COUNT: vDFF generic map(n) port map(clk,nxt,output);

  outpm1 <= output + ((n-2 downto 0 => down) & '1');

  process(all) begin
    case? std_logic_vector'(rst & up & down & load) is
      when "1---" => nxt <= (others => '0');
      when "01--" => nxt <= outpm1;
      when "001-" => nxt <= outpm1;
      when "0001" => nxt <= input;
      when others => nxt <= output;
    end case?;
  end process;
end impl;

--Figure 16.9
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ff.all;
use work.ch8.all; -- Mux4

entity UDL_Count3 is
  generic( n: integer := 4 );
  port( clk, rst, up, down, load: in std_logic;
        input: in std_logic_vector(n-1 downto 0);
        output: buffer std_logic_vector(n-1 downto 0) );
end UDL_Count3;

architecture impl of UDL_Count3 is
  signal outpm1, nxt: std_logic_vector(n-1 downto 0);
  signal sel: std_logic_vector(3 downto 0);
begin
  REG: vDFF generic map(n) port map(clk,nxt,output);

  outpm1 <= output + ((n-2 downto 0 => (not up)) & '1');

  MUX: Mux4 generic map(n) port map(output, input, outpm1, (n-1 downto 0 => '0'),
         ((not rst) and (not up) and (not down) and (not load)) &
         ((not rst) and load) &
         ((not rst) and (up or down)) &
         rst, nxt);
end impl;

--Figure 16.11
------------------------------------------------------------------------
-- Timer design entity
-- rst sets count to zero
-- load sets count to input
-- Otherwise count decrements and saturates at zero (doesn't wrap)
-- Done is asserted when count is zero
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ch8.all;
use work.ff.all;

entity Timer is
  generic( n: integer := 4 );
  port( clk, rst, load: in std_logic;
        input: in std_logic_vector(n-1 downto 0);
        done: buffer std_logic );
end Timer;

architecture impl of Timer is
  signal count, next_count, cntm1, zero: std_logic_vector(n-1 downto 0);
  signal sel: std_logic_vector(2 downto 0);
begin
  CNT: vDFF generic map(n) port map(clk,next_count,count);
  MUX: Mux3 generic map(n) port map(count - 1,input, (n-1 downto 0 => '0'),
         ((not rst) and (not load) and (not done)) &
         (load and (not rst)) &
         (rst or (done and (not load))), 
         next_count);
  done <= '1' when count = 0 else '0';
end impl;

--Figure 16.12
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.ff.all;

entity IncDecBy3 is
  generic( n: integer := 8 );
  port( clk, rst, inc, dec: in std_logic;
        output: buffer std_logic_vector(n-1 downto 0) );
end IncDecBy3;

architecture impl of IncDecBy3 is
  signal outpm3, pm3, nxt: std_logic_vector(n-1 downto 0);
begin
  SR: vDFF generic map(n) port map(clk,nxt,output); 

  pm3 <= conv_std_logic_vector(-3,n) when dec else conv_std_logic_vector(3,n);
  outpm3 <= output + pm3;
  
  process(all) begin
    case? rst & inc & dec & outpm3 is
      when "1--" => nxt <= (others => '0'); -- reset
      when "010" => nxt <= outpm3;          -- increment
      when "001" => nxt <= outpm3;          -- decrement
      when "000" => nxt <= output;          -- hold
      when others=> nxt <= (others => '-');
    end case?;
  end process;
end impl;

-- Figure 16.14
------------------------------------------------------------------------
-- Basic shift register 
-- rst - sets out to zero, otherwise out shifts left - sin becomes lsb
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.ff.all;

entity Shift_Register1 is
  generic( n: integer := 4 );
  port( clk, rst, sin: in std_logic;
        output: buffer std_logic_vector(n-1 downto 0) );
end Shift_Register1;

architecture impl of Shift_Register1 is
  signal nxt: std_logic_vector(n-1 downto 0);
begin
  nxt <= (others => '0') when rst else output(n-2 downto 0) & sin;
  CNT: vDFF generic map(n) port map(clk, nxt, output);
end impl;

--Figure 16.16
------------------------------------------------------------------------
-- Left/Right SR with Load
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.ff.all;

entity LRL_Shift_Register is
  generic( n: integer := 4 );
  port( clk, rst, left, right, load, sin: in std_logic;
        input: in std_logic_vector(n-1 downto 0);
        output: buffer std_logic_vector(n-1 downto 0) );
end LRL_Shift_Register;

architecture impl of LRL_Shift_Register is
  signal nxt: std_logic_vector(n-1 downto 0);
begin
  CNT: vDFF generic map(n) port map(clk,nxt,output);
  process(all) begin
    case? std_logic_vector'(rst & left & right & load) is
      when "1---" => nxt <= (others => '0');            -- reset
      when "01--" => nxt <= output(n-2 downto 0) & sin; -- left
      when "001-" => nxt <= sin & output(n-1 downto 1); -- right
      when "0001" => nxt <= input;                      -- load
      when others => nxt <= output;                     -- hold
    end case?;
  end process;
end impl;

--Figure 16.17
------------------------------------------------------------------------
-- Universal Shifter/Counter
-- inputs take priority in order listed
-- rst - resets state to zero
-- left - shifts state to the left, sin fills LSB
-- right - shifts state to the right, sin fills MSB
-- up - increments state
-- down - decrements state - will not decrement through zero.
-- load - load from in
-- 
-- Output done indicates when state is all zeros.
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ff.all;
use work.ch8.all;

entity UnivShCnt is
  generic( n: integer := 4 );
  port( clk, rst, left, right, up, down, load, sin: in std_logic;
        input: in std_logic_vector(n-1 downto 0);
        output: buffer std_logic_vector(n-1 downto 0);
        done: buffer std_logic );
end UnivShCnt;

architecture impl of UnivShCnt is
  signal sel: std_logic_vector(6 downto 0);
  signal nxt, outpm1: std_logic_vector(n-1 downto 0);
begin
  outpm1 <= output + ((n-1 downto 1 => down) & '1');
  CNT: vDFF generic map(n) port map(clk,nxt,output);
  ARB: RArb generic map(7) 
    port map(rst & left & right & up & (down and (not done)) & load & '1', sel);
  MUX: Mux7 generic map(n) 
    port map( (n-1 downto 0 => '0'), output(n-2 downto 0) & sin, 
              sin & output(n-1 downto 1), outpm1, outpm1, input, output, sel, nxt);
  done <= '1' when output = 0 else '0';
end impl;

-- example of assertion with pragmas to disable synthesis
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity assertion is
  port( input: in std_logic_vector(2 downto 0);
        err: out std_logic );
end assertion;

architecture impl of assertion is
  --signal count: integer;
  signal count: std_logic_vector(1 downto 0); --integer;
begin
  --count <= to_integer(unsigned(input(0 downto 0)) + unsigned(input(1 downto 1)) + unsigned(input(2 downto 2)) );
  -- pragma translate_off
  count <= ("0" & input(0)) + ("0" & input(1)) + ("0" & input(2));
  err <= '1' when count > 1 else '0';
  -- pragma translate_on
end impl;


--Figure 16.18
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ff.all;

entity VarShift is
  generic( n: integer := 8 );
  port( clk, rst: in std_logic;
        sh_amount: in std_logic_vector(1 downto 0);
        sin: in std_logic_vector(2 downto 0);
        output: buffer std_logic_vector(n-1 downto 0) );
end VarShift;

architecture impl of VarShift is
  signal sh_i, sh_o: unsigned(n+2 downto 0);
  signal nxt: std_logic_vector(n-1 downto 0);
begin
  SR: vDFF generic map(n) port map(clk,nxt,output);
  sh_i <= unsigned(output & sin);
  sh_o <= sh_i srl 3-to_integer(unsigned(sh_amount));
  nxt  <= (others => '0') when rst else std_logic_vector(sh_o(n-1 downto 0));
end impl;

------------------------------------------------------------------------

-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;

entity testbench_varshift is
end testbench_varshift;

architecture test of testbench_varshift is
  signal clk, rst: std_logic;
  signal sh_amount: std_logic_vector(1 downto 0);
  signal sin: std_logic_vector(2 downto 0);
  signal output: std_logic_vector(7 downto 0);
begin
  DUT: entity work.VarShift(impl) port map(clk,rst,sh_amount,sin,output);

  process begin
    report "rst=" & to_string(rst) & "; sh_amount=" & to_string(sh_amount) & 
           "; sin=" & to_string(sin) & "; output=" & to_string(output);
    clk <= '0'; wait for 5 ns;
    clk <= '1'; wait for 5 ns;
  end process;

  process
  begin
    rst <= '1'; sh_amount <= "00"; sin <= "000"; wait for 10 ns;
    rst <= '0'; 
    sh_amount <= "01"; sin <= "111"; wait for 10 ns;
    sh_amount <= "00"; sin <= "111"; wait for 10 ns;
    sh_amount <= "01"; sin <= "111"; wait for 10 ns;
    sh_amount <= "10"; sin <= "111"; wait for 10 ns;
    sh_amount <= "11"; sin <= "111"; wait for 10 ns;
  end process;
end test;

--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity testbench_counter1 is
end testbench_counter1;

architecture test of testbench_counter1 is
  signal clk,rst: std_logic;
  signal count: std_logic_vector(2 downto 0);
begin
  DUT: entity work.Counter(impl) generic map(3) port map(clk,rst,count);

  process begin
    report "count = " & to_string(count);
    clk <= '0'; wait for 5 ns;
    clk <= '1'; wait for 5 ns;
  end process;

  process begin
    rst <= '1'; wait for 10 ns;
    rst <= '0'; wait;
  end process;
end test;

library ieee;
use ieee.std_logic_1164.all;

entity testbench_udl_count is
end testbench_udl_count;

architecture test of testbench_udl_count is
  signal clk,rst,up,down,load: std_logic;
  signal input,count: std_logic_vector(2 downto 0);
begin
  DUT: entity work.UDL_Count3(impl) generic map(3) port map(clk,rst,up,down,load,input,count);

  process begin
    report "count = " & to_string(count);
    clk <= '0'; wait for 5 ns;
    clk <= '1'; wait for 5 ns;
  end process;

  process begin
    report "-- reset --";
    input <= "000"; up <= '0'; down <= '0'; load <= '0';
    rst <= '1'; wait for 10 ns;
    report "-- nothing --";
    rst <= '0'; wait for 20 ns;
    report "-- up --";
    up <= '1'; wait for 100 ns;
    report "-- down --";
    up <= '0'; down <= '1'; wait for 100 ns;
    report "-- load --";
    down <= '0'; input <= "101"; load <= '1'; wait for 10 ns;
    report "-- nothing --";
    load <= '0'; wait for 20 ns;
    report "-- up --";
    up <= '1'; wait for 100 ns;
    up <= '0';
    report "-- done --";
    wait;     
  end process;
end test;

library ieee;
use ieee.std_logic_1164.all;

entity testbench_timer is
end testbench_timer;

architecture test of testbench_timer is
  signal clk, rst, load: std_logic;
  signal input: std_logic_vector(2 downto 0);
  signal output: std_logic;
begin
  DUT: entity work.Timer(impl) generic map(3) port map(clk,rst,load,input,output);
 
  process begin
    report "load = " & to_string(load) & "; input = " & to_string(input) & "; count = " & 
      to_string( <<signal DUT.count : std_logic_vector>>) & "; done = " & to_string(output);
    clk <= '0'; wait for 5 ns;
    clk <= '1'; wait for 5 ns;
  end process;

  process begin
    rst <= '1'; load <= '0'; input <= "000";
    wait for 10 ns;
    rst <= '0';
    input <= "110"; load <= '1';
    wait for 10 ns;
    load <= '0';
    wait;
  end process; 
end test;

library ieee;
use ieee.std_logic_1164.all;

entity testbench_incdec3 is
end testbench_incdec3;

architecture test of testbench_incdec3 is
  signal clk, rst, inc, dec: std_logic;
  signal output: std_logic_vector(3 downto 0);
begin
  DUT: entity work.IncDecBy3(impl) generic map(4) port map(clk,rst,inc,dec,output);

  process begin
    report "rst = " & to_string(rst) & "; inc = " & to_string(inc) & "; dec = " & 
           to_string(dec) & "; output = " & to_string(output);
    clk <= '0'; wait for 5 ns;
    clk <= '1'; wait for 5 ns;
  end process;

  process begin
    rst <= '1'; inc <= '0'; dec <= '0'; wait for 10 ns;
    rst <= '0'; wait for 20 ns;
    inc <= '1'; wait for 100 ns;
    inc <= '0'; dec <= '1'; wait for 50 ns;
    dec <= '0';
    wait;
  end process;
end test;


library ieee;
use ieee.std_logic_1164.all;

entity testbench_shift_register1 is
end testbench_shift_register1;

architecture test of testbench_shift_register1 is
  signal clk, rst, sin: std_logic;
  signal output: std_logic_vector(3 downto 0);
begin
  DUT: entity work.Shift_Register1(impl) port map(clk,rst,sin,output);

  process begin
    report "rst = " & to_string(rst) & "; sin = " & to_string(sin) & "; output = " & to_string(output);
    clk <= '0'; wait for 5 ns;
    clk <= '1'; wait for 5 ns;
  end process;

  process begin
    rst <= '1'; sin <= '0'; wait for 10 ns;
    rst <= '0'; wait for 10 ns;
    sin <= '1'; wait for 20 ns;
    sin <= '0'; wait for 10 ns;
    sin <= '1'; wait for 10 ns;
    sin <= '0'; wait for 10 ns;
    sin <= '1'; wait for 40 ns;
    sin <= '0'; 
    wait;
  end process;
end test;

library ieee;
use ieee.std_logic_1164.all;

entity testbench_lrl_shift_register is
end testbench_lrl_shift_register;

architecture test of testbench_lrl_shift_register is
  signal clk, rst, left, right, load, sin: std_logic;
  signal input: std_logic_vector(3 downto 0);
  signal output: std_logic_vector(3 downto 0);
begin
  DUT: entity work.LRL_Shift_Register(impl) port map(clk,rst,left,right,load,sin,input,output);

  process begin
    report "rst = " & to_string(rst) & "; left = " & to_string(left) & "; right = " & to_string(right) &
        "; load = " & to_string(load) & "; sin = " & to_string(sin) & "; input = " & to_string(input) &
        "; output = " & to_string(output);

    clk <= '0'; wait for 5 ns;
    clk <= '1'; wait for 5 ns;
  end process;

  process begin
    rst <= '1'; left <= '0'; right <= '0'; load <= '0'; sin <= '0'; input <= "0000"; wait for 10 ns;
    rst <= '0'; load <= '1'; input <= "0110"; wait for 10 ns;
    load <= '0'; left <= '1'; sin <= '1'; wait for 40 ns;
    left <= '0'; right <= '1'; sin <= '0'; wait for 40 ns;
    sin <= '1'; wait for 40 ns;
    sin <= '0'; 
    wait;
  end process;
end test;

library ieee;
use ieee.std_logic_1164.all;

entity testbench_univshcnt is
end testbench_univshcnt;

architecture test of testbench_univshcnt is
  signal clk, rst, left, right, up, down, load, sin: std_logic;
  signal input: std_logic_vector(3 downto 0);
  signal output: std_logic_vector(3 downto 0);
  signal done: std_logic;
begin
  DUT: entity work.UnivShCnt(impl) port map(clk,rst,left,right,up,down,load,sin,input,output,done);

  process begin
    report "rst = " & to_string(rst) & "; left = " & to_string(left) & "; right = " & to_string(right) &
        "; up = " & to_string(up) & "; down = " & to_string(down) & 
        "; load = " & to_string(load) & "; sin = " & to_string(sin) & "; input = " & to_string(input) &
        "; output = " & to_string(output) & "; done = " & to_string(done);

    clk <= '0'; wait for 5 ns;
    clk <= '1'; wait for 5 ns;
  end process;

  process begin
    rst <= '1'; left <= '0'; right <= '0'; up <= '0'; down <= '0'; load <= '0'; sin <= '0'; input <= "0000"; 
    wait for 10 ns;
    rst <= '0'; left <= '1'; sin <= '1'; wait for 40 ns;
    sin <= '0'; wait for 40 ns;
    left <= '0'; right <= '1'; sin <= '1'; wait for 40 ns;
    sin <= '0'; wait for 40 ns;
    right <= '0'; up <= '1'; wait for 100 ns;
    up <= '0'; down <= '1'; wait for 120 ns;
    down <= '0'; load <= '1'; input <= "1010"; wait for 10 ns;
    down <= '1';
    wait;
  end process;
end test;

-- pragma translate_on
