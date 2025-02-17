--------------------------------
-- Components for C Processor --
--                            --
--       (c) Keishi SAKANUSHI --
--                 2004/08/23 --	
--------------------------------


--------------------------------
-- D-FF                       --
--                            --
--       (c) Keishi SAKANUSHI --
--                 2005/08/23 --
--------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity DFlipFlop is
  port (
    d   : in  std_logic;
    clk : in  std_logic;
    rst : in  std_logic;
    q   : out std_logic;
    qb  : out std_logic
  );
end DFlipFlop;

architecture logic of DFlipFlop is
begin 
  DFlipFlop : process (clk)
  begin
    if clk'event and clk = '1' then
      if( rst = '1' ) then
        q <= '0';
      else  
        q  <= d;
        qb <= not d;
      end if;
    end if;
  end process DFlipFlop;
end logic;


--------------------------------
-- 1 bit Register             --
--                            --
--       (c) Keishi SAKANUSHI --
--                 2004/08/23 --
--    Modify Keishi SAKANUSHI --
--                 2005/08/23 --
--------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity Register01 is
  port (
    d     : in  std_logic;
    load  : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic
  );
end Register01;

architecture logic of Register01 is

signal Dtmp : std_logic;
signal Qtmp : std_logic;

component DFlipFlop
  port (
    d   : in  std_logic;
    clk : in  std_logic;
    rst : in  std_logic;
    q   : out std_logic;
    qb  : out std_logic
  );
end component;

begin 
  dff1 : DFlipFlop
  port map (
    d => Dtmp,
    clk => clock,
    rst => reset,
    q => Qtmp
  );
  Dtmp <= ( Qtmp and not load ) or ( d and load );
  q <= Qtmp;
end logic;



--------------------------------
-- 8 bit Register             --
--                            --
--       (c) Keishi SAKANUSHI --
--                 2004/08/23 --
--    Modify Keishi SAKANUSHI --
--                 2005/08/23 --
--------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity Register08 is
  port (
    d     : in  std_logic_vector(7 downto 0);
    load  : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic_vector(7 downto 0)
  );
end Register08;

architecture logic of Register08 is

signal Dtmp : std_logic_vector(7 downto 0);
signal Qtmp : std_logic_vector(7 downto 0);

component DFlipFlop
  port (
    d   : in  std_logic;
    clk : in  std_logic;
    rst : in  std_logic;
    q   : out std_logic;
    qb  : out std_logic
  );
end component;


begin 
  Generate_Registers : for i in 0 to 7 generate
  dffi : DFlipFlop
  port map (
    d => Dtmp(i),
    clk => clock,
    rst => reset,
    q => Qtmp(i)
  );
  Dtmp(i) <= (Qtmp(i) and not load) or ( d(i) and load );
  q(i) <= Qtmp(i);
  end generate Generate_Registers;
end logic;

--------------------------------
-- 16 bit Register            --
--                            --
--       (c) Keishi SAKANUSHI --
--                 2004/08/23 --
--    Modify Keishi SAKANUSHI --
--                 2005/08/23 --
--------------------------------
Library IEEE;
use IEEE.std_logic_1164.all;

entity Register16 is
  port (
    d     : in  std_logic_vector(15 downto 0);
    load  : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic_vector(15 downto 0)
  );
end Register16;

architecture logic of Register16 is
signal Dtmp : std_logic_vector(15 downto 0);
signal Qtmp : std_logic_vector(15 downto 0);

component DFlipFlop
  port (
    d   : in  std_logic;
    clk : in  std_logic;
    rst : in  std_logic;
    q   : out std_logic;
    qb  : out std_logic
  );
end component;


begin 
  Generate_Registers : for i in 0 to 15 generate
  dffi : DFlipFlop
  port map (
    d => Dtmp(i),
    clk => clock,
    rst => reset,
    q => Qtmp(i)
  );
  Dtmp(i) <= (Qtmp(i) and not load) or ( d(i) and load );
  q(i) <= Qtmp(i);
  end generate Generate_Registers;
end logic;


--------------------------------
-- 16 bit (in 2) Register     --
--                            --
--       (c) Keishi SAKANUSHI --
--                 2004/08/23 --
--------------------------------
Library IEEE;
use IEEE.std_logic_1164.all;

