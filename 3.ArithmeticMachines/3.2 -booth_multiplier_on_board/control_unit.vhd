library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    Generic(N : integer := 8);
    Port(   clock : in STD_LOGIC;
            reset : in STD_LOGIC;
            btn_x : in STD_LOGIC;
            btn_y : in STD_LOGIC;
            switch_in : in STD_LOGIC_VECTOR(N-1 downto 0);
            btn_start : in STD_LOGIC;
            start_out : out STD_LOGIC;
            x_out : out STD_LOGIC_VECTOR(N-1 downto 0);
            y_out : out STD_LOGIC_VECTOR(N-1 downto 0);
            check_x : out STD_LOGIC;
            check_y : out STD_LOGIC;
            check_start : out STD_LOGIC);
            
end control_unit;

architecture Behavioral of control_unit is

    signal x_out_reg : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
    signal y_out_reg : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
    signal start_out_reg : STD_LOGIC := '0';
    
    signal check_x_reg : STD_LOGIC := '0';
    signal check_y_reg : STD_LOGIC := '0';
    signal check_start_reg : STD_LOGIC := '0'; 
    
    begin
        
        input_proc: process(clock)
            begin
                if (clock'event and clock = '1') then
                    if (reset = '1') then
                        x_out_reg <= (others => '0');
                        y_out_reg <= (others => '0');
                        start_out_reg <= '0';
                        check_x_reg <= '0';
                        check_y_reg <= '0';
                        check_start_reg <= '0';
                    else
                        start_out_reg <= '0';
                        if (btn_x = '1') then
                            x_out_reg <= switch_in;
                            check_x_reg <= '1';
                            check_start_reg <= '0';
                        elsif (btn_y = '1') then
                            y_out_reg <= switch_in;
                            check_y_reg <= '1';
                            check_start_reg <= '0';
                        elsif (btn_start = '1') then
                            start_out_reg <= '1';
                            check_x_reg <= '0';
                            check_y_reg <= '0';
                            check_start_reg <= '1';
                        end if;
                    end if;
                end if;
        end process;
        
        x_out <= x_out_reg;
        y_out <= y_out_reg;
        start_out <= start_out_reg;
        
        check_x <= check_x_reg;
        check_y <= check_y_reg;
        check_start <= check_start_reg;
        
end Behavioral;