--------------------------------
--  Subset of C Processor     --
--                            -- -- edit
--       (c) Keishi SAKANUSHI --
--------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity Controler is
    port (
    selMuxDIn : out std_logic_vector(1 downto 0);

    loadhMB   : out std_logic;
    loadlMB   : out std_logic;
    loadhIX   : out std_logic;
    loadlIX   : out std_logic;

    loadIR    : out std_logic;
    IRout     : in  std_logic_vector (7 downto 0);

    loadIP    : out std_logic;
    incIP     : out std_logic;
    inc2IP    : out std_logic;
    clearIP   : out std_logic;

    selMuxAddr: out std_logic;
    selMuxDOut: out  std_logic_vector (1 downto 0);
    ZeroF     : in  std_logic;
    CarryF    : in  std_logic;

    loadRegC  : out std_logic;
    loadRegB  : out std_logic;
    loadRegA  : out std_logic;

    modeALU   : out std_logic_vector (3 downto 0);
    loadFZ    : out std_logic;
    loadFC    : out std_logic;

    read      : out std_logic;
    write     : out std_logic;

    clock     : in  std_logic;
    reset     : in  std_logic;

    modeShift : out std_logic_vector (1 downto 0);
    selMuxCOut: out std_logic;
    selMuxZOut: out std_logic
  );
end Controler;

architecture logic of Controler is

component Johnson1L0 
  port (
    cond0 : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic
  );
end component;

component Johnson1L1 
  port (
    cond1 : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic
  );
end component;

component Johnson1L01 
  port (
    cond0 : in  std_logic;
    cond1 : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic
  );
end component;

component Johnson2L0 
  port (
    cond0 : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic_vector(1 downto 0)
  );
end component;

component Johnson3L0 
  port (
    cond0 : in  std_logic;
    clock : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic_vector(2 downto 0)
  );
end component;

--------------------------------
--  
--  Signals from/ot Johnson Counters for External Signals
--  
--------------------------------
signal qJCextA : std_logic;
signal qJCextB : std_logic;
signal qJCextC : std_logic_vector(1 downto 0);
signal qJCextD : std_logic_vector(1 downto 0);
signal qJCextE : std_logic_vector(2 downto 0);

signal cJCextA : std_logic;
signal cJCextB : std_logic;
signal cJCextC : std_logic;
signal cJCextD : std_logic;
signal cJCextE : std_logic;

signal cs1     : std_logic;
signal cs2     : std_logic;

--------------------------------
--  
--  Signals from/ot Johnson Counters for internal Signals
--  
--------------------------------
signal qJCintA : std_logic;
signal qJCintB : std_logic_vector(1 downto 0);
signal qJCintC : std_logic_vector(1 downto 0);
signal qJCintD : std_logic;
signal qJCintE : std_logic_vector(1 downto 0);
signal qJCintF : std_logic_vector(2 downto 0);

signal cact    : std_logic;
signal cJCintB : std_logic;
signal cJCintC : std_logic;
signal cJCintD : std_logic;
signal cJCintE : std_logic;
signal cJCintF : std_logic;
signal chalt   : std_logic;


--------------------------------

signal one     : std_logic;

begin    -- logic
one <= '1';

--------------------------------
--  
--  Johnson Counters for External Signals
--  
--------------------------------

----------------
--   JCextA   --
----------------
JCextA : Johnson1L01
  port map(
    cond0 => cJCextA,
    cond1 => cs1,
    clock => clock,
    reset => reset,
    q     => qJCextA
  );

----------------
--   JCextB   --
----------------
JCextB : Johnson1L01
  port map(
    cond0 => cJCextB,
    cond1 => cs2,
    clock => clock,
    reset => reset,
    q     => qJCextB
  );

----------------
--   JCextC   --
----------------
JCextC : Johnson2L0
  port map(
    cond0  => cJCextC,
    clock => clock,
    reset => reset,
    q     => qJCextC
  );

---------------- 
--   JCextD   --
----------------
JCextD : Johnson2L0
  port map(
    cond0  => cJCextD,
    clock => clock,
    reset => reset,
    q     => qJCextD
  );

