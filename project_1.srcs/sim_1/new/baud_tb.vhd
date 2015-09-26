----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2015 12:34:47 PM
-- Design Name: 
-- Module Name: baud_tb - Behavioral
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

entity baud_tb is

end baud_tb;

architecture Behavioral of baud_tb is
component Boud_rate_gen is
    generic (BAUD_RATE : natural;
             AXI_CLK : natural);

    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           bclk : out STD_LOGIC); --baud clock out
end component;

signal clk : STD_LOGIC := '0';
signal rst : STD_LOGIC := '0';
signal bclk : STD_LOGIC := '0';
constant clk_period : time := 20 ns;
begin

uut: Boud_rate_gen
generic map (BAUD_RATE => 9600,
             AXI_CLK => 50)
port map(clk => clk, rst => rst, bclk => bclk);

clk_process : process
begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;

reset_process : process 
begin
    rst <= '1';
    wait for 200 ns;
    rst <= '0'; 
    wait;       
end process;

end Behavioral;
