library ieee;
use ieee.std_logic_1164.all;

entity AND_GATE is
    port ( a, b : in std_logic; c : out std_logic );
  end AND_GATE;

architecture impl of AND_GATE is
begin
    c <= a and b;
  end impl;
  ----------------------------------------------------------------------------
  library ieee;
  use ieee.std_logic_1164.all;

entity NOT_GATE is
    port ( x : in std_logic; y : out std_logic );
  end NOT_GATE;

architecture impl of NOT_GATE is
begin
    y <= not x;
  end impl;
  ----------------------------------------------------------------------------
  library ieee;
  use ieee.std_logic_1164.all;

entity NAND_GATE is
    port ( a, in2: in std_logic; output : out std_logic );
  end NAND_GATE;

architecture impl of NAND_GATE is
    component AND_GATE is
          port ( a, b : in std_logic; c : out std_logic );
            end component;
            component NOT_GATE is
                  port ( x : in std_logic; y : out std_logic );
                    end component;
                    signal w: std_logic;
                begin
                    U1: NOT_GATE port map( w, output );
                      U2: AND_GATE port map( c => w, a => a, b => in2 );
                  end impl;

library ieee;
use ieee.std_logic_1164.all;

entity MagComp is
    generic( k: integer := 8 );
      port( a, b: in std_logic_vector(k-1 downto 0); gt: out std_logic );
  end MagComp;

architecture impl of MagComp is
begin
    gt <= '1' when a > b else '0';
  end impl;
  ----------------------------------------------------------------------------
  library ieee;
  use ieee.std_logic_1164.all;

entity SORTER is
    port ( in1, in2: in std_logic_vector(15 downto 0); 
             larger, smaller : out std_logic_vector(15 downto 0) );
  end SORTER;

architecture impl of SORTER is
    component MagComp is
          generic( k: integer := 8 );
              port( a, b: in std_logic_vector(k-1 downto 0); gt: out std_logic );
            end component;

            signal in1_gt_in2: std_logic;
        begin
            CMP: MagComp generic map(16) port map( a => in1, b => in2, gt => in1_gt_in2 );

              with in1_gt_in2 select 
                    larger <= in1 when '1', 
                                            in2 when others; 

                with in1_gt_in2 select 
                      smaller <= in2 when '1', 
                                                in1 when others;
              end impl;

--

library ieee;
use ieee.std_logic_1164.all;

entity example is
  port( clk, w: in std_logic;
        x: buffer std_logic;
        y, z: out std_logic );
end example;

architecture impl of example is
begin
  process(clk)
    variable tmp: std_logic;
  begin
    if clk = '1' then
      tmp := w;
      x <= tmp;
      y <= x; 
      z <= not w; 
    end if;
  end process;
end impl;



library ieee;
use ieee.std_logic_1164.all;

entity tb_example is
end tb_example;

architecture impl of tb_example is
  signal w, x, y, z, clk: std_logic;
begin
  DUT: entity work.example port map(clk,w,x,y,z);

  process begin
    clk <= '0'; wait for 5 ns;
    clk <= '1'; wait for 5 ns;
  end process;

  process begin
    w <= '0'; wait for 20 ns;
    w <= '1'; wait for 20 ns;
    w <= '0'; wait for 10 ns;
    w <= '1'; wait for 10 ns;
    w <= '0'; wait;
  end process;
end impl;

--

library ieee;
use ieee.std_logic_1164.all;

entity tri_state_buffer is
    port ( a, e : in std_logic; 
           x : out std_logic );
end tri_state_buffer;

architecture impl of tri_state_buffer is
begin
    x <= a when e else 'Z';
end impl;

--

library ieee;
use ieee.std_logic_1164.all;

entity Mux3b is
  generic( k : integer := 1 );
  port( a2, a1, a0 : in std_logic_vector( k-1 downto 0 );
        s : in std_logic_vector( 1 downto 0 );
        b : out std_logic_vector( k-1 downto 0 ) );
end Mux3b;

architecture tri_impl of Mux3b is
begin
  b <= a2 when s = 2d"2" else (others => 'Z');
  b <= a1 when s = 2d"1" else (others => 'Z');
  b <= a0 when s = 2d"0" else (others => 'Z');
end tri_impl;

--

library ieee;
use ieee.std_logic_1164.all;

entity Mux2b is
  port( a1, a0 : in std_logic;
        s : in std_logic;
        b : out std_logic );
end Mux2b;

architecture tri_impl of Mux2b is
begin
  b <= a1 when s = '1' else 'Z';
  b <= a0 when s = '0' else 'Z';
end tri_impl;


library ieee;
use ieee.std_logic_1164.all;

entity example2 is
  port( clk, x : in std_logic; y: out std_logic );
end example2;
  
architecture impl of example2 is
  signal state, state_next : std_logic_vector(1 downto 0);
begin
  process(clk) begin
    if clk = '1' then
	    state <= state_next;
	 end if;
  end process;
  
  process(all)
  begin
    case? state & x is
      when "000"  => state_next <= "01"; y <= '0';
      when "01-"  => state_next <= "10"; y <= '1';
      when "100"  => state_next <= "10";
      when others => state_next <= "00"; y <= '0';
    end case?;  
  end process;
end impl;


library ieee;
use ieee.std_logic_1164.all;

entity case_example is
 port( A: in std_logic_vector(2 downto 0); B: out std_logic );
end case_example;

architecture impl of case_example is
begin
  process(all)
  begin
    case? A is
      when "000"         => B <= '1';
      when "001"         => B <= '0';
      when "01-"         => B <= '1';
      when "110" | "111" => B <= '1';
      when others        => B <= '0';
    end case?;
  end process;
end impl;
