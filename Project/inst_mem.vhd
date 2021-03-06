library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Entity inst_mem is port ( 
	clk,rst : in std_logic;
	read_address : in std_logic_vector ( 15 downto 0 );
	instruction : out std_logic_vector ( 31 downto 0)
);
end entity inst_mem;

architecture behave of inst_mem is

type memory_type is array (0 to 1023) of std_logic_vector(15 downto 0);  -- 1 KB of 16-bit width 
signal mem : memory_type;

signal 	pcplus1 : std_logic_vector(15 downto  0);
signal temp : std_logic_vector( 31 downto 0 );
begin

pcplus1 <= std_logic_vector(unsigned(read_address) + 1);

process(clk,rst)
begin
if( rst = '1' ) then temp <= (others =>'0'); 

elsif rising_edge(clk) then
temp <= mem(to_integer(unsigned(read_address))) & mem(to_integer(unsigned(pcplus1))) ;
end if;
end process;

instruction <= temp ;

end architecture behave;
