
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit_b is 
    Port (  address : in STD_LOGIC_VECTOR (2 downto 0);
            reset : in STD_LOGIC;
            clk : in STD_LOGIC;
            rda : in STD_LOGIC;
            rxd : in STD_LOGIC;
            db_out : in STD_LOGIC_VECTOR (7 downto 0);
            data_mem_out : out STD_LOGIC_VECTOR (7 downto 0); 
            write : out STD_LOGIC;
            rd : out STD_LOGIC;
            count_enable : out STD_LOGIC;
            count_reset : out STD_LOGIC);            
end control_unit_b;

architecture Behavioral of control_unit_b is

    type state is (idle, rst_counter, rx, wait_db, write_state, wait_rda);
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
        
        FSM: process (current_state, rxd, rda)
            begin
                case current_state is 
                    
                    -- Nello stato idle, la FSM attende che il segnale di ricezione dei dati sia attivo.
                    -- Quando ciò accade, resetta il contatore e passa allo stato di reset del contatore.
                    when idle =>
                        if (rxd = '0') then
                            count_reset <= '1';
                            next_state <= rst_counter;
                        else 
                            next_state <= idle;
                        end if;
                            
                    -- Nello stato di reset del contatore, la FSM attende che il segnale di disponibilità
                    -- dei dati sia attivo. Quando ciò accade, disattiva il reset del contatore e passa allo stato di ricezione.
                    when rst_counter =>
                        if (rda = '1') then
                            count_reset <= '0';
                            next_state <= rx;
                        else
                            next_state <= rst_counter;
                        end if;
                        
                    -- Nello stato di ricezione, la FSM attiva il segnale di lettura, disattiva il contatore,
                    -- trasmette i dati ricevuti alla memoria e passa allo stato di attesa dei dati.
                    when rx => 
                        rd <= '1';
                        count_enable <= '0';
                        data_mem_out <= db_out;
                        next_state <= wait_db;
                    
                    -- Nello stato di attesa dei dati, la FSM disattiva il segnale di lettura, attiva il segnale
                    -- di scrittura e passa allo stato di scrittura.
                    when wait_db =>
                        rd <= '0';
                        write <= '1';
                        next_state <= write_state;
                    
                    -- Nello stato di scrittura, la FSM disattiva il segnale di scrittura e
                    -- passa allo stato di attesa della disponibilità dei dati.
                    when write_state =>
                        write <= '0';
                        next_state <= wait_rda;
                    
                    -- Nello stato di attesa della disponibilità dei dati, la FSM controlla se
                    -- l'indirizzo è "111" o se i dati sono disponibili. Se l'indirizzo è "111",
                    -- significa che è arrivata all'ultima locazione di memoria (dopo aver ricevuto
                    -- 8 locazioni) e quindi torna allo stato idle. Se i dati sono disponibili, abilita
                    -- il contatore e torna allo stato di ricezione. Altrimenti, rimane nello stato di
                    -- attesa della disponibilità dei dati.
                    when wait_rda => 
                        if (address = "111") then
                            next_state <= idle;
                        elsif (rda = '1') then
                            count_enable <= '1';
                            next_state <= rx;
                        else 
                            next_state <= wait_rda;
                        end if;   
               
                end case;
        end process;

    
end Behavioral;
