library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shifter is
    port (
        a: in std_logic_vector(31 downto 0);
        result: out std_logic_vector(31 downto 0);
        typ: in std_logic_vector(3 downto 0);
        amt: in std_logic(4 downto 0);
        carry: out std_logic
    );   
    
architecture beh of alu is
begin
    process(a,b,operation)
    begin    
    if (operation = "0100") then


end entity;