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

-- this file uses modules defined in ch08.vhd and ff.vhd

--Figure 24.3
-- Combinational Bus Interface
-- t (transmit) and r (receive) in signal names are from the 
-- perspective of the bus
library ieee;
use ieee.std_logic_1164.all;

entity BusInt is
  generic( aw: integer := 2;   -- address width
           dw: integer := 4 ); -- data width
  port( cr_valid, arb_grant, bt_valid: in std_logic;
        cr_ready, ct_valid, arb_req, br_valid: out std_logic;
        cr_addr, bt_addr, my_addr: in std_logic_vector(aw-1 downto 0);
        br_addr: out std_logic_vector(aw-1 downto 0); 
        cr_data, bt_data: in std_logic_vector(dw-1 downto 0);
        br_data, ct_data: out std_logic_vector(dw-1 downto 0) );
end BusInt;

architecture impl of BusInt is
begin
  -- arbitration
  arb_req <= cr_valid;
  cr_ready <= arb_grant;

  -- bus drive
  br_valid <= arb_grant;
  br_addr <= cr_addr when arb_grant else (others => '0');
  br_data <= cr_data when arb_grant else (others => '0');

  -- bus receive
  ct_valid <= '1' when (bt_valid = '1') and (bt_addr = my_addr) else '0';
  ct_data <= bt_data ; 
end impl; 


-- 2x2 Crossbar switch - full flow control
-- Figure 24.5
library ieee;
use ieee.std_logic_1164.all;

entity Xbar22 is
  generic( dw: integer := 4 ); -- data width
  port( c0r_valid, c0t_ready, c1r_valid, c1t_ready: in std_logic;	-- r-v handshakes
        c0r_ready, c0t_valid, c1r_ready, c1t_valid: out std_logic;
        c0r_addr, c1r_addr: in std_logic; -- address
        c0r_data, c1r_data: in std_logic_vector(dw-1 downto 0); -- data
        c0t_data, c1t_data: out std_logic_vector(dw-1 downto 0) );
end Xbar22;

architecture impl of Xbar22 is
  signal req00, req01, req10, req11: std_logic;
  signal grant00, grant01, grant10, grant11: std_logic;
begin
  -- request matrix
  req00 <= '1' when not c0r_addr and c0r_valid else '0';
  req01 <= '1' when     c0r_addr and c0r_valid else '0';
  req10 <= '1' when not c1r_addr and c1r_valid else '0';
  req11 <= '1' when     c1r_addr and c1r_valid else '0';

  -- arbitration 0 wins
  grant00 <= req00;
  grant01 <= req01;
  grant10 <= req10 and not req00 ;
  grant11 <= req11 and not req01 ;

  -- connections
  c0t_valid <= (grant00 and c0r_valid) or (grant10 and c1r_valid);
  c0t_data <=  (c0r_data and (dw-1 downto 0 => grant00))  or
               (c1r_data and (dw-1 downto 0 => grant10));
  c1t_valid <= (grant01 and c0r_valid) or (grant11 and c1r_valid);
  c1t_data <=  (c0r_data and (dw-1 downto 0 => grant01)) or 
               (c1r_data and (dw-1 downto 0 => grant11));

  -- ready
  c0r_ready <= (grant00 and c0t_ready) or (grant01 and c1t_ready);
  c1r_ready <= (grant10 and c0t_ready) or (grant11 and c1t_ready);
end impl;
------------------------------------------------------------------------

-- pragma translate_off

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.ch8.all;

entity testbus is
end testbus;

architecture test of testbus is
  constant NC: integer := 4;
  subtype stype is std_logic_vector(NC-1 downto 0);
  type atype is array (0 to NC-1) of std_logic_vector(1 downto 0);
  type dtype is array (0 to NC-1) of std_logic_vector(3 downto 0);

  signal cr_valid, arb_grant, bt_valid: stype;
  signal cr_ready, ct_valid, arb_req, br_valid: stype;
  signal cr_addr, bt_addr, my_addr: atype;
  signal br_addr: atype;
  signal cr_data, bt_data: dtype;
  signal br_data, ct_data: dtype;

  signal bus_valid: std_logic;
  signal bus_addr: std_logic_vector(1 downto 0);
  signal bus_data: std_logic_vector(3 downto 0);
begin
  DUT: for i in 0 to NC-1 generate
    BI: entity work.BusInt(impl) port map(cr_valid(i), arb_grant(i), bt_valid(i),
          cr_ready(i), ct_valid(i), arb_req(i), br_valid(i),
          cr_addr(i), bt_addr(i), my_addr(i),
          br_addr(i),
          cr_data(i), bt_data(i),
          br_data(i), ct_data(i) );

    my_addr(i) <= conv_std_logic_vector(i,2);
    bus_addr <= br_addr(i) when br_valid(i) = '1' else (others => 'Z');
    bus_data <= br_data(i) when br_valid(i) = '1' else (others => 'Z');
    bt_data(i) <= bus_data;
    bt_addr(i) <= bus_addr;
    bt_valid(i) <= bus_valid;
  end generate;

  A: Arb generic map(NC) port map( arb_req, arb_grant );

  bus_valid <= or br_valid;

  process begin
    cr_valid(0) <= '0';  
    cr_valid(1) <= '0';  
    cr_valid(2) <= '0';  
    cr_valid(3) <= '0'; wait for 10 ns;

    -- send "1001" from client 0 to client 3
    cr_valid(0) <= '1';  
    cr_addr(0) <= "11";
    cr_data(0) <= "1001";
    wait;
  end process;
end test;

------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity testxbar is
end testxbar;

architecture test of testxbar is
  signal c0r_valid, c0t_ready, c1r_valid, c1t_ready: std_logic;	-- r-v handshakes
  signal c0r_ready, c0t_valid, c1r_ready, c1t_valid: std_logic;
  signal c0r_addr, c1r_addr: std_logic; -- address
  signal c0r_data, c1r_data: std_logic_vector(3 downto 0); -- data
  signal c0t_data, c1t_data: std_logic_vector(3 downto 0);
begin
  DUT: entity work.Xbar22(impl) port map(
    c0r_valid, c0t_ready, c1r_valid, c1t_ready,
    c0r_ready, c0t_valid, c1r_ready, c1t_valid,
    c0r_addr, c1r_addr,
    c0r_data, c1r_data,
    c0t_data, c1t_data );

  process begin
    c0r_valid <= '0'; c1r_valid <= '0';
    wait for 10 ns;
    c0r_addr <= '1';
    c0r_data <= x"a";
    c0r_valid <= '1';
    wait for 10 ns;

    wait;
  end process;
end test;

-- pragma translate_on
