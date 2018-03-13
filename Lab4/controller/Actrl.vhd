library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;  

entity Actrl is
    port (
        ins27_21: in std_logic_vector(6 downto 0);
        op: out std_logic_vector(3 downto 0)
    );    
end entity;

architecture beh of Actrl is
begin
    op <= ins27_21(3 downto 0);  
end architecture;