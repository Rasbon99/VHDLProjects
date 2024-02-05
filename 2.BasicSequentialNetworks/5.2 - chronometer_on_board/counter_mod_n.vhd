
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_mod_n is
    Generic(N_cmn : integer := 6;
            selection_cmn : integer range 0 to 2);                             
    Port (  CLK_cmn : in STD_LOGIC;
            reset_cmn : in STD_LOGIC;
            input_cmn : in integer := 0;
            load_cmn : in STD_LOGIC;
            q_cmn : out integer := 0;
            co_cmn : out STD_LOGIC);
end counter_mod_n;

architecture Behavioral of counter_mod_n is
    signal temp : STD_LOGIC_VECTOR(N_cmn - 1 downto 0);
    signal internal_reset : STD_LOGIC;
    signal co_interrupt : STD_LOGIC_VECTOR (N_cmn - 1 downto 0);    

    begin
    
        with selection_cmn select
            co_interrupt <= "101111101011110000011111111" when 0,       -- interruzione del counter 1s = 99999999 
                            "111011" when 1,                            -- interruzione del counter 1 min/1 hour = 59 
                            "10111" when 2;                             -- interruzione del counter 1 gg = 23

        counter_proc : process (CLK_cmn, reset_cmn)
            begin
                if (reset_cmn = '1') then
                        temp <= (others => '0');
                        co_cmn <= '0';
                elsif rising_edge(CLK_cmn) then
                        if (temp = co_interrupt) then
                            temp <= (others => '0');
                            co_cmn <= '1';
                        elsif (load_cmn = '1') then
                            temp <= std_logic_vector(to_unsigned(input_cmn, N_cmn));
                            co_cmn <= '0';
                        else
                            temp <= std_logic_vector(unsigned(temp) + 1);
                            co_cmn <= '0';
                        end if;                        
                end if;
        end process;
        
        
        q_cmn <= to_integer(unsigned(temp));

end Behavioral;
