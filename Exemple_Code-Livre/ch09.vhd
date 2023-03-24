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

-- this file uses components defined in ch08.vhd

library ieee;
package ch9 is
  use ieee.std_logic_1164.all;

  component Multiple_of_3_bit is
    port( input: in std_logic; 
          remin: in std_logic_vector(1 downto 0); 
          remout: out std_logic_vector(1 downto 0) );
  end component;

  component TicTacToe is
    port( xin, oin: in std_logic_vector( 8 downto 0 );
          xout: out std_logic_vector( 8 downto 0 ) );
  end component;

end package;

-------------------------------------------------------------------------------
-- Multiple_of_3_bit
-- Cell for iterative multiple of 3 circuit.
-- Determines the remainder (mod 3) of the number from this bit to the MSB.
-- Input:
--    input - the current bit of the number being checked
--    remin - the remainder after the last bit checked (2 bits)
-- Output:
--    remout - the remainder after checking this bit (2 bits).
--
-- remin has weight 2 since its from the bit to the left, thus remin & input
-- forms a 3 bit number.  We divide this number by 3 and produce the remainder
-- on remout.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Multiple_of_3_bit is
  port( input: in std_logic; 
        remin: in std_logic_vector(1 downto 0); 
        remout: out std_logic_vector(1 downto 0) );
end Multiple_of_3_bit;

architecture impl of Multiple_of_3_bit is
begin
  process(all) begin
    case remin & input is
      when "000" => remout <= 2d"0";
      when "001" => remout <= 2d"1";
      when "010" => remout <= 2d"2";
      when "011" => remout <= 2d"0";
      when "100" => remout <= 2d"1";
      when "101" => remout <= 2d"2";
      when others => remout <= "--";
    end case;
  end process;
end impl;

----------------------------------------------------
-- Multiple_of_3
-- Determines if input is a multiple of 3
-- Input: 
--    input - an 8-bit binary number
-- Output:
--    output - true if in is a multiple of 3
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.ch9.all;

entity Multiple_of_3 is
  port( input: in std_logic_vector( 7 downto 0 );
        output: out std_logic );
end Multiple_of_3;

architecture impl of Multiple_of_3 is
  signal re: std_logic_vector(17 downto 0); -- two bits of remainder per cell
begin
  -- instantiate 8 copies of the bit cell
  b7: Multiple_of_3_bit port map(input(7),"00",re(15 downto 14));
  b6: Multiple_of_3_bit port map(input(6),re(15 downto 14),re(13 downto 12));
  b5: Multiple_of_3_bit port map(input(5),re(13 downto 12),re(11 downto 10));
  b4: Multiple_of_3_bit port map(input(4),re(11 downto 10),re(9 downto 8));
  b3: Multiple_of_3_bit port map(input(3),re(9 downto 8),re(7 downto 6));
  b2: Multiple_of_3_bit port map(input(2),re(7 downto 6),re(5 downto 4));
  b1: Multiple_of_3_bit port map(input(1),re(5 downto 4),re(3 downto 2));
  b0: Multiple_of_3_bit port map(input(0),re(3 downto 2),re(1 downto 0));

  -- output is true if remainder out is zero
  output <= '1' when re(1 downto 0) = "00" else 
            '0';
end impl;

--Figure 9.4
-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testMul3 is
end testMul3;

architecture test of testMul3 is
  signal input: std_logic_vector( 7 downto 0 );
  signal output, err: std_logic;
begin
  DUT: entity work.Multiple_of_3(impl) port map(input,output);

  process begin
    err <= '0';
    for i in 0 to 255 loop 
      input <= std_logic_vector(to_unsigned(i,8));
      wait for 10 ns;
      if (?? output) /= ((i mod 3) = 0) then
          err <= '1';
      end if;
    end loop;
    if not err then report "PASS"; end if;
    wait;
  end process;
