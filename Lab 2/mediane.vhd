library ieee;
use ieee.std_logic_1164.all;

package mediane_constants is
	component mediane is
		PORT (
			a, b, c : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			res : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
	end component;
end package;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.ch8.all;

ENTITY mediane IS
	PORT (
		a, b, c : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		res : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END mediane;

ARCHITECTURE arch OF mediane IS
	signal res_magcomp : std_logic_vector(2 downto 0);
BEGIN
	magcomp0: MagComp generic map(3) port map(a, b, res_magcomp(0));
	magcomp1: MagComp generic map(3) port map(a, c, res_magcomp(1));
	magcomp2: MagComp generic map(3) port map(b, c, res_magcomp(2));
	
	mux0 : Muxb8 generic map(3) port map(b, a, b, c, c, a, c, b, res_magcomp, res);
END arch;