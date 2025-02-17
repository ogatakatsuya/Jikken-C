--------------------------------
--  Subset of C Processor     --
--                            --
--       (c) Keishi SAKANUSHI --
--------------------------------
library IEEE;
use IEEE.std_logic_1164.all;


entity CProcessor is
  port (
    clock   : in std_logic;
    reset   : in  std_logic;
    DataIn  : in  std_logic_vector (7 downto 0);
    DataOut : out std_logic_vector (7 downto 0);
    Address : out std_logic_vector (15 downto 0);
    read    : out std_logic;
    write   : out std_logic;
    dbgIRout  : out std_logic_vector (7 downto 0);  -- added for debug on FPGA
    dbgZeroF  : out std_logic;                      -- added for debug on FPGA
    dbgCarryF : out std_logic;                      -- added for debug on FPGA
    dbgAout   : out std_logic_vector (7 downto 0);  -- added for debug on FPGA
    dbgBout   : out std_logic_vector (7 downto 0)   -- added for debug on FPGA
  );
end CProcessor;

architecture logic of CProcessor is
  component DataPath
    port (
    DataIn    : in  std_logic_vector (7 downto 0);
    selMuxDIn : in  std_logic_vector (1 downto 0);

    loadhMB   : in  std_logic;
    loadlMB   : in  std_logic;
    loadhIX   : in  std_logic;
    loadlIX   : in  std_logic;

    loadIR    : in  std_logic;
    IRout     : out std_logic_vector (7 downto 0);

    loadIP    : in  std_logic;
    incIP     : in  std_logic;
    inc2IP    : in  std_logic;
    clearIP   : in  std_logic;

    selMuxAddr: in  std_logic;
    Address   : out std_logic_vector (15 downto 0);
    ZeroF     : out std_logic;
    CarryF    : out std_logic;
    DataOut   : out std_logic_vector (7 downto 0);
    
    loadRegA  : in  std_logic;
    loadRegB  : in  std_logic;
    loadRegC  : in  std_logic;

    modeALU   : in  std_logic_vector (3 downto 0);
    selMuxDOut: in  std_logic_vector (1 downto 0);
    loadFZ    : in  std_logic;
    loadFC    : in  std_logic;

    clock     : in  std_logic;
    reset     : in  std_logic;

    Aout      : out std_logic_vector (7 downto 0); -- added for debug on FPGA
    Bout      : out std_logic_vector (7 downto 0); -- added for debug on FPGA

    modeShift : in  std_logic_vector (1 downto 0);
    selMuxCOut: in  std_logic;
    selMuxZOut: in  std_logic
    );
  end component;
  
  component Controler
    port (
    selMuxDIn : out std_logic_vector (1 downto 0);

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
    selMuxDOut: out std_logic_vector(1 downto 0);
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
  end component;

signal    selMuxDIn : std_logic_vector (1 downto 0);

signal    loadhMB   : std_logic;
signal    loadlMB   : std_logic;
signal    loadhIX   : std_logic;
signal    loadlIX   : std_logic;

signal    loadIR    : std_logic;
signal    IRout     : std_logic_vector (7 downto 0);

signal    loadIP    : std_logic;
signal    incIP     : std_logic;
signal    inc2IP    : std_logic;
signal    clearIP   : std_logic;

signal    selMuxAddr: std_logic;
signal    selMuxDOut: std_logic_vector(1 downto 0);
signal    ZeroF     : std_logic;
signal    CarryF    : std_logic;

signal    loadRegC  : std_logic;
signal    loadRegB  : std_logic;
signal    loadRegA  : std_logic;

signal    modeALU   : std_logic_vector (3 downto 0);
signal    loadFZ    : std_logic;
signal    loadFC    : std_logic;

signal    modeShift : std_logic_vector (1 downto 0);
signal    selMuxCOut: std_logic;
signal    selMuxZOut: std_logic;

begin    -- logic


path : DataPath
  port map(
    DataIn    => DataIn,
    selMuxDIn => selMuxDIn,
	
    loadhMB   => loadhMB,
    loadlMB   => loadlMB,
    loadhIX   => loadhIX,
    loadlIX   => loadlIX,
	
    loadIR    => loadIR,
    IRout     => IRout,
	
    loadIP    => loadIP,
    incIP     => incIP,
    inc2IP    => inc2IP,
    clearIP   => clearIP,

    selMuxAddr=> selMuxAddr,
    selMuxDOut=> selMuxDOut,
    Address   => Address,
    ZeroF     => ZeroF,
    CarryF    => CarryF,
    DataOut   => DataOut,
	
    loadRegA  => loadRegA,
    loadRegB  => loadRegB,
    loadRegC  => loadRegC,

    modeALU   => modeALU,
    loadFZ    => loadFZ,
    loadFC    => loadFC,
	
    clock     => clock,
    reset     => reset,

    Aout      => dbgAout,   -- added for debug on FPGA
    Bout      => dbgBout,   -- added for debug on FPGA

    modeShift => modeShift,
    selMuxCOut=> selMuxCOut,
    selMuxZOut=> selMuxZOut
  );

ctrl : Controler
  port map(
    selMuxDIn => selMuxDIn,
	
    loadhMB   => loadhMB,
    loadlMB   => loadlMB,
    loadhIX   => loadhIX,
    loadlIX   => loadlIX,
	
    loadIR    => loadIR,
    IRout     => IRout,
	
    loadIP    => loadIP,
    incIP     => incIP,
    inc2IP    => inc2IP,
    clearIP   => clearIP,

    selMuxAddr=> selMuxAddr,
    selMuxDOut=> selMuxDOut,
    ZeroF     => ZeroF,
    CarryF    => CarryF,
	
    loadRegA  => loadRegA,
    loadRegB  => loadRegB,
    loadRegC  => loadRegC,

    modeALU   => modeALU,
    loadFZ    => loadFZ,
    loadFC    => loadFC,
	
    clock     => clock,
    reset     => reset,

    read      => read,
    write     => write,

    modeShift => modeShift,
    selMuxCOut=> selMuxCOut,
    selMuxZOut=> selMuxZOut
  );

dbgIRout <= IRout;      -- added for debug on FPGA
dbgZeroF <= ZeroF;      -- added for debug on FPGA
dbgCarryF <= CarryF;    -- added for debug on FPGA

end logic;