	-- RTI - RET - SETC - CLRC - Forwarding - Branch Prediction   not included yet


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity main is port (

clk,rst,int : in std_logic;
in_port : in std_logic_vector( 15 downto 0 );
out_port : out std_logic_vector ( 15 downto 0 )

);
end main;




architecture behave of main is 
 
-------------------  Needed  Components   ----------------------
component pc is  port ( 
Clk,Rst,stall : in std_logic; 
d : in std_logic_vector(15 downto 0);
 q : out std_logic_vector(15 downto 0)
);
 end component; 

----------------------------\\

component hazard_detection is port (
--	clk : in std_logic;
	id_ex_MR : in std_logic;
	id_ex_Rd : in std_logic_vector(2 downto 0);
	if_id_Rs : in std_logic_vector(2 downto 0);
	if_id_Rd : in std_logic_vector(2 downto 0);
	
	stall	 : out std_logic
	
);
end component;

-------------------------------\\
component forward_unit is 
	port (
		clk : in std_logic;
		id_ex_Rs,id_ex_Rd,ex_m_Rd,m_wb_Rd: in std_logic_vector(2 downto 0);
		ex_m_RW,m_wb_RW: in std_logic;
		Fa,Fb: out std_logic_vector(1 downto 0)
	);
end component;

---------------------------------\\
component mux_1 is 

	port (
		x,y: in std_logic;
		s: in std_logic;
		z: out std_logic
	);
end component;
--------------------------------\\
component mem_wb is Port (

	  reg_data1_in,reg_data2_in,dataout_in,alu_out_in : in std_logic_vector(15 downto 0);
	  inst_in : in std_logic_vector ( 31 downto 0 );
          RW_in ,MtoR_in,int_in   : in std_logic;
	 
          clk ,rst        : in std_logic;
          reg_data1_out,reg_data2_out,dataout_out,alu_out_out : out std_logic_vector(15 downto 0);
          inst_out : out std_logic_vector ( 31 downto 0 );
	  RW_out,MtoR_out,int_out    : out std_logic);

    End component;

-----------------------------------\

component ex_m is Port (
	  
	  branch_in,int_in,rt_in,store_in,push_pop_in,call_in,MW_in,MR_in,MtoR_in,RW_in: in std_logic;
	  instr_in : in std_logic_vector( 31 downto 0 );
	  reg_data1_in,reg_data2_in,sp_in,pcplus1_in,alu_out_in : in std_logic_vector ( 15 downto 0 );
          clk,rst         : in std_logic;
          branch_out,int_out,rt_out,store_out,push_pop_out,call_out,MW_out,MR_out,MtoR_out,RW_out: out std_logic;
	  instr_out : out std_logic_vector( 31 downto 0 );
	  reg_data1_out,reg_data2_out,sp_out,pcplus1_out,alu_out_out : out std_logic_vector ( 15 downto 0 ));
    End component;

----------------------------\


component alu is 
	port(
-- 		inputs:
	 	in_1, in_2 		: in unsigned(15 downto 0);		-- operands
		op 		: in std_logic_vector(3 downto 0);	        -- operation
		
		cin, clk 	: in std_logic;				        -- carry in, clock
		
-- 		outputs:
		cout, N, zero,over: out std_logic;			                -- carry, Negative, zero flags
		result 		: out std_logic_vector(15 downto 0)	    	        -- result
	);
end component;

------------------------\

