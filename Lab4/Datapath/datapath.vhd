library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use ieee.numeric_std;

entity datapath is
    port (
        -- figure defined inputs from controller
        PW: in std_logic;   -- write to pc when 1
        IorD: in std_logic_vector(1 downto 0); -- Instruction (1) or PC inc. (0)
        MW: in std_logic_vector(0 downto 0); -- memory write enable, vector required for wrappper
        IW: in std_logic; -- Instruction write/save enable
        DW: in std_logic; -- data register write enable
        M2R: in std_logic_vector(1 downto 0); -- pick data or result to write to register file
        Rsrc: in std_logic_vector(1 downto 0); -- pick rd or rm for rad2
        RW: in std_logic; -- write enable for register file
        AW: in std_logic;  -- rf out1 store reg write enable
        BW: in std_logic;  -- rf out2 store B reg write enable
        XW: in std_logic;  -- rf out2 store X reg write enable
        Asrc1: in std_logic_vector(0 downto 0); -- pick pc for inc. or rf out1 for calc
        Asrc2: in std_logic_vector(4 downto 0); -- choose from rf out 2 or 4 (for pc+4 step) or Imm or offset for branch
        op: in std_logic_vector(3 downto 0);  -- op code for alu
        Fset: in std_logic; -- set flags along command
        ReW: in std_logic;  -- reg store write enable
        
        -- self defined
        cin: in std_logic; -- for alu
        clock: in std_logic;
        pc_reset: in std_logic; -- for reg_file pc <= 0
        
        shiftSrc: in std_logic_vector(1 downto 0);
        amtSrc: in std_logic_vector(1 downto 0);
        wadsrc: in std_logic_vector(1 downto 0);
        rad1src: in std_logic_vector(0 downto 0);
        
        
        pc_out: out std_logic_vector(31 downto 0);
        Flags: out std_logic_vector(3 downto 0)
    );
end entity;

architecture beh of datapath is
-- registers
signal IR: std_logic_vector(31 downto 0);
signal DR: std_logic_vector(31 downto 0);
signal RES: std_logic_vector(31 downto 0);
signal A: std_logic_vector(31 downto 0);
signal B: std_logic_vector(31 downto 0);
signal X: std_logic_vector(31 downto 0);
signal F: std_logic_vector(3 downto 0);
 
-- connections
signal ins: std_logic_vector(31 downto 0);
signal mem_out: std_logic_vector(31 downto 0);
signal dr_out: std_logic_vector(31 downto 0);
signal M2R_out: std_logic_vector(31 downto 0);
signal Rsrc_out: std_logic_vector(3 downto 0);
signal rd1_out: std_logic_vector(31 downto 0);
signal rd2_out: std_logic_vector(31 downto 0);
signal A_out: std_logic_vector(31 downto 0);
signal B_out: std_logic_vector(31 downto 0);
signal X_out: std_logic_vector(31 downto 0);
signal Asrc1_out: std_logic_vector(31 downto 0);
signal Asrc2_out: std_logic_vector(31 downto 0);
signal c_from_shifter: std_logic;
signal alu_out: std_logic_vector(31 downto 0);
signal f_out: std_logic_vector(3 downto 0);
signal shiftSrc_out: std_logic_vector(31 downto 0);
signal amtSrc_out: std_logic_vector(4 downto 0);
signal shifter_out: std_logic_vector(31 downto 0);
signal b_off_out: std_logic_vector(31 downto 0);
signal four: std_logic_vector(31 downto 0):= "00000000000000000000000000000100";
signal res_out: std_logic_vector(31 downto 0);
signal IorD_out: std_logic_vector(31 downto 0);
signal pc_o: std_logic_vector(31 downto 0);
signal mul_out: std_logic_vector(31 downto 0);

signal wadsrc_out: std_logic_vector(3 downto 0);
signal rad1src_out: std_logic_vector(3 downto 0);
signal MW_bus: std_logic_vector(3 downto 0);

begin
-- components
ALU: entity work.alu port map (
    a => Asrc1_out,
    b => Asrc2_out,
    operation => op,
    carryIn => cin,
    c_in_from_shifter => c_from_shifter,
    result => alu_out,
    flags => f_out
);

RF: entity work.reg_file port map (
    raddr1 => rad1src_out,
    raddr2 => Rsrc_out,
    winp => m2r_out,
    waddr => wadsrc_out,
    we => RW,
    clock => clock,
    reset => pc_reset,

    pc => pc_o,
    rout1 => rd1_out,
    rout2 => rd2_out
);
pc_out <= pc_o;

MW_bus <= MW & MW & MW & MW;
MEM: entity work.memory_block_wrapper port map (
    BRAM_PORTA_0_addr => IorD_out,
    BRAM_PORTA_0_clk => clock,
    BRAM_PORTA_0_din => B_out,
    BRAM_PORTA_0_dout => mem_out,
    BRAM_PORTA_0_en => '1',
    BRAM_PORTA_0_we => MW_bus
);

SHIFTER: entity work.shifter port map (
    a => shiftSrc_out,
    result => shifter_out,
    typ => ins(6 downto 5),
    amt => amtSrc_out,
    carry => c_from_shifter
);

MUL: entity work.multiplier port map (
    a => B_out,
    b => X_out,
    s => mul_out
);


-- all muxes
-- shifter mux
shiftSrc_out <= B_out when shiftSrc = "00" else
                "000000000000000000000000" & ins(7 downto 0) when shiftSrc = "01" else
                "00000000" & ins(23 downto 0);
                
-- amt mux
amtSrc_out <= X_out(4 downto 0) when amtSrc = "00" else
                "00010" when amtSrc = "01" else
                ins(11 downto 7) when amtSrc = "10" else
                ins(11 downto 7) when amtSrc = "11";

-- Asrc2 mux
Asrc2_out <= shifter_out when Asrc2 = "00" else
                four when Asrc2 = "01" else
                mul_out;

-- Asrc1 mux
Asrc1_out <= pc_o when Asrc1 = "0" else
                A_out;
                
-- IorD mux
IorD_out <= alu_out when IorD = "0" else
            pc_o;
            
-- Rsrc mux
Rsrc_out <= ins(3 downto 0) when Rsrc = "0" else
            ins(15 downto 12);
            
-- m2r mux
m2r_out <= dr_out when dr = "0" else
            RES_out;
            
-- wadsrc mux
wadsrc_out <= ins(15 downto 12) when wadsrc = "00" else
                ins(19 downto 16) when wadsrc = "01" else
                "1111";    

-- rad1src 
rad1src_out <= ins(19 downto 16) when rad1src = "0" else ins(15 downto 12);

-- datapath internal registers
-- flags registers
F <= f_out when Fset = '1';
Flags <= F;

-- RES reg set
RES <= alu_out when ReW = '1';
res_out <= RES;

--  A and B and X reg
A <= rd1_out when AW = '1';
B <= rd2_out when BW = '1';
X <= rd2_out when XW = '1';
A_out <= A;
B_out <= B;
X_out <= X;

-- IR and DR reg
IR <= mem_out when IW = '1';
ins <= IR;
DR <= mem_out when DW = '1';
dr_out <= DR;

end architecture;