entity Register16in2 is
  port (
    dh    : in  std_logic_vector(7 downto 0);
    dl    : in  std_logic_vector(7 downto 0);
    loadh : in  std_logic;
    loadl : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic_vector(15 downto 0)
  );
end Register16in2;

architecture logic of Register16in2 is

component Register08
  port (
    d     : in  std_logic_vector(7 downto 0);
    load  : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic_vector(7 downto 0)
  );
end component;

begin
  RegH : Register08
  port map(
    d => dh,
    load => loadh,
    clock => clock,
    reset => reset,
    q => q(15 downto 8)
  );
  RegL : Register08
  port map(
    d => dl,
    load => loadl,
    clock => clock,
    reset => reset,
    q => q(7 downto 0)
  );
end logic;



--------------------------------
-- 8bit Multiplexer in 2      --
--                            --
--       (c) Keishi SAKANUSHI --
--                 2004/08/23 --
--------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity Mux2x08 is
  port (
    a   : in  std_logic_vector(7 downto 0); 
    b   : in  std_logic_vector(7 downto 0);
    sel : in  std_logic;
    q   : out std_logic_vector(7 downto 0)
  ); 
end Mux2x08;

architecture logic of Mux2x08 is
begin
  q <= a when sel = '0' else
       b ;
end logic;


--------------------------------
-- 8bit Multiplexer in 4      --
--                            --
--          (c) Katsuya OGATA --
--                 2024/10/21 --
--------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Mux4x08 is
  port (
    a   : in  std_logic_vector(7 downto 0); 
    b   : in  std_logic_vector(7 downto 0);
    c   : in  std_logic_vector(7 downto 0);
    d   : in  std_logic_vector(7 downto 0);
    sel : in  std_logic_vector(1 downto 0);
    q   : out std_logic_vector(7 downto 0)
  ); 
end Mux4x08;

architecture logic of Mux4x08 is
begin
  process(a, b, c, d, sel)
  begin
    case sel is
      when "00" =>
        q <= a;
      when "01" =>
        q <= b;
      when "10" =>
        q <= c;
      when "11" =>
        q <= d;
      when others =>
        q <= (others => '0');
    end case;
  end process;
end logic;


--------------------------------
-- 16bit Multiplexer in 2     --
--                            --
--       (c) Keishi SAKANUSHI --
--                 2004/08/23 --
--------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity Mux2x16 is
  port (
    a   : in  std_logic_vector(15 downto 0);
    b   : in  std_logic_vector(15 downto 0);
    sel : in  std_logic;
    q   : out std_logic_vector(15 downto 0)
  );
end Mux2x16;

architecture logic of Mux2x16 is
begin
  q <= a when sel = '0' else
       b ;
end logic;


--------------------------------
-- Full Adder                 --
--                            --
--       (c) Keishi SAKANUSHI --
--                 2004/08/23 --
--------------------------------
Library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdder is
  port (
    x     : in  std_logic;
    y     : in  std_logic;
    cin   : in  std_logic;
    s     : out std_logic;
    c     : out std_logic
  );
end FullAdder;

architecture rtl of FullAdder is
begin 
  s <= x xor y xor cin;
  c <= (x and y) or ((x or y) and cin);
end rtl;



--------------------------------
-- 8 bit Ripple Carry Adder   --
--                            --
--       (c) Keishi SAKANUSHI --
--                 2004/08/23 --
--------------------------------
Library IEEE;
use IEEE.std_logic_1164.all;

entity RCAdder08 is
  port (
    x     : in  std_logic_vector(7 downto 0);
    y     : in  std_logic_vector(7 downto 0);
    cin   : in  std_logic;
    s     : out std_logic_vector(7 downto 0);
    c     : out std_logic
  );
end RCAdder08;

architecture rtl of RCAdder08 is
component FullAdder
  port (
    x     : in  std_logic;
    y     : in  std_logic;
    cin   : in  std_logic;
    s     : out std_logic;
    c     : out std_logic
  );
