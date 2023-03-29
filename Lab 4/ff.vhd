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

library ieee;

package ff is
  use ieee.std_logic_1164.all;

  ------------------------------------------------------------------------
  -- D-type Flip Flop
  -- Figure 14.16
  ------------------------------------------------------------------------
  component vDFF is
    generic( n: integer := 1 ); -- width
    port( clk: in std_logic;
          D: in std_logic_vector( n-1 downto 0 );
          Q: out std_logic_vector( n-1 downto 0 ) );
  end component;

  ------------------------------------------------------------------------

  component sDFF is
    port( clk, D: in std_logic;
          Q: out std_logic );
  end component;

  ------------------------------------------------------------------------
  -- Flop with enable
  ------------------------------------------------------------------------
  component vDFFE is
    generic( n: integer := 1 ); -- width
    port( clk, en: in std_logic;
          D: in std_logic_vector( n-1 downto 0 );
          Q: out std_logic_vector( n-1 downto 0 ) );
  end component;

  ------------------------------------------------------------------------
  component ROM is
    generic( data_width: integer := 32; 
             addr_width: integer := 4; 
             filename: string := "dataFile" );
    port( addr: in std_logic_vector(addr_width-1 downto 0);
          data: out std_logic_vector(data_width-1 downto 0) );
  end component;

  ------------------------------------------------------------------------
  component RAM is
    generic( data_width: integer := 32; 
             addr_width: integer := 4 );
    port( ra, wa: in std_logic_vector(addr_width-1 downto 0);
          write: in std_logic;
          din: in std_logic_vector(data_width-1 downto 0);
          dout: out std_logic_vector(data_width-1 downto 0) );
  end component;

end package;


------------------------------------------------------------------------
-- D-type Flip Flop
-- Figure 14.16
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity vDFF is
    generic( n: integer := 1 );
    port( clk: in std_logic;
          D: in std_logic_vector( n-1 downto 0 );
          Q: out std_logic_vector( n-1 downto 0 ) );
end vDFF;

architecture impl of vDFF is
begin
  process(clk) begin
    if rising_edge(clk) then
      Q <= D;
    end if;
  end process;
end impl;
 
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity sDFF is
  port( clk, D: in std_logic;
        Q: out std_logic );
end sDFF;

architecture impl of sDFF is
begin
  process(clk) begin
    if rising_edge(clk) then
      Q <= D; 
    end if;
  end process;
end impl;

------------------------------------------------------------------------
-- Flop with enable
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity vDFFE is
  generic( n: integer := 1 ); -- width
  port( clk, en: in std_logic;
        D: in std_logic_vector( n-1 downto 0 );
        Q: buffer std_logic_vector( n-1 downto 0 ) );
end vDFFE;

architecture impl of vDFFE is
  signal Q_next: std_logic_vector(n-1 downto 0);
begin
  Q_next <= D when en else Q;

  process(clk) begin
    if rising_edge(clk) then
      Q <= Q_next;
    end if;
  end process;
end impl;

------------------------------------------------------------------------
--Figure 8.49
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity ROM is
  generic( data_width: integer := 32; 
           addr_width: integer := 4; 
           filename: string := "dataFile" );
  port( addr: in std_logic_vector(addr_width-1 downto 0);
        data: out std_logic_vector(data_width-1 downto 0) );
end ROM;

architecture impl of ROM is
  subtype word_t is std_logic_vector(data_width-1 downto 0); 
  type mem_t is array(0 to (2**addr_width-1)) of word_t;

  -- ModelSim and Vivado will initialize RAM/ROMs using the following function
  impure function init_rom (filename: in string) return mem_t is
    file init_file: text open read_mode is filename; 
    variable init_line: line;
    variable result_mem: mem_t;
  begin
    for i in result_mem'range loop
      readline(init_file,init_line);
      ieee.std_logic_textio.read(init_line, result_mem(i));
    end loop; 
    return result_mem;
  end init_rom;

  signal rom_data: mem_t := init_rom(filename);
  
  -- Quartus initializes RAM/ROMs via ram_init_file synthesis attribute
  -- filename must be in MIF format (different format than used by init_rom)
  attribute ram_init_file : string;
  attribute ram_init_file of rom_data : signal is filename;
begin
  data <= rom_data(to_integer(unsigned(addr)));
end impl;

------------------------------------------------------------------------
--Figure 8.52

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
  generic( data_width: integer := 32; 
           addr_width: integer := 4 );
  port( ra, wa: in std_logic_vector(addr_width-1 downto 0);
        write: in std_logic;
        din: in std_logic_vector(data_width-1 downto 0);
        dout: out std_logic_vector(data_width-1 downto 0) );
end RAM;

architecture impl of RAM is
  subtype word_t is std_logic_vector(data_width-1 downto 0); 
  type mem_t is array(0 to (2**addr_width-1)) of word_t;
  signal data: mem_t;
begin
  dout <= data(to_integer(unsigned(ra)));

  process(all) begin
    if write = '1' then
      data(to_integer(unsigned(wa))) <= din;
    end if;
  end process;
end impl;
