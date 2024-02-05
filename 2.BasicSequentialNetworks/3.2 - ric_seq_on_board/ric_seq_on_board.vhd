
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ric_seq_on_board is
    Port (  S1, S2 : in STD_LOGIC;                  -- INPUT E MODO
            CLOCK : in STD_LOGIC;                     --  CLOCK
            LED, LED1, LED2 : out STD_LOGIC;                    -- OUTPUT
            B1, B2, BTN_RST : in STD_LOGIC);        -- BTN SX, BTN DX, BTN CPU RESET
end ric_seq_on_board;

architecture Strucural of ric_seq_on_board is

    component ric_seq is
        Port ( i : in STD_LOGIC;         -- INPUT
               R, A : in STD_LOGIC;      -- RESET E CLOCK
               M : in STD_LOGIC;         -- MODO
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
    
    signal btn1_wire, btn2_wire, btnRst_wire : STD_LOGIC := '0';
    signal clr_btn1, clr_btn2 : STD_LOGIC := '0'; 
    signal enable : STD_LOGIC := '0';
    signal input_rs : STD_LOGIC := '0';
    signal mode_rs : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    

    begin
        
        reset <= not BTN_RST;
    
        RIC_SEQ_0: ric_seq port map(
            i => input_rs,
            R => reset,
            A => enable,
            M => mode_rs,
            Y => LED);
            
            
        BTND_1: ButtonDebouncer generic map (CLK_period => 10, btn_noise_time => 10000000) port map(
            RST => reset,
            CLK => CLOCK,
            BTN => B1,
            CLEARED_BTN => clr_btn1);

        BTND_2: ButtonDebouncer generic map (CLK_period => 10, btn_noise_time => 10000000) port map(
            RST => reset,
            CLK => CLOCK,
            BTN => B2,
            CLEARED_BTN => clr_btn2);
            
        input_proc: process(B1, B2)
            begin
                if (B1 = '1' or B2 = '1') then
                    enable <= '1';
                    if (B1 = '1') then
                        input_rs <= S1;
                    else
                        mode_rs <= S2;
                    end if;
                else
                    enable <= '0';
                end if;
        end process;
        
--        led_output : process
--            begin
--                if (B1 = '1') then
--                    LED1 <= '1';
--                    wait for 10000 ms;
--                else
--                    LED1 <= '0';
--                end if;
                
--                if (B2 = '1') then
--                    LED2 <= '1';
--                    wait for 10000 ms;
--                else
--                    LED2 <= '0';
--                end if;
--        end process;
            
--        enable <= '1' when clr_btn1 = '1' or clr_btn2 = '1' else '0';
        
--        input_rs <= S1 when clr_btn1 = '1';
        
--        mode_rs <= S2 when clr_btn2 = '1';

end Strucural;
