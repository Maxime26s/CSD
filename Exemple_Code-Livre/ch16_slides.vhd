-- synthesis VHDL_INPUT_VERSION VHDL_2008

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ff.all;

entity Counter1 is
  port( clk, rst: in std_logic;
        output: buffer std_logic_vector(5 downto 0) );
end Counter1;

--architecture symbolic_fsm_impl of Counter1 is
--  signal nxt: std_logic_vector( 4 downto 0 );
--begin
--  counter: vDFF generic map(5) port map(clk,nxt,output);
--
--  process(all) begin
--    case rst is
--      when '1' => nxt <= 5d"0";
--      when others => nxt <= nxt + 1;
--    end case;
--  end process; 
--end symbolic_fsm_impl;


architecture fsm_impl of Counter1 is
  signal nxt: std_logic_vector(5 downto 0);
begin
  counter: vDFF generic map(5) port map(clk,nxt,output);

  process(all) begin
    case? rst & output is
      when "1-----" => nxt <= 5d"0";
      when  6d"0" => nxt <= 5d"1";
      when  6d"1" => nxt <= 5d"2";
      when  6d"2" => nxt <= 5d"3";
      when  6d"3" => nxt <= 5d"4";
      when  6d"4" => nxt <= 5d"5";
      when  6d"5" => nxt <= 5d"6";
      when  6d"6" => nxt <= 5d"7";
      when  6d"7" => nxt <= 5d"8";
      when  6d"8" => nxt <= 5d"9";
      when  6d"9" => nxt <= 5d"10";
      when  6d"10" => nxt <= 5d"11";
      when  6d"11" => nxt <= 5d"12";
      when  6d"12" => nxt <= 5d"13";
      when  6d"13" => nxt <= 5d"14";
      when  6d"14" => nxt <= 5d"15";
      when  6d"15" => nxt <= 5d"16";
      when  6d"16" => nxt <= 5d"17";
      when  6d"17" => nxt <= 5d"18";
      when  6d"18" => nxt <= 5d"19";
      when  6d"19" => nxt <= 5d"20";
      when  6d"20" => nxt <= 5d"21";
      when  6d"21" => nxt <= 5d"22";
      when  6d"22" => nxt <= 5d"23";
      when  6d"23" => nxt <= 5d"24";
      when  6d"24" => nxt <= 5d"25";
      when  6d"25" => nxt <= 5d"26";
      when  6d"26" => nxt <= 5d"27";
      when  6d"27" => nxt <= 5d"28";
      when  6d"28" => nxt <= 5d"29";
      when  6d"29" => nxt <= 5d"30";
      when  6d"30" => nxt <= 5d"31";
      when  6d"31" => nxt <= 5d"0";
      when others => nxt <= "-----";
    end case?;
  end process;
end fsm_impl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ff.all;

entity Counter is
  generic( n: integer := 5 );
  port( clk, rst: in std_logic;
        output: buffer std_logic_vector(n-1 downto 0) );
end Counter;

architecture impl of Counter is
  signal nxt: std_logic_vector(n-1 downto 0); 
begin
  nxt <= (others => '0') when rst else output+1;
  COUNT: vDFF generic map(n) port map(clk,nxt,output);
end impl;



--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ff.all;

entity UDL_Count1 is 
  generic( n: integer := 1 ); 
  port( clk, rst, up, down, load: in std_logic; 
        input: in std_logic_vector(n-1 downto 0); 
        output: buffer std_logic_vector(n-1 downto 0) ); 
end UDL_Count1;

architecture impl of UDL_Count1 is 
  signal nxt: std_logic_vector(n-1 downto 0); 
begin 
  COUNT: vDFF generic map(n) port map(clk,nxt,output);

  process(all) begin 
    case? std_logic_vector'(rst & up & down & load) is 
      when "1---" => nxt <= (others => '0'); 
      when "01--" => nxt <= output + 1; 
      when "001-" => nxt <= output - 1; 
      when "0001" => nxt <= input; 
      when others => nxt <= output; 
    end case?; 
  end process; 
end impl;

--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ch8.all;
use work.ff.all;

entity Timer is
  generic( n: integer := 4 );
  port( clk, rst, load: in std_logic;
        input: in std_logic_vector(n-1 downto 0);
        done: buffer std_logic );
end Timer;


--

architecture struct_impl of Timer is
  signal count, next_count, cntm1, zero: std_logic_vector(n-1 downto 0);
  signal sel: std_logic_vector(2 downto 0);
begin
  CNT: vDFF generic map(n) port map(clk,next_count,count);
  MUX: Mux3 generic map(n) port map(count - 1,input, (n-1 downto 0 => '0'),
         ((not rst) and (not load) and (not done)) &
         (load and (not rst)) &
         (rst or (done and (not load))), 
         next_count);
  done <= '1' when count = 0 else '0';
end struct_impl;

--

architecture behav_impl of Timer is
  signal count, next_count: std_logic_vector(n-1 downto 0);
begin 
  CNT: vDFF generic map(n) port map(clk,next_count,count);

  process(all) begin
    case? std_logic_vector'( rst & load & done ) is
      when 3b"1--" => next_count <= (others => '0'); -- reset
      when 3b"001" => next_count <= (others => '0'); -- done
      when 3b"01-" => next_count <= input; -- load
      when others => next_count <= count-1; -- count down
    end case?;
  end process;

  done <= '1' when count = 0 else '0';
end behav_impl;


--

-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;
use std.env.all;

entity timer_tb is
end timer_tb;

architecture test of timer_tb is
  constant n: integer := 4;
  signal clk, rst, load: std_logic;
  signal input: std_logic_vector(n-1 downto 0);
  signal done1, done2: std_logic;
begin
  DUT1: entity work.Timer(struct_impl) generic map(4) port map (clk, rst, load, input, done1);
  DUT2: entity work.Timer(behav_impl) generic map(4) port map(clk, rst, load, input, done2);

  process begin
    clk <= '0'; wait for 5 ns;
    clk <= '1'; wait for 5 ns;
    assert <<signal DUT1.count: std_logic_vector>> = <<signal DUT2.count: std_logic_vector>> 
      report "state mismatch" severity failure;
  end process;

  process begin
    rst <= '1'; load <= '0'; input <= (others => '0');  wait for 10 ns; 
    rst <= '0';
    load <= '1'; input <= 4d"7"; wait for 10 ns;
    load <= '0';

    wait until done1 = '1';

    assert done2 = '1' report "done mismatch" severity failure;

    report "Test PASSED";

    stop(0);  
  end process;
end test;
-- pragma translate_on

-- next_state <= (others=>'0') when rst else state(n-2 downto 0) & sin;

