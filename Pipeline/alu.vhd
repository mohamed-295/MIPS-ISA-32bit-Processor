library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port(
        A       : in std_logic_vector(31 downto 0);  -- source operand
        B       : in std_logic_vector(31 downto 0);  -- second operand (not used in sll)
        control : in std_logic_vector(2 downto 0);
        result  : out std_logic_vector(31 downto 0);
        zero    : out std_logic
    );
end entity;

architecture ALU_ARCH of ALU is
    signal temp_buf: std_logic_vector(31 downto 0) := (others => '0');
    signal A_int   : std_logic_vector(31 downto 0) := (others => '0');
    signal B_int   : std_logic_vector(31 downto 0) := (others => '0');
begin

    A_int <= A;
    B_int <= B;

    process(A_int, B_int, control)
    begin
        case control is

            when "010" =>  -- ADD
                temp_buf <= std_logic_vector(unsigned(A_int) + unsigned(B_int));

            when "110" =>  -- SUB
                temp_buf <= std_logic_vector(unsigned(A_int) - unsigned(B_int));

            when "000" =>  -- AND
                temp_buf <= A_int and B_int;

            when "001" =>  -- OR
                temp_buf <= A_int or B_int;

            when others =>
                temp_buf <= (others => '0');

        end case;
    end process;

    result <= temp_buf;
    zero   <= '1' when temp_buf = x"00000000" else '0';

end architecture;
