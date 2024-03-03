library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity sys_a_b is
        Port (  start : in STD_LOGIC;
                reset : in STD_LOGIC;
                clk : in STD_LOGIC ); 
end sys_a_b;

architecture Behavioral of sys_a_b is

    component a_unit is
        Port(   clk : in STD_LOGIC;
                reset : in STD_LOGIC;
                data_bus_out : out STD_LOGIC_VECTOR (7 downto 0);
                txd : out STD_LOGIC;
                start : in STD_LOGIC);
    end component;

    component b_unit is
        Port(   clk : in STD_LOGIC;
                reset : in STD_LOGIC;
                data_bus_in : in STD_LOGIC_VECTOR (7 downto 0);
                rxd : in STD_LOGIC );
    end component;
    
    signal data_bus : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal txd_rxd : STD_LOGIC;
    
begin

        A : a_unit
            port map (
                start => start,
                reset => reset,
                clk => clk,
                data_bus_out => data_bus,
                txd => txd_rxd
            );

        B : b_unit
            port map (
                reset => reset,
                clk => clk,
                data_bus_in => data_bus,
                rxd => txd_rxd
            );

end Behavioral;
