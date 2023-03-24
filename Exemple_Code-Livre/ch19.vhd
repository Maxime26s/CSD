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

-- this file uses modules defined in ch08.vhd, ch09.vhd, ff.vhd, and ch16.vhd

------------------------------------------------------------------------
--Divide by 3 FSM of Section 19.1
--  in - increments state when high
--  out - goes high one cycle for every three cycles in is high
--    it goes high for the first time on the cycle after the third cycle 
--    in is high.
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.ff.all;

entity Div3FSM is
  port( clk, rst, input: in std_logic;
        output: out std_logic );
end Div3FSM;

architecture impl of Div3FSM is
  constant AWIDTH: integer := 2;
  constant A: std_logic_vector(AWIDTH-1 downto 0) := 2d"0";
  constant B: std_logic_vector(AWIDTH-1 downto 0) := 2d"1";
  constant C: std_logic_vector(AWIDTH-1 downto 0) := 2d"2";
  constant D: std_logic_vector(AWIDTH-1 downto 0) := 2d"3";

  signal state, n: std_logic_vector(AWIDTH-1 downto 0); -- current, next state
begin
  -- state register
  state_reg: vDFF generic map(AWIDTH) port map(clk, n, state);

  -- next state function
  process(all) begin
    case state is 
      when A => if rst then n <= A; elsif input then n <= B; else n <= A; end if;
      when B => if rst then n <= A; elsif input then n <= C; else n <= B; end if;
      when C => if rst then n <= A; elsif input then n <= D; else n <= C; end if;
      when D => if rst then n <= A; elsif input then n <= B; else n <= A; end if;
      when others => n <= A;
    end case;
  end process;

  -- output function
  output <= '1' when state = D else '0';
end impl;

library ieee;
use ieee.std_logic_1164.all;

entity Div3TB is
end Div3TB;

architecture test of Div3TB is
  signal clk, rst, input, output: std_logic;
begin
  DUT: entity work.Div3FSM(impl) port map(clk, rst, input, output);

  process begin
    wait for 5 ns; clk <= '0';
    wait for 5 ns; clk <= '1';
  end process;

  process begin
    wait for 5 ns; rst <= '1'; input <= '0';
    wait for 10 ns; rst <= '0';

    wait for 10 ns; input <= '1';
    wait for 10 ns; input <= '0';
    wait for 10 ns; input <= '1';
    wait for 10 ns; input <= '0';
    wait for 10 ns; input <= '1';
    wait for 10 ns; input <= '0';
    wait for 10 ns; input <= '1';
    wait for 10 ns; input <= '0';
    wait for 10 ns; input <= '1';
    wait for 10 ns; input <= '0';

    wait for 10 ns; input <= '1';
    wait for 20 ns; input <= '0';
    wait for 20 ns; input <= '1';
      
    wait for 10 ns; input <= '0';
    wait for 10 ns; input <= '1';
    wait for 10 ns; input <= '0';
    wait for 10 ns; input <= '1';

    wait;
  end process;
   
end test; -- Div3TB


-------------------------------------------------------------------------------
-- Figure 19.11
-- Sequential Tic-Tac-Toe game
--   Plays a game against itself
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.ff.all;
use work.ch9.all;

entity SeqTic is
  port( clk, rst: in std_logic;
        xreg, oreg: buffer std_logic_vector(8 downto 0);
        xplays: buffer std_logic );
end SeqTic;

architecture impl of SeqTic is
  signal nxreg, noreg, move, areg, breg: std_logic_vector(8 downto 0);
  signal nxplays: std_logic;
begin

  -- state
  X:  vDFF generic map(9) port map(clk, nxreg, xreg);
  O:  vDFF generic map(9) port map(clk, noreg, oreg);
  XP: sDFF port map(clk, nxplays, xplays);

  -- x plays first, then alternate
  nxplays <= '1' when rst else not xplays;

  -- move generator - mux inputs so current player is x
  areg <= xreg when xplays else oreg;
  breg <= oreg when xplays else xreg;
  moveGen: TicTacToe port map(areg, breg, move);

  -- update current player
  nxreg <= 9d"0" when rst else
           xreg or move when xplays else
           xreg;
  noreg <= 9d"0" when rst else
           oreg or move when not xplays else
           oreg;
end impl;

--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity testSeqTic is
end testSeqTic;

architecture test of testSeqTic is
  signal clk, rst, xplays: std_logic;
  signal xreg, oreg: std_logic_vector(8 downto 0);
begin
  DUT: entity work.SeqTic(impl) port map( clk, rst, xreg, oreg, xplays );

  process begin
    wait for 5 ns; clk <= '0'; 
    wait for 5 ns; clk <= '1'; 
  end process;

  process begin
    rst <= '1'; wait for 20 ns;
    rst <= '0'; 
    wait;
  end process;

