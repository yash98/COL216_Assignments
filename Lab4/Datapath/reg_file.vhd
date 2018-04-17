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
        pc_we: in std_logic;
        pc_write: in std_logic_vector(31 downto 0);
        
        pc: out std_logic_vector(31 downto 0);
        rout1: out std_logic_vector(31 downto 0);
        rout2: out std_logic_vector(31 downto 0);
        r0: out std_logic_vector(31 downto 0);
        r1: out std_logic_vector(31 downto 0);
        r2: out std_logic_vector(31 downto 0);
        r3: out std_logic_vector(31 downto 0);
        r4: out std_logic_vector(31 downto 0);
        r5: out std_logic_vector(31 downto 0);
        r6: out std_logic_vector(31 downto 0);
        r7: out std_logic_vector(31 downto 0);
        r8: out std_logic_vector(31 downto 0);
        r9: out std_logic_vector(31 downto 0);
        r10: out std_logic_vector(31 downto 0);
        r11: out std_logic_vector(31 downto 0);
        r12: out std_logic_vector(31 downto 0);
        r13: out std_logic_vector(31 downto 0);
        r14: out std_logic_vector(31 downto 0);
        r15: out std_logic_vector(31 downto 0)   
    );
end entity;

architecture beh of reg_file is
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
        if (pc_we = '1') then
            r(15) <= pc_write;
        end if;
        if (rising_edge(clock)) then
            if (we = '1') then
            r(waddr_in) <= winp;
            end if;
        end if;
    end process;
end architecture;