component id_ex is Port (
	
int_id,ccr_en_in: in std_logic;
ccr_out : in std_logic_vector(3 downto 0 );
	  rt_in,rti_in: in std_logic;
	 in_port_in : in std_logic_vector( 15 downto 0 );
	  in_port_en_id,out_port_en_id,load_id,shift_id : in std_logic;
	  pcplus1_id,regdata1_id,regdata2_id : in std_logic_vector ( 15 downto 0 ); 
	  AluOp_id : in std_logic_vector ( 3 downto 0 ); 
	  carry_id :  in std_logic_vector( 1 downto 0 );
	  push_id,pop_id,MR_id,MW_id,MtoR_id,AluSrc_id,RW_id,j_id,jz_id,jn_id,jc_id,store_id,call_id :  in std_logic;
	  inst_id : in std_logic_vector ( 31 downto 0 );

	 	
          clk,rst,branch_rst,stall,int_rst          : in std_logic;
 int_ex, ccr_en_out:out std_logic;       
ccr_out_ex : out std_logic_vector(3 downto 0 );
	rt_out,rti_out : out std_logic;
	  in_port_out : out std_logic_vector( 15 downto 0 );
	in_port_en_ex,out_port_en_ex,load_ex,shift_ex : out std_logic;
   	  pcplus1_ex,regdata1_ex,regdata2_ex : out std_logic_vector ( 15 downto 0 );
	  AluOp_ex : out std_logic_vector ( 3 downto 0 ); 
	  carry_ex : out std_logic_vector ( 1 downto 0 );
	  push_ex,pop_ex,MR_ex,MW_ex,MtoR_ex,AluSrc_ex,RW_ex,j_ex,jz_ex,jn_ex,jc_ex,store_ex,call_ex : out std_logic;
	  inst_ex : out std_logic_vector ( 31 downto 0 )

);

end component;



component Reg_file is 
port( 
reg1_sel:in std_logic_vector ( 2 downto 0);
reg2_sel:in std_logic_vector ( 2 downto 0);
w_sel:in std_logic_vector ( 2 downto 0);

w_en : in std_logic;
clk:in std_logic;
reset:in std_logic;

w_data:in std_logic_vector ( 15 downto 0);

reg1_data:out std_logic_vector ( 15 downto 0);
reg2_data:out std_logic_vector ( 15 downto 0)
);
 end component; 
 

component control is port (

	--input
	opcode : in std_logic_vector( 4 downto 0 );
	int :  in std_logic;
	--output
	AluOp : out std_logic_vector( 3 downto 0 );
	carry : out std_logic_vector( 1 downto 0 );
	rt,out_port,in_port,load,shift,push,pop,MR,MW,MtoR,AluSrc,RW,j,jz,jn,jc,store,call,rti ,ccr_en: out std_logic

);
end component;

------------------------\\

component if_id is Port (
	  int_if: in std_logic;
	  instruction : in std_logic_vector(31 downto 0);
          pcplus1,in_port_in    : in std_logic_vector(15 downto 0);
	 
          clk,rst,branch_rst,branch_rst_m,stall,int_rst        : in std_logic;
          int_id : out std_logic;
 	  instr_out   : out std_logic_vector(31 downto 0);
          pc_out ,in_port_out    : out std_logic_vector(15 downto 0));
end component;

------------------------\\

component adder is port (
	  A, B : in unsigned(15 downto 0);
          Y    : out std_logic_vector(15 downto 0)
);

end component;
------------------------\\
component sp_reg is port(        					-- Register component
	Clk,Rst : in std_logic; 
	d : in std_logic_vector(15 downto 0);
	q : out std_logic_vector(15 downto 0)
);
end component;
------------------------\\
component reg is 
generic (n: natural);
port(        					-- Register component
	Clk,Rst : in std_logic; 
	d : in std_logic_vector(n-1 downto 0);
	q : out std_logic_vector(n-1 downto 0)
);
end component;
------------------------\\

component inst_mem is port ( 
	clk,rst : in std_logic;
	read_address : in std_logic_vector ( 15 downto 0 );
	instruction : out std_logic_vector ( 31 downto 0)
);
end component;
-----------------------\\


------------------------\\

component mux is 
	generic (n: natural); -- number of bits in the choices
	port (
		x,y: in std_logic_vector(n-1 downto 0);
		s: in std_logic;
		z: out std_logic_vector(n-1 downto 0)
	);
