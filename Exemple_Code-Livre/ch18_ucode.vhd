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

-- uses modules defined in ch08.vhd, ff.vhd and ch16.vhd

library ieee;
use ieee.std_logic_1164.all;

package ch18 is
  component ucode1 is
    generic( i: integer := 1; -- input width
             o: integer := 6; -- output width
             s: integer := 3; -- bits of state
             p: string := "ucode.asm" );
    port( clk,rst: in std_logic;
          input: in std_logic_vector(i-1 downto 0);
          output: out std_logic_vector(o-1 downto 0) ) ;
  end component;

  component ucode2 is
    generic( i: integer := 2; -- input width
             o: integer := 9; -- output width
             s: integer := 4; -- bits of state
             b: integer := 3; -- bits of instruction
             p: string := "ucode.asm" );
    port( clk, rst: in std_logic;
          input: in std_logic_vector(i-1 downto 0);
          output: out std_logic_vector(o-1 downto 0) );
  end component;

  component ucodeMI is 
    generic( i: integer := 2; -- input width
             m: integer := 9; -- output width
             o: integer := 3; -- output sub-width
             s: integer := 5; -- bits of state
             x: integer := 4; -- bits of instruction
             p: string := "ucode.asm" );
    port( clk, rst: in std_logic;
          input: in std_logic_vector(i-1 downto 0);
          output: out std_logic_vector(m-1 downto 0) );
  end component;
end package;

-- Figure 18.2
library ieee;
use ieee.std_logic_1164.all;
use work.ff.all;

entity ucode1 is
  generic( i: integer := 1; -- input width
           o: integer := 6; -- output width
           s: integer := 3; -- bits of state
           p: string := "ucode1_1.asm" );
  port( clk,rst: in std_logic;
        input: in std_logic_vector(i-1 downto 0);
        output: out std_logic_vector(o-1 downto 0) ) ;
end ucode1;

architecture impl of ucode1 is
  signal nxt, state: std_logic_vector(s-1 downto 0);
  signal uinst : std_logic_vector(s+o-1 downto 0);
begin
  STATE_REG: vDFF generic map(s) port map(clk, nxt, state);  -- state register
  OUT_REG: vDFF generic map(o) port map(clk, uinst(o-1 downto 0), output); -- output register
  UC: ROM generic map(s+o,s+i,p) port map(state & input, uinst); -- microcode store
  nxt <= (others => '0') when rst else uinst(s+o-1 downto o); -- reset state
end impl;

-- Figure 18.8
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ff.all;

entity ucode2 is
  generic( i: integer := 2; -- input width
           o: integer := 9; -- output width
           s: integer := 4; -- bits of state
           b: integer := 3; -- bits of instruction
           p: string := "ucode2_1.asm" );
  port( clk, rst: in std_logic;
        input: in std_logic_vector(i-1 downto 0);
        output: out std_logic_vector(o-1 downto 0) );
end ucode2;

architecture impl of ucode2 is
  type inst_t is record
    brinst: std_logic_vector(b-1 downto 0);
    br_upc: std_logic_vector(s-1 downto 0);
    n_out: std_logic_vector(o-1 downto 0);
  end record;
  signal nupc, upc: std_logic_vector(s-1 downto 0); -- microprogram counter
  signal ibits: std_logic_vector(b+s+o-1 downto 0); -- rom output
  signal uinst: inst_t; -- microinstruction word
  signal branch: std_logic;
begin
  -- split off fields of microinstruction 
  uinst <= (ibits(b+s+o-1 downto s+o), ibits(s+o-1 downto o), ibits(o-1 downto 0));

  UPC_REG: vDFF generic map(s) port map(clk, nupc, upc);  -- microprogram counter
  OUT_REG: vDFF generic map(o) port map(clk, uinst.n_out, output); -- output register
  UC: ROM generic map(s+o+b,s,p) port map(upc, ibits); -- microcode store

  -- branch instruction decode
  branch <= ((uinst.brinst(0) and input(0)) or (uinst.brinst(1) and input(1))) 
            xor uinst.brinst(2);

  -- sequencer
  nupc <= (others => '0') when rst else 
          uinst.br_upc when branch else 
          upc + 1;
end impl;

--Figure 18.15
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ff.all;
use work.ch16.all;
use ieee.numeric_std.all;

entity ucodeMI is 
  generic( i: integer := 2; -- input width
           m: integer := 9; -- output width
           o: integer := 3; -- output sub-width
           s: integer := 5; -- bits of state
           x: integer := 4; -- bits of instruction
           p: string := "ucodemi.mif" );
  port( clk, rst: in std_logic;
        input: in std_logic_vector(i-1 downto 0);
        output: out std_logic_vector(m-1 downto 0) );
end ucodeMI;

architecture impl of ucodeMI is
  type inst_t is 
    record
      op: std_logic; -- opcode bit
      inst: std_logic_vector(x-2 downto 0); -- condition for branch, dest for store
      imm : std_logic_vector(s-1 downto 0); -- target for branch, value for store
    end record;

  function to_inst (bv: in std_logic_vector(x+s-1 downto 0)) return inst_t is
  begin 
    return (bv(x+s-1), bv(x+s-2 downto s), bv(s-1 downto 0));
  end to_inst;

  signal nupc, upc: std_logic_vector(s-1 downto 0); -- microprogram counter
  signal ibits: std_logic_vector(x+s-1 downto 0); -- microinstruction raw bits
  signal uinst: inst_t; -- microinstruction 
  signal done: std_logic; -- timer done signal
  signal branch: std_logic;
  signal e: std_logic_vector(3 downto 0); -- enable for output registers and timer
  signal blt, bew, ble, btd: std_logic;
