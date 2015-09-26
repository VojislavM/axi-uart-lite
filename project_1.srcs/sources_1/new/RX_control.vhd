----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/21/2015 05:17:42 PM
-- Design Name: 
-- Module Name: RX_control - Behavioral
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

entity RX_control is
    Port ( clk : in STD_LOGIC;
		   rst : in STD_LOGIC;
           RxD : in STD_LOGIC;
           baud_tick: in STD_LOGIC;
           received : out STD_LOGIC;
           RxD_data : out STD_LOGIC_VECTOR (7 downto 0);
           parity_error : out STD_LOGIC);
end RX_control;

architecture Behavioral of RX_control is

type state is (idle, startbit, databits, paritybit, stopbit);
signal state_reg, next_state_reg: state;
signal counter, next_count: STD_LOGIC_VECTOR(3 downto 0);
signal data_count, data_next_count: STD_LOGIC_VECTOR(2 downto 0);
signal rec, next_rec: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
signal parity: STD_LOGIC;
signal parity_err, next_parity_err : STD_LOGIC;
signal received_s, next_received_s : STD_LOGIC;
 
begin

process(clk, rst)
begin
    if (rst = '1') then
        state_reg <= idle;
        counter <= (others => '0');
        data_count <= (others => '0');
        parity_err <= '0';
        received_s <= '0';
    elsif (rising_edge(clk) and rst = '0') then
        state_reg <= next_state_reg;
        counter <= next_count;
        data_count <= data_next_count;
        rec <= next_rec;
        parity_err <= next_parity_err;
        received_s <= next_received_s;
    end if;
end process;

state_decode: process(state_reg, RxD, counter, baud_tick)
begin
    if (state_reg = idle) then
        next_state_reg <= state_reg;
        data_next_count <= data_count;
        next_count <= counter;
        next_rec <= rec;
        next_parity_err <= '0';
        next_received_s <= '0';
        if (RxD = '0') then
            next_state_reg <= startbit;
            next_count <= (others => '0');
            next_rec <= "00000000";
        end if;
    elsif (rising_edge(baud_tick)) then
        next_state_reg <= state_reg;
        data_next_count <= data_count;
        next_received_s <= received_s;
        next_count <= counter;
        next_rec <= rec;
        
        case state_reg is
			when startbit =>
				if (counter = 7) then
					next_state_reg <= databits;
					next_count <= (others => '0');
					data_next_count <= (others => '0');
				else
					next_count <= counter + 1;
				end if;
			when databits =>
				if (counter = 15) then
					next_count <= (others => '0');
					next_rec <= (RxD & rec(7 downto 1));
					if(('0' & data_count) = 7) then
						next_state_reg <= paritybit;
					else
						data_next_count <= data_count + 1;
					end if;
				else
					next_count <= counter + 1;
				end if;
			when paritybit =>
				if (counter = 15) then
					next_count <= (others => '0');
					next_state_reg <= stopbit;
					if (not(parity = RxD)) then
					    next_parity_err <= '1';
                        next_rec <= "01000101";
                    else
                        next_parity_err <= '0';
					end if;
				else
					next_count <= counter + 1;
				end if;
			when stopbit =>
			    next_parity_err <= '0';
				if (counter = 10) then
					next_received_s <= '1';
					next_count <= counter + 1;
                elsif (counter = 11) then
                    next_received_s <= '0';
                    next_count <= counter + 1;
				elsif (('0' & counter) = 15) then
					next_state_reg <= idle;
				else
					next_count <= counter + 1;
				end if;
			when others =>
				next_state_reg <= idle; 
        end case;
    end if;
end process;

parity <= rec(7) xor rec(6) xor rec(5) xor rec(4) xor rec(3) xor rec(2) xor rec(1) xor rec(0);
RxD_data <= rec;
parity_error <= parity_err;
received <= received_s;

end Behavioral;
