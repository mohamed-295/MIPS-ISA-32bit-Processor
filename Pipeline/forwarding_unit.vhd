library ieee;
use ieee.std_logic_1164.all;

entity ForwardingUnit is
    port(
        ID_EX_Rs, ID_EX_Rt   : in  std_logic_vector(4 downto 0); -- Current rs , rt for current instuction
        EX_MEM_Rd            : in  std_logic_vector(4 downto 0); -- 1 Before
        MEM_WB_Rd            : in  std_logic_vector(4 downto 0); -- 2 Before
        EX_MEM_RegWrite      : in  std_logic; -- writing flag 
        MEM_WB_RegWrite      : in  std_logic; -- writing flag
        
        ForwardA, ForwardB   : out std_logic_vector(1 downto 0)  -- Muxes Select
    );
end entity;

architecture Behavioral of ForwardingUnit is
begin
    process(ID_EX_Rs, ID_EX_Rt, EX_MEM_Rd, MEM_WB_Rd, EX_MEM_RegWrite, MEM_WB_RegWrite)
    begin
        -- Default: No Forwarding (00)
        ForwardA <= "00";
        ForwardB <= "00";

        -- Forwarding for Rs (Source A)
        if (EX_MEM_RegWrite = '1' and EX_MEM_Rd /= "00000" and EX_MEM_Rd = ID_EX_Rs) then
            ForwardA <= "01"; -- Priority 1: Take from ALU Result (EX Stage)
        elsif (MEM_WB_RegWrite = '1' and MEM_WB_Rd /= "00000" and MEM_WB_Rd = ID_EX_Rs) then
            ForwardA <= "10"; -- Priority 2: Take from WriteBack (WB Stage)
        end if;

        -- Forwarding for Rt (Source B)
        if (EX_MEM_RegWrite = '1' and EX_MEM_Rd /= "00000" and EX_MEM_Rd = ID_EX_Rt) then
            ForwardB <= "01";
        elsif (MEM_WB_RegWrite = '1' and MEM_WB_Rd /= "00000" and MEM_WB_Rd = ID_EX_Rt) then
            ForwardB <= "10";
        end if;
    end process;
end architecture;