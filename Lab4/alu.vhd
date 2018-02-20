library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu is
    port (
        a: in std_logic_vector(31 downto 0);
        b: in std_logic_vector(31 downto 0);
        operation: in std_logic_vector(3 downto 0);
        carryIn: in std_logic;
        result: out std_logic_vector(31 downto 0);
        flags: out std_logic_vector(3 downto 0)
        -- 3z 3n 2v 1c
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
            result <= a + b + ("0000000000000000000000000000000" & carryIn);
        --sbc
        elsif (operation = "0110") then
            result <= a + (not b) + ("0000000000000000000000000000000" & carryIn);
        --rsc
        elsif (operation = "0111") then 
            result <= (not a) + b + ("0000000000000000000000000000000" & carryIn);        
        
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

flags(3) <= "0" when result = "00000000000000000000000000000000" else
            "1";
flags(2) <= result(31);
flags(0) <= a(30) xor b(30) xor result(30);
flags(1) <= a(31) xor b(31) xor result(31) xor flags(0);

end architecture;