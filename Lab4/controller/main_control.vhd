library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;  

entity main_control is
    port (
        clock: in std_logic;
        pc_out: in std_logic_vector(31 downto 0);
        Flags: in std_logic_vector(3 downto 0);
        ins: in std_logic_vector(31 downto 0);

        PW: out std_logic;   -- write to pc when 1
        IorD: out std_logic_vector(1 downto 0); -- Instruction (1) or PC inc. (0)
        IRW: out std_logic; -- Instruction write/save enable
        DRW: out std_logic; -- data register write enable
        M2R: out std_logic_vector(1 downto 0); -- pick data or result to write to register file
        Rsrc: out std_logic_vector(1 downto 0); -- pick rd or rm for rad2
        RW: out std_logic; -- write enable for register file
        AW: out std_logic;  -- rf out1 store reg write enable
        BW: out std_logic;  -- rf out2 store B reg write enable
        XW: out std_logic;  -- rf out2 store X reg write enable
        Asrc1: out std_logic_vector(0 downto 0); -- pick pc for inc. or rf out1 for calc
        Asrc2: out std_logic_vector(4 downto 0); -- choose from rf out 2 or 4 (for pc+4 step) or Imm or offset for branch
        op: out std_logic_vector(3 downto 0);  -- op code for alu
        Fset: out std_logic; -- set flags along command
        ReW: out std_logic;  -- reg store write enable
        
        -- self defined
        cin: out std_logic; -- for alu
        pc_reset: out std_logic; -- for reg_file pc <= 0
        
        shiftSrc: out std_logic_vector(1 downto 0);
        amtSrc: out std_logic_vector(1 downto 0);
        wadsrc: out std_logic_vector(1 downto 0);
        rad1src: out std_logic_vector(0 downto 0);
        
        typ_dt: out std_logic_vector(3 downto 0);
        byte_off: out std_logic_vector(1 downto 0);
        
        CW: out std_logic;
        DW: out std_logic

    );    
end entity;

architecture beh of main_control is
signal state: integer := 0;
begin
    process(clock)
    begin
        if(rising_edge(clock)) then
            if (state = 1) then
                if (ins(27 downto 25) = "00") then
                    --DP
                    if ((ins(24 downto 23) = "00") and (ins(7 downto 4) = "1001")) then
                        state <= 8;
                    --MUL/MLA
                    else
                        state <= 2;
                    end if;
                --Branch
                elsif (ins(27 downto 25) = "10") then
                    if (ins(24) = '0') then
                        state <= 13;
                    else
                        state <= 14;
                    end if;
                end if;
            
            elsif(state = 2) then
                state <= 3;
            
            elsif(state = 3) then
                if (ins(25) = '1') then
                    state <= 4;
                else
                    if(ins(4) = '0') then
                        state <= 5;
                    else
                        state <= 6;
                    end if;
                end if;        
            
            elsif(state = 4) then
                state <= 7;
             
            elsif(state = 5) then
                state <= 7;
            
            elsif(state = 6) then
                state <= 7;
                
            elsif(state = 7) then
                state <= 8;
                
            elsif(state = 8) then 
                state <= 1;
                
            elsif(state = 9) then 
                state <= 10;

            elsif(state = 10) then
                state <= 11;

            elsif(state = 11) then
                state <= 12;

            elsif(state = 12) then
                state <= 1;

            elsif(state = 13) then
                state <= 15;
            
            elsif(state = 14) then
                state <= 13;

            elsif(state = 15) then
                state <= 1;
                
            end if;
            
        end if;
    end process;
    
    
    
end architecture;

