----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/26/2015 10:57:34 PM
-- Design Name: 
-- Module Name: rising_edge_detect - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rising_edge_detect is
    Port ( clk : in STD_LOGIC;
           input : in STD_LOGIC;
           output : out STD_LOGIC);
end rising_edge_detect;

architecture Behavioral of rising_edge_detect is
    signal signal_d : STD_LOGIC;
begin
    process (clk)
    begin
        if (clk = '1' and clk'event) then
            signal_d <= input;
        end if;
    end process;
    output <= (not signal_d) and input;
end Behavioral;
