
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
                enable_cmn : in STD_LOGIC;
                q_cmn : out integer := 0;
                co_cmn : out STD_LOGIC);
    end component;

    signal co_nano : STD_LOGIC := '0';
    signal co_sec : STD_LOGIC := '0';
    signal co_min : STD_LOGIC := '0';
    signal co_hour : STD_LOGIC := '0';    
    
    begin
--        Questo contatore genera il conteggio di 1 s
--        Dato che la f = 100MHz del clock, quindi un T = 10 ns
--        ho bisogno di un contatore mod-10^8 perchè 1s = 10^8*T
--        quindi mi servono log2(10^8) ~ 27 bit -> flip-flop,
--        di conseguenza a 10^8 - 1 = 101111101011110000011111111 dò
--        il segnale di co_nano = '1' e azzero il conteggio, 
--        creando un contatore per riduzione ad incremento costante.
    
        nano_counter : counter_mod_n generic map (N_cmn => 27, selection_cmn => 0) port map(
            CLK_cmn => clk,
            reset_cmn => reset,
            input_cmn => 0,
            load_cmn => load,
            enable_cmn => '1',
            q_cmn => nano_output,
            co_cmn => co_nano);
        
        sec_counter : counter_mod_n generic map (N_cmn => 6, selection_cmn => 1) port map(
            CLK_cmn => clk,             
            reset_cmn => reset,
            input_cmn => sec_input,
            load_cmn => load,
            enable_cmn => co_nano,
            q_cmn => sec_output,        
            co_cmn => co_sec);
              
        min_counter : counter_mod_n generic map (N_cmn => 6, selection_cmn => 1) port map(
            CLK_cmn => clk,
            reset_cmn => reset,
            input_cmn => min_input,
            load_cmn => load,
            enable_cmn => co_sec,
            q_cmn => min_output,        
            co_cmn => co_min);

        hour_counter : counter_mod_n generic map (N_cmn => 5, selection_cmn => 2) port map(
            CLK_cmn => clk,
            reset_cmn => reset,
            input_cmn => hour_input,
            load_cmn => load,
            enable_cmn => co_min,
            q_cmn => hour_output,        
            co_cmn => co_hour);
                        

end Structural;
