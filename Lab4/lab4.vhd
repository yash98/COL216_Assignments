library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shifter is
    port (
        a: in std_logic_vector(31 downto 0);
        result: out std_logic_vector(31 downto 0);
        typ: in std_logic_vector(1 downto 0);
        amt: in std_logic_vector(4 downto 0);
        carry: out std_logic
    );   
end entity;
    
architecture beha of alu is
signal zero: std_logic_vector (0 to 31) := "00000000000000000000000000000000";
signal one: std_logic_vector (0 to 31) := "11111111111111111111111111111111";
signal amnt: integer;
begin
    amnt <= conv_integer(amt);
    process(a,b,operation)
    begin
        if (amnt>0 and amnt<32) then
            --lsl    
            if (operation = "00") then 
                result <= a((31 - amnt) downto 0) & zero((amnt-1) downto 0);
            --lsr
            elsif (operation = "01") then
                result <= zero(31 downto (31- amnt +1)) & a(31 downto amnt);
            --asr
            elsif (operation = "10") then     
                if(a(31 downto 31) = "0") then
                    result <= zero(31 downto (31- amnt +1)) & a(31 downto amnt);
                else
                    result <= one(31 downto (31- amnt +1)) & a(31 downto amnt);
                end if;
            --ror        
            elsif (operation = "11") then
                result <= a((amnt - 1) downto 0) & a(31 downto amnt); 
            end if;
        else
            result <= a;    
        end if;
    end process;
end architecture;










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