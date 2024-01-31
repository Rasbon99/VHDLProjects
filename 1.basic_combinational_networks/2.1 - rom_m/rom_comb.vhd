
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rom_comb is
    Port ( address : in STD_LOGIC_VECTOR (3 downto 0);  -- depth: 4
           data : out STD_LOGIC_VECTOR (7 downto 0);    -- widht: 8
           enable : in STD_LOGIC);
end rom_comb;

architecture Dataflow of rom_comb is
    begin
    data <= "00000000" when (address = "0000" and enable = '1') else
            "00000001" when (address = "0001" and enable = '1') else
            "00000010" when (address = "0010" and enable = '1') else
            "00000011" when (address = "0011" and enable = '1') else
            "00000100" when (address = "0100" and enable = '1') else
            "00000101" when (address = "0101" and enable = '1') else
            "00000110" when (address = "0110" and enable = '1') else
            "00000111" when (address = "0111" and enable = '1') else
            "00001000" when (address = "1000" and enable = '1') else
            "00001001" when (address = "1001" and enable = '1') else
            "00001010" when (address = "1010" and enable = '1') else
            "00001011" when (address = "1011" and enable = '1') else
            "00001100" when (address = "1100" and enable = '1') else
            "00001101" when (address = "1101" and enable = '1') else
            "00001110" when (address = "1110" and enable = '1') else
            "00001111" when (address = "1111" and enable = '1') else
            "--------";
end Dataflow;