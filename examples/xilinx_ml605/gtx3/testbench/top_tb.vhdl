--
-- Xilinx ml605 Minimal Transceiver Testbench
--
-- Author:
-- * Rodrigo A. Melo
--
-- Copyright (c) 2017 INTI
-- Distributed under the BSD 3-Clause License
--

library IEEE;
use IEEE.std_logic_1164.all;
library FPGALIB;
use FPGALIB.Simul.all;

entity Top_tb is
end entity Top_tb;

architecture Structural of Top_tb is
   constant PERIOD       : time := 5 ns;
   signal clk, nclk, rst : std_logic;
   signal usrclk         : std_logic;
   signal stop           : boolean;
   signal ready          : std_logic;
   signal leds           : std_logic_vector(7 downto 0);
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
      clk_o      => usrclk,
      sma_rx_p_i => '0',
      sma_rx_n_i => '0',
      sma_tx_p_o => open,
      sma_tx_n_o => open,
      pbc_i      => '0',
      leds_o     => leds
   );

   process
   begin
      print("Test start");
      wait until rising_edge(usrclk) and leds(7)='1'; -- finish
      assert leds(4 downto 0)="00000"
         report "There were errors in the loop ("&to_str(leds(4 downto 0))&")." severity failure;
      stop <= TRUE;
      report "Test end without errors" severity failure;
      wait;
   end process;

end architecture Structural;
