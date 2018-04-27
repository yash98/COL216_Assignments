
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lsl2 is
    Port ( opr1 : in STD_LOGIC_VECTOR (31 downto 0);
           shifter : in std_logic;
           carryin : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (31 downto 0);
           carryout : out STD_LOGIC);
end lsl2;

architecture Behavioral of lsl2 is

begin
output <= opr1(29 downto 0) & "00" when shifter = '1' else
          opr1;
carryout <= opr1(30) when shifter = '1' else
            carryin;

end Behavioral;
