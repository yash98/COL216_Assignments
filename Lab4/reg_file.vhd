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

architecture beh of reg_file is
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

    process(rising_edge(clock))
    begin

    end process;
end architecture;