end component;
signal carry : std_logic_vector(8 downto 0);
begin
  carry(0) <= cin;
  add_gen: for i in 0 to 7 generate
    adderi : FullAdder
      port map (
        x => x(i),
        y => y(i),
        cin => carry(i),
        s => s(i),
        c => carry(i+1)
      );
    end generate add_gen; 
  c <= carry(8);
end rtl;



--------------------------------
-- 16 bit Ripple Carry Adder  --
--                            --
--       (c) Keishi SAKANUSHI --
--                 2004/08/23 --
--------------------------------
Library IEEE;
use IEEE.std_logic_1164.all;

entity RCAdder16 is
  port (
    x     : in  std_logic_vector(15 downto 0);
    y     : in  std_logic_vector(15 downto 0);
    cin   : in  std_logic;
    s     : out std_logic_vector(15 downto 0);
    c     : out std_logic
  );
end RCAdder16;

architecture rtl of RCAdder16 is
component FullAdder
  port (
    x     : in  std_logic;
    y     : in  std_logic;
    cin   : in  std_logic;
    s     : out std_logic;
    c     : out std_logic
  );
end component;
signal carry : std_logic_vector(16 downto 0);
begin
  carry(0) <= cin;
  adder_generate: for i in 0 to 15 generate
    adderi : FullAdder
      port map (
        x => x(i),
        y => y(i),
        cin => carry(i),
        s => s(i),
        c => carry(i+1)
      );
    end generate adder_generate; 
  c <= carry(16);
end rtl;



--------------------------------
--                            --
-- 8 bit ALU                  --
--                            --
--       (c) Keishi SAKANUSHI --
--                 2004/08/23 --
--                            --
--------------------------------

--------------------------------

--                            --
-- mode                       --
--                            --
-- '00' : not a               --
-- '01' : a + b               --
-- '10' : a + 1               --
-- '11' : a - 1               --
--                            --
--------------------------------

-- Library IEEE;
-- use IEEE.std_logic_1164.all;

-- entity ALU08 is
--   port (
--     a       : in  std_logic_vector(7 downto 0);
--     b       : in  std_logic_vector(7 downto 0);
--     cin     : in  std_logic;
--     mode    : in  std_logic_vector(1 downto 0);
--     fout    : out std_logic_vector(7 downto 0);
--     cout    : out std_logic;
--     zout    : out std_logic
--   );
-- end ALU08;

-- architecture logic of ALU08 is
-- component RCAdder08
--   port (
--     x     : in  std_logic_vector(7 downto 0);
--     y     : in  std_logic_vector(7 downto 0);
--     cin   : in  std_logic;
--     s     : out std_logic_vector(7 downto 0);
--     c     : out std_logic
--   );
-- end component;

-- signal result       : std_logic_vector(7 downto 0);
-- signal result_adder : std_logic_vector(7 downto 0);
-- signal result_logic : std_logic_vector(7 downto 0);
-- signal inA          : std_logic_vector(7 downto 0);
-- signal inB          : std_logic_vector(7 downto 0);
-- signal cout_tmp     : std_logic;
-- signal cin_tmp      : std_logic;

-- begin

-- inA <= a;

-- inB <= b          when mode = "01"    -- (a + b)
-- 	              else 
--        "00000001" when mode = "10"    -- (a + 1)
--    		          else
--        "11111111" when mode = "11"    -- (a - 1)
--                   else
--        "00000000";
	            
-- cin_tmp <= cin;

-- adder : RCAdder08
--   port map (
--     x   => inA,
--     y   => inB,
--     cin => cin_tmp,
--     s   => result_adder,
--     c   => cout_tmp
--   );
 
-- zout <= '1' when (result = "00000000")
--             else
--         '0';

-- cout <= cout_tmp;


-- result_logic <= (not a)   when mode = "00" -- ( not a )
--                           else
--                 "00000000";


-- result <= result_adder when mode = "01" or -- (a + b)
--                             mode = "10" or -- (a + 1)
--                             mode = "11"    -- (a - 1)
--                        else
--           result_logic;
                  
-- fout <= result;
                    
-- end logic;

