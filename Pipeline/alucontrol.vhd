library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUControl is
    Port (
        ALUOp       : in  STD_LOGIC_VECTOR(1 downto 0); 
        Funct       : in  STD_LOGIC_VECTOR(5 downto 0); 
        control     : out STD_LOGIC_VECTOR(2 downto 0) 
    );
end ALUControl;

architecture Behavioral of ALUControl is
begin
    process(ALUOp, Funct)
    begin
        case ALUOp is
            -- LW / SW -ADD
            when "00" =>
                control <= "010";

            -- BEQ - SUB
            when "01" =>
                control <= "110";

            -- R-Type
 
		    when "10" =>
 
			case Funct is
  
			    when "100000" =>  
			       control <= "010"; -- ADD
 
			    when "100010" => 
				   control <= "110"; -- SUB
    
			    when "100100" =>
				   control <= "000"; -- AND
  
			    when "100101" =>
				   control <= "001"; -- OR
 
			    when "000000" =>
			       control <= "111"; -- SHIFT LEFT
			
    when others   => 
		           control <= "010"; -- Default ADD
  
			end case;

  
		  when others =>
 
		     control <= "010";   -- default ADD
        end case;
    end process;
end Behavioral;