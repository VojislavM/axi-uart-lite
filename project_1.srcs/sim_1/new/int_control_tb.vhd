----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/29/2015 09:21:23 PM
-- Design Name: 
-- Module Name: int_control_tb - Behavioral
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

entity int_control_tb is
--  Port ( );
end int_control_tb;

architecture Behavioral of int_control_tb is

component Int_control is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rx_int : in STD_LOGIC;
           tx_int : in STD_LOGIC;
           enable : in STD_LOGIC;
           interrupt : out STD_LOGIC);
end component;

signal clk : STD_LOGIC := '0';
signal rst : STD_LOGIC := '0';
signal rx_fifo_empty : STD_LOGIC := '0';
signal tx_fifo_empty : STD_LOGIC := '0';
signal int_en : STD_LOGIC := '0';
signal interrupt : STD_LOGIC;
constant clk_period : time := 20 ns;

begin

uut: Int_control
port map ( clk => clk,
           rst => rst,
           rx_int => rx_fifo_empty,
           tx_int => tx_fifo_empty,
           enable => int_en,
           interrupt => interrupt);
           
clk_process: process
begin
   clk <= '0';
   wait for clk_period/2;
   clk <= '1';
   wait for clk_period/2;
end process;

reset_process: process 
begin
    rst <= '1';
    wait for clk_period * 10;
    rst <= '0'; 
    wait;       
end process;

interrupt_process: process
begin
   int_en <= '0';
    wait for clk_period * 12;
    int_en <= '1';
    -- rx fifo is non empty and tx fifo is non empty
    rx_fifo_empty <= '0';
    tx_fifo_empty <= '0';
    wait for clk_period * 15;
    -- tx fifo is empty and rx fifo is empty
    rx_fifo_empty <= '1';
    tx_fifo_empty <= '1';
    wait for clk_period * 20;
    -- rx fifo is non empty and tx fifo is empty
    rx_fifo_empty <= '0';
    tx_fifo_empty <= '1';
    wait for clk_period * 25;
    -- rx fifo is empty and tx fifo is non empty
    rx_fifo_empty <= '1';
    tx_fifo_empty <= '0';
    wait for clk_period * 15;
    wait; 
end process;
    
end Behavioral;
