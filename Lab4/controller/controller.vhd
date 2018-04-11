library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;  
use UNISIM.Vcomponents.all;

entity controller is
    Port (
        clock: in std_logic;
        pc_out: in std_logic_vector(31 downto 0);
        Flags: in std_logic_vector(3 downto 0);
        ins: in std_logic_vector(31 downto 0);

        PW: out std_logic;   -- write to pc when 1
        IorD: out std_logic_vector(1 downto 0); -- Instruction (1) or PC inc. (0)
        IRW: out std_logic; -- Instruction write/save enable
        DRW: out std_logic; -- data register write enable
        M2R: out std_logic_vector(1 downto 0); -- pick data or result to write to register file
        Rsrc: out std_logic_vector(1 downto 0); -- pick rd or rm for rad2
        RW: out std_logic; -- write enable for register file
        AW: out std_logic;  -- rf out1 store reg write enable
        BW: out std_logic;  -- rf out2 store B reg write enable
        XW: out std_logic;  -- rf out2 store X reg write enable
        Asrc1: out std_logic_vector(0 downto 0); -- pick pc for inc. or rf out1 for calc
        Asrc2: out std_logic_vector(4 downto 0); -- choose from rf out 2 or 4 (for pc+4 step) or Imm or offset for branch
        op: out std_logic_vector(3 downto 0);  -- op code for alu
        Fset: out std_logic; -- set flags along command
        ReW: out std_logic;  -- reg store write enable
        
        -- self defined
        pc_reset: out std_logic; -- for reg_file pc <= 0
        
        shiftSrc: out std_logic_vector(1 downto 0);
        amtSrc: out std_logic_vector(1 downto 0);
        wadsrc: out std_logic_vector(1 downto 0);
        rad1src: out std_logic_vector(0 downto 0);
        
        typ_dt: out std_logic_vector(3 downto 0);
        byte_off: out std_logic_vector(1 downto 0);
        
        CW: out std_logic;
        DW: out std_logic 
     );
end controller;

architecture Behavioral of controller is
signal znvc_int: std_logic_vector(3 downto 0);
signal p_int: std_logic;
signal pc_out_int: std_logic_vector(31 downto 0);
signal Flags_int: std_logic_vector(3 downto 0);

signal PW_int: std_logic;   -- write to pc when 1
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
signal pc_reset_int: std_logic; -- for reg_file pc <= 0

signal shiftSrc_int: std_logic_vector(1 downto 0);
signal amtSrc_int: std_logic_vector(1 downto 0);
signal wadsrc_int: std_logic_vector(1 downto 0);
signal rad1src_int: std_logic_vector(0 downto 0);

signal typ_dt_int: std_logic_vector(3 downto 0);
signal byte_off_int: std_logic_vector(1 downto 0);

signal CW_int: std_logic;
signal DW_int: std_logic;
begin
-- component
main_control: entity work.main_control port map (
    clock => clock,
    pc_out => pc_out_int,
    Flags => Flags_int,
    ins => ins,

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
    pc_reset => pc_reset_int,
    
    shiftSrc => shiftSrc_int,
    amtSrc => amtSrc_int,
    wadsrc => wadsrc_int,
    rad1src => rad1src_int,
    
    typ_dt => typ_dt_int,
    byte_off => byte_off_int,
    
    CW => CW_int,
    DW => DW_int
);

Bctrl: entity work.Bctrl port map (
        ins31_28 => ins(31 downto 28),
        znvc => Flags,
        p => p_int
);



end Behavioral;
