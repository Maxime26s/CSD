library ieee;
use ieee.std_logic_1164.all;
package qs is
component quickstart is
PORT (
SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
);
end component;
end package;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY quickstart IS
PORT (
SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
);
END quickstart;
ARCHITECTURE Behavior OF quickstart IS
BEGIN
LEDR <= SW;
END Behavior;
------------------------------------------------------
-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.qs.all;
entity testbench_quickstart is
end testbench_quickstart;
architecture test of testbench_quickstart is
signal SW : STD_LOGIC_VECTOR(9 DOWNTO 0);
signal LEDR : STD_LOGIC_VECTOR(9 DOWNTO 0);

begin
DUT: quickstart port map(SW,LEDR);
process begin
SW <= "0000000001";
wait for 10 ns;
 report "SW = " & to_string(SW) & "; LEDR = " & to_string(LEDR);
SW <= "0000000010";
wait for 10 ns;
 report "SW = " & to_string(SW) & "; LEDR = " & to_string(LEDR);
SW <= "0000000100";
wait for 10 ns;
 report "SW = " & to_string(SW) & "; LEDR = " & to_string(LEDR);
wait;
end process;
end architecture test;
-- pragma translate_on