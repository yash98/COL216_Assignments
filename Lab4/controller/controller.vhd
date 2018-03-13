library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;  
use UNISIM.Vcomponents.all;

entity controller is
    Port (
        PW: out std_logic; -- write to pc when 1
        IorD: out std_logic_vector(1 downto 0); -- Instruction (1) or PC inc. (0)
        MW: out std_logic_vector(0 downto 0); -- memory write enable, vector required for wrappper
        IW: out std_logic; -- Instruction write/save enable
        DW: out std_logic; -- data register write enable
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
        ReW: out std_logic  -- reg store write enable   
     );
end controller;

architecture Behavioral of controller is

begin


end Behavioral;
