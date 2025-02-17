--------------------------------
--  DataPath of C Processor   --
--                            --
--       (c) Keishi SAKANUSHI --
--------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity TestMux is
end TestMux;

architecture behavior of TestMux is
  constant STEP : Time := 100 ns;

  signal In_A     : std_logic_vector(7 downto 0);
  signal In_B     : std_logic_vector(7 downto 0);
  signal In_C     : std_logic_vector(7 downto 0);
  signal In_D     : std_logic_vector(7 downto 0);
  signal Sel      : std_logic_vector(1 downto 0);
  signal Q        : std_logic_vector(7 downto 0);

  component Mux4x08
    port (
      a   : in  std_logic_vector(7 downto 0); 
      b   : in  std_logic_vector(7 downto 0);
      c   : in  std_logic_vector(7 downto 0);
      d   : in  std_logic_vector(7 downto 0);
      sel : in  std_logic_vector(1 downto 0);
      q   : out std_logic_vector(7 downto 0)
    ); 
  end component;

begin
  Selector: Mux4x08 
  port map(
    a => In_A,
    b => In_B,
    c => In_C,
    d => In_D,
    sel => Sel,
    q => Q
  );
  
  In_A <= "11000000";
  In_B <= "00110000";
  In_C <= "00001100";
  In_D <= "00000011";
  
  process
    begin
      Sel <= "00";
      wait for STEP;
      Sel <= "01";
      wait for STEP;
      Sel <= "10";
      wait for STEP;
      Sel <= "11";
      wait for STEP;
    wait;
  end process;
end behavior;