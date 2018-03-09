library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use ieee.numeric_std;

entity datapath is
    port (
        PW: in std_logic;   -- write to pc when 1
        IorD: in std_logic; -- Instruction (1) or PC inc. (0)
        MW: in std_logic; -- memory write enable
        IW: in std_logic; -- Instruction write/save enable
        DW: in std_logic; -- data register write enable
        M2R: in std_logic; -- pick data or result to write to register file
        Rsrc: in std_logic; -- pick rd or rm for rad2
        RW: in std_logic; -- write enable for register file
        AW: in std_logic;  -- rf out1 store reg write enable
        BW: in std_logic;  -- rf out2 store reg write enable
        Asrc1: in std_logic;  -- pick pc for inc. or op1 for calc
        Asrc2: in std_logic;  -- 
        op: in std_logic_vector(3 downto 0);
        Fset: in std_logic;
        ReW: in std_logic
    );
end entity;

architecture beh of datapath is

begin


end architecture;