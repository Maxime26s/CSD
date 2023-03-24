--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ff.all;

entity Good_Counter is
  generic( n: integer := 4 );
  port( clk, rst: in std_logic; 
        output: buffer std_logic_vector(n-1 downto 0) );
end Good_Counter;

architecture impl of Good_Counter is
  signal nxt: std_logic_vector(n-1 downto 0);
begin
  nxt <= (others=>'0') when rst else output+1;
  count: vDFF generic map(n) port map(clk, nxt, output);
end impl;

--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ff.all;

entity Bad_Counter is
  generic( n: integer := 4 );
  port( clk, rst: in std_logic; 
        output: buffer std_logic_vector(n-1 downto 0) );
end Bad_Counter;

architecture impl of Bad_Counter is
  signal nxt: std_logic_vector(n-1 downto 0);
begin
  process(clk) begin
    if rising_edge(clk) then
      if rst then
        output <= (others => '0');
      else 
        output <= output + 1;
      end if;
    end if;
  end process;
end impl;

--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity popcount is
  port( x: in std_logic_vector(3 downto 0);
        number_of_ones: out std_logic_vector(2 downto 0) );
end popcount;

architecture impl of popcount is
begin
  number_of_ones <= ("00" & x(0)) + ("00" & x(1)) + ("00" & x(2)) + ("00" & x(3));
end impl;

--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity tb_popcount is
end tb_popcount;

architecture test of tb_popcount is
  signal x: std_logic_vector(3 downto 0);
  signal num: std_logic_vector(2 downto 0);
begin
  DUT: entity work.popcount port map(x,num);

  process begin
    for i in 0 to 15 loop
      x <= conv_std_logic_vector(i,4);
      wait for 1 ns;
    end loop;
  end process;
end test;

--

library ieee;
use ieee.std_logic_1164.all;

package hybrid_style_ex is
  subtype op_t is std_logic_vector(2 downto 0);
  constant OP_ADD: op_t := "001";
  constant OP_XOR: op_t := "010";
  constant OP_AND: op_t := "011";
  constant OP_OR:  op_t := "100";
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.hybrid_style_ex.all;

entity hybrid_style is
  port( opcode: in op_t;
        data: in std_logic_vector(7 downto 0);
        acc: in std_logic_vector(7 downto 0);
        nxt: out std_logic_vector(7 downto 0) );
end hybrid_style;

architecture impl of hybrid_style is
begin
  process(all) begin
    case opcode is
      when OP_ADD => nxt <= acc + data;
      when OP_XOR => nxt <= acc xor data;
      when OP_AND => nxt <= acc and data;
      when OP_OR  => nxt <= acc or data;
      when others => nxt <= 8d"0";
    end case;
  end process;
end impl;

library ieee;
use ieee.std_logic_1164.all;
use work.hybrid_style_ex.all;

entity tb_hybrid_style is
end tb_hybrid_style;

architecture test of tb_hybrid_style is
  signal opcode:  op_t;
  signal data:  std_logic_vector(7 downto 0);
  signal acc:  std_logic_vector(7 downto 0);
  signal nxt: std_logic_vector(7 downto 0);
begin
  DUT: entity work.hybrid_style(impl) port map(opcode,data,acc,nxt);

  process begin
    acc <= 8x"11";
    data <= 8x"03";
    opcode <= OP_ADD; wait for 1 ns; -- x14
    opcode <= OP_XOR; wait for 1 ns; -- x12
    opcode <= OP_AND; wait for 1 ns; -- x01
    opcode <= OP_OR; wait for 1 ns;  -- x13
  end process;
end test;

---

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ff.all;

entity ccase_style is
  port( clk, rst, load, shl, inc: in std_logic;
        input: in std_logic_vector(7 downto 0);
        state: buffer std_logic_vector(7 downto 0) );
end ccase_style;

architecture impl of ccase_style is
  signal nxt: std_logic_vector(7 downto 0);
begin
  process(all) begin
    case? std_logic_vector'((0=>rst)) & load & shl & inc is
      when "1---" => nxt <= 8b"0";
      when "01--" => nxt <= input;
      when "001-" => nxt <= state(6 downto 0) & '0';
      when "0001" => nxt <= state + 1;
      when others => nxt <= state;
    end case?;
  end process;

  state_reg: vDFF generic map(8) port map(clk,nxt,state);