begin
  -- split off fields of microinstruction
  uinst <= to_inst(ibits); 

  UPC_REG: vDFF generic map(s) port map(clk, nupc, upc) ;  -- microprogram counter
  UC: ROM generic map(s+x,s,p) port map(upc, ibits) ; -- microcode store
  
  -- output registers and timer
  NS: vDFFE generic map(o) 
            port map(clk, e(0), uinst.imm(o-1 downto 0), output(o-1 downto 0));
  EW: vDFFE generic map(o) 
            port map(clk, e(1), uinst.imm(o-1 downto 0), output(2*o-1 downto o));
  LT: vDFFE generic map(o) 
            port map(clk, e(2), uinst.imm(o-1 downto 0), output(3*o-1 downto 2*o));
  TIM: Timer generic map(s) port map(clk, rst, e(3), uinst.imm, done); -- timer

  e <= "0000" when uinst.op else 
       std_logic_vector( to_unsigned(1,4) sll to_integer(unsigned(uinst.inst)) );

  -- branch instruction decode
  blt <= '1' when uinst.inst(1 downto 0) = "00" else '0'; -- left turn
  bew <= '1' when uinst.inst(1 downto 0) = "01" else '0'; -- east/west
  ble <= '1' when uinst.inst(1 downto 0) = "10" else '0'; -- left turn or east/west
  btd <= '1' when uinst.inst(1 downto 0) = "11" else '0'; -- timer done
  branch <=  (uinst.inst(2) xor ((blt and input(0)) or 
                              (bew and input(1)) or 
                              (ble and (input(0) or input(1))) or 
                              (btd and done))) when uinst.op
                         else '0'; -- for a store opcode

  -- microprogram counter
  nupc <=  (others => '0') when rst else
           uinst.imm when branch else
           upc + 1;
end impl;

--------------------------------------------------------------------------------
-- NOTE: testbenches use VHDL-2008 syntax supported by ModelSim, but not some 
-- synthesis tools

-- pragma translate_off

library ieee;
use ieee.std_logic_1164.all;

entity ucode1_tb is
end ucode1_tb;

architecture test of ucode1_tb is
  signal clk, rst: std_logic;
  signal input: std_logic_vector(0 downto 0); 
  signal output: std_logic_vector(5 downto 0); 
  signal upc: std_logic_vector(3 downto 0);
begin
  DUT: entity work.ucode1(impl) generic map(p=>"ucode1_1.asm") port map(clk,rst,input,output);
  process begin
    clk <= '1'; 
    wait for 5 ns; clk <= '0';
    loop
      wait for 5 ns; clk <= '1';
      wait for 5 ns; clk <= '0';
      report "ADDR: " & 
        to_hstring(<<signal dut.state:std_logic_vector>> & <<signal dut.input:std_logic_vector>>) & 
        ", output: " & 
        to_string(output) & " uinst:" & to_string(<<signal dut.uinst:std_logic_vector>>);
    end loop;
  end process;

  process begin
    rst <= '1'; input <= "0";
    wait for 15 ns; 
    rst <= '0'; 
    wait for 10 ns;
    input <= "1"; 
    wait for 40 ns;
    input <= "0"; 
    wait for 60 ns;
    std.env.stop(0);
  end process;
end test;

--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ucode2_tb is
end ucode2_tb;

architecture test of ucode2_tb is
  signal clk, rst: std_logic;
  signal input: std_logic_vector(1 downto 0); 
  signal output: std_logic_vector(8 downto 0); 
begin
  DUT: entity work.ucode2(impl) generic map(p=>"ucode2_2.asm") port map(clk,rst,input,output);
  process begin
    clk <= '1'; 
    wait for 5 ns; clk <= '0';
    loop
      wait for 5 ns; clk <= '1';
      wait for 5 ns; clk <= '0';
      report "upc: " & to_hstring(<<signal dut.upc:std_logic_vector>>) & ", out: " & to_string(output);
    end loop;
  end process;

  process begin
    rst <= '1'; input <= "00";
    wait for 25 ns; rst <= '0'; wait for 10 ns;
    input <= "01"; 
    wait for 60 ns;
    input <= "10"; 
    wait for 60 ns;
    input <= "00"; 
    wait for 60 ns;
    input <= "11"; 
    wait for 60 ns;
    std.env.stop(0);
  end process;
end test;

--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity testMI is
end testMI;

architecture test of testMI is
  signal clk, rst: std_logic;
  signal input: std_logic_vector(1 downto 0); 
  signal output: std_logic_vector(8 downto 0); 
begin
  DUT: entity work.ucodeMI(impl) generic map(p=>"ucodemi.asm") port map(clk,rst,input,output);
  process begin
    clk <= '1'; 
    wait for 5 ns; clk <= '0';
    loop
      wait for 5 ns; clk <= '1';
      wait for 5 ns; clk <= '0';
    end loop;
  end process;

  process begin
    rst <= '1'; input <= "00";
    wait for 25 ns; rst <= '0'; wait for 10 ns;
    input <= "01"; 
    wait for 300 ns;
    input <= "10"; 
    wait for 400 ns;
    input <= "00"; 
    wait for 400 ns;
    std.env.stop(0);
  end process;
end test;

-- pragma translate_on
