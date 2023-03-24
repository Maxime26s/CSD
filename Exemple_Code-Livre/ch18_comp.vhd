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

-- requires modules from ch08.vhd, ff.vhd, and ch16.vhd

--The computer of section 18.6, includes the ALU and basic testbench
library ieee;
package alu_ch18_6 is
use ieee.std_logic_1164.all;
constant OP_ADD: std_logic_vector(2 downto 0) := "000";
constant OP_SUB: std_logic_vector(2 downto 0) := "001";
constant OP_MUL: std_logic_vector(2 downto 0) := "010";
constant OP_SH: std_logic_vector(2 downto 0) := "011";
constant OP_XOR: std_logic_vector(2 downto 0) := "100";
constant OP_AND: std_logic_vector(2 downto 0) := "101";
constant OP_OR : std_logic_vector(2 downto 0) := "110";
constant OP_NOT: std_logic_vector(2 downto 0) := "111";

component alu is 
  port( opcode: in std_logic_vector(2 downto 0);
        s0, s1: in std_logic_vector(15 downto 0);
        o_high, o_low: out std_logic_vector(15 downto 0);
        write_high: out std_logic );
end component;

end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.alu_ch18_6.all;

entity alu is 
  port( opcode: in std_logic_vector(2 downto 0);
        s0, s1: in std_logic_vector(15 downto 0);
        o_high, o_low: out std_logic_vector(15 downto 0);
        write_high: out std_logic );
end alu;

architecture impl of alu is
  type out_t is record
    high, low: std_logic_vector(15 downto 0);
    write_high: std_logic;
  end record;
  signal output: out_t;
  signal sub: std_logic;
  signal addsub_val, s1i: std_logic_vector(15 downto 0);
  signal product: std_logic_vector(31 downto 0);
  signal shft: std_logic_vector(31 downto 0);
  signal us0: unsigned(31 downto 0);
