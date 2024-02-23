
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;

entity b_unit is
    Generic(N : integer := 16;
            M : integer := 8);
    Port(   clock_b : in STD_LOGIC;
            reset : in STD_LOGIC;
            data_in : in STD_LOGIC_VECTOR (M-1 downto 0);
            req : in STD_LOGIC;
            done : out STD_LOGIC;
            ack : out STD_LOGIC);
end b_unit;

architecture Behavioral of b_unit is

        
    constant log2_N : integer := integer(ceil(log2(real(N))));
    constant log2_2N : integer := integer(ceil(log2(real(2*N))));
    
    component cu_b is
        Generic(N : integer := N;
                M : integer := M);
        Port(   clock : in STD_LOGIC;
                reset : in STD_LOGIC;
                mem_read : out STD_LOGIC;
                mem_write : out STD_LOGIC;
                mem_sum_in : out STD_LOGIC_VECTOR (M-1 downto 0);
                mem_data_in : in STD_LOGIC_VECTOR (M-1 downto 0);
                address : in STD_LOGIC_VECTOR (log2_N - 1 downto 0);
                counter_enable : out STD_LOGIC;
                counter_reset : out STD_LOGIC;
                data_in : in STD_LOGIC_VECTOR (M-1 downto 0);
                req : in STD_LOGIC;
                done : out STD_LOGIC;
                ack : out STD_LOGIC);
    end component;
    
    component counter_mod_n is
        Generic(N_cmn : integer range 0 to 255 := N);
        Port(   CLK_cmn : in STD_LOGIC;
                reset_cmn : in STD_LOGIC;
                enable_cmn : in STD_LOGIC;
                q_cmn : out STD_LOGIC_VECTOR(integer(ceil(log2(real(N_cmn)))) - 1 downto 0));
    end component;
    
    component mem_b is
        Generic(N : integer range 0 to 255 := N;
                M : integer := M);
        Port (  mem_input : in STD_LOGIC_VECTOR(M-1 downto 0);
                mem_address : in STD_LOGIC_VECTOR(log2_2N - 1 downto 0); 
                clock : in STD_LOGIC;
                mem_write : in STD_LOGIC;
                mem_read : in STD_LOGIC;
                mem_output : out STD_LOGIC_VECTOR(M-1 downto 0));
    end component;
    
    signal mem_read_wire : STD_LOGIC := '0';
    signal mem_write_wire : STD_LOGIC := '0';
    signal mem_data_out_wire : STD_LOGIC_VECTOR(M-1 downto 0):= (others => '0');
    signal mem_sum_in_wire : STD_LOGIC_VECTOR(M-1 downto 0):= (others => '0');
    signal counter_enable_wire : STD_LOGIC := '0';
    signal counter_reset_wire : STD_LOGIC := '0';
    signal address_wire : STD_LOGIC_VECTOR(log2_N - 1 downto 0) := (others => '0');
    signal mem_input_wire : STD_LOGIC_VECTOR(M-1 downto 0):= (others => '0');
    signal address_mem_in_wire : STD_LOGIC_VECTOR(log2_2N - 1 downto 0) := (others => '0');
    signal address_sum_wire : STD_LOGIC_VECTOR(log2_2N - 1 downto 0) := (others => '0');
    
    begin
    
        CONTROL_UNIT_B: cu_b port map (
            clock => clock_b,
            reset => reset,
            mem_read => mem_read_wire,
            mem_write => mem_write_wire,
            mem_sum_in => mem_sum_in_wire,
            mem_data_in => mem_data_out_wire,
            address => address_wire,
            counter_enable => counter_enable_wire,
            counter_reset => counter_reset_wire,
            data_in => data_in,
            req => req,
            done => done,
            ack => ack);
            
        MEMORY_B: mem_b port map (
            clock => clock_b,
            mem_input => mem_sum_in_wire,
            mem_output => mem_data_out_wire,
            mem_write => mem_write_wire,
            mem_read => mem_read_wire,
            mem_address => address_mem_in_wire);
            
        COUNTER_B: counter_mod_n port map(
            CLK_cmn => clock_b,
            reset_cmn => counter_reset_wire,
            enable_cmn => counter_enable_wire,
            q_cmn => address_wire);
        
        address_sum_wire <= std_logic_vector(resize(unsigned(address_wire), log2_2N) + to_unsigned(N, log2_2N));
         
        address_mem_in_wire <= address_sum_wire when mem_write_wire = '1' else std_logic_vector(resize(unsigned(address_wire), log2_2N));


end Behavioral;