--------------------------------
--                            --
-- 8 bit ALU                  --
--                            --
--          (c) Katsuya OGATA --
--                 2024/10/21 --
--                            --
--------------------------------
--------------------------------
--                            --
-- mode                       --
--                            --
-- '0000' : a + b             --
-- '0001' : a - b             --
-- '0010' : a and b           --
-- '0011' : a or b            --
-- '0100' : not a             --
-- '0101' : a + 1             --
-- '0110' : a - 1             --
-- '0111' : undefined         --
-- '1000' : not b             --
-- '1001' : b + 1             --
-- '1010' : b - 1             --
-- '1011' : undefined         --
--                            --
--------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;

entity ALU08 is
  port (
    a       : in  std_logic_vector(7 downto 0);
    b       : in  std_logic_vector(7 downto 0);
    cin     : in  std_logic;
    mode    : in  std_logic_vector(3 downto 0);
    fout    : out std_logic_vector(7 downto 0);
    cout    : out std_logic;
    zout    : out std_logic
  );
end ALU08;

architecture logic of ALU08 is
component RCAdder08
  port (
    x     : in  std_logic_vector(7 downto 0);
    y     : in  std_logic_vector(7 downto 0);
    cin   : in  std_logic;
    s     : out std_logic_vector(7 downto 0);
    c     : out std_logic
  );
end component;

signal result       : std_logic_vector(7 downto 0);
signal result_adder : std_logic_vector(7 downto 0);
signal result_logic : std_logic_vector(7 downto 0);
signal inA          : std_logic_vector(7 downto 0);
signal inB          : std_logic_vector(7 downto 0);
signal cout_tmp     : std_logic;
signal cin_tmp      : std_logic;

begin

inA <= "00000000" when mode = "0111" or mode = "1011"
                      else
       "00000001" when mode = "1001"
		      else
       "11111111" when mode = "1010"
		      else
       a;
 
inB <= "00000000" when mode = "0111" or mode = "1011"
	              else 
       (not b)    when mode = "0001"
   		      else
       "00000001" when mode = "0101"
                      else
       "11111111" when mode = "0110"
		      else
       b;
	            
cin_tmp <= '1' when mode = "0001"
		else
           cin;

adder : RCAdder08
  port map (
    x   => inA,
    y   => inB,
    cin => cin_tmp,
    s   => result_adder,
    c   => cout_tmp
  );
 
zout <= '1' when (result = "00000000")
            else
        '0';

cout <= cout_tmp;


result_logic <= (not a)   when mode = "0100"
                          else
	        (not b)   when mode = "1000"
			  else
		(a and b) when mode = "0010"
			  else
		(a or b)  when mode = "0011"
			  else
                "00000000";


result <= result_logic when mode = "0100" or
			    mode = "1000" or
		            mode = "0010" or
			    mode = "0011"
			  else
	  result_adder;
                  
fout <= result;
                    
end logic;


--------------------------------
-- 16 bit Counter             --
--                            --
--       (c) Keishi SAKANUSHI --
--                 2004/08/23 --
--------------------------------
Library IEEE;
use IEEE.std_logic_1164.all;

entity Counter16 is
  port (
    clock : in  std_logic;
    load  : in  std_logic;
    d     : in  std_logic_vector(15 downto 0);
    inc   : in  std_logic;
    inc2  : in  std_logic;
    clear : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic_vector(15 downto 0)
  );
end Counter16;

architecture logic of Counter16 is
component RCAdder16
  port (
    x     : in  std_logic_vector(15 downto 0);
    y     : in  std_logic_vector(15 downto 0);
    cin   : in  std_logic;
    s     : out std_logic_vector(15 downto 0);
    c     : out std_logic
  );
end component;

component Register16
  port (
    d     : in  std_logic_vector(15 downto 0);
    load  : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic_vector(15 downto 0)
  );
end component;

signal data           : std_logic_vector(15 downto 0);
signal zero           : std_logic;
signal load_in        : std_logic;
signal add_result     : std_logic_vector(15 downto 0);
signal data_in        : std_logic_vector(15 downto 0);
signal result         : std_logic_vector(15 downto 0);
signal carry          : std_logic;