begin
  sub <= '1' when opcode = OP_SUB else '0';
  s1i <= (not s1) when sub = '1' else s1;
  addsub_val <= s0 + s1i + ((15 downto 1 => '0') & sub);
  product <= s0 * s1;

  us0 <= unsigned(std_logic_vector'(x"0000" & s0));
  shft <= std_logic_vector( us0 sll to_integer(unsigned(s1)) ); 

  process(all) begin
    case opcode is
      when OP_ADD => output <= (16x"0", addsub_val, '0');
      when OP_SUB => output <= (16x"0", addsub_val, '0');
      when OP_MUL => output <= (product(31 downto 16), product(15 downto 0), '1');
      when OP_SH =>  output <= (shft(31 downto 16), shft(15 downto 0), '1');
      when OP_XOR => output <= (16x"0", (s0 xor s1), '0');
      when OP_AND => output <= (16x"0", (s0 and s1), '0');
      when OP_OR =>  output <= (16x"0", (s0 or s1),  '0');
      when OP_NOT => output <= (16x"0", not s0, '0');
      when others => output <= (16x"0", 16x"0", '0');
    end case;
  end process;

  (o_high, o_low, write_high) <= output;
end impl; -- alu

library ieee;
package processor_opcodes is
  use ieee.std_logic_1164.all;

  constant OP_BR    : std_logic_vector(3 downto 0) := "0000";
  constant OP_BRS   : std_logic_vector(3 downto 0) := "0001";
  constant OP_BRIM  : std_logic_vector(3 downto 0) := "0010"; 
  constant OP_BRIMI : std_logic_vector(3 downto 0) := "0011"; 
  constant OP_BRACC : std_logic_vector(3 downto 0) := "0100"; 
  constant OP_LDA   : std_logic_vector(3 downto 0) := "0101";
  constant OP_LDAI  : std_logic_vector(3 downto 0) := "0110"; 
  constant OP_STA   : std_logic_vector(3 downto 0) := "0111";

  constant BR_EQ  : std_logic_vector(1 downto 0) := "00";
  constant BR_NEQ : std_logic_vector(1 downto 0) := "01";
  constant BR_GZ  : std_logic_vector(1 downto 0) := "10";
  constant BR_LZ  : std_logic_vector(1 downto 0) := "11";

  constant RACC : std_logic_vector(3 downto 0) := x"0";
  constant RACCH : std_logic_vector(3 downto 0) := x"1";
  constant RO0 : std_logic_vector(3 downto 0) := x"2";
  constant RO1 : std_logic_vector(3 downto 0) := x"3";
  constant RO2 : std_logic_vector(3 downto 0) := x"4";
  constant RO3 : std_logic_vector(3 downto 0) := x"5";
  constant RBRD : std_logic_vector(3 downto 0) := x"6";
  constant RMA : std_logic_vector(3 downto 0) := x"7";
  constant RMD : std_logic_vector(3 downto 0) := x"8";
  constant RIM : std_logic_vector(3 downto 0) := x"9";
  constant RT0 : std_logic_vector(3 downto 0) := x"a";
  constant RT1 : std_logic_vector(3 downto 0) := x"b";
  constant RT2 : std_logic_vector(3 downto 0) := x"c";
  constant RIN : std_logic_vector(3 downto 0) := x"d";
  constant RPC : std_logic_vector(3 downto 0) := x"e";
  constant RTIME : std_logic_vector(3 downto 0) := x"f";
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;
use work.ff.all;
use work.processor_opcodes.all;
use work.alu_ch18_6.all;
use work.ch16.all;

entity processor is
  generic( programFile: string := "fib.asm" );
  port( o0, o1, o2, o3: buffer std_logic_vector(15 downto 0);
        input: in std_logic_vector(7 downto 0);
        rst, clk: in std_logic );
end processor;
   
architecture impl of processor is
  signal i: std_logic_vector(7 downto 0); -- the instruction
  signal pc: std_logic_vector(15 downto 0);
  signal op: std_logic_vector(3 downto 0); -- opcode
  signal alu_op: std_logic; -- alu operation?
  signal alu_opcode: std_logic_vector(2 downto 0);
  signal br_op: std_logic_vector(1 downto 0); -- branch opcode
  signal rs: std_logic_vector(3 downto 0); -- source register
  signal acc, acch, brd, ma, mout, t0, t1, t2: std_logic_vector(15 downto 0); 
   --The register state
  signal tdone: std_logic;
  signal im: std_logic_vector(9 downto 0);
  signal s1: std_logic_vector(15 downto 0); -- source register
  signal imbranch, acc_eqz, accbranch, bran: std_logic;
  signal npc, npcr: std_logic_vector(15 downto 0);
  signal write_high: std_logic;
  signal o_high, o_low, acc_nxt, acch_nxt, brdn, brdr, en_i, en, accr: std_logic_vector(15 downto 0);
  signal ld, lda, ldai, sta, brs, en_acc, en_acch, en_brd: std_logic;
begin
  --Instruction fetch and parse
  instStore: ROM generic map(8, 16, programFile) port map(pc, i);
  op <= i(7 downto 4);
  alu_op <= op(3);
  alu_opcode <= op(2 downto 0);
  br_op <= i(3 downto 2);
  rs <= i(3 downto 0); -- source register

  --Decode source register
  process(all) begin
    case rs is
      when RACC => s1 <= acc;
      when RACCH => s1 <= acch;
      when RO0 => s1 <= o0;
      when RO1 => s1 <= o1;
      when RO2 => s1 <= o2;
      when RO3 => s1 <= o3;
      when RBRD => s1 <= brd;
      when RMA => s1 <= ma;
      when RMD => s1 <= mout;
      when RIM => s1 <= 6d"0" & im;
      when RT0 => s1 <= t0;
      when RT1 => s1 <= t1;        
      when RT2 => s1 <= t2;
      when RIN => s1 <= 8d"0" & input;
      when RPC => s1 <= pc;
      when others => s1 <= 16d"0";
    end case;
  end process;

  --Compute the next PC
  --im reg branch condition
  imbranch <= im(9) xor or_reduce( (im(8) and tdone) & (im(7 downto 0) and input) );
  --acc branch condition
  acc_eqz <= '1' when acc = 16x"0" else '0';
  accbranch <= '1' when (br_op = BR_EQ) and (acc_eqz = '1') else
               '1' when (br_op = BR_NEQ) and (acc_eqz = '0') else
               '1' when (br_op = BR_GZ) and (acc_eqz = '0') and (acc(15) = '0') else
               '1' when (br_op = BR_LZ) and (acc_eqz = '0') and (acc(15) = '0') else
               '0';
  --Do we branch?
  bran <=     '1' when (op = OP_BR) or (op = OP_BRS) or 
                        (((op = OP_BRIM) or (op = OP_BRIMI)) and (imbranch = '1')) or 
                        ((op = OP_BRACC) and (accbranch = '1'))
                      else '0';
   
  --compute next PC
  npc <= pc + i(3 downto 0) when bran = '1' and op = OP_BRIMI else 
         brd when bran = '1' else 
         pc + 1;
  npcr <= 16x"0" when rst = '1' else npc;

   --The ALU, and next accumulator inputs
  theALU: alu port map(alu_opcode, acc, s1, o_high, o_low, write_high);
   
  lda <= '1' when op = OP_LDA else '0';
  ldai <= '1' when op = OP_LDAI else '0';
  acc_nxt <= (((acc_nxt'range => alu_op) and o_low) or
               ((acc_nxt'range => lda) and s1) or
               ((acc_nxt'range => ldai) and (12x"0" & rs))) and
             (acc_nxt'range => not rst);

  sta <= '1' when op = OP_STA else '0';
  acch_nxt <= (((acch_nxt'range => alu_op) and o_high) or
               ((acch_nxt'range => sta) and acc)) and
              (acch_nxt'range => not rst);

  --The next brd register value
  brdn <= pc + 1 when op = OP_BRS else acc;
  brdr <= 16x"0" when rst = '1' else brdn;
  
  --Compute the write signals for the registers
  en_i <= std_logic_vector(shift_left(unsigned(std_logic_vector'(16x"1")),to_integer(unsigned(rs))));
  en <= (en_i and (en'range => sta)) or (en'range => rst);
  ld <= lda or ldai; -- Load the acc?
  en_acc <= alu_op or ld or en(to_integer(unsigned(RACC)));
  en_acch <= (alu_op and write_high) or en(to_integer(unsigned(RACCH)));
  brs <= '1' when op = OP_BRS else '0';
  en_brd <= en(to_integer(unsigned(RBRD))) or brs;
  accr <= 16x"0" when rst = '1' else acc;
           
  ACC_REG: vDFFE generic map(16) port map(clk, en_acc, acc_nxt, acc);
  ACCH_REG: vDFFE generic map(16) port map(clk, en_acch, acch_nxt, acch);
  O0_REG: vDFFE generic map(16) port map(clk, en(to_integer(unsigned(RO0))), accr, o0);
  O1_REG: vDFFE generic map(16) port map(clk, en(to_integer(unsigned(RO1))), accr, o1);
  O2_REG: vDFFE generic map(16) port map(clk, en(to_integer(unsigned(RO2))), accr, o2);
  O3_REG: vDFFE generic map(16) port map(clk, en(to_integer(unsigned(RO3))), accr, o3);
  BRD_REG:vDFFE generic map(16) port map(clk, en_brd, brdr, brd);
  MA_REG: vDFFE generic map(16) port map(clk, en(to_integer(unsigned(RMA))), accr, ma);
  dataStore: RAM generic map(16, 16) port map(ma, ma, en(to_integer(unsigned(RMD))), accr, mout);
  IM_REG: vDFFE generic map(10) port map(clk, en(to_integer(unsigned(RIM))), accr(9 downto 0), im);
  TO_REG: vDFFE generic map(16) port map(clk, en(to_integer(unsigned(RT0))), accr, t0);
  T1_REG: vDFFE generic map(16) port map(clk, en(to_integer(unsigned(RT1))), accr, t1);
  T2_REG: vDFFE generic map(16) port map(clk, en(to_integer(unsigned(RT2))), accr, t2);
  --IN, not included
  PC_REG: vDFFE generic map(16) port map(clk, '1', npcr, pc);
  TTIMER: Timer generic map(16) port map(clk, rst, en(to_integer(unsigned(RTIME))), acc, tdone);
end impl;

-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;

entity proc_tb is
end proc_tb;

architecture test of proc_tb is
  signal clk, rst: std_logic;
  signal input: std_logic_vector(7 downto 0); 
  signal o0, o1, o2, o3: std_logic_vector(15 downto 0);
begin
  DUT: entity work.processor(impl) generic map("fib.asm") port map(o0, o1, o2, o3, input, rst, clk);
  process begin
    clk <= '1'; 
    wait for 5 ns; clk <= '0';
    loop
      wait for 5 ns; clk <= '1';
      wait for 5 ns; clk <= '0';
    end loop;
  end process;

  process begin
    rst <= '1';
    wait for 25 ns; rst <= '0';
    input <= 8d"10"; 
    for i in 1 to 100 loop
      report "PC: " & to_hstring(<<signal dut.pc:std_logic_vector>>) & ", o1: " & 
        to_hstring(o1) & " i:" & to_string(<<signal dut.i:std_logic_vector>>);
      wait for 10 ns;
    end loop;
    wait;
  end process;
end test;
-- pragma translate_on

/*
Fib.S Figure 18.22:
LDAI 0111   
STA BRD     
LDA IN      
STA O1      
LDAI 0001   
STA T0      
STA T1      
#begin loop 
LDA O0      
ADD T1      
STA T2      
LDA O0      
STA T1      
LDA T2      
STA O0      
LDA O1      
SUB T0      
STA O1      
BRACC 0100  
*/






/* 
Fib.asm: The binary:
01100111
01110110
01011101
01110011
01100001
01111010
01111011
01010010
10001011
01111100
01010010
01111011
01011100
01110010
01010011
10011010
01110011
01000100
*/