end test;
-- pragma translate_on
-------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package calendar is
constant SUNDAY   : std_logic_vector( 2 downto 0 ) := 3d"1";
constant MONDAY   : std_logic_vector( 2 downto 0 ) := 3d"2";
constant TUESDAY  : std_logic_vector( 2 downto 0 ) := 3d"3";
constant WEDNESDAY: std_logic_vector( 2 downto 0 ) := 3d"4";
constant THURSDAY : std_logic_vector( 2 downto 0 ) := 3d"5";
constant FRIDAY   : std_logic_vector( 2 downto 0 ) := 3d"6";
constant SATURDAY : std_logic_vector( 2 downto 0 ) := 3d"7";
constant JANUARY  : std_logic_vector( 3 downto 0 ) := 4d"1";
constant DECEMBER : std_logic_vector( 3 downto 0 ) := 4d"12";
end package;

--Figure 9.5
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.calendar.all;  -- our definition of constants SUNDAY..SATURDAY (not shown)

entity NextDayOfWeek is
  port( today: in std_logic_vector( 2 downto  0 );
        tomorrow: out std_logic_vector( 2 downto 0 ) );
end NextDayOfWeek;

architecture behav of NextDayOfWeek is
begin
  tomorrow <= SUNDAY when today = SATURDAY else today + 1;
end behav;

--Figure 9.6
library ieee;
use ieee.std_logic_1164.all;

entity DaysInMonth is
  port( month : in std_logic_vector(3 downto 0); -- month of the year 1=Jan, 12=Dec
        days : out std_logic_vector(4 downto 0) ); -- number of days in month
end DaysInMonth;

architecture impl of DaysInMonth is
begin
  process(all) begin
    case month is
      -- thirty days have September...
      -- all the rest have 31
      -- except for February which has 28
      when 4d"4" | 4d"6" | 4d"9" | 4d"11" => days <= 5d"30";
      when 4d"2" => days <= 5d"28";
      when others => days <= 5d"31";
    end case;
  end process;
end impl;


--Figure 9.7
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.calendar.all;

entity Tomorrow is
  port( todayMonth: in std_logic_vector(3 downto 0);
        todayDoM: in std_logic_vector(4 downto 0);
        todayDoW: in std_logic_vector(2 downto 0);
        tomorrowMonth: out std_logic_vector(3 downto 0);
        tomorrowDoM: out std_logic_vector(4 downto 0);
        tomorrowDoW: out std_logic_vector(2 downto 0) );
end Tomorrow;

architecture impl of Tomorrow is
  signal daysInMonth : std_logic_vector(4 downto 0);
  signal lastDay, lastMonth : std_logic;
begin
  -- compute next day of week
  NDOW: entity work.NextDayOfWeek port map(todayDoW,tomorrowDoW);

  -- compte month and day of month
  DIM: entity work.DaysInMonth port map(todayMonth,daysInMonth);

  -- compute month and day of month
  lastDay <= '1' when todayDoM = daysInMonth else '0';
  lastMonth <= '1' when todayMonth = DECEMBER else '0';
  tomorrowMonth <= JANUARY when lastDay and lastMonth else
                   todayMonth+1 when lastDay else
                   todayMonth;
  tomorrowDoM <= 5d"1" when lastDay else todayDoM+1;
end impl; 

-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;
use work.calendar.all;

entity testDay is
end testDay;

architecture test of testDay is
  signal tM, ttM: std_logic_vector(3 downto 0);
  signal tD, ttD: std_logic_vector(4 downto 0);
  signal tW, ttW: std_logic_vector(2 downto 0);
  signal nM: std_logic_vector(3 downto 0);
  signal nD: std_logic_vector(4 downto 0);
  signal nW: std_logic_vector(2 downto 0);
begin
  DUT0: entity work.Tomorrow(impl) port map(tM, tD, tW, nM, nD, nW);

  process begin
    tM <= JANUARY;
    tD <= 5d"1";
    tW <= MONDAY;

    for i in 1 to 100 loop
      wait for 10 ns;
      report to_string(nM) & " " & to_string(nD) & " " & to_string(nW);
      ttD <= nD;
      ttM <= nM;
      ttW <= nW;
      tD <= ttD;
      tM <= ttM;
      tW <= ttW;
    end loop;
    tM <= DECEMBER;
    tD <= 5d"30";
    tW <= MONDAY;
    for i in 1 to 10 loop
      wait for 10 ns;
      report to_string(nM) & " " & to_string(nD) & " " & to_string(nW);
      ttD <= nD;
      ttM <= nM;
      ttW <= nW;
      tD <= ttD;
      tM <= ttM;
      tW <= ttW;
    end loop;
  end process;
