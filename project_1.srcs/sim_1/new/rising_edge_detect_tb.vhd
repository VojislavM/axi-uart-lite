----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/26/2015 11:01:53 PM
-- Design Name: 
-- Module Name: rising_edge_detect_tb - Behavioral
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

entity rising_edge_detect_tb is
--  Port ( );
end rising_edge_detect_tb;

architecture Behavioral of rising_edge_detect_tb is

component rising_edge_detect is
    Port ( clk : in STD_LOGIC;
           input : in STD_LOGIC;
           output : out STD_LOGIC);
end component;

signal clk : STD_LOGIC := '0';
constant clk_period : time := 20 ns;
signal input : STD_LOGIC;
signal output : STD_LOGIC;

begin

uut: rising_edge_detect
    port map(clk => clk,
             input => input,
             output => output);
             
clk_process: process
begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;

edge_det_process: process
begin
    input <= '0';
    wait for 100 ns;
    input <= '1'; 
    wait for 100 ns;
    input <= '0';
    wait;
end process;


end Behavioral;
