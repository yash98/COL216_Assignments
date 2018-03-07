--ALU
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;  
use UNISIM.Vcomponents.all;

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
type reg_arr is array (0 to 15) of std_logic_vector(31 downto 0);
signal r: reg_arr;
signal raddr1_in: integer;
signal raddr2_in: integer;
signal waddr_in: integer;
begin
    pc <= r(15);
    r(15) <= "00000000000000000000000000000000" when reset = '1';
    
    raddr1_in <= conv_integer(unsigned(raddr1));
    raddr2_in <= conv_integer(unsigned(raddr2));
    waddr_in <= conv_integer(unsigned(waddr));
    
    rout1 <= r(raddr1_in);
    rout2 <= r(raddr2_in);

    process(clock)
    begin
        if (rising_edge(clock)) then
            if (we = '1') then
                r(waddr_in) <= winp;
            end if;
        end if;
    end process;
end architecture;



--DATAPATH

--DATEPATH
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity datapath is
    port (
        PW: in std_logic;
        IorD: in std_logic;
        MR: in std_logic; --d
        MW: in std_logic; --d
        IW: in std_logic;
        DW: in std_logic;
        M2R: in std_logic;
        Rsrc: in std_logic;
        RW: in std_logic;
        AW: in std_logic;
        BW: in std_logic;
        Asrc1: in std_logic;
        Asrc2: in std_logic;
        op: in std_logic_vector(3 downt 0);
        Fset: in std_logic;
        ReW: in std_logic;
    );
end entity;