----------------
--   JCextE   --
----------------
JCextE : Johnson3L0
  port map(
    cond0  => cJCextE,
    clock => clock,
    reset => reset,
    q     => qJCextE
  );


--------------------------------
--  
--  Decode logic for External Signals
--  
--------------------------------
selMuxDOut <= "01" when qJCextD = "01" else
              "01" when qJCextD = "11" else
              "01" when qJCextD = "10" else
              "10" when qJCextE = "100" else
              "10" when qJCextE = "110" else
              "10" when qJCextE = "111" else
              "00";

selMuxAddr <= '1' when qJCextB = '1'  else
              '1' when qJCextC = "01" else
              '1' when qJCextC = "11" else
              '1' when qJCextC = "10" else
              '1' when qJCextD = "01" else
              '1' when qJCextD = "11" else
              '1' when qJCextD = "10" else
              '1' when qJCextE = "100" else
              '1' when qJCextE = "110" else
              '1' when qJCextE = "111" else
              '0';

read  <= '0' when qJCextA = '1' else
        '0' when qJCextB = '1' else
        '0' when qJCextE = "001" else
        '0' when qJCextE = "011" else
        '1';

write <= '0' when qJCextC = "11" else
          '0' when qJCextD = "11" else
          '0' when qJCextE = "110" else 
        '1';


--------------------------------
--  
--  Johnson Counters for Internal Signals
--  
--------------------------------
----------------
--   JCintA   --
----------------
JCintA : Johnson1L1
  port map(
    cond1 => cact,
    clock => clock,
    reset => reset,
    q     => qJCintA
  );


----------------
--   JCintB   --
----------------
JCintB : Johnson2L0
  port map(
    cond0 => cJCintB,
    clock => clock,
    reset => reset,
    q     => qJCintB
  );


----------------
--   JCintC   --
----------------
JCintC : Johnson2L0
  port map(
    cond0 => cJCintC,
    clock => clock,
    reset => reset,
    q     => qJCintC
  );


----------------
--   JCintD   --
----------------
JCintD : Johnson1L0
  port map(
    cond0 => cJCintD,
    clock => clock,
    reset => reset,
    q     => qJCintD
  );


----------------
--   JCintE   --
----------------
JCintE : Johnson2L0
  port map(
    cond0 => cJCintE,
    clock => clock,
    reset => reset,
    q     => qJCintE
  );


----------------
--   JCintF   --
----------------
JCintF : Johnson3L0
  port map(
    cond0  => cJCintF,
    clock => clock,
    reset => reset,
    q     => qJCintF
  );


-- 外部出力脱出信号
--------------------------------
--  
--  Decode Logic for Control Signals
--   of Johnson Counters for External
--  
--------------------------------

cJCextA <= '1' when qJCintA = '0' else
           '1' when (qJCintB = "10" and irout(7 downto 4) = "1101") else -- SETIXH SETIXL LDIA LDIB
           '1' when (qJCintB = "10" and irout(7 downto 4) = "0110") else -- JP
           '1' when (qJCintB = "10" and irout(7 downto 4) = "0101" and ZeroF = '1') else -- JPZ(Z=1)
           '1' when (qJCintB = "10" and irout(7 downto 4) = "0100" and CarryF = '1') else -- JPC(C=1)
           '1' when (qJCintB = "10" and irout(7 downto 2) = "011100") else -- shift
           '1' when (qJCintC = "11" and irout(7 downto 4) = "1110") else -- LDDA LDDB
           '1' when (qJCintD = '1')  else
           '1' when (qJCintE = "10") else
           '1' when (qJCintF = "100") else
           '0';

cJCextB <= '1' when (qJCintB = "10" and irout(7 downto 4) = "1110") else -- LDDA LDDB
           '0';

cJCextC <= '1' when (qJCintB = "10" and irout(7 downto 2) = "111100") else -- STDA 
           '0';

cJCextD <= '1' when (qJCintB = "10" and irout(7 downto 2) = "111101") else -- STDB
           '0';

cJCextE <= '1' when (qJCintB = "10" and irout(7 downto 3) = "11111") else -- STDI
           '0';

cs1     <= '1' when qJCintB = "11"  else
           '1' when qJCintF = "110" else
           '1' when (qJCintE = "11" and irout(7 downto 2) = "011100") else --shift
           '0';

