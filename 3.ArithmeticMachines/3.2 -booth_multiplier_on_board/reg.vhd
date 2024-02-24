library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
    Generic(N : integer := 8);
    Port(   clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            data_in : in STD_LOGIC_VECTOR (N-1 downto 0);
            load : in STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR (N-1 downto 0));
end reg;

architecture Behavioral of reg is
    
    signal reg : STD_LOGIC_VECTOR (N-1 downto 0);
    
    begin
        process(clk)
        begin
            if (clk'event and clk = '1') then
                if (reset = '1') then
                    reg <= (others => '0');
                elsif (load = '1') then
                    reg <= data_in;
                end if;
            end if;
        end process;
        
        data_out <= reg;
end Behavioral;