end component;
-------------------------\\
component memory is port ( 

	clk,MW,MR : in std_logic;                         -- Clock , Memory Write Enable , Memory Read Enable
 	address : in std_logic_vector(15 downto 0);       -- Address
	datain : in std_logic_vector(15 downto 0);        -- Write-Data 
	dataout,M1 : out std_logic_vector(15 downto 0) 
);							  -- Read-Data
end component;


----------------------------------------------------------------

-- Needed signals for Progam counter .

signal pcminus1_if,pc_out,pc_out2,pc_out3,pc_actual,pcplus1_if,pcplus1_id,pcplus1_ex,pcplus1_m,jump_address,pc_if,pc_if2,pc_id: std_logic_vector( 15 downto 0 );    
signal pc_selc: std_logic;


signal jump_selc,c2: std_logic;

--------------------------------------
-- Needed signals for CCR  .

signal ccr_in,ccr_out,ccr_out_ex,ccr_in2,ccr_out2 : std_logic_vector(3 downto 0 );
signal ccr_en_ex,ccr_en_id: std_logic;
--------------------------------------
--------------------------------------
-- Needed signals for Stack Pointer  .

signal sp_in,sp_out,sp_if,sp_id,sp_ex,sp_ex2,sp_m,sp_wb : std_logic_vector ( 15 downto 0 );

signal sp_plus1,sp_minus1,sp_push_pop : std_logic_vector ( 15 downto 0 );

signal sp_mux_ex,sp_mux_m : std_logic;
--------------------------------------
-- Signals for Instruction Memory 
signal inst_if,inst_id,inst_ex,inst_m,inst_wb : std_logic_vector( 31 downto 0 );

--------------------------------------

-- Signals for Controller unit 

signal carry_id :  std_logic_vector( 1 downto 0 );
signal shift_id,push_id,pop_id,MR_id,MW_id,MtoR_id,AluSrc_id,RW_id,j_id,jz_id,jn_id,jc_id,store_id,call_id :  std_logic;
signal AluOp_id : std_logic_vector( 3 downto 0 );

signal carry_ex : std_logic_vector ( 1 downto 0 );
signal in_id,in_ex,in_m,in_wb,outP_id,outP_ex,outP_m,outP_wb,shift_ex,push_ex,pop_ex,MR_ex,MW_ex,MtoR_ex,AluSrc_ex,RW_ex,j_ex,jz_ex,jn_ex,jc_ex,store_ex,call_ex :  std_logic;
signal AluOp_ex : std_logic_vector( 3 downto 0 );


signal MR_m,MW_m,MtoR_m,RW_m,store_m,call_m : std_logic;

signal RW_wb ,MtoR_wb: std_logic;
--------------------------------------
signal reg_write : std_logic_vector ( 2 downto 0 );
signal w_en : std_logic;

signal in_port_en_id,in_port_en_ex,in_port_en_m,in_port_en_wb,out_port_en_id,out_port_en_ex: std_logic;
signal reg_data1_id,reg_data2_id,in_port_id,in_port_ex,in_port_m,in_port_wb,out_port_id,out_port_ex,out_port_m,out_port_wb : std_logic_vector(15 downto 0 );
signal reg_data1_ex,reg_data1_wb,reg_data2_wb,reg_data1_m,reg_data2_ex,reg_data2_m,reg_data1T1_ex,reg_data2T1_ex,reg_data1T2_ex,reg_data2T2_ex : std_logic_vector(15 downto 0 );
--------------------------------------
-- Alu result Signals

signal imm_ex,alu_out_ex2,alu_out_ex,alu_out_m,alu_out_wb,Alu_in2,Alu_in3 : std_logic_vector(15 downto 0 );
--------------------------------------
-- Memory stage needed signals
signal address_m,data_m,dataT_m,dataout_m,dataout_wb,M1: std_logic_vector ( 15 downto 0 ); 
--------------------------------------
signal wb_data : std_logic_vector(15 downto 0 );
signal carryT1_ex:std_logic;
--------------------------------------
signal load_ex,load_id,branch_rst,branch_rst_m,stall : std_logic;

