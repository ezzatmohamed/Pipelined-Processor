library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Entity memory is port ( 

	clk,MW,MR : in std_logic;                         -- Clock , Memory Write Enable , Memory Read Enable
 	address : in std_logic_vector(15 downto 0);       -- Address
	datain : in std_logic_vector(15 downto 0);        -- Write-Data 
	dataout,M1 : out std_logic_vector(15 downto 0) );	  -- Read-Data
end entity memory;

architecture behave of memory is

type memory_type is array (0 to 1023) of std_logic_vector(15 downto 0);  -- 1 KB of 16-bit width 
signal mem : memory_type;

begin

M1 <= mem(1);
process(clk) is

begin
if rising_edge(clk) then
 if MW = '1' then
	mem(to_integer(unsigned(address))) <= datain;
 end if;
end if;
if MR = '1' then
	dataout <= mem(to_integer(unsigned(address)));
end if;
end process;
end architecture behave;