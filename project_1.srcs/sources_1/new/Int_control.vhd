----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/21/2015 05:19:14 PM
-- Design Name: 
-- Module Name: Int_control - Behavioral
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

entity Int_control is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rx_int : in STD_LOGIC;
           tx_int : in STD_LOGIC;
           enable : in STD_LOGIC;
           interrupt : out STD_LOGIC);
end Int_control;

architecture Behavioral of Int_control is

signal interrupt_s, next_interrupt_s : STD_LOGIC;

begin

process (clk, rst)
begin
    if (rst = '1') then
       interrupt_s <= '0'; 
    elsif (rising_edge(clk)) then
        if (enable = '1') then
            interrupt_s <= next_interrupt_s;
        else
            interrupt_s <= '0';
        end if;
    end if;
end process;

process (rx_int, tx_int)
begin
    next_interrupt_s <= (not rx_int) and tx_int;
end process;

interrupt <= interrupt_s;
end Behavioral;
