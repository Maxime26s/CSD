-- Copyright (C) Tor M. Aamodt, UBC

--synthesis VHDL_INPUT_VERSION VHDL_2008

library ieee;
use ieee.std_logic_1164.all;

entity thermostat is
  port ( presetTemp, currentTemp : in std_logic_vector( 2 downto 0 );
         fanOn : out std_logic );
end thermostat;

architecture impl of thermostat is
begin
  fanOn <= '1' when currentTemp > presetTemp
               else '0';
end impl;

-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end testbench;

architecture test of testbench is
  signal preset,  current: std_logic_vector(2 downto 0);
  signal fanon: std_logic;
begin
  DUT: entity work.thermostat(impl) port map( preset, current, fanon );

  preset <= "011";

  process begin
    for i in 0 to 7 loop
      current <= std_logic_vector(to_unsigned(i,current'length));
      wait for 10 ns;
      report to_string(preset) & " " & to_string(current) & " -> " & to_string(fanon);
    end loop;
    std.env.stop(0);
  end process;
end test;
-- pragma translate_on
