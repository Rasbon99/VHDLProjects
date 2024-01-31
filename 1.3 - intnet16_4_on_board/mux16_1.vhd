library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux16_1 is port(
    c : in STD_LOGIC_VECTOR (15 downto 0);
    r : in STD_LOGIC_VECTOR (3 downto 0);
    w : out STD_LOGIC);
end mux16_1;

architecture structural of mux16_1 is 
    signal u : STD_LOGIC_VECTOR(3 downto 0) := "0000"; 

    component mux4_1
        port(
            b : in STD_LOGIC_VECTOR (3 downto 0);
            t : in STD_LOGIC_VECTOR (1 downto 0);
            z : out STD_LOGIC);
        end component;

    begin
        mux0 : mux4_1 port map(
            b(0) => c(0),
            b(1) => c(1),
            b(2) => c(2),
            b(3) => c(3),

            t(0) => r(0),
            t(1) => r(1),

            z => u(0));

        mux1 : mux4_1 port map(
            b(0) => c(4),
            b(1) => c(5),
            b(2) => c(6),
            b(3) => c(7),

            t(0) => r(0),
            t(1) => r(1),

            z => u(1));

        mux2 : mux4_1 port map(
            b(0) => c(8),
            b(1) => c(9),
            b(2) => c(10),
            b(3) => c(11),

            t(0) => r(0),
            t(1) => r(1),

            z => u(2));

        mux3 : mux4_1 port map(
            b(0) => c(12),
            b(1) => c(13),
            b(2) => c(14),
            b(3) => c(15),

            t(0) => r(0),
            t(1) => r(1),

            z => u(3));

        mux5 : mux4_1 port map(
            b(0) => u(0),
            b(1) => u(1),
            b(2) => u(2),
            b(3) => u(3),

            t(0) => r(2),
            t(1) => r(3),

            z => w);

end structural;