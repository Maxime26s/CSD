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

--Vending machine code for Figures 16.22, 16.23, 16.24, 16.25, 16.26

library ieee;
use ieee.std_logic_1164.all;

package vending_machine_declarations is
  -----------------------------------------------
  -- define state assignment - binary
  -----------------------------------------------
  constant SWIDTH:  integer := 3;
  constant DEPOSIT: std_logic_vector(SWIDTH-1 downto 0) := "000";
  constant SERVE1:  std_logic_vector(SWIDTH-1 downto 0) := "001";
  constant CHANGE1: std_logic_vector(SWIDTH-1 downto 0) := "010";
  constant SERVE2:  std_logic_vector(SWIDTH-1 downto 0) := "011";
  constant CHANGE2: std_logic_vector(SWIDTH-1 downto 0) := "100";

  constant DWIDTH:  integer := 4;
  constant CNICKEL:  std_logic_vector(DWIDTH-1 downto 0) := "0001";
  constant CDIME:    std_logic_vector(DWIDTH-1 downto 0) := "0010";
  constant CQUARTER: std_logic_vector(DWIDTH-1 downto 0) := "0101";
  constant CPRICE: std_logic_vector(DWIDTH-1 downto 0) := "1011";

  component VendingMachineControl is
    port( clk, rst, nickel, dime, quarter, dispense, done, enough, zero: in std_logic;
          serve, change: out std_logic;
          selval: out std_logic_vector(3 downto 0);
          selnext: out std_logic_vector(2 downto 0);
          sub: out std_logic );
  end component;
  component VendingMachineData is
    generic( n: integer := 6 );
    port( clk: in std_logic;
          selval: in std_logic_vector(3 downto 0); -- price, 1, 2, 5
          selnext: in std_logic_vector(2 downto 0); --amount, sum, 0
          sub: in std_logic;
          price: in std_logic_vector(n-1 downto 0); -- price of soft drink - in nickels
          enough: out std_logic; -- amount > price 
          zero: out std_logic ); -- amount = zero
  end component;

end package;

------------------------------------------------------------------------
-- VendingMachine - Top level design entity
-- Just hooks together control and datapath
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.vending_machine_declarations.all;

entity VendingMachine is
  generic( n: integer := DWIDTH );
  port( clk, rst, nickel, dime, quarter, dispense, done: in std_logic;
        price: in std_logic_vector(n-1 downto 0);
        serve, change: out std_logic );
end VendingMachine;

architecture impl of VendingMachine is
  signal enough, zero, sub: std_logic;
  signal selval: std_logic_vector(3 downto 0);
  signal selnext: std_logic_vector(2 downto 0);
begin
  VMC: VendingMachineControl port map(clk,rst,nickel,dime,quarter,dispense,done,
    enough, zero, serve, change, selval, selnext, sub);
  VMD: VendingMachineData generic map(n) port map(clk, selval, selnext, sub, price, enough, zero); 
end impl;
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.ff.all;
use work.vending_machine_declarations.all;

entity VendingMachineControl is
  port( clk, rst, nickel, dime, quarter, dispense, done, enough, zero: in std_logic;
        serve, change: out std_logic;
        selval: out std_logic_vector(3 downto 0);
        selnext: out std_logic_vector(2 downto 0);
        sub: out std_logic );
end VendingMachineControl;

architecture impl of VendingMachineControl is
  signal state, nxt, nxt1: std_logic_vector(SWIDTH-1 downto 0);
  signal nfirst, first, serve_1, change_1, change_int, dep, selv: std_logic;
