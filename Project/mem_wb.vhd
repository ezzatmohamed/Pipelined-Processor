
library ieee;
use ieee.std_logic_1164.all;

-- Pipe 4 - Mem stage to WB stage

Entity mem_wb is Port (

	  reg_data1_in,reg_data2_in,dataout_in,alu_out_in : in std_logic_vector(15 downto 0);
	  inst_in : in std_logic_vector ( 31 downto 0 );
          RW_in ,MtoR_in ,int_in  : in std_logic;
	 
          clk ,rst        : in std_logic;
          reg_data1_out,reg_data2_out,dataout_out,alu_out_out : out std_logic_vector(15 downto 0);
          inst_out : out std_logic_vector ( 31 downto 0 );
	  RW_out,MtoR_out,int_out    : out std_logic);
    End;

Architecture behave of mem_wb is
    begin
        process(clk)
        begin
            if(rst = '1') then
		  inst_out <= (others=>'0');
		dataout_out <= (others=>'0');
		alu_out_out <= (others=>'0');
		reg_data1_out <= (others=>'0'); 
		reg_data2_out <= (others=>'0');
		RW_out <= '0';
		MtoR_out <= '0';
           	int_out<='0';
	    elsif( clk'event and clk = '1') then
		int_out <= int_in;
                inst_out <= inst_in;
		dataout_out <= dataout_in;
		alu_out_out <= alu_out_in;
		RW_out <= RW_in;
		MtoR_out <= MtoR_in;
		reg_data1_out <= reg_data1_in; 
		reg_data2_out <= reg_data2_in;
            end if;
        end process;
    end;
