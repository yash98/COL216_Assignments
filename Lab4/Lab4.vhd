library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use ieee.numeric_std;

entity alu is
    port (
        a: in std_logic_vector(31 downto 0);
        b: in std_logic_vector(31 downto 0);
        operation: in std_logic_vector(3 downto 0);
        carry: in std_logic;
        c: out std_logic_vector(31 downto 0);
        flags: out std_logic_vector(3 downto 0)
    );    
end entity;

architecture beh of alu is
begin
    process(a,b,operation)
        begin
        
        --and
        if (operation = "0000") then 
        c <= a and b ;
            
        elsif (operation = "0001") then
            c <= a xor b;
        
        end if;
end process;
end architecture;