begin
  -- outputs
  serve_1 <= '1' when state = SERVE1 else '0';
  change_1 <= '1' when state = CHANGE1 else '0';
  serve <= serve_1 and first;
  change_int <= change_1 and first;
  change <= change_int;

  -- datapath controls
  dep <= '1' when state = DEPOSIT else '0';
  selval <= (dep and dispense) & 
            ((dep and nickel) or change_int) & 
            (dep and dime) & 
            (dep and quarter);

  -- amount, sum, 0
  selv <= (dep and (nickel or dime or quarter or (dispense and enough))) or
          (change_int and first);
  selnext <= (not (selv or rst)) & ((not rst) and selv) & rst;

  -- subtract
  sub <= (dep and dispense) or change_int;

  -- only do actions on first cycle of serve_1 or change_1
  nfirst <= not (serve_1 or change_1);
  first_reg: sDFF port map(clk, nfirst, first);

  -- state register
  state_reg: vDFF generic map(SWIDTH) port map(clk, nxt, state);

  -- next state logic
  process(all) begin
    case? dispense & enough & done & zero & state is
      when "11--" & DEPOSIT => nxt1 <= SERVE1;  -- dispense & enough
      when "01--" & DEPOSIT => nxt1 <= DEPOSIT; 
      when "-0--" & DEPOSIT => nxt1 <= DEPOSIT;
      when "--1-" & SERVE1  => nxt1 <= SERVE2;  -- done
      when "--0-" & SERVE1  => nxt1 <= SERVE1; 
      when "--01" & SERVE2  => nxt1 <= DEPOSIT; -- not done and zero
      when "--00" & SERVE2  => nxt1 <= CHANGE1; -- not done and not zero
      when "--1-" & SERVE2  => nxt1 <= SERVE2;  -- done
      when "--1-" & CHANGE1 => nxt1 <= CHANGE2; -- done
      when "--0-" & CHANGE1 => nxt1 <= CHANGE1; -- done
      when "--00" & CHANGE2 => nxt1 <= CHANGE1; -- not done and not zero
      when "--01" & CHANGE2 => nxt1 <= DEPOSIT; -- not done and zero
      when "--1-" & CHANGE2 => nxt1 <= CHANGE2; -- not done and zero
      when others => nxt1 <= DEPOSIT;
    end case?;
  end process;

  nxt <= DEPOSIT when rst = '1' else nxt1;
end impl;
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.ff.all;
use work.ch8.all;
use work.ch10.all;
use work.vending_machine_declarations.all;

entity VendingMachineData is
  generic( n: integer := 6 );
  port( clk: in std_logic;
        selval: in std_logic_vector(3 downto 0); -- price, 1, 2, 5
        selnext: in std_logic_vector(2 downto 0); --amount, sum, 0
        sub: in std_logic;
        price: in std_logic_vector(n-1 downto 0); -- price of soft drink - in nickels
        enough: out std_logic; -- amount > price 
        zero: out std_logic ); -- amount = zero
end VendingMachineData;

architecture impl of VendingMachineData is
  signal sum, amount, nxt, value, z: std_logic_vector(n-1 downto 0);
  signal ovf: std_logic;
