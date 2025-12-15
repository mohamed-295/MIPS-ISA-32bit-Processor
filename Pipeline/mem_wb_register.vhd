library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEM_WB_REGISTER is  
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
end MEM_WB_REGISTER;



architecture MEM_WB_REGISTERS_ARC of MEM_WB_REGISTER is
begin

    SYNC_MEM_WB : process(clk, reset)
        begin
            if RESET = '1' then
                WB_out        <= (others => '0');
                read_data_mem_out <= (others => '0');
                mem_add_out   <= (others => '0');
                write_reg_add_out <= (others => '0');

            elsif rising_edge(CLK) then
                WB_out        <= WB_in;
                read_data_mem_out <= read_data_mem;
                mem_add_out   <= mem_add;
                write_reg_add_out <= write_reg_add;
            end if;
        end process;

end MEM_WB_REGISTERS_ARC;
