
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit_a is 
    Port (  start : in STD_LOGIC;
            address : in STD_LOGIC_VECTOR (2 downto 0);
            reset : in STD_LOGIC;
            clk : in STD_LOGIC;
            tbe : in STD_LOGIC;
            data_mem_in : in STD_LOGIC_VECTOR (7 downto 0); 
            db_in : out STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
            read : out STD_LOGIC := '0';
            wr : out STD_LOGIC := '0';
            count_enable : out STD_LOGIC := '0';
            count_reset : out STD_LOGIC := '0' );            
end control_unit_a;

architecture Behavioral of control_unit_a is

    type state is (idle, rst_counter, tx, read_state, data_out, wait_tbe);
    signal current_state : state := idle;
    signal next_state : state;
        
    begin
        
        transition_proc: process (clk)
            begin
                if (clk'event and clk = '1') then
                    if (reset = '1') then
                        current_state <= idle;
                    else 
                        current_state <= next_state;
                    end if;
                end if;
            end process;
        
        FSM: process (current_state, start, tbe)
            begin
                case current_state is 
                    
                    -- Nello stato idle, la FSM attende che il segnale di avvio sia attivo. Quando ciò accade, 
                    -- resetta il contatore e passa allo stato di reset del contatore.
                    when idle =>
                        if (start = '1') then
                            count_reset <= '1';
                            next_state <= rst_counter;
                        else 
                            next_state <= idle;
                        end if;
                            
                    -- Nello stato di reset del contatore, la FSM disattiva il 
                    -- reset del contatore e passa allo stato di trasmissione.
                    when rst_counter =>
                        count_reset <= '0';
                        next_state <= tx;
                        
                    -- Nello stato di trasmissione, la FSM attiva il segnale 
                    -- di lettura, disattiva il contatore e passa allo stato di lettura.
                    when tx => 
                        read <= '1';
                        count_enable <= '0';
                        next_state <= read_state;
                        
                    -- Nello stato di lettura, la FSM disattiva il segnale di lettura
                    -- e passa allo stato di output dei dati.
                    when read_state =>
                        read <= '0';
                        next_state <= data_out;
                        
                    -- Nello stato di output dei dati, la FSM attiva il segnale di scrittura,
                    -- trasmette i dati all'unità B e passa allo stato di attesa del buffer vuoto.
                    when data_out =>
                        wr <= '1';
                        db_in <= data_mem_in;
                        next_state <= wait_tbe;
                    
                    -- Nello stato di attesa del buffer vuoto, la FSM controlla se l'indirizzo è
                    -- "111" o se il buffer è vuoto. Se l'indirizzo è "111", significa che è arrivata
                    -- all'ultima locazione di memoria (dopo aver trasmesso 8 locazioni) e quindi disattiva
                    -- il segnale di scrittura e torna allo stato idle. Se il buffer è vuoto, abilita il
                    -- contatore e torna allo stato di trasmissione. Altrimenti, disattiva sia il segnale
                    -- di scrittura che il contatore e rimane nello stato di attesa del buffer vuoto.
                    when wait_tbe =>
                        if (address = "111") then
                            wr <= '0';
                            next_state <= idle;
                        elsif (tbe = '1') then
                            count_enable <= '1';
                            next_state <= tx;
                        else 
                            wr <= '0';
                            count_enable <= '0';
                            next_state <= wait_tbe;
                        end if;   
               
                end case;
        end process;

    
end Behavioral;
