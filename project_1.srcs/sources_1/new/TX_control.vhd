----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/21/2015 05:17:42 PM
-- Design Name: 
-- Module Name: TX_control - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: novi
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

entity TX_control is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           load : in STD_LOGIC;
           baud_tick: STD_LOGIC;
           TxD_data : in STD_LOGIC_VECTOR (7 downto 0);
           transmitted : out STD_LOGIC;
           TxD : out STD_LOGIC;
           count1 : out STD_LOGIC_VECTOR(3 downto 0);
           count2 : out STD_LOGIC_VECTOR(2 downto 0));
end TX_control;

architecture Behavioral of TX_control is

type state is (idle, startbit, databits, paritybit, stopbit);
signal state_reg, next_state_reg: state;
signal counter, next_count : STD_LOGIC_VECTOR(3 downto 0);
signal data_count, data_next_count : STD_LOGIC_VECTOR(2 downto 0);
signal tsr, tsr_next : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
signal tx, tx_next : STD_LOGIC;
signal parity : STD_LOGIC;

begin

process(clk, rst)
begin
    if (rst = '1') then
		state_reg <= idle;
		counter <= (others => '0');
		data_count <= (others => '0');
		tsr <= (others => '0');
		tx <= '1';
	elsif (rising_edge(clk) and (rst = '0')) then
        state_reg <= next_state_reg;
        counter <= next_count;
        data_count <= data_next_count;
        tsr <= tsr_next;
        tx <= tx_next;
    end if;
end process;

state_decode: process(state_reg, baud_tick, tx, load, TxD_data)
begin
    if (state_reg = idle) then
        next_state_reg <= state_reg;
        next_count <= counter;
        data_next_count <= data_count;
        tsr_next <= tsr;
        transmitted <= '0';
        tx_next <= '1';
        if (load = '1') then
            next_state_reg <= startbit;
            next_count <= (others => '0');
            tsr_next <= TxD_data;
        end if;
    elsif (rising_edge(baud_tick)) then
        next_state_reg <= state_reg;
        next_count <= counter;
        data_next_count <= data_count;
        tsr_next <= tsr;
        tx_next <= tx;
        transmitted <= '0';
        case state_reg is
			when startbit =>
				tx_next <= '0';
				if (counter = 15) then
					next_state_reg <= databits;
					next_count <= (others => '0');
					data_next_count <= (others => '0');
				else
					next_count <= counter + 1;
				end if;
			when databits =>
				tx_next <= tsr(0);
				if (counter = 15) then
					next_count <= (others => '0');
					tsr_next <= '0' & tsr(7 downto 1);
					if (data_count = 7) then
						next_state_reg <= paritybit;
					else
						data_next_count <= data_count + 1;
					end if;
				else
					next_count <= counter + 1;
				end if;
			when paritybit =>
				tx_next <= parity;
				if (counter = 15) then
					next_count <= (others => '0');
					next_state_reg <= stopbit;
				 else
					next_count <= counter + 1;
				end if;
			when stopbit =>
				tx_next <= '1';
				if (counter = 10) then
					transmitted <= '1';
					next_count <= counter + 1;
				elsif (counter = 15) then
					next_state_reg <= idle;
				else
					next_count <= counter + 1;
				end if;
			when others => 
				next_state_reg <= idle;
        end case;
    end if;
end process;

count1 <= counter;
count2 <= data_count;
parity <= TxD_data(7) xor TxD_data(6) xor TxD_data(5) xor TxD_data(4) xor TxD_data(3) xor TxD_data(2) xor TxD_data(1) xor TxD_data(0);   
TxD <= tx;

end Behavioral;
