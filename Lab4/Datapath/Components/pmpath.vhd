library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pmpath is
    port (
    type_of_dt: in std_logic_vector(3 downto 0); -- 0/1 3(str/ldr = l) 2(word/byte = b) 1(not/halfword = H) 0(unsigned/signed = S)
    byte_offset: in std_logic_vector(1 downto 0);
    data_from_reg: in std_logic_vector(31 downto 0);
    data_from_mem: in std_logic_vector(31 downto 0);
    
    
    data_to_mem: out std_logic_vector(31 downto 0);
    data_to_reg: out std_logic_vector(31 downto 0);
    mem_write_en: out std_logic_vector(3 downto 0)
    
    );
end entity;

architecture beh of pmpath is
signal inp: std_logic_vector(31 downto 0);
signal outp: std_logic_vector(31 downto 0);
begin
    -- ldr or str
    inp <= data_from_reg when type_of_dt(3) = '0' else
        data_from_mem when type_of_dt(3) = '1';
    data_to_mem <= outp when type_of_dt(3) = '0';
    data_to_reg <= outp when type_of_dt(3) = '1';


end architecture;