begin 
  reg : register16
    port map (
      d     => data_in,
      load  => load_in,
      clock => clock,
      reset => reset,
      q     => result
    );

  q <= result;

  data_in <= d          when load = '1' else
             add_result when inc = '1' or inc2 = '1' else
             "0000000000000000";

  load_in <= '1' when load = '1' or inc = '1' or clear = '1'
                      or inc2 = '1' else
             '0';

  adder : RCAdder16
    port map (
      x    => result,
      y    => data,
      cin  => zero,
      s    => add_result,
      c    => carry
      );

  data <= "0000000000000001" when inc = '1' else
          "0000000000000010";
  
  zero <= '0';
end logic;


--------------------------------
-- 1bit Johnson Counter       --
--      Loop S0               --
--       (c) Keishi SAKANUSHI --
--                 2004/08/23 --
--------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity Johnson1L0 is
  port (
    cond0 : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic
  );
end Johnson1L0;

architecture logic of Johnson1L0 is
component Register01
  port (
    d     : in  std_logic;
    load  : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic
  );
end component;

signal result : std_logic;
signal stop1  : std_logic;
signal one    : std_logic;

begin 
one <= '1';

stop1 <= not result and cond0;

jc1 : Register01
  port map(
  d     => stop1,
  load  => one,
  clock => clock,
  reset => reset,
  q     => result
  );

q <= result;

end logic;


--------------------------------
-- 1bit Johnson Counter       --
--      Loop S1               --
--       (c) Keishi SAKANUSHI --
--                 2004/08/23 --
--------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity Johnson1L1 is
  port (
    cond1 : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic
  );
end Johnson1L1;

architecture logic of Johnson1L1 is
component Register01
  port (
    d     : in  std_logic;
    load  : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic
  );
end component;

signal result : std_logic;
signal stop1  : std_logic;
signal one    : std_logic;

begin
one <= '1';
stop1 <= (result and not cond1) or not result ;

jc1 : Register01
  port map(
  d     => stop1,
  load  => one,
  clock => clock,
  reset => reset,
  q     => result
  );

q <= result;

end logic;



--------------------------------
-- 1bit Johnson Counter       --
--      Loop S0 S1            --
--       (c) Keishi SAKANUSHI --
--                 2004/08/23 --
--------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity Johnson1L01 is
  port (
    cond0 : in  std_logic;
    cond1 : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic
  );
end Johnson1L01;

architecture logic of Johnson1L01 is
component Register01
  port (
    d     : in  std_logic;
    load  : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic
  );
end component;

signal result : std_logic;
signal stop1  : std_logic;
signal one    : std_logic;

begin

one <= '1';
jc1 : Register01
  port map(
  d     => stop1,
  load  => one,
  clock => clock,
  reset => reset,
  q     => result
  );

q <= result;

stop1 <= (not result and cond0) or ( result and not cond1);

end logic;



--------------------------------
-- 2bit Johnson Counter       --
--      Loop S0               --
--       (c) Keishi SAKANUSHI --
--                 2004/08/23 --
--------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity Johnson2L0 is
  port (
    cond0 : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic_vector(1 downto 0)
  );
end Johnson2L0;

architecture logic of Johnson2L0 is
component Register01
  port (
    d     : in  std_logic;
    load  : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic
  );
end component;

signal result : std_logic_vector(1 downto 0);
signal stop1  : std_logic;
signal one    : std_logic;

begin
one <= '1';

jc1 : Register01
  port map(
  d     => stop1,
  load  => one,
  clock => clock,
  reset => reset,
  q     => result(0)
  );

jc2 : Register01
  port map(
  d     => result(0),
  load  => one,
  clock => clock,
  reset => reset,
  q     => result(1)
  );

q <= result;

stop1 <= not result(1) and ( result(0) or cond0);

end logic;



--------------------------------
-- 3bit Johnson Counter       --
--      Loop S0               --
--       (c) Keishi SAKANUSHI --
--                 2004/08/23 --
--------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity Johnson3L0 is
  port (
    cond0 : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic_vector(2 downto 0)
  );
end Johnson3L0;

architecture logic of Johnson3L0 is
component Register01
  port (
    d     : in  std_logic;
    load  : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic
      );
end component;

signal result : std_logic_vector(2 downto 0);
signal stop1  : std_logic;
signal one    : std_logic;

begin

one <= '1';
stop1 <= ( result(0) or cond0 ) and not result(2) ;

