
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_mod_n_refresh is
    Generic(N_cmn : integer := 4);
    Port (  CLK_cmn : in STD_LOGIC;
            reset_cmn : in STD_LOGIC;
            q_cmn : out STD_LOGIC_VECTOR(N_cmn - 1 downto 0));
end counter_mod_n_refresh;

architecture Behavioral of counter_mod_n_refresh is
    signal temp : STD_LOGIC_VECTOR(N_cmn - 1 downto 0);

    begin
        process (CLK_cmn)
            begin
                if rising_edge(CLK_cmn) then
                    if (reset_cmn = '1') then
                        temp <= (others => '0');
                    else
                        temp <= std_logic_vector(unsigned(temp) + 1);
                    end if;
                end if;
        end process;
        q_cmn <= temp;

end Behavioral;
