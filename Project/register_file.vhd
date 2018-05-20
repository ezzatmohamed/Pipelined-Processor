Library ieee; 
Use ieee.std_logic_1164.all; 
use IEEE.numeric_std.all;
Entity Reg_file is 
port( 
reg1_sel:in std_logic_vector ( 2 downto 0);
reg2_sel:in std_logic_vector ( 2 downto 0);
w_sel:in std_logic_vector ( 2 downto 0);

w_en:in std_logic;
clk:in std_logic;
reset:in std_logic;

w_data:in std_logic_vector ( 15 downto 0);

reg1_data:out std_logic_vector ( 15 downto 0);
reg2_data:out std_logic_vector ( 15 downto 0)
);
 end Reg_file; 
 



Architecture behave of Reg_file is

component reg is port( 
	Clk,Rst : in std_logic; 
	d : in std_logic_vector(15 downto 0);
	q : out std_logic_vector(15 downto 0)
);
end component;
 
type mem_array is array(0 to 5) of STD_LOGIC_VECTOR (15 downto 0);
signal reg_mem: mem_array;

begin

    reg1_data <= reg_mem(to_integer(unsigned(reg1_sel)));
    reg2_data <= reg_mem(to_integer(unsigned(reg2_sel)));

    process(clk)
        begin
        if clk='0' and clk'event and w_en = '1' then
            -- write to reg. mem. when the reg_write flag is set and on a falling clock
            reg_mem(to_integer(unsigned(w_sel))) <= w_data;
        end if;
    end process;
 	

end behave;
