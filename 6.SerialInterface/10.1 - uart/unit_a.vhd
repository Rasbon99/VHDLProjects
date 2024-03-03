library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;

entity a_unit is
    Port (  clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            data_bus_out : out STD_LOGIC_VECTOR (7 downto 0);
            txd : out STD_LOGIC;
            start : in STD_LOGIC);
end a_unit;

architecture Behavioral of a_unit is

    component control_unit_a is 
        Port (  start : in STD_LOGIC;
                address : in STD_LOGIC_VECTOR (2 downto 0);
                reset : in STD_LOGIC;
                clk : in STD_LOGIC;
                tbe : in STD_LOGIC;
                data_mem_in : in STD_LOGIC_VECTOR (7 downto 0); 
                db_in : out STD_LOGIC_VECTOR (7 downto 0);
                read : out STD_LOGIC;
                wr : out STD_LOGIC;
                count_enable : out STD_LOGIC;
                count_reset : out STD_LOGIC);            
    end component;
    
    component counter_mod_n is
        Generic(N_cmn : integer range 0 to 255 := 8);
        Port(   CLK_cmn : in STD_LOGIC;
                reset_cmn : in STD_LOGIC;
                enable_cmn : in STD_LOGIC;
                q_cmn : out STD_LOGIC_VECTOR(integer(ceil(log2(real(N_cmn)))) - 1 downto 0));
    end component;
    
    component rom_seq is
        Generic(N : integer range 0 to 255 := 8;
                M : integer := 8);
        Port(   rom_address : in STD_LOGIC_VECTOR (integer(ceil(log2(real(N))))- 1 downto 0);
                rom_output : out STD_LOGIC_VECTOR (M-1 downto 0);
                clock : in STD_LOGIC;
                rom_read : in STD_LOGIC);
    end component;
    
    component Rs232RefComp is
        Port (  TXD 	: out std_logic  	:= '1';
                RXD 	: in  std_logic;					
                CLK 	: in  std_logic;					--Master Clock
                DBIN 	: in  std_logic_vector (7 downto 0);--Data Bus in
                DBOUT : out std_logic_vector (7 downto 0);	--Data Bus out
                RDA	: inout std_logic;						--Read Data Available(1 quando il dato è disponibile nel registro rdReg)
                TBE	: inout std_logic 	:= '1';				--Transfer Bus Empty(1 quando il dato da inviare è stato caricato nello shift register)
                RD		: in  std_logic;					--Read Strobe(se 1 significa "leggi" --> fa abbassare RDA)
                WR		: in  std_logic;					--Write Strobe(se 1 significa "scrivi" --> fa abbassare TBE)
                PE		: out std_logic;					--Parity Error Flag
                FE		: out std_logic;					--Frame Error Flag
                OE		: out std_logic;					--Overwrite Error Flag
                RST		: in  std_logic	:= '0');			--Master Reset
    end component;
    
    signal mem_read_wire : STD_LOGIC := '0';
    signal counter_enable_wire : STD_LOGIC := '0';
    signal counter_reset_wire : STD_LOGIC := '0';
    signal address_wire : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
    signal tbe_wire : STD_LOGIC;
    signal wr_wire : STD_LOGIC;
    signal data_mem_in_wire : STD_LOGIC_VECTOR (7 downto 0);
    signal db_in_wire : STD_LOGIC_VECTOR (7 downto 0);
    
    begin

        CU_A : control_unit_a
            port map (
                start => start,
                address => address_wire,
                reset => reset,
                clk => clk,
                tbe => tbe_wire,
                data_mem_in => data_mem_in_wire,
                db_in => db_in_wire,
                read => mem_read_wire,
                wr => wr_wire,
                count_enable => counter_enable_wire,
                count_reset => counter_reset_wire
            );
    
        COUNTER_A : counter_mod_n
            port map (
                CLK_cmn => clk,
                reset_cmn => counter_reset_wire,
                enable_cmn => counter_enable_wire,
                q_cmn => address_wire
            );
    
        ROM_A : rom_seq
            port map (
                rom_address => address_wire,
                rom_output => data_mem_in_wire,
                clock => clk,
                rom_read => mem_read_wire
            );
    
        UART_A : Rs232RefComp
            port map (
                TXD => txd,
                RXD => '0',
                CLK => clk,
                DBIN => db_in_wire,
                DBOUT => data_bus_out,
                RDA => open,
                TBE => tbe_wire,
                RD => '0',
                WR => wr_wire,
                PE => open,
                FE => open,
                OE => open,
                RST => reset
            );
    end Behavioral;