end test; -- testDay
-- pragma translate_on

--Figure 9.9
-------------------------------------------------------------------------------
-- 4-input Priority Arbiter
-- Outputs the index of the input with the highest value
-- Inputs:
--   in0, in1, in2, in3 - n-bit binary input values
-- Out:
--   o - 2-bit index of the input with the highest value
--
-- We pick the "winning" output via a tournament.  
-- In the first round we compare in0 against in1 and in2 against in3
-- The second round compares the winners of the first round.
-- The MSB comes from the final round, the LSB from the selected first round.
--
-- Ties are given to the lower numbered input.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.ch8.all;

entity PriorityArbiter is
  generic( n : integer := 8 );
  port( in3, in2, in1, in0: in std_logic_vector(n-1 downto 0);
        o: buffer std_logic_vector( 1 downto 0 ) );
end PriorityArbiter;

architecture impl of PriorityArbiter is
  signal match0winner, match1winner: std_logic_vector(n-1 downto 0);
  signal c1gt0, c3gt2: std_logic_vector(0 downto 0);
begin
  -- first round of tournament
  round0match0: MagComp generic map(n) port map(in1,in0,c1gt0(0)); -- compare in0 and in1
  round0match1: MagComp generic map(n) port map(in3,in2,c3gt2(0)); -- compare in2 and in3

  -- select first round winners
  match0: Mux2 generic map(n) port map(in1, in0, c1gt0 & not c1gt0, match0winner);
  match1: Mux2 generic map(n) port map(in3, in2, c3gt2 & not c3gt2, match1winner);

  -- compare round0 winners
  round1: MagComp generic map(n) port map( match1winner, match0winner, o(1));

  -- select winning LSB index
  winningLSB: Mux2 generic map(1) port map(c3gt2, c1gt0, o(1) & not o(1), o(0 downto 0) );
end impl;

-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;

entity testPriArb is
end testPriArb;

architecture test of testPriArb is
  signal in3, in2, in1, in0: std_logic_vector(3 downto 0);
  signal output: std_logic_vector(1 downto 0);
begin
  DUT: entity work.PriorityArbiter(impl) generic map(4) port map(in3,in2,in1,in0,output);

  process
  begin
    in3 <= x"3";
    in2 <= x"2";
    in1 <= x"1";
    in0 <= x"0";
    wait for 10 ns; report "Winner 3 " & to_hstring(output);

    in3 <= x"a";
    in2 <= x"2";
    in1 <= x"f";
    in0 <= x"0";
    wait for 10 ns; report "Winner 1 " & to_hstring(output);

    in3 <= x"0";
    in2 <= x"0";
    in1 <= x"0";
    in0 <= x"0";
    wait for 10 ns; report "Winner 0 " & to_hstring(output);

    in3 <= x"3";
    in2 <= x"c";
    in1 <= x"1";
    in0 <= x"0";
    wait for 10 ns; report "Winner 2 " & to_hstring(output);
    wait;
  end process;
end test; -- testPriArb
-- pragma translate_on

--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package tictactoe_declarations is
  component TwoInArray is
    port( ain, bin: in std_logic_vector( 8 downto 0 );
          cout: out std_logic_vector( 8 downto 0 ) );
  end component;
  component Empty is
    port( i: in std_logic_vector(8 downto 0);
          o: out std_logic_vector(8 downto 0) );
  end component;
  component Select3 is
    port( a, b, c: in std_logic_vector( 8 downto 0 );
          output: out std_logic_vector( 8 downto 0 ) );
  end component;
  component TwoInRow is
    port( ain, bin : in std_logic_vector( 2 downto 0 );
          cout : out std_logic_vector( 2 downto 0 ) );
  end component;
end package;