--------------------------------
signal ccrT_out,ccrT_in : std_logic_vector( 3 downto 0);
signal rt_id,rt_ex,rt_m,rti_ex,rti_id : std_logic;

signal int_if,int_id,int_ex ,int_m,int_wb,int_rst: std_logic;
signal pc_ex,pc_out4 : std_logic_vector(15 downto 0 );
--------------------- Forward unit Signals -----------------------

signal FA,FB : std_logic_vector(1 downto 0 );


begin

------------------ out-port

out_port <= "0000000000000000" when rst = '1' else alu_out_ex when out_port_en_ex = '1' ;


----------------------   Fetching Stage   -------	---------------

pcmux : mux generic map(16) port map(pcplus1_if,reg_data2_ex,jump_selc,pc_out2); 

rt_mux : mux generic map(16) port map (pc_out2,dataout_m,rt_m,pc_out3);

pcmux2 : mux generic map(16) port map(pc_out3,M1,int_ex,pc_out4); 

pc_reg : reg generic map(16) port map (clk,rst,pc_out4,pc_if);			-- Program counter register


--pc_reg : pc generic map(16) port map (clk,rst,stall,pc_out,pc_if);			-- Program counter register

pcplus1_if <= std_logic_vector(unsigned(pc_if) + 2) when stall = '0' else pc_if;
pcminus1_if <= std_logic_vector(unsigned(pc_if) - 2);

sp: sp_reg port map (clk,rst,sp_in,sp_out);			-- Stack pointer register



ccr_mux3 : mux generic map(4) port map(ccr_out,ccr_in,ccr_en_ex,ccr_in2);

ccr_mux : mux generic map(4) port map(ccr_in2,ccrT_out,rti_ex,ccr_out2);

ccr: reg generic map(4) port map (clk,rst,ccr_out2,ccr_out); 			-- Condition code  register

ccrT_mux : mux generic map(4) port map( ccrT_out,ccr_out,int_ex,ccrT_in);

ccr_temp: reg generic map(4) port map (clk,rst,ccrT_in,ccrT_out); 			-- Register for preserving and restoring Condition code  register

instmux : mux generic map(16) port map(pc_if,pcminus1_if,stall,pc_if2); 

insts_mem :  inst_mem port map (clk,rst,pc_if2,inst_if);

pipe_IF_ID : if_id port map(int,inst_if,pcplus1_if,in_port,clk,rst,branch_rst,branch_rst_m,stall,int_rst,int_id,inst_id,pcplus1_id,in_port_id);

----------------------------------------------------------------

----------------------   Decoding Stage   ----------------------
hazard_detect : hazard_detection port map(
		id_ex_MR => load_ex,
		id_ex_Rd => inst_ex(26 downto 24 ),
		if_id_Rs => inst_id(23 downto 21 ),
		if_id_Rd => inst_id(26 downto 24 ),
		stall    => stall
);


controller : control port map(
		int    => int_id,
		ccr_en => ccr_en_id,
		out_port => out_port_en_id,
		opcode => inst_id(31 downto 27),  -- Input 
		carry  => carry_id,
		push   => push_id,
		pop    => pop_id,
		MR     => MR_id,
		MW     => MW_id,
		MtoR   => MtoR_id,
		AluSrc => AluSrc_id,
		RW     => RW_id,
		j      => j_id,
		jz     => jz_id,
		jn     => jn_id,
		jc     => jc_id,
		store  => store_id,
		call   => call_id,
		AluOp  => AluOp_id,
		load   => load_id,
	        shift  => shift_id,
		in_port => in_port_en_id,
		rt     => rt_id,
		rti	=> rti_id
		
				);
