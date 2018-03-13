library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;  

entity main_control is
    port (
        p: in std_logic;

        ins27_20: in std_logic_vector(7 downto 0);
        Rsrc: out std_logic;
        brn: out std_logic;
        MR: out std_logic;
        M2R: out std_logic;
        Fset: out std_logic;
        Asrc: out std_logic;
        RW: out std_logic
    );    
end entity;

architecture beh of main_control is
signal state: integer := 0; --0=fetch, 1=rdAB, 2=arith, 3=addr, 4=brn, 5=wrRF, 6= wrM, 7=rdM, 8= M2RF
begin
    process(p,ins27_20)
        begin
            if(state = 0) then
                state <= 1;
            elsif(state = 1) then
                if(ins27_20(7 downto 6) = "00") then
                    state <= 2;
                elsif(ins27_20(7 downto 6) = "01") then
                    state <= 3;
                elsif(ins27_20(7 downto 6) = "10") then
                    state <= 4;
                end if;
            elsif(state = 2) then
                state <= 5;
            elsif(state = 3) then
                if(ins27_20(0) = '0') then
                    state <=6;
                elsif(ins27_20(0) = '1') then
                    state <=7;
                end if;           
            elsif(state = 4) then
                state <= 0;
            elsif(state = 5) then
                state <= 0;
            elsif(state = 6) then
                state <= 0;
            elsif(state = 7) then
                state <=8;
            elsif(state =8) then
                state <=0;                
            end if;
    end process;    
end architecture;

