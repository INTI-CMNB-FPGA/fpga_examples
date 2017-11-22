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
   constant GTXPERIOD        : time := 5 ns;
   constant SYSPERIOD        : time := 6.25 ns;
   signal gtxclkn, gtxclkp   : std_logic;
   signal sysclkn, sysclkp   : std_logic;
   signal stop               : boolean;
   signal dips, leds         : std_logic_vector(3 downto 0);
   signal txp, txn, rxn, rxp : std_logic;
begin

   gtxclk_i : Clock
      generic map(PERIOD => GTXPERIOD, RESET_CLKS => 15.0)
      port map(clk_o => gtxclkp, rst_o => open, stop_i => stop);

   sysclk_i : Clock
      generic map(PERIOD => SYSPERIOD, RESET_CLKS => 15.0)
      port map(clk_o => sysclkp, rst_o => open, stop_i => stop);

   gtxclkn <= not(gtxclkp);
   sysclkn <= not(sysclkp);

   dut: entity work.top
   port map(
      sysclk_p_i => sysclkp,
      sysclk_n_i => sysclkn,
      gtxclk_p_i => gtxclkp,
      gtxclk_n_i => gtxclkn,
      rx_p_i     => '0',
      rx_n_i     => '0',
      tx_p_o     => open,
      tx_n_o     => open,
      pbc_i      => '0',
      dips_i     => "1010",
      leds_o     => open
   );

end architecture Structural;
