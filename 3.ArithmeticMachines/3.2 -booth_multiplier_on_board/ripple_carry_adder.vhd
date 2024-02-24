
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ripple_carry_adder is
    Generic(N : integer := 4);
    Port(   x : in STD_LOGIC_VECTOR (N-1 downto 0);
            y : in STD_LOGIC_VECTOR (N-1 downto 0);
            cin : in STD_LOGIC;
            cout : out STD_LOGIC;
            s : out STD_LOGIC_VECTOR (N-1 downto 0));
end ripple_carry_adder;

architecture Structural of ripple_carry_adder is

    component full_adder is
        Port ( a : in STD_LOGIC;
               b : in STD_LOGIC;
               cin : in STD_LOGIC;
               cout : out STD_LOGIC;
               s : out STD_LOGIC);
    end component;
    
    signal cout_wire : STD_LOGIC_VECTOR (N-2 downto 0) := (others => '0');

    begin
        
        FA: for i in 0 to N-1 GENERATE
            
            first: if i = 0 GENERATE
                FA0: full_adder port map(
                    a => x(i),
                    b => y(i),
                    cin => cin,
                    cout => cout_wire(i),
                    s => s(i));
            END GENERATE;
            
            last: if i = N-1 GENERATE
                FANminus1: full_adder port map(
                    a => x(i),
                    b => y(i),
                    cin => cout_wire(i-1),
                    cout => cout,
                    s => s(i));
            END GENERATE;
        
            rest: if i > 0 and i < N-1 GENERATE
                FA: full_adder port map(
                    a => x(i),
                    b => y(i),
                    cin => cout_wire(i-1),
                    cout => cout_wire(i),
                    s => s(i));
            END GENERATE;
                        
        END GENERATE;


end Structural;
