library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;  

entity main_control is
    port (
        p: in std_logic;

        ins27_20: in std_logic_vector(8 downto 0);
        Rsrc: out std_logic;
        brn: out std_logic;
        MR: out std_logic;
        M2R: out std_logic;
        Fset: out std_logic;
        Asrc: out std_logic;
        RW: out std_logic;
    );    
end entity;

architecture beh of main_control is
begin
    process(p,ins27_20)
end architecture;

