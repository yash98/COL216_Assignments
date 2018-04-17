library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;  

entity main_control is
    port (
        clock: in std_logic;
        ins: in std_logic_vector(31 downto 0);
        pred: in std_logic;

        PW: out std_logic;   -- write to pc when 1
        IorD: out std_logic_vector(0 downto 0); -- Instruction (1) or PC inc. (0)
        IRW: out std_logic; -- Instruction write/save enable
        DRW: out std_logic; -- data register write enable
        M2R: out std_logic_vector(0 downto 0); -- pick data or result to write to register file
        Rsrc: out std_logic_vector(1 downto 0); -- pick rd or rm for rad2
        RW: out std_logic; -- write enable for register file
        AW: out std_logic;  -- rf out1 store reg write enable
        BW: out std_logic;  -- rf out2 store B reg write enable
        XW: out std_logic;  -- rf out2 store X reg write enable
        Asrc1: out std_logic_vector(0 downto 0); -- pick pc for inc. or rf out1 for calc
        Asrc2: out std_logic_vector(1 downto 0); -- choose from rf out 2 or 4 (for pc+4 step) or Imm or offset for branch
        op: out std_logic_vector(3 downto 0);  -- op code for alu
        Fset: out std_logic; -- set flags along command
        ReW: out std_logic;  -- reg store write enable
        
        --self defined
        shiftSrc: out std_logic_vector(1 downto 0);
        amtSrc: out std_logic_vector(1 downto 0);
        wadsrc: out std_logic_vector(1 downto 0);
        rad1src: out std_logic_vector(0 downto 0);
        
        typ_dt: out std_logic_vector(3 downto 0);
        byte_off: out std_logic_vector(1 downto 0);
        
        CW: out std_logic;
        DW: out std_logic;
        state_out: out integer
    );
end entity;

architecture beh of main_control is
signal state: integer range 1 to 16 := 1;
signal wait_count: std_logic_vector(1 downto 0):= "00";

