--
-- Xilinx ml605 Minimal Transceiver Testbench
--
-- Author:
-- * Rodrigo A. Melo, rmelo@inti.gob.ar
--
-- Copyright (c) 2016 INTI
-- Copyright (c) 2016 Rodrigo A. Melo
--

library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;
library UTILS;
use UTILS.Simul.all;

entity Top_tb is
end entity Top_tb;

architecture Structural of Top_tb is
   constant PERIOD       : time := 5 ns;
   signal clk, nclk, rst : std_logic;
   signal stop           : boolean;
   signal ready          : std_logic;
   signal dips           : std_logic_vector(7 downto 0):=(others => '0');
begin

   nclk <= not(clk);

   do_clk: Clock
      generic map(PERIOD => PERIOD, RESET_CLKS => 15.0)
      port map(clk_o => clk, rst_o => rst, stop_i => stop);

   dut: entity work.top
   port map(
      rst_i      => rst,
      clk_p_i    => clk,
      clk_n_i    => nclk,
      sma_rx_p_i => '0',
      sma_rx_n_i => '0',
      sma_tx_p_o => open,
      sma_tx_n_o => open,
      pbc_i      => '0',
      dips_i     => "11000011",
      leds_o     => open
   );

end architecture Structural;
