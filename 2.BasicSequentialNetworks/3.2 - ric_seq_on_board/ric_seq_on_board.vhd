
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ric_seq_on_board is
    Port (  S1, S2 : in STD_LOGIC;                  -- INPUT E MODO
            CLOCK : in STD_LOGIC;                   -- CLOCK
            LED: out STD_LOGIC;                     -- OUTPUT
            BTN, BTN_RST : in STD_LOGIC);        -- BTN SX (MODO, INPUT), BTN CPU RESET
end ric_seq_on_board;

architecture Strucural of ric_seq_on_board is

    component ric_seq is
        Port ( i : in STD_LOGIC;         -- INPUT
               R, A : in STD_LOGIC;      -- RESET E CLOCK
               M : in STD_LOGIC;         -- MODO
               E : in STD_LOGIC;         -- ENABLE
               Y : out STD_LOGIC);       -- OUTPUT
    end component;
    
    component ButtonDebouncer is
        generic(CLK_period: integer := 10;  -- periodo del clock in nanosec
                btn_noise_time: integer := 10000000); -- durata dell'oscillazione in nanosec
        Port (  RST : in STD_LOGIC;
                CLK : in STD_LOGIC;
                BTN : in STD_LOGIC; 
                CLEARED_BTN : out STD_LOGIC);
    end component;
    
    signal clr_btn: STD_LOGIC := '0'; 
    signal enable : STD_LOGIC := '0';
    signal input_rs : STD_LOGIC := '0';
    signal mode_rs : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    
    begin
        
        reset <= not BTN_RST;
    
        RIC_SEQ_0: ric_seq port map(
            i => S1,
            R => reset,
            A => CLOCK,
            E => clr_btn,
            M => S2,
            Y => LED);
            
        BTND_1: ButtonDebouncer generic map (CLK_period => 10, btn_noise_time => 10000000) port map(
            RST => reset,
            CLK => CLOCK,
            BTN => BTN,
            CLEARED_BTN => clr_btn);
                
end Strucural;