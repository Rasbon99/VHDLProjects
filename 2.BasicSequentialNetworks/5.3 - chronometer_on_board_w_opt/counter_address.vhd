
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity counter_address is
    Generic(N_cmn : integer range 0 to 255 := 4);
    Port (  CLK_cmn : in STD_LOGIC;
            reset_cmn : in STD_LOGIC;
            enable_cmn : in STD_LOGIC;
            q_cmn : out STD_LOGIC_VECTOR(integer(ceil(log2(real(N_cmn)))) - 1 downto 0));
end counter_address;

architecture Behavioral of counter_address is

    signal temp : STD_LOGIC_VECTOR(integer(ceil(log2(real(N_cmn)))) - 1 downto 0);

    begin
        process (CLK_cmn)
            begin
                if rising_edge(CLK_cmn) then
                    if (reset_cmn = '1') then
                        temp <= (others => '0');
                    elsif (enable_cmn = '1') then
                        temp <= std_logic_vector(unsigned(temp) + 1);
                    end if;
                end if;
        end process;
        
        q_cmn <= temp;

end Behavioral;
