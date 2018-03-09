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
        Asrc1: in std_logic_vector(2 downto 0); -- pick pc for inc. or rf out1 for calc
        Asrc2: in std_logic_vector(4 downto 0); -- choose from rf out 2 or 4 (for pc+4 step) or Imm or offset for branch
        op: in std_logic_vector(3 downto 0);  -- op code for alu
        Fset: in std_logic; -- set flags along command
        ReW: in std_logic;  -- reg store write enable
        
        -- self defined
        cin: in std_logic; -- for alu
        clock: in std_logic;
        pc_reset: in std_logic; -- for reg_file pc <= 0
        
        shiftSrc: in std_logic;
        
        
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
signal F: std_logic_vector(4 downto 0);

-- connections
signal ins: std_logic_vector(31 downto 0);
signal mem_out: std_logic_vector(31 downto 0);
signal dr_out: std_logic_vector(31 downto 0);
signal M2R_choose: std_logic_vector(31 downto 0);
signal Rsrc_choose: std_logic_vector(3 downto 0);
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
signal lorD_out: std_logic_vector(31 downto 0);
signal pc_o: std_logic_vector(31 downto 0);

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
    raddr1 => ins(19 downto 16),
    raddr2 => Rsrc_choose,
    winp => m2r_choose,
    waddr => ins(15 downto 0),
    we => RW,
    clock => clock,
    reset => pc_reset,
    pc_set => PW,

    pc => pc_o,
    rout1 => rd1_out,
    rout2 => rd2_out
);
pc_out <= pc_o;

MEM: entity work.memory_block_wrapper port map (
    BRAM_PORTA_0_addr => lorD_out,
    BRAM_PORTA_0_clk => clock,
    BRAM_PORTA_0_din => B_out,
    BRAM_PORTA_0_dout => mem_out,
    BRAM_PORTA_0_en => '1',
    BRAM_PORTA_0_we => MW
);

SHIFTER: entity work.shifter port map (
    a => shiftSrc_out,
    result => shifter_out,
    typ => ins(6 downto 5),
    amt => amtSrc_out,
    carry => c_from_shifter
);




-- all muxes
-- shifter mux
shiftSrc_out <= B_out when shiftSrc = '0' else
                "000000000000000000000000" & ins(7 downto 0);

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