		       
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_EX_REGISTER is  
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
end entity;

architecture ID_EX_REGISTERS_ARC of ID_EX_REGISTER is
begin
    SYNC_ID_EX : process(clk, reset)
    begin
        if reset = '1' then
            -- asynchronous reset 
            new_pc_adder_out <= (others => '0');
            read_data1_out   <= (others => '0');
            read_data2_out   <= (others => '0');
            num_out_at_EX    <= (others => '0');
            rs_out           <= (others => '0');
            rt_out           <= (others => '0');
            rd_out           <= (others => '0');
            WB_out           <= (others => '0');  -- 2 bits
            M_out            <= (others => '0');  -- 3 bits
            EX_out           <= (others => '0');  -- 4 bits

        elsif rising_edge(clk) then
            -- latch inputs into pipeline register
            new_pc_adder_out <= new_pc_adder_in;
            read_data1_out   <= read_data1;
            read_data2_out   <= read_data2;
            num_out_at_EX    <= num_out;
            rs_out           <= rs;
            rt_out           <= rt;
            rd_out           <= rd;
            WB_out           <= WB_in;
            M_out            <= M_in;
            EX_out           <= EX_in;
        end if;
    end process;

end ID_EX_REGISTERS_ARC;
