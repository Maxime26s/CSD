library ieee;
use ieee.std_logic_1164.all;

package digit_converter_constants is
	component digit_converter is
		PORT (
			data : in std_logic_vector(8 downto 0);
			hundred, ten, unit : out std_logic_vector(3 downto 0)
		);
	end component;
end package;

------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY digit_converter IS
	PORT (
			data : in std_logic_vector(8 downto 0);
			hundred, ten, unit : out std_logic_vector(3 downto 0)
	);
END digit_converter;

ARCHITECTURE arch OF digit_converter IS
	signal data_u : unsigned(8 downto 0);
	signal mod_h, mod_t, mod_u, mod_diff_ht, mod_diff_tu : unsigned(8 downto 0);
BEGIN
	data_u <= unsigned(data);
	
	mod_h <= data_u mod 1000;
	mod_t <= data_u mod 100;
	mod_u <= data_u mod 10;
	
	mod_diff_tu <= mod_t - mod_u;
	mod_diff_ht <= mod_h - mod_t;
	
	unit <= std_logic_vector(resize(mod_u,4));
	ten <= std_logic_vector(resize(mod_diff_tu / to_unsigned(10, 9),4));
	hundred <= std_logic_vector(resize(mod_diff_ht / to_unsigned(100, 9),4));
end arch;