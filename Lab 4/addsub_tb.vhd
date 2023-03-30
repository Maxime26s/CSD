LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.addsub_constants.ALL;

ENTITY addsub_tb IS
END addsub_tb;

ARCHITECTURE test OF addsub_tb IS
  SIGNAL a, b, c : STD_LOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL mode : STD_LOGIC;
BEGIN
  DUT : addsub PORT MAP(a, b, mode, c);

  PROCESS
  BEGIN
    REPORT "Testbench starting...";

    a <= "000000000";
    b <= "000000000";
    mode <= '0';
    WAIT FOR 10 ns;

    a <= "000000001";
    b <= "000000001";
    mode <= '0';
    WAIT FOR 10 ns;

    a <= "111111111";
    b <= "000000001";
    mode <= '0';
    WAIT FOR 10 ns;

    a <= "000000001";
    b <= "111111111";
    mode <= '1';
    WAIT FOR 10 ns;

    a <= "111111111";
    b <= "000000001";
    mode <= '1';
    WAIT FOR 10 ns;

    a <= "111111111";
    b <= "111111111";
    mode <= '1';
    WAIT FOR 10 ns;

    a <= "000000001";
    b <= "000000001";
    mode <= '1';
    WAIT FOR 10 ns;

    WAIT;
  END PROCESS;
END ARCHITECTURE test;