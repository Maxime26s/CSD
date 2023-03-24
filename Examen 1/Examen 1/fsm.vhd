library ieee;
use ieee.std_logic_1164.all;

package q3 is
	component fsm is
	PORT (
		w, clk, rst : in std_logic; -- w pour l'entrée, clk pour la clock, rst pour le reset
		z : out std_logic; -- z pour la sortie
		state : out std_logic_vector(4 downto 0) -- state pour l'état de la fsm
	);
	end component;
end package;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.ff.all;

ENTITY fsm IS
	PORT (
		w, clk, rst : in std_logic;
		z : out std_logic;
		state : out std_logic_vector(4 downto 0)
	);
END fsm;

ARCHITECTURE arch OF fsm IS
	signal a,b,c,d,e,reseted : std_logic;
BEGIN
	a <= (not b and not c and not d and not e) or reseted; -- si aucun état d'activé ou reset, état A
	ffrst: sDFF port map(clk or rst, rst, reseted); -- si on reset, active le mode reset
	ffb: sDFF port map(clk or rst, (a or d or e) and not w, b); -- si l'état A/D/E et w=0, on passe à l'état B
	ffc: sDFF port map(clk or rst, (b or c) and not w, c); -- si l'état B/C et w=0, on passe à l'état C
	ffd: sDFF port map(clk or rst, (a or b or c) and w, d); -- si l'état A/B/C et w=1, on passe à l'état D
	ffe: sDFF port map(clk or rst, (d or e) and w, e); -- si l'état D/E et w=1, on passe à l'état E
	
	z <= c or e; -- z=1 si l'état est C/E
	state <= a & b & c & d & e; -- affiche l'état actuel
END arch;