-------------------------------------------------------------------------------
-- TicTacToe
-- Generates a move for X in the game of tic-tac-toe
-- Inputs:
--   xin, oin - (9-bit) current positions of X and O.
-- Out:
--   xout - (9-bit) one hot position of next X.
--
-- Inputs and outputs use a board mapping of:
--
--   0 | 1 | 2 
--  ---+---+---
--   3 | 4 | 5 
--  ---+---+---
--   6 | 7 | 8 
--
-- The top-level circuit instantiates strategy components that each generate
-- a move according to their strategy and a selector component that selects
-- the highest-priority strategy component with a move.
--
-- The win strategy component picks a space that will win the game if any exists.
--
-- The block strategy component picks a space that will block the opponent
-- from winning.
--
-- The empty strategy component picks the first open space - using a particular
-- ordering of the board.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.tictactoe_declarations.all;

entity TicTacToe is
  port( xin, oin: in std_logic_vector( 8 downto 0 );
        xout: out std_logic_vector( 8 downto 0 ) );
end TicTacToe;

architecture impl of TicTacToe is
  signal win, blk, emp : std_logic_vector( 8 downto 0 );
begin
  WINX: TwoInArray port map(xin, oin, win);
  BLOCKX: TwoInArray port map(oin, xin, blk);
  EMPTYX: Empty port map( not (oin or xin), emp);
  COMB: Select3 port map(win,blk,emp,xout);
end impl;


--Figure 9.13
-------------------------------------------------------------------------------
-- TwoInArray
-- Indicates if any row or column or diagonal in the array has two pieces of
-- type a and no pieces of type b. (a and b can be x and o or o and x)
-- Inputs:
--   ain, bin - (9 bits) array of types a and b
-- Output:
--   cout - (9 bits) location of space to play in to complete row, column
--          or diagonal of a.
-- If more than one space meets the criteria the output may have more than 
-- one bit set.
-- If no spaces meet the criteria, the output will be all zeros.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.tictactoe_declarations.all;

entity TwoInArray is
  port( ain, bin: in std_logic_vector( 8 downto 0 );
        cout: out std_logic_vector( 8 downto 0 ) );
end TwoInArray;

architecture impl of TwoInArray is
  signal rows, cols, cc: std_logic_vector( 8 downto 0 );
  signal ddiag, udiag : std_logic_vector( 2 downto 0 );
begin
  -- check each row
  TOPR: TwoInRow port map( ain(2 downto 0), bin(2 downto 0), rows(2 downto 0) );
  MIDR: TwoInRow port map( ain(5 downto 3), bin(5 downto 3), rows(5 downto 3) );
  BOTR: TwoInRow port map( ain(8 downto 6), bin(8 downto 6), rows(8 downto 6) );

  -- check each column
  LEFTC:  TwoInRow port map( ain(6) & ain(3) & ain(0),
                             bin(6) & bin(3) & bin(0), 
                             cc(8 downto 6) );
  MIDC:   TwoInRow port map( ain(7) & ain(4) & ain(1),
                             bin(7) & bin(4) & bin(1), 
                             cc(5 downto 3) );
  RIGHTC: TwoInRow port map( ain(8) & ain(5) & ain(2),
                             bin(8) & bin(5) & bin(2),
                             cc(2 downto 0) );
  (cols(6),cols(3),cols(0),cols(7),cols(4),cols(1),cols(8),cols(5),cols(2)) <= cc;

  -- check both diagonals
  DNDIAGX: TwoInRow port map( ain(8)&ain(4)&ain(0), bin(8)&bin(4)&bin(0), ddiag );
  UPDIAGX: TwoInRow port map( ain(6)&ain(4)&ain(2), bin(6)&bin(4)&bin(2), udiag );

  cout <= rows or cols or (ddiag(2) & "000" & ddiag(1) & "000" & ddiag(0)) or
	  ("00" & udiag(2) & "0" & udiag(1) & "0" & udiag(0) & "00");
end impl;

--Figure 9.14
-------------------------------------------------------------------------------
-- TwoInRow
-- Indicates if a row (or column, or diagonal) has two pieces of type a 
-- and no pieces of type b. (a and b can be x and o or o and x)
-- Inputs:
--   ain, bin - (3 bits) row of types a and b.
-- Outputs:
--   cout - (3 bits) location of empty square if other two are type a.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TwoInRow is
  port( ain, bin : in std_logic_vector( 2 downto 0 );
        cout : out std_logic_vector( 2 downto 0 ) );
end TwoInRow;

