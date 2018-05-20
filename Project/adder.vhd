library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
Entity adder is
    Port (A, B : in unsigned(15 downto 0);
          Y    : out std_logic_vector(15 downto 0));
    End;

Architecture behave of adder is
    begin
    Y <= std_logic_vector(A + B);
    end;