end test;

------------------------------------------------------------------------
-- Encoder
--  Figure 19.15
--   in - character 'a' to 'z' - must be ready 
--   irdy - when high accepts the current input character
--   out - bit serial huffman output
--   oval - true when output holds valid bits
--
--   input character accesses a table RAM with each entry having
--   length[4], bits[9] 
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.ch16.all;
use work.ff.all;

entity HuffmanEncoder is
  port( clk, rst: in std_logic; 
        input: in std_logic_vector(4 downto 0); 
        irdy, output, oval: buffer std_logic );
end HuffmanEncoder;

architecture impl of HuffmanEncoder is
  component HuffmanEncTable is
    port( input: in std_logic_vector(4 downto 0); 
          length: out std_logic_vector(3 downto 0); 
          bits: out std_logic_vector(8 downto 0) );
  end component;

  signal length, count: std_logic_vector(3 downto 0);
  signal bits, obits: std_logic_vector(8 downto 0);
  signal char, nchar: std_logic_vector(4 downto 0);
  signal dirdy: std_logic; -- irdy delayed by one cycle - loads count and sr
  signal noval: std_logic;
begin
  -- control
  output  <= obits(8); -- MSB is output
  irdy <= '0' when rst else -- 0 count for reset
          '1' when count = 4d"2" or count = 4d"0" else
          '0';
  noval <= '0' when rst else 
           dirdy or oval; -- output valid cycle after load

  -- instantiate blocks
  CNTR: UDL_Count2 generic map(4) port map(clk=>clk, rst =>rst, up => '0', down => not dirdy, 
          load => dirdy, input => length, output => count);
  SHIFT: LRL_Shift_Register generic map(9) port map(clk =>clk, rst => rst, left => not dirdy, 
          right => '0', load => dirdy, sin => '0', input => bits, output => obits);
  nchar <= input when irdy else char;
  IN_REG: vDFF generic map(5) port map(clk, nchar, char);
  IRDY_REG: sDFF port map(clk, irdy, dirdy);
  OV_REG: sDFF port map(clk, noval, oval);
  TAB: HuffmanEncTable port map(char, length, bits);
end impl;
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity HuffmanEncTable is
  port( input: in std_logic_vector(4 downto 0); 
        length: out std_logic_vector(3 downto 0); 
        bits: out std_logic_vector(8 downto 0) );
end HuffmanEncTable;

architecture impl of HuffmanEncTable is
  type encode_type is record
    length: std_logic_vector(3 downto 0);
    bits: std_logic_vector(8 downto 0);
  end record;
  signal encoded: encode_type;
begin
  process(all) begin
    case input(4 downto 0) is
      when 5x"01" => encoded <= (4d"4", "111100000"); -- A
      when 5x"02" => encoded <= (4d"6", "110000000"); -- B
      when 5x"03" => encoded <= (4d"5", "010010000"); -- C
      when 5x"04" => encoded <= (4d"5", "111010000"); -- D
      when 5x"05" => encoded <= (4d"3", "100000000"); -- E
      when 5x"06" => encoded <= (4d"5", "000010000"); -- F
      when 5x"07" => encoded <= (4d"6", "110011000"); -- G
      when 5x"08" => encoded <= (4d"4", "011000000"); -- H
      when 5x"09" => encoded <= (4d"4", "101100000"); -- I
      when 5x"0a" => encoded <= (4d"9", "000000011"); -- J
      when 5x"0b" => encoded <= (4d"7", "000000100"); -- K
      when 5x"0c" => encoded <= (4d"5", "111000000"); -- L
      when 5x"0d" => encoded <= (4d"5", "000110000"); -- M
      when 5x"0e" => encoded <= (4d"4", "101000000"); -- N
      when 5x"0f" => encoded <= (4d"4", "110100000"); -- O
      when 5x"10" => encoded <= (4d"6", "110001000"); -- P
      when 5x"11" => encoded <= (4d"9", "000000001"); -- Q
      when 5x"12" => encoded <= (4d"4", "010100000"); -- R
      when 5x"13" => encoded <= (4d"4", "011100000"); -- S
      when 5x"14" => encoded <= (4d"3", "001000000"); -- T
      when others => encoded <= (4d"4", "101000000"); -- N
    end case;
  end process;
  (length,bits) <= encoded;
end impl;
------------------------------------------------------------------------
-- Huffman Decoder - decodes bit-stream generated by encoder
-- Figure 19.19
--   in - bit stream
--   ival - true when new valid bit present
--   out - output character
--   oval - true when new valid output present
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.ff.all;

entity HuffmanDecoder is
  port( clk, rst, input, ival: in std_logic; 
        output: buffer std_logic_vector(4 downto 0); 
        oval: out std_logic );
