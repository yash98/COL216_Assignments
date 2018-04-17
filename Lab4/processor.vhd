library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;

entity processor is 
    port (
        cl: in std_logic;
        pc_res: in std_logic
        
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

signal typ_dt_int: std_logic_vector(3 downto 0);
signal byte_off_int: std_logic_vector(1 downto 0);

signal CW_int: std_logic;
signal DW_int: std_logic;

signal pc_out_int: std_logic_vector(31 downto 0);
signal ins_int: std_logic_vector(31 downto 0);
signal Flags_int: std_logic_vector(3 downto 0);


-- Bctrl related
signal pred_int: std_logic;
begin
DP: entity work.datapath port map (
    PW => PW_int,
    IorD => IorD_int,
    IRW => IRW_int,
    DRW => DRW_int,
    M2R => M2R_int,
    Rsrc => Rsrc_int,
    RW => RW_int,
    AW => AW_int,
    BW => BW_int,
    XW => XW_int,
    Asrc1 => Asrc1_int,
    Asrc2 => Asrc2_int,
    op => op_int,
    Fset => Fset_int,
    ReW => ReW_int,
    
    -- self defined
    clock => cl,
    pc_reset => pc_res,
    
    shiftSrc => shiftSrc_int,
    amtSrc => amtSrc_int,
    wadsrc => wadsrc_int,
    rad1src => rad1src_int,
    
    typ_dt => typ_dt_int,
    byte_off => byte_off_int,
    
    CW => CW_int,
    DW => DW_int,
    
    pc_out => pc_out_int,
    instruction => ins_int,
    Flags => Flags_int
);
MC: entity work.main_control port map (
    clock => cl,
    ins => ins_int,
    pred => pred_int,

    PW => PW_int,
    IorD => IorD_int,
    IRW => IRW_int,
    DRW => DRW_int,
    M2R => M2R_int,
    Rsrc => Rsrc_int,
    RW => RW_int,
    AW => AW_int,
    BW => BW_int,
    XW => XW_int,
    Asrc1 => Asrc1_int,
    Asrc2 => Asrc1_int,
    op => op_int,
    Fset => Fset_int,
    ReW => ReW_int,
    
    --self defined
    shiftSrc => shiftSrc_int,
    amtSrc => amtSrc_int,
    wadsrc => wadsrc_int,
    rad1src => rad1src_int,
    
    typ_dt => typ_dt_int,
    byte_off => byte_off_int,
    
    CW => CW_int,
    DW => DW_int
);
BC: entity work.Bctrl port map (
    ins31_28 => ins_int(31 downto 28),
    znvc => Flags_int,
    p => pred_int
);
end architecture;