begin
  --  state register holds current amount
  AMT: vDFF generic map(n) port map(clk, nxt, amount);

  --  select next state from 0, sum, or hold
  z <= (nxt'range => '0');
  NSMUX: Mux3 generic map(n) port map(amount, sum, z, selnext, nxt);

  --  add or subtract a value from current amount
  ADD: AddSub generic map(n) port map(amount, value, sub, sum, ovf);

  --  select the value to add or subtract
  VMUX: Mux4 generic map(n) port map(price, CNICKEL, CDIME, CQUARTER, selval, value);

  -- comparators
  enough <= '1' when amount >= price else '0';
  zero <= '1' when amount = (amount'range => '0') else '0';
end impl;

------------------------------------------------------------------------
-- VendingMachine - Flat implementation
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ff.all;
use work.vending_machine_declarations.all;

entity VendingMachine1 is
  generic( n: integer := DWIDTH );
  port( clk, rst, nickel, dime, quarter, dispense, done: in std_logic;
        price: in std_logic_vector(n-1 downto 0);
        serve, change: buffer std_logic );
end VendingMachine1;

architecture impl of VendingMachine1 is
  signal serve_1, change_1, dep, enough, zero, nfirst, first: std_logic;
  signal state, nxt, nxt1: std_logic_vector(SWIDTH-1 downto 0);
  signal amount, namount, inc: std_logic_vector(n-1 downto 0);
begin
  -- decode
  serve_1 <= '1' when state = SERVE1 else '0';
  change_1 <= '1' when state = CHANGE1 else '0';
  dep <= '1' when state = DEPOSIT else '0';
  nfirst <= not (serve_1 or change_1); -- not in serve_1 or change_1

  -- state registers
  STATE_REG: vDFF generic map(SWIDTH) port map(clk,nxt,state);
  DATA_REG:  vDFF generic map(n) port map(clk,namount,amount);
  FIRST_REG: sDFF port map(clk,nfirst,first); 

  -- outputs
  serve <= '1' when (state = SERVE1) and first = '1' else '0';
  change <= '1' when (state = CHANGE1) and first = '1' else '0';

  -- status signals
  enough <= '1' when (amount >= price) else '0';
  zero <= '1' when (amount = (amount'range => '0')) else '0';

  -- datapath - select increment
  process(all) begin
    case? std_logic_vector'(nickel & dime & quarter & dep & serve & change) is
      when "---010" => inc <= (inc'range => '0') - price;
      when "100100" => inc <= CNICKEL;
      when "010100" => inc <= CDIME;
      when "001100" => inc <= CQUARTER;
      when "---001" => inc <= (inc'range => '0') - CNICKEL;
      when others => inc <= (inc'range => '0');
    end case?;
  end process;

  -- datapath - select next amount
  namount <= (namount'range => '0') when rst else amount + inc;

  -- next state logic (same as in Figure 16.24)
  process(all) begin
    case? dispense & enough & done & zero & state is
      when "11--" & DEPOSIT => nxt1 <= SERVE1;  -- dispense & enough
      when "01--" & DEPOSIT => nxt1 <= DEPOSIT; 
      when "-0--" & DEPOSIT => nxt1 <= DEPOSIT;
      when "--1-" & SERVE1  => nxt1 <= SERVE2;  -- done
      when "--0-" & SERVE1  => nxt1 <= SERVE1; 
      when "--01" & SERVE2  => nxt1 <= DEPOSIT; -- not done and zero
      when "--00" & SERVE2  => nxt1 <= CHANGE1; -- not done and not zero
      when "--1-" & SERVE2  => nxt1 <= SERVE2;  -- done
      when "--1-" & CHANGE1 => nxt1 <= CHANGE2; -- done
      when "--0-" & CHANGE1 => nxt1 <= CHANGE1; -- done
      when "--00" & CHANGE2 => nxt1 <= CHANGE1; -- not done and not zero
      when "--01" & CHANGE2 => nxt1 <= DEPOSIT; -- not done and zero
      when "--1-" & CHANGE2 => nxt1 <= CHANGE2; -- not done and zero
      when others => nxt1 <= DEPOSIT;
    end case?;
  end process;

  nxt <= DEPOSIT when rst = '1' else nxt1;
end impl;

-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;
use work.vending_machine_declarations.all;

entity testVend is
end testVend;

architecture test of testVend is
  signal clk, rst, nickel, dime, quarter, dispense, done: std_logic;
  signal NDQd, price: std_logic_vector(3 downto 0);
  signal serve, change: std_logic;
begin
  DUT: entity work.VendingMachine(impl) generic map(4) 
    port map(clk, rst, nickel, dime, quarter, dispense, done, price, serve, change);

  process begin
    report to_string(nickel & dime & quarter & dispense) & " " &
      to_hstring(<<signal DUT.VMC.STATE: std_logic_vector>>) & " " &
      to_hstring(<<signal DUT.VMD.AMOUNT: std_logic_vector>>) & " " &
      to_string(serve) & " " & to_string(change);
    wait for 5 ns; clk <= '1'; 
    wait for 5 ns; clk <= '0'; 
  end process;

  process(clk) begin
    if rising_edge(clk) then
      done <= serve or change; -- give prompt feedback 
    end if;
  end process;

  process begin
    rst <= '1'; price <= CPRICE;
    (nickel, dime, quarter, dispense) <= std_logic_vector'("0000");
    wait for 20 ns; rst <= '0';
    wait for 10 ns; (nickel, dime, quarter, dispense) <= std_logic_vector'("1000"); -- nickel 1
    wait for 10 ns; (nickel, dime, quarter, dispense) <= std_logic_vector'("0100"); -- dime 3
    wait for 10 ns; (nickel, dime, quarter, dispense) <= std_logic_vector'("0000"); -- nothing
    wait for 10 ns; (nickel, dime, quarter, dispense) <= std_logic_vector'("0001"); -- try dispense
    wait for 10 ns; (nickel, dime, quarter, dispense) <= std_logic_vector'("0010"); -- quarter 8
    wait for 10 ns; (nickel, dime, quarter, dispense) <= std_logic_vector'("0010"); -- quarter 13
    wait for 10 ns; (nickel, dime, quarter, dispense) <= std_logic_vector'("0000"); -- nothing
    wait for 10 ns; (nickel, dime, quarter, dispense) <= std_logic_vector'("0001"); -- dispense 2
    wait for 10 ns; dispense <= '0';
    wait;
  end process;
end test;
-- pragma translate_on
