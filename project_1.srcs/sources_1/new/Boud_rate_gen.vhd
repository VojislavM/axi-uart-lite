----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/21/2015 05:17:42 PM
-- Design Name: 
-- Module Name: Boud_rate_gen - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Boud_rate_gen is
    generic (BAUD_RATE : natural := 9600;
             AXI_CLK : natural := 50);

    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           bclk : out STD_LOGIC); --baud clock out
end Boud_rate_gen;

architecture Behavioral of Boud_rate_gen is

signal cnt : STD_LOGIC_VECTOR(9 downto 0) := "0000000000"; -- broji do 163
signal modules : STD_LOGIC_VECTOR(9 downto 0);

begin

modules <= conv_std_logic_vector(AXI_CLK * 10**6/(16 * BAUD_RATE), modules'length);
--modules <= "0101000101"; --9600

process(clk, rst)
begin
    if rst = '1' then
        cnt <= (others=>'0');
        bclk <= '0';
    elsif (rising_edge(clk) and (rst = '0')) then
        if cnt = modules then
            cnt <= (others => '0');
            bclk <= '1';
        else
            cnt <= cnt + 1;
            --counter <= cnt(7 downto 0);
            bclk <= '0';
        end if;
    end if;    
end process;

end Behavioral;
