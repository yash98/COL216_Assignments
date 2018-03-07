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
        -- 3z 2n 1v 0c
    );    
end entity;

architecture beh of alu is
signal res: std_logic_vector (0 to 31);
begin
    process(a,b,operation)
    begin
        
        --Arithmetic
        --add   
        if (operation = "0100") then
            res <= a + b;
        --sub    
        elsif (operation = "0010") then
            res <= a + (not b) + "00000000000000000000000000000001";
        --rsb    
        elsif (operation = "0011") then
            res <= (not a) + b + "00000000000000000000000000000001";
        --adc    
        elsif (operation = "0101") then
            res <= a + b + ("0000000000000000000000000000000" & carryIn);
        --sbc
        elsif (operation = "0110") then
            res<= a + (not b) + ("0000000000000000000000000000000" & carryIn);
        --rsc
        elsif (operation = "0111") then 
            res <= (not a) + b + ("0000000000000000000000000000000" & carryIn);        
        
        --Logical
        --and
        elsif (operation = "0000") then
            res <= a and b;
        --orr
        elsif (operation = "1100") then
            res <= a or b;
        --eor
        elsif (operation = "0001") then
            res <= a xor b;        
        --bic
        elsif (operation = "1110") then
            res <= a and (not b);
            
        --Test
        --cmp
        elsif (operation = "1010") then
            res <= a + (not b) + "00000000000000000000000000000001";
        --cmn
        elsif (operation = "1011") then
            res <= a + b;
        --tst
        elsif (operation = "1000") then
            res <= a and b;
        --teq
        elsif (operation = "1001") then
            res <= a xor b; 
        
        end if;
    end process;

result <= res;
    
with res select
flags(3) <= '0' when "00000000000000000000000000000000",
                     '1' when others;
flags(2) <= res(31);
flags(0) <= (a(30) xor b(30) xor res(30));
flags(1) <= a(31) xor b(31) xor res(31) xor (a(30) xor b(30) xor res(30)); --a(31) xor b(31) xor res(31) xor flags(0)

end architecture;