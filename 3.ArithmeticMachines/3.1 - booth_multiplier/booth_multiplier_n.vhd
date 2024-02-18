
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity booth_multiplier_n is
    Generic(N : integer := 4);
    Port(   x : in STD_LOGIC_VECTOR (N-1 downto 0);
            y : in STD_LOGIC_VECTOR (N-1 downto 0);
            clock: in STD_LOGIC;
            start : in STD_LOGIC;
            reset : in STD_LOGIC;
            p : out STD_LOGIC_VECTOR (2*N - 1 downto 0));
end booth_multiplier_n;

architecture Structural of booth_multiplier_n is

    -- BOOTH MULTIPLIER MANAGER        

    component booth_mul_manager is
        Generic(N : integer := N);
        Port(   clock : in STD_LOGIC;
                start : in STD_LOGIC;
                reset : in STD_LOGIC;
                count_in : in STD_LOGIC_VECTOR(integer(ceil(log2(real(N)))) - 1 downto 0);
                q0_1 : in STD_LOGIC_VECTOR(1 downto 0);
                an_1 : in STD_LOGIC;
                read_aq : out STD_LOGIC;
                load_aq : out STD_LOGIC;
                sel_aq : out STD_LOGIC;
                load_m : out STD_LOGIC;
                sel_sum : out STD_LOGIC;
                sub : out STD_LOGIC;
                shift : out STD_LOGIC;
                fill : out STD_LOGIC;
                reset_counter : out STD_LOGIC;
                enable_counter : out STD_LOGIC);
    end component;
    
    -- COUNTER MOD N
    
    component counter_mod_n is
        Generic(N_cmn : integer range 0 to 255 := N);
        Port (  CLK_cmn : in STD_LOGIC;
                reset_cmn : in STD_LOGIC;
                enable_cmn : in STD_LOGIC;
                q_cmn : out STD_LOGIC_VECTOR(integer(ceil(log2(real(N_cmn)))) - 1 downto 0));
    end component;
    
    -- RIPPLE CARRY ADDER
    
    component ripple_carry_adder is
        Generic(N : integer := N);
        Port(   x : in STD_LOGIC_VECTOR (N-1 downto 0);
                y : in STD_LOGIC_VECTOR (N-1 downto 0);
                cin : in STD_LOGIC;
                cout : out STD_LOGIC;
                s : out STD_LOGIC_VECTOR (N-1 downto 0));
    end component;
    
    -- REGISTRO M
    
    component reg is
        Generic(N : integer := N);
        Port(   clk : in STD_LOGIC;
                reset : in STD_LOGIC;
                data_in : in STD_LOGIC_VECTOR (N-1 downto 0);
                load : in STD_LOGIC;
                data_out : out STD_LOGIC_VECTOR (N-1 downto 0));
    end component;
    
    -- SHIFT REGISTER
    
    component shiftregister is
        Generic(N : integer := 2*N + 1);
        Port (  data_in : in STD_LOGIC_VECTOR(N - 1 downto 0);
                EI, EO : in STD_LOGIC := '0';  
                clk : in STD_LOGIC;
                reset : in STD_LOGIC;
                Y : in integer range 1 to 2;
                direction : in STD_LOGIC;          
                load : in STD_LOGIC;                        -- la seconda volta che vogliamo loddare bisogna tenere alto 2
                shift_enable : in STD_LOGIC;
                data_out : out STD_LOGIC_VECTOR(N - 1 downto 0));
    end component;
    
    -- MUX2:1 N BIT
    
    component mux2_1_n is
        Generic(N : integer := N);
        Port(   a : in STD_LOGIC_VECTOR (N-1 downto 0);
                b : in STD_LOGIC_VECTOR (N-1 downto 0);
                s : in STD_LOGIC;
                y : out STD_LOGIC_VECTOR (N-1 downto 0));
    end component;
    
    -- SIGNAL
    
    signal count_out_wire : STD_LOGIC_VECTOR(integer(ceil(log2(real(N)))) - 1 downto 0) := (others => '0');
    signal data_aq_wire : STD_LOGIC_VECTOR (2*N downto 0) := (others => 'U');
    alias q0_1 is data_aq_wire (1 downto 0);
    alias an_1 is data_aq_wire (2*N);
    alias aq is data_aq_wire (2*N downto 1);
    alias a is data_aq_wire (2*N downto N + 1);
    alias q is data_aq_wire (N downto 0);
    signal read_aq_wire : STD_LOGIC := '0';
    signal load_aq_wire : STD_LOGIC := '0';
    signal sel_aq_wire : STD_LOGIC := '0';
    signal load_m_wire : STD_LOGIC := '0';
    signal sel_sum_wire : STD_LOGIC := '0';
    signal sub_wire : STD_LOGIC := '0';
    signal shift_wire : STD_LOGIC := '0';
    signal fill_wire : STD_LOGIC := '0';
    signal reset_counter_wire : STD_LOGIC := '0';
    signal enable_counter_wire : STD_LOGIC := '0';
    signal mux_out_aq_wire : STD_LOGIC_VECTOR (2*N downto 0) := (others => '0');
    signal mux_out_sum_wire : STD_LOGIC_VECTOR (N-1 downto 0) := (others => '0');
    signal sum_result_wire : STD_LOGIC_VECTOR (N-1 downto 0) := (others => '0');
    signal data_out_m_wire : STD_LOGIC_VECTOR (N-1 downto 0) := (others => '0');
    signal xor_out_wire : STD_LOGIC_VECTOR (N-1 downto 0) := (others => '0');
    signal start_string : STD_LOGIC_VECTOR (2*N downto 0) := (others => '0');
    signal sum_mux_in : STD_LOGIC_VECTOR (2*N downto 0) := (others => '0');
    signal sub_string_wire : STD_LOGIC_VECTOR (N-1 downto 0) := (others => '0');
    
    -- CONSTANTS
    
    constant n_zeros : STD_LOGIC_VECTOR (N-1 downto 0) := (others => '0');
    constant N_bm : integer := N;
        
    begin
        
        BOOTH_MNG: booth_mul_manager port map(
            clock => clock,
            start => start,
            reset => reset,
            count_in => count_out_wire,
            q0_1 => q0_1,
            an_1 => an_1,
            read_aq => read_aq_wire,
            load_aq => load_aq_wire,
            sel_aq => sel_aq_wire,
            load_m => load_m_wire,
            sel_sum => sel_sum_wire,
            sub => sub_wire,
            shift => shift_wire,
            fill => fill_wire,
            reset_counter => reset_counter_wire,
            enable_counter => enable_counter_wire);
            
        AQplus1: shiftregister generic map (N => 2*N + 1) port map(
            data_in => mux_out_aq_wire,
            EI => an_1,
            EO => '0',
            clk => clock,
            reset => reset,
            Y => 1,
            direction => '0',
            load => load_aq_wire,
            shift_enable => shift_wire,
            data_out => data_aq_wire);
            
        REG_M: reg port map(
            clk => clock,
            reset => reset,
            data_in => y,
            load => load_m_wire,
            data_out => data_out_m_wire);
            
        COUNTER: counter_mod_n port map(
            CLK_cmn => clock,
            reset_cmn => reset_counter_wire,
            enable_cmn => enable_counter_wire,
            q_cmn => count_out_wire);
            
        RCA: ripple_carry_adder port map(
            x => a,
            y => mux_out_sum_wire,
            cin => sub_wire,
            s => sum_result_wire);
            
        MUX2_1_AQ: mux2_1_n generic map (N => 2*N + 1) port map(
            a => sum_mux_in,
            b => start_string,
            s => sel_aq_wire,
            y => mux_out_aq_wire);
            
        MUX2_1_SUM: mux2_1_n generic map (N => N) port map(
            a => (others => '0'),
            b => xor_out_wire,
            s => sel_sum_wire,
            y => mux_out_sum_wire);
            
        start_string <= n_zeros&x&'0';
        
        sum_mux_in <= sum_result_wire&q;
            
        -- XOR bitwise
        sub_string_wire <= (others => sub_wire);      
        xor_out_wire <= sub_string_wire xor data_out_m_wire;
        
        p <= aq when read_aq_wire = '1';

end Structural;
