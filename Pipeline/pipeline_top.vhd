library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Pipeline is
	
    port( clk , reset : in std_logic );	 
	
end Pipeline;	

architecture Behavioral of Pipeline is
component PC 
	port(
	-- inputs
	    clk    : in STD_LOGIC;	  
		reset  : in STD_LOGIC;  
        pc_in  : in STD_LOGIC_VECTOR(31 downto 0);
		pc_out : out STD_LOGIC_VECTOR(31 downto 0)
    
	);
end component;
component ALU is
    port(
        A       : in std_logic_vector(31 downto 0);  -- source operand
        B       : in std_logic_vector(31 downto 0);  -- second operand (not used in sll)
        control : in std_logic_vector(2 downto 0);
        result  : out std_logic_vector(31 downto 0);
        zero    : out std_logic
    );
end component;
component Add_ALU is
    port(
        A       : in  std_logic_vector(31 downto 0);
        B       : in  std_logic_vector(31 downto 0);
        result  : out std_logic_vector(31 downto 0)

    );
end component;
component DataMemory is
  port(
        CLK       : in std_logic;
        address   : in std_logic_vector(31 downto 0);
        MemWrite  : in std_logic;
        MemRead   : in std_logic;
        WriteData : in std_logic_vector(31 downto 0);
        ReadData  : out std_logic_vector(31 downto 0)
  );
end component;
component EX_MEM_REGISTER is
    generic(
        INST_SIZE : integer := 32;   
        ADDR_SIZE : integer := 5   
    );
    port(
        clk   : in std_logic;
        reset : in std_logic;	

        -- control signals from EX stage
        WB_in  : in std_logic_vector(1 downto 0);  -- {RegWrite, MemtoReg}
        M_in   : in std_logic_vector(2 downto 0);  -- {Branch, MemRead, MemWrite}

        -- data signals from EX stage
        new_pc_adder_in : in std_logic_vector(INST_SIZE-1 downto 0); 
	
        alu_zero_flag   : in std_logic;          
        alu_res_in      : in std_logic_vector(INST_SIZE-1 downto 0); -- ALU result
        read_data2  : in std_logic_vector(INST_SIZE-1 downto 0); -- value to be written to Data Memory (Write Data)
        mux2x1_res   : in std_logic_vector(ADDR_SIZE-1 downto 0);

        -- outputs towards MEM/WB stages
        WB_out          : out std_logic_vector(1 downto 0);
        M_out           : out std_logic_vector(2 downto 0);

        new_pc_adder_out : out std_logic_vector(INST_SIZE-1 downto 0);
        alu_zero_flag_out    : out std_logic;
        alu_res_out      : out std_logic_vector(INST_SIZE-1 downto 0);  --memory address
        mem_write_data   : out std_logic_vector(INST_SIZE-1 downto 0);
        mux2x1_res_out       : out std_logic_vector(ADDR_SIZE-1 downto 0) 
    );
end component; 
component ALUControl is
    Port (
        ALUOp       : in  STD_LOGIC_VECTOR(1 downto 0); 
        Funct       : in  STD_LOGIC_VECTOR(5 downto 0); 
        control     : out STD_LOGIC_VECTOR(2 downto 0) 
    );
end component;
component  IF_ID_Register is
    port(
        CLK         : in  STD_LOGIC;  
        RESET       : in  STD_LOGIC;  -- Asynchronous reset
        PC_In       : in  STD_LOGIC_VECTOR(31 downto 0); 
        Inst_In     : in  STD_LOGIC_VECTOR(31 downto 0); 
        PC_Out      : out STD_LOGIC_VECTOR(31 downto 0); 
        Inst_Out    : out STD_LOGIC_VECTOR(31 downto 0)  
    );
