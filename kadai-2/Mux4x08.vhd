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
