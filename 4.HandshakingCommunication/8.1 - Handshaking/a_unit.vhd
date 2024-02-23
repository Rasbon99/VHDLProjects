
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;

entity a_unit is
    Generic(N : integer := 16;
            M : integer := 8);
    Port(   clock_a : in STD_LOGIC;
            reset : in STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR (M-1 downto 0);
            req : out STD_LOGIC;
            ack : in STD_LOGIC;
            done : in STD_LOGIC;
            start : in STD_LOGIC);
end a_unit;

architecture Behavioral of a_unit is

    component cu_a is
        Generic(N : integer := N;
                M : integer := M);
        Port(   clock : in STD_LOGIC;
                reset : in STD_LOGIC;
                mem_read : out STD_LOGIC;
                mem_data_in : in STD_LOGIC_VECTOR (M-1 downto 0);
                counter_enable : out STD_LOGIC;
                counter_reset : out STD_LOGIC;
                address : in STD_LOGIC_VECTOR (integer(ceil(log2(real(N))))-1 downto 0);
                start : in STD_LOGIC;
                data_out : out STD_LOGIC_VECTOR (M-1 downto 0);
                req : out STD_LOGIC;
                done : in STD_LOGIC;
                ack : in STD_LOGIC);
    end component;
    
    component counter_mod_n is
        Generic(N_cmn : integer range 0 to 255 := N);
        Port(   CLK_cmn : in STD_LOGIC;
                reset_cmn : in STD_LOGIC;
                enable_cmn : in STD_LOGIC;
                q_cmn : out STD_LOGIC_VECTOR(integer(ceil(log2(real(N_cmn)))) - 1 downto 0));
    end component;
    

    component rom_seq is
        Generic(N : integer range 0 to 255 := 16;
                M : integer := 8);
        Port(   rom_address : in STD_LOGIC_VECTOR (integer(ceil(log2(real(N))))- 1 downto 0);
                rom_output : out STD_LOGIC_VECTOR (M-1 downto 0);
                clock : in STD_LOGIC;
                rom_read : in STD_LOGIC);
    end component;
    
    signal mem_read_wire : STD_LOGIC := '0';
    signal mem_data_out_wire : STD_LOGIC_VECTOR(M-1 downto 0):= (others => '0');
    signal counter_enable_wire : STD_LOGIC := '0';
    signal counter_reset_wire : STD_LOGIC := '0';
    signal address_wire : STD_LOGIC_VECTOR(integer(ceil(log2(real(N)))) - 1 downto 0) := (others => '0');

    begin
        
        CONTROL_UNIT_A: cu_a port map(
            clock => clock_a,
            reset => reset,
            mem_read => mem_read_wire,
            mem_data_in => mem_data_out_wire,
            counter_enable => counter_enable_wire,
            counter_reset => counter_reset_wire,
            address => address_wire,
            start => start,
            data_out => data_out,
            req => req,
            done => done,
            ack => ack);
            
        COUNTER_A: counter_mod_n port map(
            CLK_cmn => clock_a,
            reset_cmn => counter_reset_wire,
            enable_cmn => counter_enable_wire,
            q_cmn => address_wire);
            
        ROM_A: rom_seq port map(
            rom_address => address_wire,
            rom_output => mem_data_out_wire,
            clock => clock_a,
            rom_read => mem_read_wire);


end Behavioral;
