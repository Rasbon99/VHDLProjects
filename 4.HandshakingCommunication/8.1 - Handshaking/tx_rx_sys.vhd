
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tx_rx_sys is
    Generic(N: integer := 16;
            M: integer := 8);
    Port(   start: in STD_LOGIC;
            reset: in STD_LOGIC;
            clock_a : in STD_LOGIC;
            clock_b : in STD_LOGIC);
end tx_rx_sys;

architecture Behavioral of tx_rx_sys is

    component a_unit is
        Generic(N : integer := N;
                M : integer := M);
        Port(   clock_a : in STD_LOGIC;
                reset : in STD_LOGIC;
                data_out : out STD_LOGIC_VECTOR (M-1 downto 0);
                req : out STD_LOGIC;
                done : in STD_LOGIC;
                ack : in STD_LOGIC;
                start : in STD_LOGIC);
    end component;
    
    component b_unit is
        Generic(N : integer := N;
                M : integer := M);
        Port(   clock_b : in STD_LOGIC;
                reset : in STD_LOGIC;
                data_in : in STD_LOGIC_VECTOR (M-1 downto 0);
                req : in STD_LOGIC;
                done : out STD_LOGIC;
                ack : out STD_LOGIC);
    end component;
    
    signal data_bus: STD_LOGIC_VECTOR (M-1 downto 0) := (others => '0');
    signal req_wire : STD_LOGIC := '0';
    signal ack_wire : STD_LOGIC := '0';
    signal done_wire : STD_LOGIC := '0';

    begin

        A: a_unit port map (
            clock_a => clock_a,
            reset => reset,
            data_out => data_bus,
            req => req_wire,
            ack => ack_wire,
            done => done_wire,
            start => start);
            
        B: b_unit port map (
            clock_b => clock_b,
            reset => reset,
            data_in => data_bus,
            req => req_wire,
            done => done_wire,
            ack => ack_wire);


end Behavioral;