end component;
component ID_EX_REGISTER is  
        generic(
        INST_SIZE : integer := 32;   
        ADDR_SIZE : integer := 5     
        );
	port(
	clk: in	STD_LOGIC;
	reset: in STD_LOGIC;	
	
	WB_in  : in  std_logic_vector(1 downto 0);  -- {RegWrite, MemtoReg}
    M_in   : in  std_logic_vector(2 downto 0);  -- {Branch, MemRead, MemWrite}
    EX_in  : in  std_logic_vector(3 downto 0);  -- {RegDst, ALUOp(1 downto 0), ALUSrc}  
	
	new_pc_adder_in: in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0); --Pc plus 4 from IF-ID reg	    
		
    read_data1: in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0); 
	read_data2: in	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
	
	num_out: in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0); -- instruction[15-0] after sign extend  

	rs: in	STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0); --instruction[25-21]
	rt: in	STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0); --instruction[20-16]
	rd: in	STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0); --instruction[15-11]   
	
	
	--outputs   
	WB_out  : out std_logic_vector(1 downto 0);
        M_out   : out std_logic_vector(2 downto 0);
        EX_out  : out std_logic_vector(3 downto 0);	     
	
	new_pc_adder_out: out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0); --Pc plus 4 from ID-EX reg	
		
        read_data1_out: out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0); 
	read_data2_out: out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
	
	num_out_at_EX: out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0); -- instruction[15-0] after sign extend
	
        rs_out: out	STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0); --instruction[25-21]
	rt_out: out	STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0); --instruction[20-16]
	rd_out: out	STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0) --instruction[15-11] 
	
);					    
end component;
component MEM_WB_REGISTER is  
   generic(
        INST_SIZE : integer := 32;   
        ADDR_SIZE : integer := 5   
    );
    port(
        clk  : in STD_LOGIC;
        reset: in STD_LOGIC;  
	
        WB_in  : in std_logic_vector(1 downto 0);  -- {RegWrite, MemtoReg}
        read_data_mem   : in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
        mem_add     : in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
        write_reg_add   : in STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);

        WB_out          : out std_logic_vector(1 downto 0);
        read_data_mem_out   : out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);      --input 1 mux
        mem_add_out     : out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);		--input 2 mux
        write_reg_add_out   : out STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0)
    );
end component;
component MainControl is
    Port ( 
        Opcode   : in  STD_LOGIC_VECTOR (5 downto 0); 
        
        RegDst   : out STD_LOGIC;
        Jump     : out STD_LOGIC;
        Branch   : out STD_LOGIC;
        MemRead  : out STD_LOGIC;
        MemtoReg : out STD_LOGIC;
        MemWrite : out STD_LOGIC;
        ALUSrc   : out STD_LOGIC;
        RegWrite : out STD_LOGIC;
        ALUOp    : out STD_LOGIC_VECTOR (1 downto 0)
    );
end component;
component InstructionMem is
    port (
        ReadAddress      : in  std_logic_vector(31 downto 0); -- PC input
        Instruction      : out std_logic_vector(31 downto 0)  -- instruction
    );
end component;
component ForwardingUnit is
    port(
        ID_EX_Rs, ID_EX_Rt   : in  std_logic_vector(4 downto 0); -- Current rs , rt for current instuction
        EX_MEM_Rd            : in  std_logic_vector(4 downto 0); -- 1 Before
        MEM_WB_Rd            : in  std_logic_vector(4 downto 0); -- 2 Before
        EX_MEM_RegWrite      : in  std_logic; -- writing flag 
        MEM_WB_RegWrite      : in  std_logic; -- writing flag
        
        ForwardA, ForwardB   : out std_logic_vector(1 downto 0)  -- Muxes Select
    );
end component;
component MUX2x1_5bit is
	port(
		A,B: in std_logic_vector(4 downto 0);
		sel: in std_logic;
		num_out: out std_logic_vector(4 downto 0)
	);
