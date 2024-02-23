
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity rom_seq is
    Generic(N : integer range 0 to 255 := 16;
            M : integer := 8);
    Port(   rom_address : in STD_LOGIC_VECTOR (integer(ceil(log2(real(N))))- 1 downto 0);
            rom_output : out STD_LOGIC_VECTOR (M-1 downto 0);
            clock : in STD_LOGIC;
            rom_read : in STD_LOGIC);
end rom_seq;

architecture Behavioral of rom_seq is
    
    type locations is array (N - 1 downto 0) of STD_LOGIC_VECTOR(M-1 downto 0);
    signal rom : locations := (others => (others => '0'));
    
    begin
    
        -- Creiamo N locazioni a 8 bit con dati incrementati di 1 ad ogni posizione
        iter: for i in 0 to N - 1 GENERATE
        
            rom(i) <= STD_LOGIC_VECTOR(to_unsigned(i+1, 8));
        
        END GENERATE;
    
    
        process(clock)
            begin
                if (clock'event and clock = '1') then
                    if (rom_read = '1') then
                        rom_output <= rom(to_integer(unsigned(rom_address)));
                    end if;
                end if;
    
        end process;

end Behavioral;