regs : Reg_file port map (
				reg1_sel => inst_id(23 downto 21) ,
				reg2_sel => inst_id(26 downto 24 ) ,
				w_sel    => inst_wb(26 downto 24),
				w_en     => RW_wb,
				clk      => clk,
				reset    => rst,
				w_data   => wb_data,
				reg1_data => reg_data1_id,
				reg2_data=> reg_data2_id);

pipe_ID_EX : id_ex port map(int_id,ccr_en_id,ccr_out,rt_id,rti_id,in_port_id,in_port_en_id,out_port_en_id,load_id,shift_id,pcplus1_id,reg_data1_id,reg_data2_id,AluOp_id,carry_id,push_id,pop_id,MR_id,MW_id,MtoR_id,AluSrc_id,RW_id,j_id,jz_id,jn_id,jc_id,store_id,call_id,inst_id,clk,rst,branch_rst,stall,int_rst,int_ex,ccr_en_ex,ccr_out_ex,rt_ex,rti_ex,in_port_ex,in_port_en_ex,out_port_en_ex,load_ex,shift_ex,pcplus1_ex,reg_data1T1_ex,reg_data2T1_ex,AluOp_ex,carry_ex,push_ex,pop_ex,MR_ex,MW_ex,MtoR_ex,AluSrc_ex,RW_ex,j_ex,jz_ex,jn_ex,jc_ex,store_ex,call_ex,inst_ex);



----------------------------------------------------------------

---------------------- Executing Stage -------------------------

--Forward_mux1 : mux generic map(16) port map(reg_data1_m,reg_data1_wb,FA(0),reg_data1T2_ex);
Forward_mux1 : mux generic map(16) port map(alu_out_m,wb_data,FA(0),reg_data1T2_ex);
Forward_mux2 : mux generic map(16) port map(reg_data1T2_ex,reg_data1T1_ex,FA(1),reg_data1_ex);

--Forward_mux3 : mux generic map(16) port map(reg_data2_m,reg_data2_wb,FB(0),reg_data2T2_ex);
Forward_mux3 : mux generic map(16) port map(alu_out_m,wb_data,FB(0),reg_data2T2_ex);
Forward_mux4 : mux generic map(16) port map(reg_data2T2_ex,reg_data2T1_ex,FB(1),reg_data2_ex);


int_rst <= '1' when int_ex = '1'  else '1' when int_m = '1' else '1' when int_wb = '1' else '0';

sp_plus1 <= std_logic_vector(unsigned(sp_out) + 1 );
sp_minus1 <= std_logic_vector(unsigned(sp_out) - 1 );
sp_mux_ex   <= ( push_ex or pop_ex);
sp_ex <= sp_plus1 when  pop_ex = '1' else sp_out;
	
spmux1: mux generic map(16) port map (sp_plus1,sp_minus1,push_ex,sp_push_pop);
spmux2: mux generic map(16) port map (sp_ex,sp_push_pop,sp_mux_ex,sp_in);	

immMux : mux generic map(16) port map(inst_ex(23 downto 8),inst_ex(20 downto 5),shift_ex,imm_ex);
src2mux : mux generic map(16) port map (reg_data2_ex,imm_ex, AluSrc_ex, Alu_in2);

inport_mux : mux generic map(16) port map (Alu_in2,in_port_ex,in_port_en_ex, Alu_in3);


alu_comp : alu port map(unsigned(reg_data1_ex),unsigned(Alu_in3),AluOp_ex,ccr_out(2),clk,c2,ccr_in(1),ccr_in(0),ccr_in(3),alu_out_ex2);


pc_ex <= std_logic_vector(unsigned(pc_if) - 4 );

int_mux : mux generic map(16) port map (alu_out_ex2,pc_ex,int_ex, alu_out_ex);

--ccr_in(3) <= '0';

carrymux : mux_1 port map ('1','0',carry_ex(1),carryT1_ex);
carry2mux : mux_1 port map (carryT1_ex,c2,carry_ex(0),ccr_in(2));