end component;
component Reg_File is

	Port (	
		clk : in STD_LOGIC;
		reset: in std_logic;
		RegWrite : in STD_LOGIC;-- from Control       
		write_reg : in STD_LOGIC_VECTOR(4 downto 0);
		write_data : in STD_LOGIC_VECTOR(31 downto 0);
		read_reg1 : in STD_LOGIC_VECTOR(4 downto 0);  
		read_reg2 : in STD_LOGIC_VECTOR(4 downto 0);  
		read_data1 : out STD_LOGIC_VECTOR(31 downto 0);
		read_data2 : out STD_LOGIC_VECTOR(31 downto 0) 
	); 
end component;
component MUX3x1_32bit is
	port(
		A,B,C: in std_logic_vector(31 downto 0);
		sel: in std_logic_vector(1 downto 0);
		num_out: out std_logic_vector(31 downto 0)
	);
end	component;
component SL2 is
	port(
		num_in: in std_logic_vector(31 downto 0);
	   	num_out: out std_logic_vector(31 downto 0)
	);
end component;
component SL2_Jump  is
	port(
		num_in: in std_logic_vector(25 downto 0);
	   	num_out: out std_logic_vector(27 downto 0)
	);
end component;
component sign_ext is
	port(
		num_in: in std_logic_vector(15 downto 0);
	   	num_out: out std_logic_vector(31 downto 0)
	);
end component; 
component  MUX2x1_32bit is
	port(
		A,B: in std_logic_vector(31 downto 0);
		sel: in std_logic;
		num_out: out std_logic_vector(31 downto 0)
	);
end component;
------------------------------------------------------
signal PC_in, PC_out, MemDataOut, InstructionMemOut, PC_adder, IF_TO_EX, IF_ID_OUT, Write_mux_out, SignExtendOut,EX_to_adder,ReadData1_EX_out,ReadData2_EX_out,SignExtend_EX : std_logic_vector(31 downto 0);
signal ReadData1_To_EX, ReadData2_To_EX,read_data_reg_to_mux,MuxtoPC,mem_add_out,ShiftLeftToAdd2, Add2_out, MemAddress, MUX_A_out, MUX_B_out, MUX_ALUSRC_OUT,AluResult,EX_MEM_pc_adder_out,mem_write_data : std_logic_vector(31 downto 0) ;
signal write_reg,rs_out_EX,rt_out_EX ,rd_out_EX, MUX_RegDst_out, EX_MEM_Rd,EX_MEM_mux_out: std_logic_vector(4 downto 0);
signal RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, EX_MEM_WB,Zero,EX_MEM_zero_flag_out,PCSrc: STD_LOGIC;
signal ALUOp, Forward_MUX_A, Forward_MUX_B : std_logic_vector(1 downto 0);
signal WB_ID_EX_out,WB_EX_MEM_out,WB_out  : std_logic_vector(1 downto 0);
signal M_ID_EX_out,M_EX_MEM_out   : std_logic_vector(2 downto 0);
signal EX_out       :  std_logic_vector(3 downto 0);	
signal WB_ID_EX_in  : std_logic_vector(1 downto 0);  -- {RegWrite, MemtoReg}
signal M_ID_EX_in   : std_logic_vector(2 downto 0);  -- {Branch, MemRead, MemWrite}
signal EX_ID_EX_in  : std_logic_vector(3 downto 0);  -- {RegDst, ALUOp(1 downto 0), ALUSrc} 
signal ALUControltoALU : std_logic_vector(2 downto 0);	


