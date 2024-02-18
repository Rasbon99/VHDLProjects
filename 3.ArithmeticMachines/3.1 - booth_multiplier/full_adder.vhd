
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           cin : in STD_LOGIC;
           cout : out STD_LOGIC;
           s : out STD_LOGIC);
end full_adder;

architecture Dataflow of full_adder is

    signal sum : STD_LOGIC := '0';

    begin
        sum <= a xor b;
        s <= sum xor cin;
        cout <= (a and b) or (cin and sum);        
    
end Dataflow;