end impl;

---

library ieee;
use ieee.std_logic_1164.all;

entity bad_if is
  port( rst: in std_logic; 
        output: out std_logic_vector(7 downto 0) );
end bad_if;

architecture impl of bad_if is
  signal nxt: std_logic_vector(7 downto 0);
begin
  process(all) begin
    if rst then 
      nxt <= 8d"0";
    end if;
  end process;

  output <= nxt;
end impl;


---

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ff.all;

entity good_if is
  port( clk, rst: in std_logic; 
        output: buffer std_logic_vector(7 downto 0) );
end good_if;

architecture impl of good_if is
  signal nxt: std_logic_vector(7 downto 0);
begin
  process(all) begin
    if rst then 
      nxt <= 8d"0";
    else 
      nxt <= output+1;
    end if;
  end process;

  reg: vDFF generic map(8) port map(clk,nxt,output);
end impl;

---

library ieee;
use ieee.std_logic_1164.all;

package bad_var_dec is
  constant n: integer := 3;
  subtype s_type is std_logic_vector(n-1 downto 0);
  constant FETCH_STATE: s_type := "001";
  constant DECODE_STATE: s_type := "010";
  constant REG_READ_STATE: s_type := "011";

  constant m: integer := 4;
  subtype o_type is std_logic_vector(m-1 downto 0);

  constant FETCH_OUT: o_type := "0001";
  constant DECODE_ZERO: o_type := "0010";
  constant RR_OUT: o_type := "1010";
end bad_var_dec;


library ieee;
use ieee.std_logic_1164.all;
use work.bad_var_dec.all;
use work.ff.all;

entity bad_var is
  port( clk, rst: in std_logic; 
        input: in std_logic_vector(1 downto 0);
        output: out o_type );
end bad_var;

architecture impl of bad_var is
  signal state, next_state: std_logic_vector(n-1 downto 0);
  signal next_state_rst: std_logic_vector(n-1 downto 0);
begin
  process(all) begin
    case? input & state is
      when "--" & FETCH_STATE =>
        output <= FETCH_OUT;
        next_state <= DECODE_STATE;
      when "1-" & DECODE_STATE =>
        next_state <= REG_READ_STATE;
      when "0-" & DECODE_STATE =>
        output <= DECODE_ZERO;
        next_state <= REG_READ_STATE;
      when others =>
        output <= (others => '-');
        next_state <= (others => '-');
    end case?;
  end process;
  next_state_rst <= FETCH_STATE when rst else next_state;

  sr: vDFF generic map(n) port map(clk,next_state_rst,state);
end impl;

---

library ieee;
use ieee.std_logic_1164.all;
use work.bad_var_dec.all;
use work.ff.all;

entity good_var is
  port( clk, rst: in std_logic; 
        input: in std_logic_vector(1 downto 0);
        output: out o_type );
end good_var;

architecture impl of good_var is
  signal state, next_state: std_logic_vector(n-1 downto 0);

  type fsm_t is record
    outp: std_logic_vector(m-1 downto 0);
    nxts: std_logic_vector(n-1 downto 0);
  end record;

  signal fsmo: fsm_t;
begin
  process(all) begin
    case? input & state is
      when "--" & FETCH_STATE =>  fsmo <= (FETCH_OUT, DECODE_STATE);
      when "1-" & DECODE_STATE => fsmo <= (RR_OUT, REG_READ_STATE);
      when "0-" & DECODE_STATE => fsmo <= (DECODE_ZERO, REG_READ_STATE);
      when others => fsmo <= ((others => '-'),(others => '-'));
    end case?;
  end process;

  next_state <= FETCH_STATE when rst else fsmo.nxts;
  output <= fsmo.outp;

  sr: vDFF generic map(n) port map(clk,next_state,state);
end impl;

---

