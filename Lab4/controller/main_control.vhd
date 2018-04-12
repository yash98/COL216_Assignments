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
signal state: integer := 1;
signal wait_count: std_logic_vector(1 downto 0);

begin
    process(clock)
    begin
        if(rising_edge(clock)) then
            if (state = 1) then
                if (ins(27 downto 25) = "00") then
                    --DP
                    if ((ins(24 downto 23) = "00") and (ins(7 downto 4) = "1001")) then
                        state <= 9;
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
    end process;
    
    process(clock)
    begin
        --PC=PC+4 and IR = Mem[PC]
        if (state = 1) then
            PW <= '1';
            IorD <= "0";
            IRW <= '1';
            DRW <= '0'; --x
            M2R <= "0"; --x
            Rsrc <= "0"; --x
            RW <= '0'; --x
            AW <= '0'; --x
            BW <= '0'; --x
            XW <= '0'; --x
            Asrc1 <= "0";
            Asrc2 <= "1";
            op <= "0100";
            Fset <= '0';
            ReW <= '0';
            
            -- self defined
            pc_reset <= '0'; --x
            
            shiftSrc <= "00"; --x
            amtSrc <= "00"; --x
            wadsrc <= "0000"; --x
            rad1src <= "0";
            
            typ_dt <= "00";
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
            Rsrc <= "1";
            RW <= '0'; --x
            AW <= '1';
            BW <= '1';
            XW <= '0'; --x
            Asrc1 <= "1"; --x
            Asrc2 <= "0"; --x
            op <= "0000"; --x
            Fset <= '0'; --x
            ReW <= '0'; --x
            
            -- self defined
            pc_reset <= '0'; --x
            
            shiftSrc <= "00"; --x
            amtSrc <= "00"; --x
            wadsrc <= "0000"; --x
            rad1src <= "0";
            
            typ_dt <= "00";
            byte_off <= "00";
            
            CW <= '0'; --x
            DW <= '0'; --x
        
        --X=ins[11-8]    
        elsif (state = 3) then
            PW <= '0';
            IorD <= "0"; --x
            IRW <= '0'; --x
            DRW <= '0'; --x
            M2R <= "0"; --x
            Rsrc <= "0";
            RW <= '0'; --x
            AW <= '0';
            BW <= '0';
            XW <= '1';
            Asrc1 <= "1";
            Asrc2 <= "0"; --x
            op <= "0000"; --x
            Fset <= '0';
            ReW <= '0';
            
            -- self defined
            pc_reset <= '0'; --x
            
            shiftSrc <= "00"; --x
            amtSrc <= "00"; --x
            wadsrc <= "0000"; --x
            rad1src <= "0"; --x
            
            typ_dt <= "00";
            byte_off <= "00";
            
            CW <= '0'; --x
            DW <= '0'; --x
        
        -- shiftSrc = ins[3-0] and amtSrc = ins[11-8]&'0' and Shifter "ROR" mode    (DP instruction without shift)
        elsif (state = 4) then
            PW <= '0';
            IorD <= "0"; --x
            IRW <= '0'; --x
            DRW <= '0'; --x
            M2R <= "0"; --x
            Rsrc <= "0"; --x
            RW <= '0'; --x
            AW <= '0';
            BW <= '0';
            XW <= '0';
            Asrc1 <= "1";
            Asrc2 <= "0"; --x
            op <= "0000"; --x
            Fset <= '0';
            ReW <= '0';
            
            -- self defined
            pc_reset <= '0'; --x
            
            shiftSrc <= "01";
            amtSrc <= "11";
            wadsrc <= "0000"; --x
            rad1src <= "0"; --x
            
            typ_dt <= "00"; --x
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
            Rsrc <= "0"; --x
            RW <= '0'; --x
            AW <= '0';
            BW <= '0';
            XW <= '0';
            Asrc1 <= "1";
            Asrc2 <= "0"; --x
            op <= "0000"; --x
            Fset <= '0';
            ReW <= '0';
            
            -- self defined
            pc_reset <= '0'; --x
            
            shiftSrc <= "00";
            amtSrc <= "10";
            wadsrc <= "0000"; --x
            rad1src <= "0"; --x
            
            typ_dt <= "00"; --x
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
            Rsrc <= "0"; --x
            RW <= '0'; --x
            AW <= '0';
            BW <= '0';
            XW <= '0';
            Asrc1 <= "1";
            Asrc2 <= "0"; --x
            op <= "0000"; --x
            Fset <= '0';
            ReW <= '0';
            
            -- self defined
            pc_reset <= '0'; --x
            
            shiftSrc <= "00";
            amtSrc <= "00";
            wadsrc <= "0000"; --x
            rad1src <= "0"; --x
            
            typ_dt <= "00"; --x
            byte_off <= "00"; --x
            
            CW <= '1';
            DW <= '1';
        
        -- ALU Step 
        elsif (state = 7) then
            PW <= '0';
            IorD <= "0"; --x
            IRW <= '0'; --x
            DRW <= '0'; --x
            M2R <= "0"; --x
            Rsrc <= "0"; --x
            RW <= '0'; --x
            AW <= '0';
            BW <= '0';
            XW <= '0';
            Asrc1 <= "1";
            Asrc2 <= "0"; --x
            op <= ins(24 downto 21); --x
            Fset <= '1';
            ReW <= '1';
            
            -- self defined
            pc_reset <= '0'; --x
            
            shiftSrc <= "00";
            amtSrc <= "00";
            wadsrc <= "0000"; --x
            rad1src <= "0"; --x
            
            typ_dt <= "00"; --x
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
            Rsrc <= "0"; --x
            RW <= '1'; 
            AW <= '0'; --x
            BW <= '0'; --x
            XW <= '0'; --x
            Asrc1 <= "1"; --x
            Asrc2 <= "0"; --x
            op <= "0000"; --x
            Fset <= '0';
            ReW <= '0';
            
            -- self defined
            pc_reset <= '0'; --x
            
            shiftSrc <= "00"; --x
            amtSrc <= "00"; --x
            wadsrc <= "0000";
            rad1src <= "0"; --x
            
            typ_dt <= "00"; --x
            byte_off <= "00"; --x
            
            CW <= '0'; --x
            DW <= '0'; --x
        
        
        --A=ins[15-12] and B=ins[3-0]    
        elsif (state = 9) then
            PW <= '0';
            IorD <= "0"; --x
            IRW <= '0'; --x
            DRW <= '0'; --x
            M2R <= "1";
            Rsrc <= "0"; --x
            RW <= '1'; 
            AW <= '0'; --x
            BW <= '0'; --x
            XW <= '0'; --x
            Asrc1 <= "1"; --x
            Asrc2 <= "0"; --x
            op <= "0000"; --x
            Fset <= '0';
            ReW <= '0';
                
                -- self defined
            pc_reset <= '0'; --x
                
            shiftSrc <= "00"; --x
            amtSrc <= "00"; --x
            wadsrc <= "0000";
            rad1src <= "0"; --x
                
            typ_dt <= "00"; --x
            byte_off <= "00"; --x
                
            CW <= '0'; --x
            DW <= '0'; --x            
            
         




        end if;
    end process;
    
end architecture;

