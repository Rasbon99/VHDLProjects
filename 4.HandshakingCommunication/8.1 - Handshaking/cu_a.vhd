library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cu_a is
    Generic(N : integer := 16;
            M : integer := 8);
    Port(   clock : in STD_LOGIC;
            reset : in STD_LOGIC;
            mem_read : out STD_LOGIC;
            mem_data_in : in STD_LOGIC_VECTOR (M-1 downto 0);
            counter_enable : out STD_LOGIC;
            counter_reset : out STD_LOGIC;
            address : in STD_LOGIC_VECTOR (integer(ceil(log2(real(N))))-1 downto 0);
            start : in STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR (M-1 downto 0);
            req : out STD_LOGIC;
            done : in STD_LOGIC;
            ack : in STD_LOGIC);
end cu_a;

architecture Behavioral of cu_a is

    type state is (idle, reset_counter, read, wait_ack);
    signal current_state : state := idle;
    signal next_state : state;
    
    signal data_out_reg : STD_LOGIC_VECTOR(M-1 downto 0) := (others => '0');
    signal req_temp : STD_LOGIC := '0';

    begin
    
        trans_proc: process (clock)
            begin
                if (clock'event and clock = '1') then
                    if (reset = '1') then
                        current_state <= idle;
                    else
                        current_state <= next_state;
                        req <= req_temp;
                    end if;
                end if;
        end process;
        
        FSM: process (current_state, start, ack)
            begin
                case current_state is
                    when idle =>
                        -- Se il nodo A riceve un segnale di start, resetta il contatore e passa allo stato reset_counter
                        if (start = '1') then
                            counter_reset <= '1';
                            next_state <= reset_counter;
                        else
                            next_state <= idle;
                        end if;
                        
                    when reset_counter =>
                        -- Dopo aver resettato il contatore, il nodo A inizia a leggere i dati dalla memoria e invia una richiesta al nodo B
                        counter_reset <= '0';
                        mem_read <= '1';
                        req_temp <= '1';
                        next_state <= read;
                        
                    when read =>
                        -- Se il nodo A non ha ricevuto un segnale di acknowledgement, invia i dati letti al nodo B e passa allo stato wait_ack
                        counter_enable <= '0';
                        if(ack = '0') then
                            data_out_reg <= mem_data_in;
                            mem_read <= '0';
                            req_temp <= '1';
                            next_state <= wait_ack;
                        else
                            next_state <= read;
                        end if;
                        
                    when wait_ack =>
                        -- Se il nodo A riceve un segnale di acknowledgement, legge il prossimo dato dalla memoria e torna allo stato read,
                        --  se invece riceve il segnale di done ritorna in idle
                        if (done = '1') then
                            req_temp <= '0';
                            next_state <= idle;
                        elsif (ack = '1') then
                            mem_read <= '1';
                            counter_enable <= '1';
                            req_temp <= '0';
                            next_state <= read;
                        else
                            next_state <= wait_ack;
                        end if;
                end case;
        end process;

        data_out <= data_out_reg;
        
end Behavioral;