LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.fsm_constants.ALL;

PACKAGE processeur_constants IS
	COMPONENT processeur IS
		PORT (
			run, clk, rst : IN STD_LOGIC;
			din : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
			buswire : BUFFER STD_LOGIC_VECTOR(8 DOWNTO 0);
			done : OUT STD_LOGIC
		);
	END COMPONENT;
END PACKAGE;
------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.ff.ALL;
USE work.ch8.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.registre_constants.ALL;
USE work.addsub_constants.ALL;
USE work.muxb10_constants.ALL;
USE work.fsm_constants.ALL;

ENTITY processeur IS
	PORT (
		run, clk, rst : IN STD_LOGIC;
		din : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		buswire : BUFFER STD_LOGIC_VECTOR(8 DOWNTO 0);
		done : OUT STD_LOGIC
	);
END processeur;

ARCHITECTURE arch OF processeur IS
	SIGNAL r0in, r1in, r2in, r3in, r4in, r5in, r6in, r7in, ain, gin, irin, mode : STD_LOGIC := '0';
	SIGNAL inControl : STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL outControl : STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL r0out, r1out, r2out, r3out, r4out, r5out, r6out, r7out, aout, gout, irout, addsubout : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL sb : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL i : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL xReg, yReg : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	r0 : registre PORT MAP(buswire, clk, inControl(0), r0out);
	r1 : registre PORT MAP(buswire, clk, inControl(1), r1out);
	r2 : registre PORT MAP(buswire, clk, inControl(2), r2out);
	r3 : registre PORT MAP(buswire, clk, inControl(3), r3out);
	r4 : registre PORT MAP(buswire, clk, inControl(4), r4out);
	r5 : registre PORT MAP(buswire, clk, inControl(5), r5out);
	r6 : registre PORT MAP(buswire, clk, inControl(6), r6out);
	r7 : registre PORT MAP(buswire, clk, inControl(7), r7out);

	a : registre PORT MAP(buswire, clk, inControl(8), aout);
	addsub0 : addsub PORT MAP(aout, buswire, mode, addsubout);
	g : registre PORT MAP(addsubout, clk, inControl(9), gout);

	ir : registre PORT MAP(din, clk, inControl(10), irout);

	i <= irout(8 DOWNTO 6);
	decX : Dec GENERIC MAP(3, 8) PORT MAP(irout(5 DOWNTO 3), xReg);
	decY : Dec GENERIC MAP(3, 8) PORT MAP(irout(2 DOWNTO 0), yReg);

	fsmProc : fsm PORT MAP(i, xReg, yReg, run, clk, rst, inControl, outControl, done, mode);

	enc : Enc164 PORT MAP("000000" & outControl, sb);
	mux : Muxb10 PORT MAP(gout, "000000" & irout(2 DOWNTO 0), r7out, r6out, r5out, r4out, r3out, r2out, r1out, r0out, sb, buswire);
END arch;