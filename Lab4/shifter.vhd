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