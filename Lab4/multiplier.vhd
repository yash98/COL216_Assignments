library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use ieee.numeric_std;

entity multipliter is
    port (
        a: in std_logic_vector(31 downto 0);
        b: in std_logic_vector(31 downto 0);
        s: out std_logic_vector(31 downto 0);
    );
end entity;

architecture beh of multiplier is
signal res: std_logic_vector (0 to 63);
begin
    res <= a*b;
    s <= res(31 downto 0);
end architecture;