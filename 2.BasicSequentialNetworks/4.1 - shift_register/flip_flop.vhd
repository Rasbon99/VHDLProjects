
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- FLIP FLOP EDGE_TRIGGERED (RISING)

entity flip_flop is
    Port (  d_ff : in STD_LOGIC;
            a_ff : in STD_LOGIC;
            r_ff : in STD_LOGIC;
            q_ff : out STD_LOGIC );
end flip_flop;

architecture Behavioral of flip_flop is

    begin
        process (a_ff)
            begin
                if rising_edge(a_ff) then      -- fronte di salita 0->1 di a_ff, memorizza d_ff
                    if (r_ff = '1') then       -- reset sincrono
                        q_ff <= '0';
                    else
                        q_ff <= d_ff;
                    end if;
                end if;
        end process;

end Behavioral;
