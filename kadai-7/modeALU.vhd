
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
--                            --
-- 8 bit ALU                  --
--                            --
--       (c) Keishi SAKANUSHI --
--                 2004/08/23 --
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