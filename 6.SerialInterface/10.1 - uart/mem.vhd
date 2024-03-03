
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity mem is
    Generic(N : integer range 0 to 255 := 16;
            M : integer := 8);
    Port (  mem_input : in STD_LOGIC_VECTOR(M -1 downto 0);
            mem_address : in STD_LOGIC_VECTOR(integer(ceil(log2(real(N)))) - 1 downto 0); 
            clock : in STD_LOGIC;
            mem_write : in STD_LOGIC;
            mem_read : in STD_LOGIC;
            mem_output : out STD_LOGIC_VECTOR(M - 1 downto 0));
end mem;

architecture Behavioral of mem is

    type locations is array (N - 1 downto 0) of STD_LOGIC_VECTOR(M-1 downto 0);
    signal mem : locations := (others => (others => '0'));
    
    begin
        process(clock)
            begin
                if (clock'event and clock = '1') then
                    if (mem_write = '1') then
                        mem(to_integer(unsigned(mem_address))) <= mem_input;
                    end if;                    
                    if (mem_read = '1') then
                        mem_output <= mem(to_integer(unsigned(mem_address)));
                    end if;
                end if;
        end process;
        
        


end Behavioral;
