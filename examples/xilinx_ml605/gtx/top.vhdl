--
-- Top level of gtx example
--
-- Author:
-- * Rodrigo A. Melo
--
-- Copyright (c) 2016 Authors and INTI
-- Distributed under the BSD 3-Clause License
--

library IEEE;
use IEEE.std_logic_1164.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity Top is
port (
   rst_i        : in  std_logic;
   clk_p_i      : in  std_logic;
   clk_n_i      : in  std_logic;
   sma_rx_p_i   : in  std_logic;
   sma_rx_n_i   : in  std_logic;
   sma_tx_p_o   : out std_logic;
   sma_tx_n_o   : out std_logic;
   pbc_i        : in  std_logic;
   dips_i       :  in std_logic_vector(7 downto 0);
   leds_o       : out std_logic_vector(7 downto 0)
);
end entity Top;

architecture RTL of top is

   signal reset, sysclk            : std_logic;
   signal locked, ready            : std_logic;
   signal loopback                 : std_logic;
   -- GBT data
   signal rx_data, tx_data         : std_logic_vector(15 downto 0);
   signal rx_isk,  tx_isk          : std_logic_vector(1 downto 0);

begin

   mmcm_inst: entity work.mmcm
   port map (
      CLK_IN1_P => clk_p_i,
      CLK_IN1_N => clk_n_i,
      CLK_OUT1  => sysclk,
      RESET     => rst_i,
      LOCKED    => locked
   );

   reset    <= not locked;
   loopback <= not pbc_i;

   gbt_i: entity work.Wrapper
   port map (
      clk_i     => sysclk,
      rst_i     => reset,
      clk_o     => open,
      --
      rxp_i     => sma_rx_p_i,
      rxn_i     => sma_rx_n_i,
      txp_o     => sma_tx_p_o,
      txn_o     => sma_tx_n_o,
      --
      loopback_i=> loopback,
      rx_data_o => rx_data,
      rx_isk_o  => rx_isk,
      tx_data_i => tx_data,
      tx_isk_i  => tx_isk,
      ready_o   => ready
   );

   tx_data <= dips_i & x"BC"       when ready='1' else (others => '0');
   tx_isk  <= "01"                 when ready='1' else (others => '0');
   leds_o  <= rx_data(15 downto 8) when ready='1' else "10101010";

end architecture RTL;