cs2     <= '1' when (qJCintC = "11" and irout(7 downto 4) = "1110") else -- LDDA LDDB
           '0';

-- 内部出力脱出信号
--------------------------------
--  
--  Decode Logic for Control Signals
--   of Johnson Counters for Inernal
--  
--------------------------------
cact    <= '0';

cJCintB <= '1' when qJCintA = '0'   else
           '1' when qJCintC = "11"  else
	   '1' when qJCintD = '1'   else
	   '1' when qJCintE = "10"  else
	   '1' when qJCintF = "100" else
	   '0';

cJCintC <= '1' when (qJCintB = "10" and irout(7 downto 5) = "110") else -- SETIXH SETIXL LDIA LDIB
           '1' when (qJCintB = "10" and irout(7 downto 4) = "1110") else -- LDDA LDDB
           '0';

cJCintD <= '1' when (qJCintB = "10" and irout(7 downto 6) = "10") else -- ADDA ADDB SUBA SUBB ANDA ANDB ORA ORB NOTA NOTB INCA INCB DECA DECB CMP
           '1' when (qJCintB = "10" and irout(7 downto 4) = "0101" and ZeroF = '0') else -- JPZ(Z=0)
           '1' when (qJCintB = "10" and irout(7 downto 4) = "0100" and CarryF = '0') else -- JPC(C=0)
           '1' when (qJCintB = "10" and irout(7 downto 6) = "00") else -- NOP
           '0';

cJCintE <= '1' when (qJCintB = "10" and irout(7 downto 3) = "11110") else -- STDA STDB
           '1' when (qJCintB = "10" and irout(7 downto 2) = "011100") else --shift
           '0';
      
cJCintF <= '1' when (qJCintB = "10" and irout(7 downto 5) = "0110") else -- JP
           '1' when (qJCintB = "10" and irout(7 downto 4) = "0101" and ZeroF = '1') else -- JPZ(Z=1)
           '1' when (qJCintB = "10" and irout(7 downto 4) = "0100" and CarryF = '1') else -- JPC(C=1)
           '1' when (qJCintB = "10" and irout(7 downto 3) = "11111") else -- STDI
           '0';  


--------------------------------
--  
--  Decode logic for Internal Signals
--  
--------------------------------
clearIP   <= '1' when qJCintA='0' else
             '0';

loadIR    <= '1' when qJCintB = "11" else
	           '0';

modeALU   <= irout(3 downto 0) when (qJCintD = '1' and irout(7 downto 6) = "10") else -- ADDA ADDB SUBA SUBB ANDA ANDB ORA ORB NOTA NOTB INCA INCB DECA DECB CMP
             "0000";

loadFZ    <= '1' when (qJCintD = '1' and irout(7 downto 6) = "10") else -- ADDA ADDB SUBA SUBB ANDA ANDB ORA ORB NOTA NOTB INCA INCB DECA DECB CMP
             '1' when (qJCintE = "10" and irout(7 downto 2) = "011100") else -- shift
             '0';

loadFC    <= '1' when (qJCintD = '1' and irout(7 downto 1) = "1000000") else -- ADDA SUBA
             '1' when (qJCintD = '1' and irout(7 downto 0) = "10000101") else -- INCA
             '1' when (qJCintD = '1' and irout(7 downto 0) = "10000110") else -- DECA
             '1' when (qJCintD = '1' and irout(7 downto 1) = "1001000") else -- ADDB SUBB
             '1' when (qJCintD = '1' and irout(7 downto 0) = "10011001") else -- INCB
             '1' when (qJCintD = '1' and irout(7 downto 0) = "10011010") else -- DECB
             '1' when (qJCintE = "10" and irout(7 downto 2) = "011100") else -- shift
             '0';

loadhMB   <= '1' when (qJCintF = "011" and irout(7 downto 5) = "0110") else -- JP
             '1' when (qJCintF = "011" and irout(7 downto 4) = "0101" and ZeroF = '1') else -- JPZ(Z=1)
             '1' when (qJCintF = "011" and irout(7 downto 4) = "0100" and CarryF = '1') else -- JPC(C=1)
             '0';      
        