architecture impl of TwoInRow is
begin
  cout(0) <= not bin(0) and not ain(0) and ain(1) and ain(2);
  cout(1) <= not bin(1) and ain(0) and not ain(1) and ain(2);
  cout(2) <= not bin(2) and ain(0) and ain(1) and not ain(2);
end impl;

-------------------------------------------------------------------------------
-- Empty
-- Pick first space not in input.  Permute vector so middle comes first,
-- then corners, then edges.
-- Inputs:
--   i - (9 bits) occupied spaces
-- Outputs:
--   o - (9 bits) first empty space
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.ch8.all; -- for RArb

entity Empty is
  port( i: in std_logic_vector(8 downto 0);
        o: out std_logic_vector(8 downto 0) );
end Empty;

architecture impl of Empty is
  signal op: std_logic_vector(8 downto 0);
begin
  RA: RArb generic map(9) port map( i(4)&i(0)&i(2)&i(6)&i(8)&i(1)&i(3)&i(5)&i(7),op );
  (o(4),o(0),o(2),o(6),o(8),o(1),o(3),o(5),o(7)) <= op;
end impl;

--Figure 9.16
-------------------------------------------------------------------------------
-- Select3
-- Picks the highest priority bit from 3 9-bit vectors
-- Inputs:
--   a, b, c - (9 bits) Input vectors
-- Outputs:
--   output - (9 bits) One hot output has a bit set (if any) in the highest
--            position of the highest priority input.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.ch8.all;

entity Select3 is
  port( a, b, c: in std_logic_vector( 8 downto 0 );
        output: out std_logic_vector( 8 downto 0 ) );
end Select3;

architecture impl of Select3 is
  signal x: std_logic_vector(26 downto 0);
begin
  RA: RArb generic map(27) port map(a & b & c, x);  
  output <= x(26 downto 18) or x(17 downto 9) or x(8 downto 0);
end impl;

--Figure 9.18
-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;

entity TestTic is
end TestTic;

architecture test of TestTic is
  signal x, o, xo, oo: std_logic_vector( 8 downto 0 );
begin
  DUT: entity work.TicTacToe(impl) port map(x,o,xo);
  OPPONENT: entity work.TicTacToe(impl) port map(o,x,oo); 

  process begin
    --  all zeros, should pick middle
    x <= "000000000"; o <= "000000000"; 
    wait for 10 ns; report to_string(x) & " " & to_string(o) & " -> " & to_string(xo);
    --  can win across the top
    x <= "000000101"; o <= "000000000"; 
    wait for 10 ns; report to_string(x) & " " & to_string(o) & " -> " & to_string(xo);
    --  near-win: can't win across the top due to block
    x <= "000000101"; o <= "000000010";
    wait for 10 ns; report to_string(x) & " " & to_string(o) & " -> " & to_string(xo);
    -- block in the first column
    x <= "000000000"; o <= "000100100"; 
    wait for 10 ns; report to_string(x) & " " & to_string(o) & " -> " & to_string(xo);
    -- block along a diagonal
    x <= "000000000"; o <= "000010100"; 
    wait for 10 ns; report to_string(x) & " " & to_string(o) & " -> " & to_string(xo);
    --  start a game - x goes first
    x <= "000000000"; o <= "000000000";
    for i in 0 to 6 loop
      wait for 10 ns;
      report to_hstring(x(0)&o(0))&" "&to_hstring(x(1)&o(1))&" "&to_hstring(x(2)&o(2));
      report to_hstring(x(3)&o(3))&" "&to_hstring(x(4)&o(4))&" "&to_hstring(x(5)&o(5));
      report to_hstring(x(6)&o(6))&" "&to_hstring(x(7)&o(7))&" "&to_hstring(x(8)&o(8));
      report "";
      x <= x or xo;
      wait for 10 ns;
      report to_hstring(x(0)&o(0))&" "&to_hstring(x(1)&o(1))&" "&to_hstring(x(2)&o(2));
      report to_hstring(x(3)&o(3))&" "&to_hstring(x(4)&o(4))&" "&to_hstring(x(5)&o(5));
      report to_hstring(x(6)&o(6))&" "&to_hstring(x(7)&o(7))&" "&to_hstring(x(8)&o(8));
      report "--------";
      o <= o or oo;
    end loop;
    wait;
  end process; 
end test;
-- pragma translate_on
