library ieee;
use ieee.std_logic_1164.all;

-- Pipe 3 - EX stage to MEM stage

Entity ex_m is Port (
	  
	  branch_in,int_in,rt_in,store_in,push_pop_in,call_in,MW_in,MR_in,MtoR_in,RW_in: in std_logic;
	  instr_in : in std_logic_vector( 31 downto 0 );
	  reg_data1_in,reg_data2_in,sp_in,pcplus1_in,alu_out_in : in std_logic_vector ( 15 downto 0 );
          clk,rst         : in std_logic;
          branch_out,int_out,rt_out,store_out,push_pop_out,call_out,MW_out,MR_out,MtoR_out,RW_out: out std_logic;
	  instr_out : out std_logic_vector( 31 downto 0 );
	  reg_data1_out,reg_data2_out,sp_out,pcplus1_out,alu_out_out : out std_logic_vector ( 15 downto 0 ));
    End;

Architecture behav of ex_m is
    begin
        process(clk)
        begin
            if(rst = '1') then
		alu_out_out<= (others=>'0');
		RW_out      <= '0';
                push_pop_out<= '0';
		call_out<='0';
		MW_out <= '0';
		MR_out <= '0'; 
		MtoR_out <= '0';
		instr_out <= (others=>'0');
		sp_out <= (others=>'0'); 
		pcplus1_out <= (others=>'0');
		reg_data1_out <= (others=>'0');
		reg_data1_out <= (others=>'0'); 
		reg_data2_out <= (others=>'0');
                store_out <='0';
		rt_out <='0';
		int_out <='0';
		branch_out <='0';
	    elsif( clk'event and clk = '1') then
		int_out<= int_in;
		alu_out_out<=alu_out_in;
		RW_out      <= RW_in;
                push_pop_out<= push_pop_in;
		call_out<=call_in;
		MW_out <= MW_in;
		MR_out <= MR_in; 
		MtoR_out <= MtoR_in;
		instr_out <= instr_in;
		sp_out <=sp_in; 
		pcplus1_out <= pcplus1_in;
		reg_data1_out <= reg_data1_in;
		store_out <= store_in;
		reg_data1_out <= reg_data1_in; 
		reg_data2_out <= reg_data2_in;
		rt_out<= rt_in;
		branch_out <= branch_in;
            end if;
        end process;
    end;

