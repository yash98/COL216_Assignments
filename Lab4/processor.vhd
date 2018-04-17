library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;

entity processor is 
    port (
        clock: in std_logic;
        pc_reset: in std_logic;
        
    );
end entity;


architecture beh of processor is
signal PW_int: std_logic;   -- w
signal IorD_int: std_logic_vector(1 downto 0); -- Instruction (1) or PC inc. (0)
signal IRW_int: std_logic; -- Instruction write/save enable
signal DRW_int: std_logic; -- data register write enable
signal M2R_int: std_logic_vector(1 downto 0); -- pick data or result to write to register file
signal Rsrc_int: std_logic_vector(1 downto 0); -- pick rd or rm for rad2
signal RW_int: std_logic; -- write enable for register file
signal AW_int: std_logic;  -- rf out1 store reg write enable
signal BW_int: std_logic;  -- rf out2 store B reg write enable
signal XW_int: std_logic;  -- rf out2 store X reg write enable
signal Asrc1_int: std_logic_vector(0 downto 0); -- pick pc for inc. or rf out1 for calc
signal Asrc2_int: std_logic_vector(4 downto 0); -- choose from rf out 2 or 4 (for pc+4 step) or Imm or offset for branch
signal op_int: std_logic_vector(3 downto 0);  -- op code for alu
signal Fset_int: std_logic; -- set flags along command
signal ReW_int: std_logic;  -- reg store write enable

-- self defined
signal clock_int: std_logic;

signal shiftSrc_int: std_logic_vector(1 downto 0);
signal amtSrc_int: std_logic_vector(1 downto 0);
signal wadsrc_int: std_logic_vector(1 downto 0);
signal rad1src_int: std_logic_vector(0 downto 0);

signal typ_dt: std_logic_vector(3 downto 0);
signal byte_off: std_logic_vector(1 downto 0);

signal CW: std_logic;
signal DW: std_logic;

signal pc_out_int: std_logic_vector(31 downto 0);
signal ins_int: std_logic_vector(31 downto 0);
signal Flags_int: std_logic_vector(3 downto 0);
begin
DP: entity work.datapath port map (
    PW => PW_int,
    IorD: in std_logic_vector(1 downto 0); -- Instruction (1) or PC inc. (0)
    IRW: in std_logic; -- Instruction write/save enable
    DRW: in std_logic; -- data register write enable
    M2R: in std_logic_vector(1 downto 0); -- pick data or result to write to register file
    Rsrc: in std_logic_vector(1 downto 0); -- pick rd or rm for rad2
    RW: in std_logic; -- write enable for register file
    AW: in std_logic;  -- rf out1 store reg write enable
    BW: in std_logic;  -- rf out2 store B reg write enable
    XW: in std_logic;  -- rf out2 store X reg write enable
    Asrc1: in std_logic_vector(0 downto 0); -- pick pc for inc. or rf out1 for calc
    Asrc2: in std_logic_vector(4 downto 0); -- choose from rf out 2 or 4 (for pc+4 step) or Imm or offset for branch
    op: in std_logic_vector(3 downto 0);  -- op code for alu
    Fset: in std_logic; -- set flags along command
    ReW: in std_logic;  -- reg store write enable
    
    -- self defined
    clock: in std_logic;
    pc_reset: in std_logic; -- for reg_file pc <= 0
    
    shiftSrc: in std_logic_vector(1 downto 0);
    amtSrc: in std_logic_vector(1 downto 0);
    wadsrc: in std_logic_vector(1 downto 0);
    rad1src: in std_logic_vector(0 downto 0);
    
    typ_dt: in std_logic_vector(3 downto 0);
    byte_off: in std_logic_vector(1 downto 0);
    
    CW: in std_logic;
    DW: in std_logic;
    
    pc_out: out std_logic_vector(31 downto 0);
    instruction: out std_logic_vector(31 downto 0);
    Flags: out std_logic_vector(3 downto 0)
);
MC: entity work.main_control port map (
    clock: in std_logic;
    ins: in std_logic_vector(31 downto 0);
    pred: in std_logic;

    PW: out std_logic;   -- write to pc when 1
    IorD: out std_logic_vector(0 downto 0); -- Instruction (1) or PC inc. (0)
    IRW: out std_logic; -- Instruction write/save enable
    DRW: out std_logic; -- data register write enable
    M2R: out std_logic_vector(0 downto 0); -- pick data or result to write to register file
    Rsrc: out std_logic_vector(1 downto 0); -- pick rd or rm for rad2
    RW: out std_logic; -- write enable for register file
    AW: out std_logic;  -- rf out1 store reg write enable
    BW: out std_logic;  -- rf out2 store B reg write enable
    XW: out std_logic;  -- rf out2 store X reg write enable
    Asrc1: out std_logic_vector(0 downto 0); -- pick pc for inc. or rf out1 for calc
    Asrc2: out std_logic_vector(1 downto 0); -- choose from rf out 2 or 4 (for pc+4 step) or Imm or offset for branch
    op: out std_logic_vector(3 downto 0);  -- op code for alu
    Fset: out std_logic; -- set flags along command
    ReW: out std_logic;  -- reg store write enable
    
    --self defined
    pc_reset: out std_logic; -- for reg_file pc <= 0
    
    shiftSrc: out std_logic_vector(1 downto 0);
    amtSrc: out std_logic_vector(1 downto 0);
    wadsrc: out std_logic_vector(3 downto 0);
    rad1src: out std_logic_vector(0 downto 0);
    
    typ_dt: out std_logic_vector(1 downto 0);
    byte_off: out std_logic_vector(1 downto 0);
    
    CW: out std_logic;
    DW: out std_logic
);
BC: entity work.Bctrl port map (
    ins31_28: in std_logic_vector(3 downto 0);
    znvc: in std_logic_vector(3 downto 0);
    p: out std_logic
);
end architecture;
