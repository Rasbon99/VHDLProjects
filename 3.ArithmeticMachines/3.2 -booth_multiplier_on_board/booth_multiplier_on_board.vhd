library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity booth_multiplier_on_board is
    Generic(N : integer := 8);
    Port(   clock : in STD_LOGIC;
            btn_reset : in STD_LOGIC;
            btn_x : in STD_LOGIC;
            btn_y : in STD_LOGIC;
            btn_start : in STD_LOGIC;
            led_out : out STD_LOGIC_VECTOR(2*N-1 downto 0);
            switch_in : in STD_LOGIC_VECTOR(N-1 downto 0);
            led_check_x : out STD_LOGIC;
            led_check_y : out STD_LOGIC;
            led_check_start : out STD_LOGIC);
end booth_multiplier_on_board;

architecture Behavioral of booth_multiplier_on_board is

    component ButtonDebouncer is
        Generic(CLK_period: integer := 10;              
                btn_noise_time: integer := 10000000);   
                                                        
        Port ( RST : in STD_LOGIC;
               CLK : in STD_LOGIC;
               BTN : in STD_LOGIC;
               CLEARED_BTN : out STD_LOGIC);
    end component;
    
    component booth_multiplier_n is
        Generic(N : integer := N);
        Port(   x : in STD_LOGIC_VECTOR (N-1 downto 0);
                y : in STD_LOGIC_VECTOR (N-1 downto 0);
                clock: in STD_LOGIC;
                start : in STD_LOGIC;
                reset : in STD_LOGIC;
                p : out STD_LOGIC_VECTOR (2*N - 1 downto 0));
    end component;
    
    component control_unit is
        Generic(N : integer := N);
        Port(   clock : in STD_LOGIC;
                reset : in STD_LOGIC;
                btn_x : in STD_LOGIC;
                btn_y : in STD_LOGIC;
                switch_in : in STD_LOGIC_VECTOR(N-1 downto 0);
                btn_start : in STD_LOGIC;
                start_out : out STD_LOGIC;
                x_out : out STD_LOGIC_VECTOR(N-1 downto 0);
                y_out : out STD_LOGIC_VECTOR(N-1 downto 0);
                check_x : out STD_LOGIC;
                check_y : out STD_LOGIC;
                check_start : out STD_LOGIC);
    end component;
    
    
    signal reset : STD_LOGIC := '0';
    signal btn_x_wire : STD_LOGIC := '0';
    signal btn_y_wire : STD_LOGIC := '0';
    signal btn_start_wire : STD_LOGIC := '0';
    signal start_out_wire : STD_LOGIC := '0';
    signal x_out_wire : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
    signal y_out_wire : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');

    begin
    
        DB_X: ButtonDebouncer port map(
            RST => reset,
            CLK => clock,
            BTN => btn_x,
            CLEARED_BTN => btn_x_wire);
            
        DB_Y: ButtonDebouncer port map(
            RST => reset,
            CLK => clock,
            BTN => btn_y,
            CLEARED_BTN => btn_y_wire);
            
        DB_START: ButtonDebouncer port map(
            RST => reset,
            CLK => clock,
            BTN => btn_start,
            CLEARED_BTN => btn_start_wire);
            
        CU: control_unit port map(
            clock => clock,
            reset => reset,
            btn_x => btn_x_wire,    --btn_x_wire
            btn_y => btn_y_wire,    --btn_y_wire
            btn_start => btn_start_wire, --btn_start_wire
            switch_in => switch_in,
            start_out => start_out_wire,
            x_out => x_out_wire,
            y_out => y_out_wire,
            check_x => led_check_x,
            check_y => led_check_y,
            check_start => led_check_start);
            
        BOOTH_MUL: booth_multiplier_n port map(
            x => x_out_wire,
            y => y_out_wire,
            clock => clock,
            reset => reset,
            start => start_out_wire,
            p => led_out);
    
        reset <= not btn_reset; -- not btn_reset
        
end Behavioral;