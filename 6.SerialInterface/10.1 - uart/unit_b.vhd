library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;

entity b_unit is
    Port (  clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            data_bus_in : in STD_LOGIC_VECTOR (7 downto 0);
            rxd : in STD_LOGIC );
end b_unit;

architecture Behavioral of b_unit is

    component control_unit_b is 
        Port (  address : in STD_LOGIC_VECTOR (2 downto 0);
                reset : in STD_LOGIC;
                clk : in STD_LOGIC;
                rda : in STD_LOGIC;
                rxd : in STD_LOGIC;
                db_out : in STD_LOGIC_VECTOR (7 downto 0);
                data_mem_out : out STD_LOGIC_VECTOR (7 downto 0); 
                write : out STD_LOGIC;
                rd : out STD_LOGIC;
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
    
    component mem is
        Generic(N : integer range 0 to 255 := 8;
                M : integer := 8);
        Port (  mem_input : in STD_LOGIC_VECTOR(M -1 downto 0);
                mem_address : in STD_LOGIC_VECTOR(integer(ceil(log2(real(N)))) - 1 downto 0); 
                clock : in STD_LOGIC;
                mem_write : in STD_LOGIC;
                mem_read : in STD_LOGIC;
                mem_output : out STD_LOGIC_VECTOR(M - 1 downto 0));
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
    
    signal mem_write_wire : STD_LOGIC := '0';
    signal counter_enable_wire : STD_LOGIC := '0';
    signal counter_reset_wire : STD_LOGIC := '0';
    signal address_wire : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
    signal rda_wire : STD_LOGIC;
    signal rd_wire : STD_LOGIC;
    signal data_mem_out_wire : STD_LOGIC_VECTOR (7 downto 0);
    signal db_out_wire : STD_LOGIC_VECTOR (7 downto 0);
        
    begin
    
        CU_B : control_unit_b
            port map (
                address => address_wire,
                reset => reset,
                clk => clk,
                rda => rda_wire,
                rxd => rxd,
                db_out => db_out_wire,
                data_mem_out => data_mem_out_wire,
                write => mem_write_wire,
                rd => rd_wire,
                count_enable => counter_enable_wire,
                count_reset => counter_reset_wire
            );
    
        COUNTER_B : counter_mod_n
            port map (
                CLK_cmn => clk,
                reset_cmn => counter_reset_wire,
                enable_cmn => counter_enable_wire,
                q_cmn => address_wire
            );
    
        MEM_B : mem
            port map (
                mem_input => data_mem_out_wire,
                mem_address => address_wire,
                clock => clk,
                mem_write => mem_write_wire,
                mem_read => '0'
            );
    
        UART_B : Rs232RefComp
            port map (
                TXD => open,
                RXD => rxd,
                CLK => clk,
                DBIN => data_bus_in,
                DBOUT => db_out_wire,
                RDA => rda_wire,
                TBE => open,
                RD => rd_wire,
                WR => '0',
                PE => open,
                FE => open,
                OE => open,
                RST => reset
            );
    end Behavioral;

