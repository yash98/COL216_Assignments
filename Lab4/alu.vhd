library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu is
    port (
        a: in std_logic_vector(31 downto 0);
        b: in std_logic_vector(31 downto 0);
        operation: in std_logic_vector(3 downto 0);
        carry: in std_logic;
        result: out std_logic_vector(31 downto 0);
        flags: out std_logic_vector(3 downto 0)
    );    
end entity;

architecture beh of alu is
begin
    process(a,b,operation)
    begin
        
        --Arithmetic
        --add   
        if (operation = "0100") then
            result <= a + b;
        --sub    
        elsif (operation = "0010") then
            result <= a + (not b) + "00000000000000000000000000000001";
        --rsb    
        elsif (operation = "0011") then
            result <= (not a) + b + "00000000000000000000000000000001";
        --adc    
        elsif (operation = "0101") then
            result <= a + b + ("0000000000000000000000000000000" & carry );
        --sbc
        elsif (operation = "0110") then
            result <= a + (not b) + ("0000000000000000000000000000000" & carry );
        --rsc
        elsif (operation = "0111") then 
            result <= (not a) + b + ("0000000000000000000000000000000" & carry );        
        
        --Logical
        --and
        elsif (operation = "0000") then
            result <= a and b;
        --orr
        elsif (operation = "1100") then
            result <= a or b;
        --eor
        elsif (operation = "0001") then
            result <= a xor b;        
        --bic
        elsif (operation = "1110") then
            result <= a and (not b);
            
        --Test
        --cmp
        elsif (operation = "1010") then
            result <= a + (not b) + "00000000000000000000000000000001";
        --cmn
        elsif (operation = "1011") then
            result <= a + b;
        --tst
        elsif (operation = "1000") then
            result <= a and b;
        --teq
        elsif (operation = "1001") then
            result <= a xor b; 
        
        end if;
    end process;
end architecture;