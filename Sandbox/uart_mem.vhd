library ieee;
use ieee.std_logic_1164.all;

package uart_mem_constants is
	component uart_mem is
		PORT (
			uart_buffer : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			rst : in std_logic;
			din : out std_logic_vector(8 downto 0)
		);
	end component;
end package;

------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.ch8.all;
use work.ff.all;
use ieee.numeric_std.all;
use work.uart_mem_constants.all;


ENTITY uart_mem IS
	PORT (
			uart_buffer : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			clk, rst : in std_logic;
			din : out std_logic_vector(8 downto 0)
	);
END uart_mem;

ARCHITECTURE arch OF uart_mem IS
	FUNCTION ascii_to_ternary(input_vec : STD_LOGIC_VECTOR(7 DOWNTO 0)) RETURN STD_LOGIC_VECTOR IS
	BEGIN
		RETURN STD_LOGIC_VECTOR(unsigned(input_vec) - 48);
	END FUNCTION ascii_to_ternary;
	
	TYPE State_type IS (T0, T1, T2);
	SIGNAL Tstep_Q, Tstep_D: State_type;
BEGIN
	
	statetable: PROCESS (Tstep_Q, rst)
	BEGIN
		CASE Tstep_Q IS
			WHEN T0 => Tstep_D <= T1;
			WHEN T1 => Tstep_D <= T2;
			WHEN T2 => Tstep_D <= T0;
		END CASE;
	END PROCESS;
	
asciiconverter: PROCESS (Tstep_Q)
	BEGIN
	CASE Tstep_Q IS
		WHEN T0 => din <= "000000000";
		WHEN T1 => din <= "000000000";
		WHEN T2 => din <= "000000000";
	END CASE;
END PROCESS;
	
	uartmemflipflops: PROCESS (clk, rst, Tstep_D)
	BEGIN
			IF rst = '1' THEN
				Tstep_Q <= T0;
			ELSE
				Tstep_Q <= Tstep_D;
			END IF;
	END PROCESS;
end arch;