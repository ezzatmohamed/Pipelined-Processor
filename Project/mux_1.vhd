
------------------------------------------------------
-- General Multiplexer component
--
-- Just takes in 2 inputs and chooses between them.
------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux_1 is 

	port (
		x,y: in std_logic;
		s: in std_logic;
		z: out std_logic
	);
end mux_1;

architecture beh of mux_1 is
	begin
	z <= x when (s='0') else y;
end beh;