--ALU
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







--MULTIPLIER
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use ieee.numeric_std;

entity multiplier is
    port (
        a: in std_logic_vector(31 downto 0);
        b: in std_logic_vector(31 downto 0);
        s: out std_logic_vector(31 downto 0)
    );
end entity;

architecture behm of multiplier is
signal res: std_logic_vector (0 to 63);
begin
    res <= a*b;
    s <= res(31 downto 0);
end architecture;






--SHIFTER
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shifter is
    port (
        a: in std_logic_vector(31 downto 0);
        result: out std_logic_vector(31 downto 0);
        typ: in std_logic_vector(1 downto 0);
        amt: in unsigned(4 downto 0);
        carry: out std_logic
    );   
end entity;
    
architecture beha of shifter is
signal zero: std_logic_vector (0 to 31) := "00000000000000000000000000000000";
signal one: std_logic_vector (0 to 31) := "11111111111111111111111111111111";
signal amnt: integer;
begin
    amnt <= conv_integer(amt);
    process(a,typ,amt)
    begin
        amnt <= conv_integer(amt);
        if (amnt>0 and amnt<32) then
            --lsl    
            if (typ = "00") then 
                result <= a((31 - amnt) downto 0) & zero((amnt-1) downto 0);
                carry <= a(31-amnt);
            --lsr
            elsif (typ = "01") then
                result <= zero(31 downto (31- amnt +1)) & a(31 downto amnt);
                carry <= a(amnt - 1);
            --asr
            elsif (typ = "10") then     
                if(a(31 downto 31) = "0") then
                    result <= zero(31 downto (31- amnt +1)) & a(31 downto amnt);
                else
                    result <= one(31 downto (31- amnt +1)) & a(31 downto amnt);
                end if;
                carry <= a(amnt - 1);
            --ror        
            elsif (typ = "11") then
                result <= a((amnt - 1) downto 0) & a(31 downto amnt);
                carry <= a(amnt - 1); 
            end if;
        else
            result <= a;
            carry <= '0';
        end if;
    end process;
end architecture;






--REGISTER
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use ieee.numeric_std;

entity reg_file is
    port (
        raddr1: in std_logic_vector(3 downto 0);
        raddr2: in std_logic_vector(3 downto 0);
        winp: in std_logic_vector(31 downto 0);
        waddr: in std_logic_vector(3 downto 0); 
        we: in std_logic;
        clock: in std_logic;
        reset: in std_logic;

        pc: out std_logic_vector(31 downto 0);
        rout1: out std_logic_vector(31 downto 0);
        rout2: out std_logic_vector(31 downto 0)
    );
end entity;

architecture behr of reg_file is
signal r0: std_logic_vector(31 downto 0);
signal r1: std_logic_vector(31 downto 0);
signal r2: std_logic_vector(31 downto 0);
signal r3: std_logic_vector(31 downto 0);
signal r4: std_logic_vector(31 downto 0);
signal r5: std_logic_vector(31 downto 0);
signal r6: std_logic_vector(31 downto 0);
signal r7: std_logic_vector(31 downto 0);
signal r8: std_logic_vector(31 downto 0);
signal r9: std_logic_vector(31 downto 0);
signal r10: std_logic_vector(31 downto 0);
signal r11: std_logic_vector(31 downto 0);
signal r12: std_logic_vector(31 downto 0);
signal r13: std_logic_vector(31 downto 0);
signal r14: std_logic_vector(31 downto 0);
signal r15: std_logic_vector(31 downto 0);
begin
    pc <= r15;
    rout1<= r0 when raddr1 = "0000" else
            r1 when raddr1 = "0001" else
            r2 when raddr1 = "0010" else
            r3 when raddr1 = "0011" else
            r4 when raddr1 = "0100" else
            r5 when raddr1 = "0101" else
            r6 when raddr1 = "0110" else
            r7 when raddr1 = "0111" else
            r8 when raddr1 = "1000" else
            r9 when raddr1 = "1001" else
            r10 when raddr1 = "1010" else
            r11 when raddr1 = "1011" else
            r12 when raddr1 = "1100" else
            r13 when raddr1 = "1101" else
            r14 when raddr1 = "1110" else
            r15 when raddr1 = "1111";
    rout2<= r0 when raddr2 = "0000" else
            r1 when raddr2 = "0001" else
            r2 when raddr2 = "0010" else
            r3 when raddr2 = "0011" else
            r4 when raddr2 = "0100" else
            r5 when raddr2 = "0101" else
            r6 when raddr2 = "0110" else
            r7 when raddr2 = "0111" else
            r8 when raddr2 = "1000" else
            r9 when raddr2 = "1001" else
            r10 when raddr2 = "1010" else
            r11 when raddr2 = "1011" else
            r12 when raddr2 = "1100" else
            r13 when raddr2 = "1101" else
            r14 when raddr2 = "1110" else
            r15 when raddr2 = "1111";

    r15 <= "0000" when reset = '1';

    process(clock'event)
    begin
        if (we = '1') then
            if (waddr = "0000") then
                r0 <= winp;
            elsif (waddr = "0001") then
                r1 <= winp;
            elsif (waddr = "0010") then
                r2 <= winp;
            elsif (waddr = "0011") then
                r3 <= winp;
            elsif (waddr = "0100") then
                r4 <= winp;
            elsif (waddr = "0101") then
                r5 <= winp;
            elsif (waddr = "0110") then
                r6 <= winp;
            elsif (waddr = "0111") then
                r7 <= winp;
            elsif (waddr = "1000") then
                r8 <= winp;
            elsif (waddr = "1001") then
                r9 <= winp;
            elsif (waddr = "1010") then
                r10 <= winp;
            elsif (waddr = "1011") then
                r11 <= winp;
            elsif (waddr = "1100") then
                r12 <= winp;
            elsif (waddr = "1101") then
                r13 <= winp;
            elsif (waddr = "1110") then
                r14 <= winp;
            elsif (waddr = "1111") then
                r15 <= winp;
            end if;
        end if;
    end process;
end architecture;