jc1 : Register01
  port map(
  d     => stop1,
  load  => one,
  clock => clock,
  reset => reset,
  q     => result(0)
  );

jc2 : Register01
  port map(
  d     => result(0),
  load  => one,
  clock => clock,
  reset => reset,
  q     => result(1)
  );

jc3 : Register01
  port map(
  d     => result(1),
  load  => one,
  clock => clock,
  reset => reset,
  q     => result(2)
  );
q <= result;

end logic;

--------------------------------
-- 1bit Multiplexer in 2      --
--                            --
--          (c) Katsuya OGATA --
--                 2025/01/20 --
--------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Mux2x01 is
  port (
    a   : in  std_logic; 
    b   : in  std_logic;
    sel : in  std_logic;
    q   : out std_logic
  ); 
end Mux2x01;

architecture logic of Mux2x01 is
begin
  q <=  a when sel = '0' else
        b ;
end logic;

--------------------------------
-- 1bit Shifter               --
--                            --
--          (c) Katsuya OGATA --
--                 2025/01/20 --
--------------------------------

--------------------------------
--                            --
-- mode                       --
--                            --
-- '00' : LL                  --
-- '01' : RL                  --
-- '10' : LA                  --
-- '11' : RA                  --
--                            --
--------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity Shifter1 is
  port (
    a     : in  std_logic_vector(7 downto 0);
    mode  : in  std_logic_vector(1 downto 0);
    fout  : out std_logic_vector(7 downto 0);
    cout  : out std_logic
  );
end Shifter1;

architecture logic of Shifter1 is
begin

fout <= a(6 downto 0) & '0'         when mode = "00" -- SLL
                                    else
        '0' & a(7 downto 1)         when mode = "01" -- SRL
                                    else
        a(7) & a(5 downto 0) & '0'  when mode = "10" -- SLA
                                    else
        a(7) & a(7) & a(6 downto 1) when mode = "11" -- SRA
                                    else
        "XXXXXXXX";

cout <= a(7)  when mode = "00"    -- SLL
              else
        a(0)  when mode = "01" or mode = "11"    -- SRA or SRL
              else
        a(6)  when mode = "10"    -- SLA
              else
        'X';

end logic;

--------------------------------
-- 2bit Shifter               --
--                            --
--          (c) Katsuya OGATA --
--                 2025/01/20 --
--------------------------------

--------------------------------
--                            --
-- mode                       --
--                            --
-- '00' : LL                  --
-- '01' : RL                  --
-- '10' : LA                  --
-- '11' : RA                  --
--                            --
--------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity Shifter2 is
  port (
    a     : in  std_logic_vector(7 downto 0);
    mode  : in  std_logic_vector(1 downto 0);
    fout  : out std_logic_vector(7 downto 0);
    cout  : out std_logic
  );
end Shifter2;

architecture logic of Shifter2 is
begin

fout <= a(5 downto 0) & "00"                when mode = "00" -- SLL
                                            else
        "00" & a(7 downto 2)                when mode = "01" -- SRL
                                            else
        a(7) & a(4 downto 0) & "00"         when mode = "10" -- SLA
                                            else
        a(7) & a(7) & a(7) & a(6 downto 2)  when mode = "11" -- SRA
                                            else
        "XXXXXXXX";

cout <= a(6)  when mode = "00"    -- SLL
              else
        a(1)  when mode = "01" or mode = "11"    -- SRA or SRL
              else
        a(5)  when mode = "10"    -- SLA
              else
        'X';

end logic;


--------------------------------
-- 4bit Shifter               --
--                            --
--          (c) Katsuya OGATA --
--                 2025/01/20 --
--------------------------------

--------------------------------
--                            --
-- mode                       --
--                            --
-- '00' : LL                  --
-- '01' : RL                  --
-- '10' : LA                  --
-- '11' : RA                  --
--                            --
--------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity Shifter4 is
  port (
    a     : in  std_logic_vector(7 downto 0);
    mode  : in  std_logic_vector(1 downto 0);
    fout  : out std_logic_vector(7 downto 0);
    cout  : out std_logic
  );
end Shifter4;

architecture logic of Shifter4 is
begin

