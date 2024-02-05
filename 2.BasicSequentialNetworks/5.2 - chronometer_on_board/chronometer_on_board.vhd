
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity chronometer_on_board is
    Port (  clk : in STD_LOGIC;
            btn_reset : in STD_LOGIC;
            btn_load : in STD_LOGIC;        -- BTNC
            btn_input : in STD_LOGIC;       -- BTNL
            switch : in STD_LOGIC_VECTOR (5 downto 0);
            cathodes_out : out STD_LOGIC_VECTOR (7 downto 0);
            anodes_out : out STD_LOGIC_VECTOR (7 downto 0);
            led1, led2, led3 : out STD_LOGIC := '0');
end chronometer_on_board;

architecture Behavioral of chronometer_on_board is

    -- CHRONOMETER
    
    component chronometer is
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
    end component;
    
    -- DIGITS MANAGER
    
    component digits_manager is
        Port ( nano_in : in integer := 0;
               sec_in : in integer := 0;
               min_in : in integer := 0;
               hour_in : in integer := 0;
               display_value : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    -- DISPLAY SEVEN SEGMENTS
    
    component display_seven_segments is
        Generic(CLKIN_freq : integer := 100000000; 
                CLKOUT_freq : integer := 500);
        Port(   CLK : in  STD_LOGIC;
                RST : in  STD_LOGIC;
                VALUE : in  STD_LOGIC_VECTOR (31 downto 0);
                ENABLE : in  STD_LOGIC_VECTOR (7 downto 0);
                DOTS : in  STD_LOGIC_VECTOR (7 downto 0);
                ANODES : out  STD_LOGIC_VECTOR (7 downto 0);
                CATHODES : out  STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    -- CONTROL UNIT INPUT
    
    component control_unit_input is
        Port (  clk : in STD_LOGIC;
                reset : in STD_LOGIC;
                btn_input, btn_load : in STD_LOGIC;
                switch : in STD_LOGIC_VECTOR (5 downto 0);
                check_sec, check_min, check_hour : out STD_LOGIC;
                data_sec : out integer range 0 to 59 := 0;
                data_min : out integer range 0 to 59 := 0;
                data_hour : out integer range 0 to 23 := 0;
                load : out STD_LOGIC := '0');
    end component;
    
    -- BUTTON DEBOUNCER
    
    component ButtonDebouncer is
        Generic(CLK_period: integer := 10;  
                btn_noise_time: integer := 10000000); 
        Port (  RST : in STD_LOGIC;
                CLK : in STD_LOGIC;
                BTN : in STD_LOGIC;
                CLEARED_BTN : out STD_LOGIC);
    end component;
    
    signal sec_in_wire : integer range 0 to 59 := 0;
    signal min_in_wire : integer range 0 to 59 := 0;
    signal hour_in_wire : integer range 0 to 23 := 0;
    signal load_wire : STD_LOGIC := '0';
    
    signal nano_out_wire : integer := 0;
    signal sec_out_wire : integer range 0 to 59 := 0;
    signal min_out_wire : integer range 0 to 59 := 0;
    signal hour_out_wire : integer range 0 to 23 := 0;
    
    signal display_in_wire : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    
    -- display sempre abilitati
    signal enable_display : STD_LOGIC_VECTOR (7 downto 0) := (others => '1');
    
    -- dots statici per la suddivione delle cifre
    signal dots_display : STD_LOGIC_VECTOR (7 downto 0) := "01010100";
    
    signal reset : STD_LOGIC := '0';
    
    -- wire di collegamento tra debouncer e cu
    signal btn_in_wire : STD_LOGIC := '0';   
    
    
    begin
        
        CHRONO_METER : chronometer port map(
            sec_input => sec_in_wire,
            min_input => min_in_wire,
            hour_input => hour_in_wire,
            load => load_wire,
            reset => reset,
            clk => clk,
            nano_output => nano_out_wire,
            sec_output => sec_out_wire,
            min_output => min_out_wire,
            hour_output => hour_out_wire);
            
        DIGITS_MNG: digits_manager port map(
            nano_in => nano_out_wire,
            sec_in => sec_out_wire,
            min_in => min_out_wire,
            hour_in => hour_out_wire,
            display_value => display_in_wire);
            
        DISPLAY: display_seven_segments port map(
            CLK => clk,
            RST => reset,
            VALUE => display_in_wire,
            ENABLE => enable_display,
            DOTS => dots_display,
            ANODES => anodes_out,
            CATHODES => cathodes_out);
            
        DBNCR_INPUT: ButtonDebouncer generic map (CLK_period => 10, btn_noise_time => 10000000) port map (
            CLK => clk,
            RST => reset,
            BTN => btn_input,
            CLEARED_BTN => btn_in_wire);   
                            
        CU_IN: control_unit_input port map(
            clk => clk,
            reset => reset,
            btn_input => btn_in_wire,
            btn_load => btn_load,
            switch => switch,
            check_sec => led1,
            check_min => led2,
            check_hour => led3,
            data_sec => sec_in_wire,
            data_min => min_in_wire,
            data_hour => hour_in_wire,
            load => load_wire);                             

        reset <= not btn_reset;


end Behavioral;
