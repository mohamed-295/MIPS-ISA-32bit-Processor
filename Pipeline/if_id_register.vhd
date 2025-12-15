library IEEE;
use IEEE.STD_LOGIC_1164.all;  
use IEEE.numeric_std.all;

entity IF_ID_Register is
    port(
        CLK         : in  STD_LOGIC;  
        RESET       : in  STD_LOGIC;  -- Asynchronous reset
        PC_In       : in  STD_LOGIC_VECTOR(31 downto 0); 
        Inst_In     : in  STD_LOGIC_VECTOR(31 downto 0); 
        PC_Out      : out STD_LOGIC_VECTOR(31 downto 0); 
        Inst_Out    : out STD_LOGIC_VECTOR(31 downto 0)  
    );
end IF_ID_Register;

architecture Behavioral of IF_ID_Register is
begin
    SYNC_IF_ID:    
        process(CLK, RESET)
        begin
            if RESET = '1' then
                PC_Out    <= (others => '0');
                Inst_Out  <= (others => '0');
            elsif rising_edge(CLK) then
                PC_Out    <= PC_In;
                Inst_Out  <= Inst_In;
            end if;
        end process;
end Behavioral;