loadlMB   <= '1' when (qJCintF = "110" and irout(7 downto 5) = "0110") else -- JP
             '1' when (qJCintF = "110" and irout(7 downto 4) = "0101" and ZeroF = '1') else -- JPZ(Z=1)
             '1' when (qJCintF = "110" and irout(7 downto 4) = "0100" and CarryF = '1') else -- JPC(C=1)
             '0';                                

loadIP    <= '1' when (qJCintF = "100" and irout(7 downto 5) = "0110") else -- JP
             '1' when (qJCintF = "100" and irout(7 downto 4) = "0101" and ZeroF = '1') else -- JPZ(Z=1)
             '1' when (qJCintF = "100" and irout(7 downto 4) = "0100" and CarryF = '1') else -- JPC(C=1)
             '0';  

loadhIX <= '1' when (qJCintC = "11" and irout(7 downto 0) = "11010000") else -- SERIXH
           '0';

loadlIX <= '1' when (qJCintC = "11" and irout(7 downto 0) = "11010001") else -- SETIXL
           '0';

loadRegA <= '1' when (qJCintC = "11" and irout(7 downto 0) = "11011000") else -- LDIA
            '1' when (qJCintC = "11" and irout(7 downto 0) = "11100000") else -- LDDA
            '1' when (qJCintD = '1' and irout(7 downto 4) = "1000") else -- ADDA SUBA ANDA ORA NOTA INCA DECA
            '1' when (qJCintE = "10" and irout(7 downto 2) = "011100") else -- shift
            '0';

loadRegB <= '1' when (qJCintC = "11" and irout(7 downto 0) = "11011001") else -- LDIB
            '1' when (qJCintC = "11" and irout(7 downto 0) = "11100001") else -- LDIB
            '1' when (qJCintD = '1' and irout(7 downto 4) = "1001") else -- ADDB SUBB ANDB ORB NOTB INCB DECB
            '0';

loadRegC <= '1' when (qJCintF = "011" and irout(7 downto 3) = "11111") else -- STDI
            '1' when (qJCintE = "11" and irout(7 downto 2) = "011100") else -- shift
            '0';

incIP   <=  '1' when qJCintB = "10"  else
            '1' when (qJCintC = "11" and irout(7 downto 5) = "110") else -- SETIXH SETIXL LDIA LDIB
            '1' when (qJCintE = "11" and irout(7 downto 2) = "011100") else -- shift
            '1' when qJCintF = "011" else
            '0';

inc2IP   <= '1' when (qJCintD = '1' and irout(7 downto 4) = "0101" and ZeroF = '0') else -- JPZ(Z=0)
            '1' when (qJCintD = '1' and irout(7 downto 4) = "0100" and CarryF = '0') else -- JPC(C=0)
            '0';

selMuxDIn<= "01" when (qJCintC = "01" and irout(7 downto 3) = "11011")  else -- LDIA LDIB
            "01" when (qJCintC = "01" and irout(7 downto 4) = "1110")   else -- LDDA LDDB
            "01" when (qJCintC = "11" and irout(7 downto 3) = "11011")  else -- LDIA LDIB
            "01" when (qJCintC = "11" and irout(7 downto 4) = "1110")   else -- LDDA LDDB
            "01" when (qJCintF = "001" and irout(7 downto 3) = "11111") else -- STDI
            "01" when (qJCintF = "011" and irout(7 downto 3) = "11111") else -- STDI
            "01" when (qJCintE = "01" and irout(7 downto 2) = "011100") else -- shift
            "01" when (qJCintE = "11" and irout(7 downto 2) = "011100") else -- shift
            "10" when (qJCintE = "10" and irout(7 downto 2) = "011100") else -- shift
            "00" ;

modeShift   <=  "01" when (qJCintE = "10" and irout(7 downto 0) = "01110001") else
                "10" when (qJCintE = "10" and irout(7 downto 0) = "01110010") else
                "11" when (qJCintE = "10" and irout(7 downto 0) = "01110011") else
                "00";

selMuxCOut  <=  '1' when (qJCintE = "10" and irout(7 downto 2) = "011100") else
                '0';

selMuxZOut  <=  '1' when (qJCintE = "10" and irout(7 downto 2) = "011100") else
                '0';

end logic;