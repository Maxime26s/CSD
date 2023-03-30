LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE fsm_constants IS
	TYPE State_type IS (T0, T1, T2, T3);
	COMPONENT fsm IS
		PORT (
			i : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			xReg, yReg : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			run, clk, rst : IN STD_LOGIC;
			inControl : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
			outControl : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
			done : OUT STD_LOGIC;
			mode : OUT STD_LOGIC;
			stateValue : OUT State_type
		);
	END COMPONENT;
END PACKAGE;

------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.ch8.ALL;
USE work.ff.ALL;
USE ieee.numeric_std.ALL;
USE work.fsm_constants.ALL;
ENTITY fsm IS
	PORT (
		i : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		xReg, yReg : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		run, clk, rst : IN STD_LOGIC;
		inControl : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
		outControl : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		done : OUT STD_LOGIC;
		mode : OUT STD_LOGIC;
		stateValue : OUT work.fsm_constants.State_type
	);
END fsm;

ARCHITECTURE arch OF fsm IS
	SIGNAL Tstep_Q, Tstep_D : State_type;
BEGIN
	statetable : PROCESS (Tstep_Q, i, run, rst)
	BEGIN
		CASE Tstep_Q IS
			WHEN T0 =>
				IF run = '0' THEN
					Tstep_D <= T0;
				ELSE
					Tstep_D <= T1;
				END IF;

			WHEN T1 =>
				IF run = '0' THEN
					Tstep_D <= T1;
				ELSIF i = "000" OR i = "001" THEN
					Tstep_D <= T0;
				ELSIF i = "010" OR i = "011" THEN
					Tstep_D <= T2;
				END IF;

			WHEN T2 =>
				IF run = '0' THEN
					Tstep_D <= T2;
				ELSIF i = "010" OR i = "011" THEN
					Tstep_D <= T3;
				END IF;

			WHEN T3 =>
				IF run = '0' THEN
					Tstep_D <= T3;
				ELSE
					Tstep_D <= T0;
				END IF;
		END CASE;
	END PROCESS;

	controlsignals : PROCESS (Tstep_Q, i, xReg, yReg)
	BEGIN
		CASE Tstep_Q IS
			WHEN T0 =>
				done <= '1';
				inControl <= "10000000000";
				outControl <= "0100000000";
			WHEN T1 =>
				done <= '0';

				CASE i IS
					WHEN "000" =>
						inControl <= "000" & xReg;
						outControl <= "00" & yReg;
					WHEN "001" =>
						inControl <= "000" & xReg;
						outControl <= "0100000000";
					WHEN "010" | "011" =>
						inControl <= "00100000000";
						outControl <= "00" & xReg;
						IF i = "010" THEN
							mode <= '1';
						ELSE
							mode <= '0';
						END IF;
					WHEN OTHERS =>
						inControl <= (OTHERS => '0');
						outControl <= (OTHERS => '0');
				END CASE;
			WHEN T2 =>
				CASE i IS
					WHEN "010" | "011" =>
						inControl <= "01000000000";
						outControl <= "00" & yReg;
					WHEN OTHERS =>
						inControl <= (OTHERS => '0');
						outControl <= (OTHERS => '0');
				END CASE;
			WHEN T3 =>
				CASE i IS
					WHEN "010" | "011" =>
						inControl <= "000" & xReg;
						outControl <= "1000000000";
					WHEN OTHERS =>
						inControl <= (OTHERS => '0');
						outControl <= (OTHERS => '0');
				END CASE;
		END CASE;
	END PROCESS;

	fsmflipflops : PROCESS (clk, rst, Tstep_D)
	BEGIN
		IF rising_edge(clk) THEN
			IF rst = '1' THEN
				Tstep_Q <= T0;
			ELSE
				Tstep_Q <= Tstep_D;
			END IF;
		END IF;
	END PROCESS;

	stateValue <= Tstep_Q;

END arch;