begin
WB_ID_EX_in(0) <=  MemtoReg;
WB_ID_EX_in(1) <=  RegWrite;
M_ID_EX_in(0) <= MemWrite;
M_ID_EX_in(1) <= MemRead;
M_ID_EX_in(2) <= Branch;
EX_ID_EX_in(0) <= ALUSrc;
EX_ID_EX_in(2 downto 1) <= ALUOp;
EX_ID_EX_in(3) <= RegDst;
PC_in <= MuxtoPC;
EX_MEM_Rd <= EX_MEM_mux_out;
PCSrc <= EX_MEM_zero_flag_out and M_EX_MEM_out(2);
	PCOUNTER          : PC                 port map(clk, reset,PC_in,PC_out);
    MUX_PC      : MUX2x1_32bit         port map(PC_adder, EX_MEM_pc_adder_out, PCSrc, MuxtoPC);
	ADD_1       : Add_ALU			   port map(PC_out,x"00000004",PC_adder);
	INSTR_MEM   : InstructionMem       port map(PC_out, InstructionMemOut);
	IF_ID       : IF_ID_Register       port map(clk, reset, PC_adder, InstructionMemOut, IF_TO_EX, IF_ID_OUT);
	REG         : Reg_File             port map(clk, reset, WB_out(1), write_reg,Write_mux_out, IF_ID_OUT(25 downto 21), IF_ID_OUT(20 downto 16), ReadData1_To_EX, ReadData2_To_EX);
	Control     : MainControl          port map(IF_ID_OUT(31 downto 26),RegDst,Jump,Branch,MemRead,MemtoReg,MemWrite ,ALUSrc, RegWrite,ALUOp);
	SE          : sign_ext             port map(IF_ID_OUT(15 downto 0), SignExtendOut);
	ID_EX       : ID_EX_Register 	   port map(clk, reset,WB_ID_EX_in,M_ID_EX_in ,EX_ID_EX_in,IF_TO_EX, ReadData1_To_EX, ReadData2_To_EX,SignExtendOut,IF_ID_OUT(25 downto 21),IF_ID_OUT(21 downto 16),IF_ID_OUT(16 downto 11),WB_ID_EX_out,M_ID_EX_out,EX_out,EX_to_adder,ReadData1_EX_out,ReadData2_EX_out,SignExtend_EX,rs_out_EX,rt_out_EX,rd_out_EX);
	MUX_RegDst  : MUX2x1_5bit          port map(rt_out_EX,rd_out_EX, EX_out(3), MUX_RegDst_out);
 	SLL_EX      : SL2                  port map(SignExtend_EX, ShiftLeftToAdd2);
	ADD_2       : Add_ALU			   port map(EX_to_adder,ShiftLeftToAdd2,Add2_out);	  
	ALU_CONTROL : ALUControl           port map(EX_out(2 downto 1), SignExtend_EX(5 downto 0), ALUControltoALU);	  
	Main_ALU    : ALU                  port map(MUX_A_out,MUX_ALUSRC_OUT,ALUControltoALU,AluResult,Zero); 
    Forwarding  : ForwardingUnit	   port map(rs_out_EX,rt_out_EX, EX_MEM_mux_out, write_reg, WB_EX_MEM_out(1), WB_out(1), Forward_MUX_A, Forward_MUX_B);
	MUX_A       : MUX3x1_32bit    	   port map(ReadData1_EX_out, Write_mux_out,MemAddress,Forward_MUX_A, MUX_A_out);
	MUX_B       : MUX3x1_32bit    	   port map(ReadData2_EX_out, Write_mux_out,MemAddress,Forward_MUX_B, MUX_B_out);
	MUX_ALUSRC  : MUX2x1_32bit         port map(MUX_B_out, SignExtend_EX, EX_out(0), MUX_ALUSRC_OUT);
	EX_MEM 		: EX_MEM_REGISTER 	   port map(clk, reset,WB_ID_EX_out,M_ID_EX_out,Add2_out,Zero,AluResult,MUX_B_out,MUX_RegDst_out,WB_EX_MEM_out,M_EX_MEM_out,EX_MEM_pc_adder_out, EX_MEM_zero_flag_out,MemAddress, mem_write_data, EX_MEM_mux_out);
	MEM         : DataMemory           port map(clk,MemAddress,M_EX_MEM_out(2),M_EX_MEM_out(1), mem_write_data,MemDataOut);
	MEM_WB		: MEM_WB_REGISTER      port map(clk,reset,WB_EX_MEM_out,MemDataOut,MemAddress,EX_MEM_mux_out,WB_out,read_data_reg_to_mux,mem_add_out,write_reg);
	MUX_Write   : MUX2x1_32bit         port map(read_data_reg_to_mux, mem_add_out,WB_out(0), Write_mux_out);

end architecture;














