library ieee;
use ieee.std_logic_1164.all;

package seq_add_sub_constants is
	component seq_add_sub is
		GENERIC 	(n : INTEGER := 9);
		PORT (
        a, b : in std_logic_vector(7 downto 0);
        cin : in std_logic;
        mode : in std_logic;
        result : out std_logic_vector(7 downto 0);
        cout : out std_logic
		);
	end component;
end package;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use ieee.numeric_std.all;
entity seq_add_sub is
    port (
        a, b : in std_logic_vector(7 downto 0);
        cin : in std_logic;
        mode : in std_logic;
        result : out std_logic_vector(7 downto 0);
        cout : out std_logic
    );
end entity seq_add_sub;

architecture behavior of seq_add_sub is
    signal sum : std_logic_vector(8 downto 0);
    signal carry : std_logic;
begin
    process(a, b, cin, mode)
    begin
        if (mode = '0') then -- addition
            sum <= "000000000" + a + b + cin;
        else -- subtraction
            sum <= "000000000" + a - b - cin;
        end if;
    end process;

    result <= sum(7 downto 0);
    cout <= sum(8);
end architecture behavior;