--library ieee;
--use ieee.std_logic_1164.all;
--
--package isa_decl is
--
--  type r_type_instruction is record
--      opcode, fun: std_logic_vector(5 downto 0);
--      rega, regb, regc, sa: std_logic_vector(4 downto 0);
--    end record;
--
--  type i_type_instruction is record
--      opcode: std_logic_vector(5 downto 0);
--      rega, regb: std_logic_vector(4 downto 0);
--      immediate: std_logic_vector(15 downto 0);
--    end record;
--
--  type j_type_instruction is record
--      opcode: std_logic_vector(5 downto 0);
--      jump_target: std_logic_vector(25 downto 0);
--    end record;
--
--  type inst_type is  (r_type, i_type, j_type);
--end isa_decl;
--
--library ieee;
--use ieee.std_logic_1164.all;
--
--entity decoder is
--  port( instruction: in std_logic_vector( 31 downto 0 );
--        predecoded: in inst_type;
--        opcode, fun: out std_logic_vector(5 downto 0);
--        rega, regb, regc, sa: out std_logic_vector(4 downto 0);
--        immediate: out std_logic_vector(15 downto 0);
--        jump_target: out std_logic_vector(25 downto 0) );
--end decoder;
--
--architecture impl of decoder is
--begin
--  process(all) 
--          variable r: r_type_instruction;
--  begin
--    case predecoded is 
--      when r_type => r <= 
--
--  end process;
--
----wire [5:0] opcode, fun ;
----wire [4:0] rega, regb, regc, sa ;
----wire [15:0] immediate ;
----wire [25:0] jump_target ;
----
----assign {opcode, rega, regb, regc, sa, fun} = instruction ;
----assign {opcode, rega, regb, immediate} = instruction ;
----assign {opcode, jump_target} = instruction ;


--casex({opcode,fun})
--  {6'h0,6'h20}: aluop = 3'h5 ;
--  {6'h0,6'h21}: aluop = 3'h6 ;
--  ...
--  {6'h23,6'hxx}: aluop = 3'h5 ;
--  ...
--endcase

library ieee;
use ieee.std_logic_1164.all;

entity bad_constant is
  port( opcode, fun: in std_logic_vector(5 downto 0);
        aluop: out std_logic_vector(2 downto 0) );
end bad_constant;

architecture impl of bad_constant is
begin
  process(all) begin
    case? opcode & fun is
      when 6x"0" & 6x"20" => aluop <= 3x"5";
      when 6x"0" & 6x"21" => aluop <= 3x"6";
      when 6x"23" & "------" => aluop <= 3x"5";
      when others => aluop <= 3x"0";
    end case?;
  end process;
end impl;


--casex({opcode,fun})
--  {`RTYPE_OPC,`ADD_FUN}: aluop = `ADD_OP ;
--  {`RTYPE_OPC,`SUB_FUN}: aluop = `SUB_OP ;
--  ...
--  {`LW_OPC,6'hxx}: aluop = `ADD_OP ;
--  ...
--endcase


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity good_constant is
  port( opcode, fun: in std_logic_vector(5 downto 0);
        aluop: out std_logic_vector(2 downto 0) );
end good_constant;

architecture impl of good_constant is
  constant RTYPE_OPC: std_logic_vector(5 downto 0) := 6x"0";
  constant LW_OPC: std_logic_vector(5 downto 0) := 6x"23";
  constant ADD_FUN: std_logic_vector(5 downto 0) := 6x"20";
  constant SUB_FUN: std_logic_vector(5 downto 0) := 6x"21";
  constant ADD_OP: std_logic_vector(2 downto 0) := 3x"5";
  constant SUB_OP: std_logic_vector(2 downto 0) := 3x"5";
  signal a, b, c: std_logic_vector(1 downto 0);
begin
  process(all) begin
    case? opcode & fun is
      when RTYPE_OPC & ADD_FUN  => aluop <= ADD_OP;
      when RTYPE_OPC & SUB_FUN  => aluop <= SUB_OP;
      when LW_OPC    & "------" => aluop <= ADD_OP;
      when others => aluop <= 3x"0";
    end case?;
  end process;

  process(all) begin
    case aluop is
      when ADD_OP => c <= a + b ; -- add a and b
      when others => c <= "00";
    end case;
  end process;
end impl;
