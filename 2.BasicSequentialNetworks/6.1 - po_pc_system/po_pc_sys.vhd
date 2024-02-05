
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;

entity po_pc_sys is
    Generic(N : integer range 0 to 255 := 4);
    Port (  start : in STD_LOGIC;
            clock : in STD_LOGIC;
            reset : in STD_LOGIC;
            stop : out STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR (3 downto 0));
end po_pc_sys;

architecture Behavioral of po_pc_sys is

    -- Si è scelto di utilizzare un metodo statico per
    -- il calcolo della width degli indirizzi, tramite
    -- le funzioni log2 e ceil contenute in IEEE.MATH_REAL.ALL
    -- consentendo di calcolare il logaritmo in base due preso
    -- preso per difetto.

    constant log2N : integer := integer(ceil(log2(real(N))));

    -- CONTROL UNIT

    component control_unit is
        Generic(N : integer range 0 to 255 := 4);
        Port (  start : in STD_LOGIC;
                address : in STD_LOGIC_VECTOR (log2N - 1 downto 0);
                reset : in STD_LOGIC;
                clock : in STD_LOGIC;
                count_reset : out STD_LOGIC;
                count_enable : out STD_LOGIC;
                rom_read : out STD_LOGIC;
                mem_write : out STD_LOGIC;
                stop : out STD_LOGIC);
    end component;
    
    -- COUNTER MOD-N
    
    component counter_mod_n is
        Generic(N_cmn : integer range 0 to 255 := 4);
        Port (  CLK_cmn : in STD_LOGIC;
                reset_cmn : in STD_LOGIC;
                enable_cmn : in STD_LOGIC;
                q_cmn : out STD_LOGIC_VECTOR(log2N - 1 downto 0));
    end component;
        
    -- ROM
    
    component rom_seq is
        Generic(N : integer range 0 to 255 := 4);                           
        Port ( rom_address : in STD_LOGIC_VECTOR (log2N - 1 downto 0);
               rom_output : out STD_LOGIC_VECTOR (7 downto 0);
               clock : in STD_LOGIC;
               rom_read : in STD_LOGIC);
    end component;
    
    -- Macchina combinatoriale M
    
    component m_machine is
         Port ( m_input : in STD_LOGIC_VECTOR (7 downto 0);
                m_output : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    -- Memoria
    
    component mem is
        Generic(N : integer range 0 to 255 := 4);
        Port (  mem_input : in STD_LOGIC_VECTOR(3 downto 0);
                mem_address : in STD_LOGIC_VECTOR(log2N - 1 downto 0); 
                clock : in STD_LOGIC;
                mem_write : in STD_LOGIC;
                mem_output : out STD_LOGIC_VECTOR(3 downto 0));
    end component;
    
    -- SIGNALS
    
    signal address_wire : STD_LOGIC_VECTOR (log2N - 1 downto 0) := (others => '0');
    signal clock_wire : STD_LOGIC := '0';
    signal count_reset_wire : STD_LOGIC := '0';
    signal count_enable_wire : STD_LOGIC := '0';
    signal read_wire : STD_LOGIC := '0';
    signal write_wire : STD_LOGIC := '0';
    signal rom_output : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal m_output : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');

    begin
        
        CU : control_unit generic map (N => N) port map (
            start => start,
            address => address_wire,
            reset => reset,
            clock => clock,
            count_reset => count_reset_wire,
            count_enable => count_enable_wire,
            rom_read => read_wire,
            mem_write => write_wire,
            stop => stop);
            
        ROM : rom_seq generic map (N => N) port map (
            rom_address => address_wire,
            rom_output => rom_output,
            clock => clock,
            rom_read => read_wire);
            
        M : m_machine port map (
            m_input => rom_output,
            m_output => m_output);
            
        MEMORY : mem generic map (N => N) port map (
            mem_input => m_output,
            mem_address => address_wire,
            clock => clock,
            mem_write => write_wire,
            mem_output => data_out);
            
        COUNTER : counter_mod_n generic map (N_cmn => N) port map (
            CLK_cmn => clock,
            reset_cmn => count_reset_wire,
            enable_cmn => count_enable_wire,
            q_cmn => address_wire);


end Behavioral;
