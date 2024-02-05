
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity chronometer is
    Port (  sec_input : in integer range 0 to 59;
            min_input : in integer range 0 to 59;
            hour_input : in integer range 0 to 23;
            load : in STD_LOGIC := '0';
            reset : in STD_LOGIC := '1';
            clk : in STD_LOGIC := '0';
            nano_output : out integer;
            sec_output : out integer range 0 to 59;
            min_output : out integer range 0 to 59;
            hour_output : out integer range 0 to 23);
end chronometer;

architecture Structural of chronometer is
        
    component counter_mod_n is
        Generic(N_cmn : integer := 6;
                selection_cmn : integer range 0 to 2);                             
        Port (  CLK_cmn : in STD_LOGIC;
                reset_cmn : in STD_LOGIC;
                input_cmn : in integer := 0;
                load_cmn : in STD_LOGIC;
                q_cmn : out integer := 0;
                co_cmn : out STD_LOGIC);
    end component;
    
    component mux2_1 is
        Port ( a : in STD_LOGIC_VECTOR (1 downto 0);
               s : in STD_LOGIC;
               y : out STD_LOGIC);
    end component;
    
    signal co_nano : STD_LOGIC := '0';
    signal co_sec : STD_LOGIC := '0';
    signal co_min : STD_LOGIC := '0';
    signal co_hour : STD_LOGIC := '0';
    
    -- new_day: reset interno, controllato dall'ultimo
    -- contatore delle ore che arrivato a 23 si azzera
    -- e alza il seganle di new day -> reset per tutti
    -- i precedenti coontatori.
    signal new_day : STD_LOGIC := '0';
    
    -- mux_out: wire di collegamento tra l'uscita del
    -- mux e l'ingresso dei contatori. 
    signal mux_out : STD_LOGIC_VECTOR (2 downto 0);

    begin
    
        -- Mux controllati dal segnale di load, permettono di abilitare
        -- i contatori mettendo in ingresso a tutti il clock e ponendo
        -- valori di input per l'orario desiderato. Il contatore non
        -- avanza perchè per load alto carica il valore di input.
    
        mux0 : mux2_1 port map (a(0) => co_nano, a(1) => clk, s => load, y => mux_out(0));
        mux1 : mux2_1 port map (a(0) => co_sec, a(1) => clk, s => load, y => mux_out(1));
        mux2 : mux2_1 port map (a(0) => co_min, a(1) => clk, s => load, y => mux_out(2));
        
--        Questo contatore genera il conteggio di 1 s
--        Essendo la f = 100MHz del clock, quindi un T = 10 ns
--        ho bisogno di un contatore mod-10^8 perchè 1s = 10^8*T
--        quindi mi servono log2(10^8) ~ 27 bit -> flip-flop,
--        di conseguenza a 10^8 - 1 = 101111101011110000011111111 dò
--        il segnale di reset = '1' creando un contatore per riduzione
--        ad incremento costante pari a 1.
    
        nano_counter : counter_mod_n generic map (N_cmn => 27, selection_cmn => 0) port map(
            CLK_cmn => clk,
            reset_cmn => new_day,
            input_cmn => 0,
            load_cmn => load,
            q_cmn => nano_output,
            co_cmn => co_nano);
        
        sec_counter : counter_mod_n generic map (N_cmn => 6, selection_cmn => 1) port map(
            CLK_cmn => mux_out(0),             
            reset_cmn => new_day,
            input_cmn => sec_input,
            load_cmn => load,
            q_cmn => sec_output,        
            co_cmn => co_sec);
              
        min_counter : counter_mod_n generic map (N_cmn => 6, selection_cmn => 1) port map(
            CLK_cmn => mux_out(1),
            reset_cmn => new_day,
            input_cmn => min_input,
            load_cmn => load,
            q_cmn => min_output,        
            co_cmn => co_min);

        hour_counter : counter_mod_n generic map (N_cmn => 5, selection_cmn => 2) port map(
            CLK_cmn => mux_out(2),
            reset_cmn => new_day,
            input_cmn => hour_input,
            load_cmn => load,
            q_cmn => hour_output,        
            co_cmn => co_hour);
            
        new_day <= reset or co_hour;
            

end Structural;