end HuffmanDecoder;

architecture impl of HuffmanDecoder is
  component HuffmanDecTable is 
    port( input: in std_logic_vector(5 downto 0);
          output: out std_logic_vector(5 downto 0) );
  end component;
  signal node, nnode, hdeco: std_logic_vector(5 downto 0);
  signal value, tmp, nout: std_logic_vector(4 downto 0);
  signal typ: std_logic;  -- type from table
  signal ftyp: std_logic; -- fake a type on first ival cycle to prime pump
begin
  tmp <= 5d"0" when typ or ftyp else value;
  nnode <= 6d"0" when rst else
           (tmp & input) when ival else
           node;

  nout <= 5d"0" when rst else
          value when ival and typ else
          output;

  NODE_REG: vDFF generic map(6) port map(clk, nnode, node);
  TAB: HuffmanDecTable port map(node,hdeco);
  typ <= hdeco(5); 
  value <= hdeco(4 downto 0);
  OUT_REG: vDFF generic map(5) port map(clk, nout , output);
  OVAL_REG: sDFF port map(clk, not rst and typ and ival, oval);
  FT_REG: sDFF port map(clk, rst or (ftyp and not ival), ftyp);
end impl;
------------------------------------------------------------------------
-- since left child is always even, we store all but the LSB of the node
-- address
library ieee;
use ieee.std_logic_1164.all;
entity HuffmanDecTable is 
  port( input: in std_logic_vector(5 downto 0);  -- pointer into table
        output: out std_logic_vector(5 downto 0) ); -- type(1), value(5) - type1: output, 0:node/2
end HuffmanDecTable;

architecture impl of HuffmanDecTable is
begin
  process(input) begin
    case input is
      when 6d"0" => output <= 6d"1";
      when 6d"1" => output <= 6d"2";
      when 6d"2" => output <= 6d"3";
      when 6d"3" => output <= 6d"4";
      when 6d"4" => output <= 6d"5";
      when 6d"5" => output <= 6d"6";
      when 6d"6" => output <= 6d"7";
      when 6d"7" => output <= '1' & 5x"14"; -- T
      when 6d"8" => output <= 6d"8";
      when 6d"9" => output <= 6d"9";
      when 6d"10" => output <= '1' & 5x"05"; -- E
      when 6d"11" => output <= 6d"10";
      when 6d"12" => output <= 6d"11";
      when 6d"13" => output <= 6d"12";
      when 6d"14" => output <= 6d"13";
      when 6d"15" => output <= 6d"14";
      when 6d"16" => output <= 6d"15";
      when 6d"17" => output <= '1' & 5x"12"; -- R
      when 6d"18" => output <= '1' & 5x"08"; -- H
      when 6d"19" => output <= '1' & 5x"13"; -- S
      when 6d"20" => output <= '1' & 5x"0e"; -- N
      when others => output <= 6d"8";
    end case;
  end process;
end impl;

--------------------------------------------------------------------------------

-- pragma translate_off

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity testHuff is
end testHuff;

architecture test of testHuff is
  signal clk, rst, irdy, encoded, enc_oval, dec_oval: std_logic;
  signal input, decoded: std_logic_vector(4 downto 0); 

  type tv is array (0 to 2) of std_logic_vector(4 downto 0);
  signal testvector: tv := (5x"14",5x"08",5x"05" ); -- T, H, E
begin
  DUT1: entity work.HuffmanEncoder(impl) port map(clk, rst, input, irdy, encoded, enc_oval);
  DUT2: entity work.HuffmanDecoder(impl) port map(clk, rst, encoded, enc_oval, decoded, dec_oval);

  process begin
    clk <= '0'; wait for 5 ns; 
    clk <= '1'; wait for 5 ns; 
  end process;
 
  -- reset 
  process begin
    rst <= '1'; wait for 20 ns;
    rst <= '0'; wait;
  end process;

  -- drive input to encoder
  process begin
    for i in 0 to 2 loop
      -- wait for encoder to be ready
      report "INPUT: waiting for rising edge on irdy...";
      wait until rising_edge(irdy);
      report "INPUT: Setting encoder input = " & to_hstring(testvector(i));
      input <= testvector(i);
    end loop;
    wait;
  end process;

  -- check decoder output
  process begin 
    for i in 0 to 2 loop
      -- wait for decoder to finish
      report "CHECKER: waiting for rising edge on dec_oval...";
      wait until rising_edge(dec_oval);
      report "CHECKER: checking decoder output = " & to_string(decoded);
      assert testvector(i) = decoded 
        report "ERROR ** input = " & to_string(input) & " decoded = " & to_string(decoded) 
        severity failure;
    end loop;
    report "simulation completed -- no errors detected" severity failure;
  end process;
end test;

-- pragma translate_on
