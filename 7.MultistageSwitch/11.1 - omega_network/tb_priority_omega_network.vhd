library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_priority_omega_network is
end tb_priority_omega_network;

architecture behavior of tb_priority_omega_network is 

   component priority_omega_network
   port(
        input_0 : in  STD_LOGIC_VECTOR (1 downto 0);
        input_1 : in  STD_LOGIC_VECTOR (1 downto 0);
        input_2 : in  STD_LOGIC_VECTOR (1 downto 0);
        input_3 : in  STD_LOGIC_VECTOR (1 downto 0);
        dst_0 : in  STD_LOGIC_VECTOR (1 downto 0);
        dst_1 : in  STD_LOGIC_VECTOR (1 downto 0);
        dst_2 : in  STD_LOGIC_VECTOR (1 downto 0);
        dst_3 : in  STD_LOGIC_VECTOR (1 downto 0);
        handler_0 : in  STD_LOGIC;
        handler_1 : in  STD_LOGIC;
        handler_2 : in  STD_LOGIC;
        handler_3 : in  STD_LOGIC;
        output_0 : out  STD_LOGIC_VECTOR (1 downto 0);
        output_1 : out  STD_LOGIC_VECTOR (1 downto 0);
        output_2 : out  STD_LOGIC_VECTOR (1 downto 0);
        output_3 : out  STD_LOGIC_VECTOR (1 downto 0)
      );
   end component;

   signal input_0 : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
   signal input_1 : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
   signal input_2 : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
   signal input_3 : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
   signal dst_0 : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
   signal dst_1 : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
   signal dst_2 : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
   signal dst_3 : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
   signal handler_0 : STD_LOGIC := '0';
   signal handler_1 : STD_LOGIC := '0';
   signal handler_2 : STD_LOGIC := '0';
   signal handler_3 : STD_LOGIC := '0';

   signal output_0 : STD_LOGIC_VECTOR (1 downto 0);
   signal output_1 : STD_LOGIC_VECTOR (1 downto 0);
   signal output_2 : STD_LOGIC_VECTOR (1 downto 0);
   signal output_3 : STD_LOGIC_VECTOR (1 downto 0);

   constant clk_period : time := 10 ns;
   signal clk : STD_LOGIC := '0';

begin

   uut: priority_omega_network port map (
          input_0 => input_0,
          input_1 => input_1,
          input_2 => input_2,
          input_3 => input_3,
          dst_0 => dst_0,
          dst_1 => dst_1,
          dst_2 => dst_2,
          dst_3 => dst_3,
          handler_0 => handler_0,
          handler_1 => handler_1,
          handler_2 => handler_2,
          handler_3 => handler_3,
          output_0 => output_0,
          output_1 => output_1,
          output_2 => output_2,
          output_3 => output_3
        );

   clk_process :process
   begin
        clk <= not clk;
        wait for clk_period/2;
   end process;

   stim_proc: process
   begin

      wait for 100 ns;
      
      handler_0 <= '1';
      handler_1 <= '1';
      handler_2 <= '1';
      handler_3 <= '1';
      
      input_0 <= "01";
      input_1 <= "01";
      input_2 <= "10";
      input_3 <= "11";
      
      dst_0 <= "11";
      dst_1 <= "10";
      dst_2 <= "01";
      dst_3 <= "00";

      wait for clk_period*2;
      
      handler_0 <= '0';
      
      wait for clk_period*2;
      
      handler_1 <= '0';
      
      wait for clk_period*2;
      
      handler_2 <= '0';
      
      wait for clk_period*2;
      
      handler_3 <= '0';
      
      wait for clk_period*10;
      
      handler_2 <= '1';
      
      wait for clk_period*2;
      
      handler_1 <= '1';
      
      wait for clk_period*2;
      
      handler_3 <= '1';
      
      wait for clk_period*2;
      
      handler_0 <= '1';
      
      wait for clk_period*10;
      
      handler_0 <= '0';
      handler_1 <= '0';
      handler_2 <= '0';
      handler_3 <= '0';

      wait;
   end process;

end;
