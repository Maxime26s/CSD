library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.seq_add_sub_constants.all;

entity seq_add_sub_tb is
end entity seq_add_sub_tb;

architecture test of seq_add_sub_tb is
    signal a : std_logic_vector(7 downto 0);
    signal b : std_logic_vector(7 downto 0);
    signal cin : std_logic;
    signal mode : std_logic;
    signal result : std_logic_vector(7 downto 0);
    signal cout : std_logic;
begin
    DUT : seq_add_sub port map (a, b, cin, mode, result, cout);
	 
    process
    begin
	     report "Testbench starting...";
		  
        -- Addition
        a <= "00001010";
        b <= "00000101";
        cin <= '0';
        mode <= '0';
        wait for 10 ns;

        a <= "10000000";
        b <= "00000001";
        wait for 10 ns;

		  cin <= '1';
        wait for 10 ns;
		  
        a <= "11111111";
        b <= "00000001";
        cin <= '0';
        wait for 10 ns;


        -- Subtraction
        a <= "00001010";
        b <= "00000101";
        mode <= '1';
        wait for 10 ns;

        a <= "10000000";
        b <= "00000001";
        wait for 10 ns;
		  
		  cin <= '1';
        wait for 10 ns;

        a <= "00000000";
        b <= "00000001";
		  cin <= '0';
        wait for 10 ns;
        wait;
    end process;
end architecture test;
