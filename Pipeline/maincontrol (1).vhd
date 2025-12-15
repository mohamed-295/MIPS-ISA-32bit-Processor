library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MainControl is
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
end MainControl;

architecture Behavioral of MainControl is
begin

    process(Opcode)
    begin
      
        RegDst   <= '0';
        ALUSrc   <= '0';
        MemtoReg <= '0';
        RegWrite <= '0';
        MemRead  <= '0';
        MemWrite <= '0';
        Branch   <= '0'; 
        Jump     <= '0';
        ALUOp    <= "00";

        case Opcode is
            -- R-Type
            when "000000" => 
                RegDst   <= '1'; 
                RegWrite <= '1'; 
                ALUOp    <= "10"; 
    
            -- addi (I-Type)
            when "001000" =>
                ALUSrc   <= '1'; 
                RegWrite <= '1';
                ALUOp    <= "00";  

            -- lw
            when "100011" => 
                ALUSrc   <= '1'; 
                MemtoReg <= '1';
                RegWrite <= '1'; 
                MemRead  <= '1'; 
                ALUOp    <= "00"; 

            -- sw
            when "101011" => 
                ALUSrc   <= '1';
                MemWrite <= '1'; 
                ALUOp    <= "00";

            -- beq
            when "000100" => 
                Branch   <= '1'; 
                ALUOp    <= "01"; 

            -- J
            when "000010" =>
                Jump <= '1'; 
                
            when others =>
                NULL;
        end case;
    end process;

end Behavioral;