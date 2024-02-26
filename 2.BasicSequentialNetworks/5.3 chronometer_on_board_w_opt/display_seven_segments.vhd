
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_seven_segments is
    Generic(CLKIN_freq : integer := 100000000; 
			CLKOUT_freq : integer := 500);
    Port(   CLK : in  STD_LOGIC;
            RST : in  STD_LOGIC;
            VALUE : in  STD_LOGIC_VECTOR (31 downto 0);
            ENABLE : in  STD_LOGIC_VECTOR (7 downto 0); -- decide quali cifre abilitare
            DOTS : in  STD_LOGIC_VECTOR (7 downto 0); -- decide quali punti visualizzare
            ANODES : out  STD_LOGIC_VECTOR (7 downto 0);
            CATHODES : out  STD_LOGIC_VECTOR (7 downto 0));
end display_seven_segments;

architecture Structural of display_seven_segments is

    signal counter : std_logic_vector(2 downto 0);
    signal clock_filter_out : std_logic := '0';
    
    component counter_mod_n_refresh is
        Generic(N_cmn : integer := 4);
        Port (  CLK_cmn : in STD_LOGIC;
                reset_cmn : in STD_LOGIC;
                q_cmn : out STD_LOGIC_VECTOR(N_cmn - 1 downto 0));
    end component;
    
    component cathodes_manager
        Port(   counter : IN std_logic_vector(2 downto 0);
                value : IN std_logic_vector(31 downto 0);
                dots : IN std_logic_vector(7 downto 0);          
                cathodes : OUT std_logic_vector(7 downto 0));
    end component;
    
    component anodes_manager
        Port(   counter : IN std_logic_vector(2 downto 0);
                enable_digit : IN std_logic_vector(7 downto 0);          
                anodes : OUT std_logic_vector(7 downto 0));
    end component;
    
    component clock_filter
        Generic(CLKIN_freq : integer := 100000000;
                CLKOUT_freq : integer := 500);
        Port(   clock_in : IN std_logic; 
                reset : in  STD_LOGIC;		
                clock_out : OUT std_logic);
    end component;
    
    begin
    
    -- il clock filter genera un segnale di abilitazione per il contatore di refresh che viene usato
    -- come segnale di conteggio e quindi di fatto fornisce la frequenza con cui viene modificata
    -- la cifra da mostrare
    clk_filter: clock_filter generic map( CLKIN_freq => CLKIN_freq, CLKOUT_freq => CLKOUT_freq) port map(
            clock_in => CLK,
            reset => RST,
            clock_out => clock_filter_out);
    
    counter_instance: counter_mod_n_refresh generic map (N_cmn => 3) port map(
        CLK_cmn => clock_filter_out,
        reset_cmn => RST,
        q_cmn => counter);
        
    -- il valore di conteggio viene usato dal gestore dei catodi e degli anodi per
    -- selezionare l'anodo da accendere e il suo rispettivo valore
    cathodes_instance: cathodes_manager port map(
        counter => counter,
        value => value,
        dots => dots,
        cathodes => cathodes);
    
    -- anche il gestore degli anodi usa il conteggio per gestire l'abilitazione
    -- della cifra da mostrare, all'occhio umano sembrerà che i display siano
    -- accessi contemporanemamente
    anodes_instance: anodes_manager port map(
        counter => counter,
        enable_digit => enable,
        anodes => anodes);
    
    
end Structural;

