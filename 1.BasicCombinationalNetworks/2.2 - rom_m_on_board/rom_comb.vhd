
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rom_comb is
    Port ( address : in STD_LOGIC_VECTOR (3 downto 0):= "0000";  -- depth: 4
           data : out STD_LOGIC_VECTOR (7 downto 0):= "00000000");    -- widht: 8
end rom_comb;

architecture Dataflow of rom_comb is
    begin
    data <= "00000000" when (address = "0000") else
            "00000001" when (address = "0001") else
            "00000010" when (address = "0010") else
            "00000011" when (address = "0011") else
            "00000100" when (address = "0100") else
            "00000101" when (address = "0101") else
            "00000110" when (address = "0110") else
            "00000111" when (address = "0111") else
            "00001000" when (address = "1000") else
            "00001001" when (address = "1001") else
            "00001010" when (address = "1010") else
            "00001011" when (address = "1011") else
            "00001100" when (address = "1100") else
            "00001101" when (address = "1101") else
            "00001110" when (address = "1110") else
            "00001111" when (address = "1111") else
            "--------";
end Dataflow;