begin
    process(clock)
    begin
        if(rising_edge(clock)) then
            if (state = 1) then
                if (pred = '0') then
                    state <= 1;
                -- DP
                elsif (ins(27 downto 26) = "00") then
                    --MUL/MLA 
                    if ((ins(24 downto 23) = "00") and (ins(7 downto 4) = "1001")) then
                        state <= 9;
                    --arith logic
                    else
                        state <= 2;
                    end if;
                --Branch
                elsif (ins(27 downto 26) = "10") then
                    if (ins(24) = '0') then
                        state <= 14;
                    else
                        state <= 15;
                    end if;
                end if;
            
            elsif (state = 2) then
                state <= 3;
            
            elsif (state = 3) then
                if (ins(25) = '1') then
                    state <= 4;
                else
                    if(ins(4) = '0') then
                        state <= 5;
                    else
                        state <= 6;
                    end if;
                end if;        
            
            elsif (state = 4) then
                state <= 7;
             
            elsif (state = 5) then
                state <= 7;
            
            elsif (state = 6) then
                state <= 7;
                
            elsif (state = 7) then
                state <= 8;
                
            elsif (state = 8) then 
                state <= 1;
                
            elsif (state = 9) then 
                state <= 10;
            
            
            elsif (state = 10) then
                wait_count <= wait_count + "01";
                state <= 10;
                if (wait_count = "10") then
                    state <= 11;
                    wait_count <= "00";
                end if;
                
            elsif(state = 11) then
                state <= 12;
                
            elsif (state = 12) then
                state <= 1;
                
            elsif (state = 13) then
                state <= 15;
            
            elsif (state = 14) then
                state <= 13;
                
            elsif (state = 15) then
                state <= 1;

            end if;
            
        end if;
        
        --PC=PC+4 and IR = Mem[PC]
        if (state = 1) then
            PW <= '1';
            IorD <= "0";
            IRW <= '1';
            DRW <= '0'; --x
            M2R <= "0"; --x
            Rsrc <= "00"; --x
            RW <= '0'; --x
            AW <= '0'; --x
            BW <= '0'; --x
            XW <= '0'; --x
            Asrc1 <= "0";
            Asrc2 <= "01";
            op <= "0100";
            Fset <= '0';
            ReW <= '0';
            
            -- self defined            
            shiftSrc <= "00"; --x
            amtSrc <= "00"; --x
            wadsrc <= "00"; --x
            rad1src <= "0";
            
            typ_dt <= "0000";
            byte_off <= "00";
            
            CW <= '0'; --x
            DW <= '0'; --x
        
        --A=ins[19-16] and B=ins[3-0]    
        elsif (state = 2) then
            PW <= '0';
            IorD <= "0"; --x
            IRW <= '0';
            DRW <= '0'; --x
            M2R <= "0"; --x
            Rsrc <= "01";
            RW <= '0'; --x
            AW <= '1';
            BW <= '1';
            XW <= '0'; --x
            Asrc1 <= "1"; --x
            Asrc2 <= "00"; --x
            op <= "0000"; --x
            Fset <= '0'; --x
            ReW <= '0'; --x
            
            -- self defined            
            shiftSrc <= "00"; --x
            amtSrc <= "00"; --x
            wadsrc <= "00"; --x
            rad1src <= "0";
            
            typ_dt <= "0000";
            byte_off <= "00";
            
            CW <= '0'; --x
            DW <= '0'; --x
        
        --X=ins[11-8]
        elsif (state = 3) then
            PW <= '0';
            IorD <= "0"; --x
            IRW <= '0';
            DRW <= '0'; --x
            M2R <= "0"; --x
            Rsrc <= "00";
            RW <= '0'; --x
            AW <= '0';
            BW <= '0';
            XW <= '1';
            Asrc1 <= "1";
            Asrc2 <= "00"; --x
            op <= "0000"; --x
            Fset <= '0';
            ReW <= '0';
            
            -- self defined
            shiftSrc <= "00"; --x
            amtSrc <= "00"; --x
            wadsrc <= "00"; --x
            rad1src <= "0"; --x
            
            typ_dt <= "0000";
            byte_off <= "00";
            
            CW <= '0'; --x
            DW <= '0'; --x
        
        -- shiftSrc = ins[3-0] and amtSrc = ins[11-8]&'0' and Shifter "ROR" mode    (DP instruction without shift)
        elsif (state = 4) then
            PW <= '0';
            IorD <= "0"; --x
            IRW <= '0';
            DRW <= '0'; --x
            M2R <= "0"; --x
            Rsrc <= "00"; --x
            RW <= '0'; --x
            AW <= '0';
            BW <= '0';
            XW <= '0';
            Asrc1 <= "1";
            Asrc2 <= "00"; --x
            op <= "0000"; --x
            Fset <= '0';
            ReW <= '0';
            
            -- self defined
            shiftSrc <= "01";
            amtSrc <= "11";
            wadsrc <= "00"; --x
            rad1src <= "0"; --x
            
            typ_dt <= "0000"; --x
            byte_off <= "00"; --x
            
            CW <= '1';
            DW <= '1';
        
        --shiftSrc = "B" and amtSrc = ins[11-7] and Shifter "B" mode    (DP instruction with imm shift amt)            
        elsif (state = 5) then
            PW <= '0';
            IorD <= "0"; --x
            IRW <= '0';
            DRW <= '0'; --x
            M2R <= "0"; --x
            Rsrc <= "00"; --x
            RW <= '0'; --x
            AW <= '0';
            BW <= '0';
            XW <= '0';
            Asrc1 <= "1";
            Asrc2 <= "00"; --x
            op <= "0000"; --x
            Fset <= '0';
            ReW <= '0';
            
            -- self defined
            shiftSrc <= "00";
            amtSrc <= "10";
            wadsrc <= "00"; --x
            rad1src <= "0"; --x
            
            typ_dt <= "0000"; --x
            byte_off <= "00"; --x
            
            CW <= '1';
            DW <= '1';
        
        -- ShiftSrc = "B" and amtSrc = "X" and Shifter "B" mode    (DP instruction with reg shift amt)
        elsif (state = 6) then
            PW <= '0';
            IorD <= "0"; --x
            IRW <= '0';
            DRW <= '0'; --x
            M2R <= "0"; --x
            Rsrc <= "00"; --x
            RW <= '0'; --x
            AW <= '0';
            BW <= '0';
            XW <= '0';
            Asrc1 <= "1";
            Asrc2 <= "00"; --x
            op <= "0000"; --x
            Fset <= '0';
            ReW <= '0';
            
            -- self defined
            shiftSrc <= "00";
            amtSrc <= "00";
            wadsrc <= "00"; --x
            rad1src <= "0"; --x
            
            typ_dt <= "0000"; --x
            byte_off <= "00"; --x
            
            CW <= '1';
            DW <= '1';
        
        -- ALU Step 
        elsif (state = 7) then
            PW <= '0';
            IorD <= "0"; --x
            IRW <= '0';
            DRW <= '0'; --x
            M2R <= "0"; --x
            Rsrc <= "00"; --x
            RW <= '0'; --x
            AW <= '0';
            BW <= '0';
            XW <= '0';
            Asrc1 <= "1";
            Asrc2 <= "00"; --x
            op <= ins(24 downto 21); --x
            Fset <= ins(20);
            ReW <= '1';
            
            -- self defined
            shiftSrc <= "00";
            amtSrc <= "00";
            wadsrc <= "00"; --x
            rad1src <= "0"; --x
            
            typ_dt <= "0000"; --x
            byte_off <= "00"; --x
            
            CW <= '0';
            DW <= '0';
        
        --write back in register
        elsif (state = 8) then
            PW <= '0';
            IorD <= "0"; --x
            IRW <= '0'; --x
            DRW <= '0'; --x
            M2R <= "1";
            Rsrc <= "00"; --x
            RW <= '1'; 
            AW <= '0'; --x
            BW <= '0'; --x
            XW <= '0'; --x
            Asrc1 <= "1"; --x
            Asrc2 <= "00"; --x
            op <= "0000"; --x
            Fset <= '0';
            ReW <= '0';
            
            -- self defined
            shiftSrc <= "00"; --x
            amtSrc <= "00"; --x
            wadsrc <= "00";
            rad1src <= "0"; --x
            
            typ_dt <= "0000"; --x
            byte_off <= "00"; --x
            
            CW <= '0'; --x
            DW <= '0'; --x
        
        
        --A=ins[15-12] and B=ins[3-0]    
        elsif (state = 9) then
            PW <= '0';
            IorD <= "0"; --x
            IRW <= '0'; --x
            DRW <= '0'; --x
            M2R <= "0";
            Rsrc <= "01";
            RW <= '0';
            AW <= '1'; 
            BW <= '1';
            XW <= '0'; 
            Asrc1 <= "0"; 
            Asrc2 <= "00";
            op <= "0000"; --x
            Fset <= '0';
            ReW <= '0'; --x
                
                -- self defined         
            shiftSrc <= "00"; --x
            amtSrc <= "00"; --x
            wadsrc <= "00";
            rad1src <= "0"; --x
                
            typ_dt <= "0000"; --x
            byte_off <= "00"; --x
                
            CW <= '0'; --x
            DW <= '0'; --x            
            
        -- X = ins[11-8]
        elsif (state = 10) then
            PW <= '0';
            IorD <= "0"; --x
            IRW <= '0'; --x
            DRW <= '0'; --x
            M2R <= "0"; --x
            Rsrc <= "00";
            RW <= '0';
            AW <= '0'; 
            BW <= '0';
            XW <= '1'; 
            Asrc1 <= "1"; --x 
            Asrc2 <= "00"; --x
            op <= "0000"; --x
            Fset <= '0'; --x
            ReW <= '0'; --x
                            
            -- self defined                     
            shiftSrc <= "00"; --x
            amtSrc <= "00"; --x
            wadsrc <= "00";
            rad1src <= "0"; --x
                            
            typ_dt <= "0000"; --x
            byte_off <= "00"; --x
                            
            CW <= '0'; --x
            DW <= '0'; --x          


        --ALU Step   Asrc2="Mul" and  Asrc1="A" 
        elsif (state = 11) then
            PW <= '0';
            IorD <= "0"; --x
            IRW <= '0'; --x
            DRW <= '0'; --x
            M2R <= "0"; --x
            Rsrc <= "00"; --x
            RW <= '0';
            AW <= '0'; --x
            BW <= '0'; --x
            XW <= '0'; --x
            Asrc1 <= "1"; --x 
            Asrc2 <= "10"; --x
            op <= ins(24 downto 21); --x
            Fset <= ins(20); 
            ReW <= '1';
            
            -- self defined                    
            shiftSrc <= "00"; --x
            amtSrc <= "00"; --x
            wadsrc <= "00";
            rad1src <= "0"; --x
                            
            typ_dt <= "0000"; --x
            byte_off <= "00"; --x
                            
            CW <= '0'; --x
            DW <= '0'; --x        
            
        -- writeback to memory   
        elsif (state = 12) then
            PW <= '0'; 
            IorD <= "0"; --x
            IRW <= '0'; --x
            DRW <= '0'; --x
            M2R <= "1";
            Rsrc <= "00"; --x
            RW <= '1';
            AW <= '0'; --x
            BW <= '0'; --x
            XW <= '0'; --x
            Asrc1 <= "1"; --x 
            Asrc2 <= "00"; --x
            op <= "0000"; --x
            Fset <= '0'; 
            ReW <= '0';
                                
                -- self defined                           
            shiftSrc <= "00"; --x
            amtSrc <= "00"; --x
            wadsrc <= "10";
            rad1src <= "0"; --x
                                
            typ_dt <= "0000"; --x
            byte_off <= "00"; --x
                                
            CW <= '0'; --x
            DW <= '0'; --x
        
        -- b instruction (shiftSrc = ins[24 downto 0] and amtSrc = "1" (int 2) and mode ="LSL" )      
        elsif (state = 13) then
            PW <= '0'; 
            IorD <= "0"; --x
            IRW <= '0'; --x
            DRW <= '0'; --x
            M2R <= "0";
            Rsrc <= "00"; --x
            RW <= '0';
            AW <= '0'; --x
            BW <= '0'; --x
            XW <= '0'; --x
            Asrc1 <= "1"; --x 
            Asrc2 <= "00"; --x
            op <= "0000"; --x
            Fset <= '0'; 
            ReW <= '0';
                                            
            -- self defined                                        
            shiftSrc <= "10";
            amtSrc <= "01"; 
            wadsrc <= "00"; --x
            rad1src <= "0"; --x
                                            
            typ_dt <= "0000"; --x
            byte_off <= "00"; --x
                                            
            CW <= '1'; 
            DW <= '1';
        
        -- bl instruction (initially we store PC+=4 into l register) rest same as b instruction
        elsif (state = 14) then
            PW <= '0'; 
            IorD <= "0"; --x
            IRW <= '0'; --x
            DRW <= '0'; --x
            M2R <= "1";
            Rsrc <= "00"; --x
            RW <= '1';
            AW <= '0'; --x
            BW <= '0'; --x
            XW <= '0'; --x
            Asrc1 <= "0"; 
            Asrc2 <= "00"; 
            op <= "0000"; --x
            Fset <= '0'; 
            ReW <= '1';
                                            
            -- self defined                                     
            shiftSrc <= "00";
            amtSrc <= "00"; 
            wadsrc <= "11";
            rad1src <= "0"; --x
                                            
            typ_dt <= "0000"; --x
            byte_off <= "00"; --x
                                            
            CW <= '0'; --x 
            DW <= '0'; --x
        
        -- PC = PC + offset  and  asrc2='0'(shfter out) and asrc1='0' (PC) 
        elsif (state = 15) then
            PW <= '1'; 
            IorD <= "0"; --x
            IRW <= '0'; --x
            DRW <= '0'; --x`
            M2R <= "0"; --x
            Rsrc <= "00"; --x
            RW <= '0'; --x
            AW <= '0'; --x
            BW <= '0'; --x
            XW <= '0'; --x
            Asrc1 <= "0";
            Asrc2 <= "00";
            op <= "0100";
            Fset <= '0'; 
            ReW <= '0';
                                            
            -- self defined                                           
            shiftSrc <= "00"; --x
            amtSrc <= "00"; --x
            wadsrc <= "00"; --x
            rad1src <= "0"; --x
                                            
            typ_dt <= "0000"; --x
            byte_off <= "00"; --x
                                            
            CW <= '0'; --x
            DW <= '0'; --x
        
        end if;
        
    end process;
    state_out <= state;
end architecture;

