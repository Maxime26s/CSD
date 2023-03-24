LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
USE work.mediane_constants.all;

entity mediane_tb is
end mediane_tb;

architecture test of mediane_tb is
	signal SW : STD_LOGIC_VECTOR(8 DOWNTO 0);
	signal a, b, c: std_logic_vector(2 downto 0);
	signal res : STD_LOGIC_VECTOR(2 DOWNTO 0);
begin
	DUT: mediane port map(a, b, c, res);
	process begin
		report "Testbench starting...";
		for i in 0 to 511 loop
			SW <= std_logic_vector(to_unsigned(i, SW'length));
			a <= SW(2 downto 0);
			b <= SW(5 downto 3);
			c <= SW(8 downto 6);
			wait for 10 ns;
			if a > b then
				if b > c then
					if res /= b then
						report "a = " & to_string(a) & "; b = " & to_string(b) & "; c = " & to_string(c) & "; res = " & to_string(res);
					end if;
				elsif res /= c then
					report "a = " & to_string(a) & "; b = " & to_string(b) & "; c = " & to_string(c) & "; res = " & to_string(res);
				end if;
			elsif a > c then
				if res /= a then
					report "a = " & to_string(a) & "; b = " & to_string(b) & "; c = " & to_string(c) & "; res = " & to_string(res);
				end if;
			elsif b > c then
				if res /= c then
					report "a = " & to_string(a) & "; b = " & to_string(b) & "; c = " & to_string(c) & "; res = " & to_string(res);
				end if;
			elsif res /= b then
				report "a = " & to_string(a) & "; b = " & to_string(b) & "; c = " & to_string(c) & "; res = " & to_string(res);
			end if;
		end loop;
		wait;
	end process;
end architecture test;