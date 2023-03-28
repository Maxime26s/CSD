library ieee;
use ieee.std_logic_1164.all;
use work.fsm_constants.all;

package processeur_constants is
	component processeur is
	PORT (
		run, clk, rst : in std_logic;
		din : in std_logic_vector(8 downto 0);
		buswire : buffer std_logic_vector(8 downto 0);
		done : out std_logic
	);
	end component;
end package;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.ff.all;
use work.ch8.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.registre_constants.all;
use work.addsub_constants.all;
use work.muxb10_constants.all;
use work.fsm_constants.all;

ENTITY processeur IS
	PORT (
		run, clk, rst : in std_logic;
		din : in std_logic_vector(8 downto 0);
		buswire : buffer std_logic_vector(8 downto 0);
		done : out std_logic
	);
END processeur;

ARCHITECTURE arch OF processeur IS
	signal r0in, r1in, r2in, r3in, r4in, r5in, r6in, r7in, ain, gin, irin, mode : std_logic := '0';
	signal inControl : std_logic_vector(10 downto 0);
	signal outControl : std_logic_vector(9 downto 0);
	signal r0out, r1out, r2out, r3out, r4out, r5out, r6out, r7out, aout, gout, irout, addsubout : std_logic_vector(8 downto 0);
	signal sb : std_logic_vector(3 downto 0);
	signal i : std_logic_vector(2 downto 0);
	signal xReg, yReg : std_logic_vector(7 downto 0);
BEGIN
	r0 : registre port map(buswire, clk, inControl(0), r0out);
	r1 : registre port map(buswire, clk, inControl(1), r1out);
	r2 : registre port map(buswire, clk, inControl(2), r2out);
	r3 : registre port map(buswire, clk, inControl(3), r3out);
	r4 : registre port map(buswire, clk, inControl(4), r4out);
	r5 : registre port map(buswire, clk, inControl(5), r5out);
	r6 : registre port map(buswire, clk, inControl(6), r6out);
	r7 : registre port map(buswire, clk, inControl(7), r7out);
	
	a : registre port map(buswire, clk, inControl(8), aout);
	addsub0 : addsub port map(aout, buswire, mode, addsubout);
	g : registre port map(addsubout, clk, inControl(9), gout);
	
	ir : registre port map(din, clk, inControl(10), irout);
	
	i <= irout(8 downto 6);
	decX : Dec generic map(3, 8) port map(irout(5 downto 3), xReg);
	decY : Dec generic map(3, 8) port map(irout(2 downto 0), yReg);
	
	fsmProc : fsm port map(i, xReg, yReg, run, clk, rst, inControl, outControl, done, mode);
	
	enc : Enc164 port map("000000" & outControl, sb);
	mux : Muxb10 port map(gout, "000000" & irout(2 downto 0), r7out, r6out, r5out, r4out, r3out, r2out, r1out, r0out, sb, buswire);
END arch;