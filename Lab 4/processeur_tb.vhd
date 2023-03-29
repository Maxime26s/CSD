library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.processeur_constants.all;

entity processeur_tb is
end processeur_tb;

architecture test of processeur_tb is
	signal run, clk, rst: std_logic;
	signal din: std_logic_vector(8 downto 0);
	signal buswire : std_logic_vector(8 downto 0);
	signal done : std_logic;
begin
  DUT: processeur port map(run, clk, rst, din, buswire, done);

  process
  begin
    report "Testbench starting...";
	 run <= '1';
    rst <= '0';
    clk <= '0';
	 din <= "000000000";
    wait for 10 ns;
	 rst <= '1';
	 clk <= '1';
	 wait for 10 ns;
	 rst <= '0';
	 clk <= '0';
	 wait for 10 ns;
	 
    -- mvi
    din <= "001001001";
	 wait for 5 ns;
	 clk <= '1';
	 wait for 10 ns;
    clk <= '0';
	 wait for 10 ns;
	 clk <= '1';
	 wait for 10 ns;
	 clk <= '0';
	 wait for 10 ns;
	 
	 -- mv
    din <= "000000001";
	 wait for 5 ns;
	 clk <= '1';
	 wait for 10 ns;
    clk <= '0';
	 wait for 10 ns;
	 clk <= '1';
	 wait for 10 ns;
	 clk <= '0';
	 wait for 10 ns;
	 -- add
    din <= "010000001";
	 wait for 5 ns;
	 clk <= '1';
	 wait for 10 ns;
	 clk <= '0';
	 wait for 10 ns;
	 clk <= '1';
	 wait for 10 ns;
	 clk <= '0';
	 wait for 10 ns;
	 clk <= '1';
	 wait for 10 ns;
	 clk <= '0';
	 wait for 10 ns;
	 clk <= '1';
	 wait for 10 ns;
	 clk <= '0';
	 wait for 10 ns;
	 -- sub
	 din <= "011000001";
	 wait for 5 ns;
	 clk <= '1';
	 wait for 10 ns;
	 clk <= '0';
	 wait for 10 ns;
	 clk <= '1';
	 wait for 10 ns;
	 clk <= '0';
	 wait for 10 ns;
	 clk <= '1';
	 wait for 10 ns;
	 clk <= '0';
	 wait for 10 ns;
	 clk <= '1';
	 wait for 10 ns;
	 clk <= '0';
	 wait for 10 ns;
    wait;
  end process;
end architecture test;
