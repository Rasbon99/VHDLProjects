    
    library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;
    
    -- CONTATORE MOD N, GENERICO PER ESSERE ISTANZIATO COME:
    -- - NANO_COUNTER, con selection_cmn = 0 e N = 27 -> conteggio fino a 99999999
    -- - SEC_COUNTER, con selection_cmn = 1 e N = 6 -> conteggio fino a 59
    -- - MIN_COUNTER, con selection_cmn = 1 e N = 6 -> conteggio fino a 59
    -- - HOUR_COUNTER, con selection_cmn = 2 e N = 5 -> conteggio fino a 23
    
    entity counter_mod_n is
        Generic(N_cmn : integer := 6;
                selection_cmn : integer range 0 to 2);                             
        Port (  CLK_cmn : in STD_LOGIC;
                reset_cmn : in STD_LOGIC;
                input_cmn : in integer := 0;
                load_cmn : in STD_LOGIC;
                enable_cmn : in STD_LOGIC;
                q_cmn : out integer := 0;
                co_cmn : out STD_LOGIC);
    end counter_mod_n;
    
    architecture Behavioral of counter_mod_n is
        signal count_temp : STD_LOGIC_VECTOR(N_cmn - 1 downto 0);
        signal co_interrupt : STD_LOGIC_VECTOR (N_cmn - 1 downto 0);
    
        begin
        
            with selection_cmn select
                co_interrupt <= "101111101011110000011111111" when 0,       -- interruzione del counter 1s = 99999999 
                                "111011" when 1,                            -- interruzione del counter 1 min/1 hour = 59 
                                "10111" when 2;                             -- interruzione del counter 1 gg = 23
    
            counter_proc : process (CLK_cmn)
                begin
                    if rising_edge(CLK_cmn) then
                        if (reset_cmn = '1') then
                            count_temp <= (others => '0');
                        elsif (load_cmn = '1') then
                            count_temp <= std_logic_vector(to_unsigned(input_cmn, N_cmn));
                        elsif (enable_cmn = '1') then
                            if (count_temp = co_interrupt) then
                                count_temp <= (others => '0');
                            else
                                count_temp <= std_logic_vector(unsigned(count_temp) + 1);
                            end if; 
                        end if;     
                    end if;
            end process;
    
            q_cmn <= to_integer(unsigned(count_temp));
            
            -- co_cmn: segnale di conclusione di conteggio, è l'abilitazione del
            -- prossimo contatore: sec, min, hour. Solo nano ha sempre l'abilitazione alta.
            -- L'aggiornamento è posto fuori al process in quanto vogliamo che il 
            -- segnale si attivi esattamente alla verifica della condizione di fine.
            
            co_cmn <= '1' when count_temp = co_interrupt and enable_cmn = '1' else '0';
    
    end Behavioral;