jump_selc <= ( jz_ex and ccr_out(0) ) or ( jc_ex and ccr_out(2) ) or ( jn_ex and ccr_out(1) ) or (j_ex) or (call_ex);

branch_rst <= jump_selc ;

pipe_EX_MEM : ex_m port map(
				branch_in=> branch_rst,
				branch_out=>branch_rst_m,
				int_in   => int_ex,
				int_out  => int_m,
			     reg_data1_in=> reg_data1_ex, 
			     reg_data2_in=> reg_data2_ex,
			     push_pop_in => sp_mux_ex,
			     call_in     => call_ex,
			     MW_in       => MW_ex,
			     MR_in       => MR_ex,
			     MtoR_in     => MtoR_ex,
			     RW_in       => RW_ex,
			     instr_in    => inst_ex,
			     sp_in       => sp_ex,
			     pcplus1_in  => pcplus1_ex,
			     alu_out_in  => alu_out_ex,
			     store_in    => store_ex,
			     rt_in       => rt_ex,
		     	     clk         => clk,
			     reg_data1_out=> reg_data1_m,
			     reg_data2_out=> reg_data2_m,
			     push_pop_out => sp_mux_m,
			     call_out    => call_m,
			     MW_out      => MW_m,
			     MR_out      => MR_m,
			     MtoR_out    => MtoR_m,
			     RW_out      => RW_m,	
			     instr_out   => inst_m,
  			     sp_out      => sp_m,
			     pcplus1_out => pcplus1_m,
			     alu_out_out => alu_out_m,
			     rst         => rst,
			     rt_out 	 => rt_m,
			     store_out   => store_m
);


-- Forwarding unit 

forwarding_unit : forward_unit port map( 
				clk =>clk,				
				id_ex_Rs => inst_ex( 23 downto 21 ),
				id_ex_Rd => inst_ex( 26 downto 24 ),
				ex_m_Rd  => inst_m ( 26 downto 24 ),
				m_wb_Rd  => inst_wb( 26 downto 24 ),
				ex_m_RW  => RW_m,
				m_wb_RW  => RW_wb,
				Fa       => FA,
				Fb	 => FB
); 


----------------------------------------------------------------	

---------------------- Memory  Stage -------------------------

data1mux  : mux generic map(16) port map (alu_out_m,reg_data2_m,store_m,dataT_m);	
addresmux: mux generic map(16) port map (alu_out_m,sp_m,sp_mux_m,address_m);
datamux  : mux generic map(16) port map (dataT_m,pcplus1_m,call_m,data_m);	


--MR_mux : mux_1 generic map(1) port map (MR_m,'1',int_m,read_m);
--MW_mux : mux_1 generic map(1) port map (MW_m,'1',int_m,write_m);

memeroy_m : memory port map (
				clk      => clk,
				MW       => MW_m,
				MR       => MR_m,
				address  => address_m,
				datain   => data_m,
				dataout  => dataout_m,		
				M1       => M1
);

pipe_mem_wb : mem_wb port map(
				int_in      => int_m,
				int_out    => int_wb,
				reg_data1_in=> reg_data1_m, 
			        reg_data2_in=> reg_data2_m,
				dataout_in  => dataout_m,
				alu_out_in  => alu_out_m,
				inst_in     => inst_m,
				RW_in       => RW_m,
				MtoR_in     => MtoR_m,
				clk         => clk,
				reg_data1_out=> reg_data1_wb, 
			        reg_data2_out=> reg_data2_wb,
				dataout_out  => dataout_wb,
				alu_out_out  => alu_out_wb,
				inst_out     => inst_wb,
				RW_out       => RW_wb,
				MtoR_out     => MtoR_wb,
				rst          => rst
 );

----------------------------------------------------------------

----------------------- Write back stage -----------------------
wbmux  : mux generic map(16) port map (	alu_out_wb,dataout_wb,MtoR_wb,wb_data);	

----------------------------------------------------------------



end architecture behave;
