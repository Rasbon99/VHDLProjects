
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shiftregister is
    Generic(N : integer := 4);
    Port (  data_in : in STD_LOGIC_VECTOR(N - 1 downto 0);
            EI, EO : in STD_LOGIC := '0';  -- input di inserimento (filling) dell'SR: EI = da sx, EO = da dx 
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            Y : in integer range 1 to 2;
            direction : in STD_LOGIC;          -- direction = 1 dx oppure direction = 0 sx
            load : in STD_LOGIC;
            shift_enable : in STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR(N - 1 downto 0));
end shiftregister;

architecture Structural of shiftregister is

    component shift_manager is
        Port(   clock : in STD_LOGIC;
                load : in STD_LOGIC;
                reset : in STD_LOGIC;
                Y : in integer range 1 to 2;
                shift_enable : in STD_LOGIC;
                direction :in STD_LOGIC;
                selection : out STD_LOGIC_VECTOR (1 downto 0));
    end component;

    component flip_flop is
    Port (  d_ff : in STD_LOGIC;
            a_ff : in STD_LOGIC;
            r_ff : in STD_LOGIC;
            q_ff : out STD_LOGIC );
    end component;
    
    component mux4_1 is 
    Port (  a_mux : in STD_LOGIC_VECTOR(3 downto 0);
            s_mux : in STD_LOGIC_VECTOR(1 downto 0);
            y_mux : out STD_LOGIC
    );
    end component;
    

    signal ff_out : STD_LOGIC_VECTOR(N-1 downto 0);     -- ff_out: segnali di wiring dell'uscita dei flip-flop
    signal mux_out : STD_LOGIC_VECTOR(N-1 downto 0);    -- mux_out: segnali di wiring dell'uscita dei mux4_1
    signal selection : STD_LOGIC_VECTOR (1 downto 0);
    
    begin
    
        SHIFT_MNG: shift_manager port map(
            clock => clk,
            load => load,
            reset => reset,
            Y => Y,
            shift_enable => shift_enable,
            direction => direction,
            selection => selection);
    
        iter: for i in 0 to N - 1 GENERATE
        
            first : if i = 0 GENERATE
                    mux : mux4_1 port map(
                    a_mux(0) => data_in(i),
                    a_mux(1) => ff_out(i+1),
                    a_mux(2) => EO,
                    a_mux(3) => ff_out(i),
                    s_mux => selection,
                    y_mux => mux_out(i));    
            END GENERATE;
            
            last : if i = N - 1 GENERATE
                    mux : mux4_1 port map(
                    a_mux(0) => data_in(i),
                    a_mux(1) => EI,
                    a_mux(2) => ff_out(i-1),
                    a_mux(3) => ff_out(i),
                    s_mux => selection,
                    y_mux => mux_out(i));    
            END GENERATE;
            
            rest : if i > 0 and i < N - 1 GENERATE
                    mux : mux4_1 port map(
                    a_mux(0) => data_in(i),
                    a_mux(1) => ff_out(i+1),
                    a_mux(2) => ff_out(i-1),
                    a_mux(3) => ff_out(i),
                    s_mux => selection,
                    y_mux => mux_out(i));    
            END GENERATE;
            
            
            ff : flip_flop port map(
                    d_ff => mux_out(i),
                    a_ff => clk,
                    r_ff => reset,
                    q_ff => ff_out(i));
        
            END GENERATE;
    
        data_out <= ff_out;     
        

end Structural;