fout <= a(3 downto 0) & "0000"                            when mode = "00" -- SLL
                                                          else
        "0000" & a(7 downto 4)                            when mode = "01" -- SRL
                                                          else
        a(7) & a(2 downto 0) & "0000"                     when mode = "10" -- SLA
                                                          else
        a(7) & a(7) & a(7) & a(7) & a(7) & a(6 downto 4)  when mode = "11" -- SRA
                                                          else
        "XXXXXXXX";

cout <= a(4)  when mode = "00"    -- SLL
              else
        a(3)  when mode = "01" or mode = "11"    -- SRA or SRL
              else
        a(3)  when mode = "10"    -- SLA
              else
        'X';

end logic;


--------------------------------
-- 8bit Barrel Shifter        --
--                            --
--          (c) Katsuya OGATA --
--                 2025/01/20 --
--------------------------------

--------------------------------
--                            --
-- mode                       --
--                            --
-- '00' : LL                  --
-- '01' : RL                  --
-- '10' : LA                  --
-- '11' : RA                  --
--                            --
--------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity Shifter is
  port (
    a     : in  std_logic_vector(7 downto 0);
    b     : in  std_logic_vector(7 downto 0);
    mode  : in  std_logic_vector(1 downto 0);
    fout  : out std_logic_vector(7 downto 0);
    cout  : out std_logic;
    zout  : out std_logic
  );
end Shifter;

architecture logic of Shifter is
component Shifter1
  port (
    a     : in  std_logic_vector(7 downto 0);
    mode  : in  std_logic_vector(1 downto 0);
    fout  : out std_logic_vector(7 downto 0);
    cout  : out std_logic
  );
end component;

component Shifter2
  port (
    a     : in  std_logic_vector(7 downto 0);
    mode  : in  std_logic_vector(1 downto 0);
    fout  : out std_logic_vector(7 downto 0);
    cout  : out std_logic
  );
end component;

component Shifter4
  port (
    a     : in  std_logic_vector(7 downto 0);
    mode  : in  std_logic_vector(1 downto 0);
    fout  : out std_logic_vector(7 downto 0);
    cout  : out std_logic
  );
end component;

signal shift_stage1     : std_logic_vector(7 downto 0);
signal unshift_stage1   : std_logic_vector(7 downto 0);
signal shift_stage2     : std_logic_vector(7 downto 0);
signal unshift_stage2   : std_logic_vector(7 downto 0);
signal shift_stage4     : std_logic_vector(7 downto 0);
signal unshift_stage4   : std_logic_vector(7 downto 0);
signal temp_result1     : std_logic_vector(7 downto 0);
signal temp_result2     : std_logic_vector(7 downto 0);
signal final_result     : std_logic_vector(7 downto 0);
signal carry_stage1     : std_logic;
signal carry_stage2     : std_logic;
signal carry_stage4     : std_logic;

begin
unshift_stage1 <= a;

sft1 : Shifter1
  port map (
    a    => a,
    mode => mode,
    fout => shift_stage1,
    cout => carry_stage1
  );

temp_result1 <= shift_stage1    when b(0) = '1'
                                else
                unshift_stage1  when b(0) = '0'
                                else
                "XXXXXXXX";

unshift_stage2 <= temp_result1;

sft2 : Shifter2
  port map (
    a    => temp_result1,
    mode => mode,
    fout => shift_stage2,
    cout => carry_stage2
  );

temp_result2 <= shift_stage2      when b(1) = '1'
                                  else
                unshift_stage2    when b(1) = '0'
                                  else
                "XXXXXXXX";

unshift_stage4 <= temp_result2;

sft4 : Shifter4
  port map (
    a    => temp_result2,
    mode => mode,
    fout => shift_stage4,
    cout => carry_stage4
  );

final_result <= shift_stage4      when b(2) = '1'
                                  else
                unshift_stage4    when b(2) = '0'
                                  else
                "XXXXXXXX";

fout <= final_result;

zout <= '1' when (final_result = "00000000")
            else
        '0';

cout <= carry_stage4 when b(2) = '1'
                    else
        carry_stage2 when b(2) = '0' and b(1) = '1'
                    else
        carry_stage1 when b(2) = '0' and b(1) = '0' and b(0) = '1'
                    else
        '0';

end logic;