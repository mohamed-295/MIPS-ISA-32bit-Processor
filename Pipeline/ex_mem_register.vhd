library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_MEM_REGISTER is
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
end EX_MEM_REGISTER;


architecture EX_MEM_REGISTERS_ARC of EX_MEM_REGISTER is
begin
    SYNC_EX_MEM : process(clk, reset)
    begin
        if reset = '1' then
            -- asynchronous reset
            WB_out             <= (others => '0');
            M_out              <= (others => '0');

            new_pc_adder_out   <= (others => '0');
            alu_zero_flag_out  <= '0';
            alu_res_out        <= (others => '0');
            mem_write_data     <= (others => '0');
            mux2x1_res_out     <= (others => '0');

        elsif rising_edge(clk) then
            -- normal pipeline register update
            WB_out             <= WB_in;
            M_out              <= M_in;

            new_pc_adder_out   <= new_pc_adder_in;
            alu_zero_flag_out  <= alu_zero_flag;
            alu_res_out        <= alu_res_in;
            mem_write_data     <= read_data2;
            mux2x1_res_out     <= mux2x1_res;
        end if;
    end process;

end EX_MEM_REGISTERS_ARC;

