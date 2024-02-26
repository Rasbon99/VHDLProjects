

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity priority_omega_network is
    Port(   input_0 : in STD_LOGIC_VECTOR(1 downto 0);
            input_1 : in STD_LOGIC_VECTOR(1 downto 0);
            input_2 : in STD_LOGIC_VECTOR(1 downto 0);
            input_3 : in STD_LOGIC_VECTOR(1 downto 0);
            dst_0 : in STD_LOGIC_VECTOR (1 downto 0);
            dst_1 : in STD_LOGIC_VECTOR (1 downto 0);
            dst_2 : in STD_LOGIC_VECTOR (1 downto 0);
            dst_3 : in STD_LOGIC_VECTOR (1 downto 0);
            handler_0 : in STD_LOGIC;
            handler_1 : in STD_LOGIC;
            handler_2 : in STD_LOGIC;
            handler_3 : in STD_LOGIC;
            output_0 : out STD_LOGIC_VECTOR(1 downto 0);
            output_1 : out STD_LOGIC_VECTOR(1 downto 0);
            output_2 : out STD_LOGIC_VECTOR(1 downto 0);
            output_3 : out STD_LOGIC_VECTOR(1 downto 0));
end priority_omega_network;

architecture Behavioral of priority_omega_network is

    component omega_network is
        Port(   input_0 : in STD_LOGIC_VECTOR(1 downto 0);
                input_1 : in STD_LOGIC_VECTOR(1 downto 0);
                input_2 : in STD_LOGIC_VECTOR(1 downto 0);
                input_3 : in STD_LOGIC_VECTOR(1 downto 0);
                src_address: in STD_LOGIC_VECTOR(1 downto 0);
                dst_address : in STD_LOGIC_VECTOR(1 downto 0);
                output_0 : out STD_LOGIC_VECTOR(1 downto 0);
                output_1 : out STD_LOGIC_VECTOR(1 downto 0);
                output_2 : out STD_LOGIC_VECTOR(1 downto 0);
                output_3 : out STD_LOGIC_VECTOR(1 downto 0));
    end component;
    
    component priority_manager is
        Port(   handler_0 : in STD_LOGIC;
                handler_1 : in STD_LOGIC;
                handler_2 : in STD_LOGIC;
                handler_3 : in STD_LOGIC;
                dst_0 : in STD_LOGIC_VECTOR (1 downto 0);
                dst_1 : in STD_LOGIC_VECTOR (1 downto 0);
                dst_2 : in STD_LOGIC_VECTOR (1 downto 0);
                dst_3 : in STD_LOGIC_VECTOR (1 downto 0);
                priority_src: out STD_LOGIC_VECTOR (1 downto 0);
                priority_dst : out STD_LOGIC_VECTOR (1 downto 0));
    end component;

    signal priority_src_wire : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
    signal priority_dst_wire : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');

    begin
    
        OMEGA_NET: omega_network port map (
            input_0 => input_0,
            input_1 => input_1,
            input_2 => input_2,
            input_3 => input_3,
            src_address => priority_src_wire,
            dst_address => priority_dst_wire,
            output_0 => output_0,
            output_1 => output_1,
            output_2 => output_2,
            output_3 => output_3);
            
        PR_MNG: priority_manager port map(
            handler_0 => handler_0,
            handler_1 => handler_1,
            handler_2 => handler_2,
            handler_3 => handler_3,
            dst_0 => dst_0,
            dst_1 => dst_1,
            dst_2 => dst_2,
            dst_3 => dst_3,
            priority_src => priority_src_wire,
            priority_dst => priority_dst_wire);

end Behavioral;
