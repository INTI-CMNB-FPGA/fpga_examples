--
-- Top level of gtx3 example
--
-- Author:
-- * Rodrigo A. Melo, rmelo@inti.gob.ar
--
-- Copyright (c) 2017 INTI
-- Copyright (c) 2017 Rodrigo A. Melo
--

library IEEE;
use IEEE.std_logic_1164.all;
library UTILS;
use UTILS.verif.all;
use UTILS.sync.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity Top is
port (
   rst_i        :  in std_logic;
   clk_p_i      :  in std_logic;
   clk_n_i      :  in std_logic;
   clk_o        : out std_logic;
   sma_rx_p_i   :  in std_logic;
   sma_rx_n_i   :  in std_logic;
   sma_tx_p_o   : out std_logic;
   sma_tx_n_o   : out std_logic;
   pbc_i        :  in std_logic;
   leds_o       : out std_logic_vector(7 downto 0)
);
end entity Top;

architecture RTL of top is

   constant BYTES                         : positive:=4;

   signal sysclk, clk                     : std_logic;
   signal rst_gtx, rst_loop               : std_logic;
   signal locked, ready                   : std_logic;
   signal loopback                        : std_logic;
   -- GBT data
   signal rx_data, rx_data_bound, tx_data : std_logic_vector(BYTES*8-1 downto 0);
   signal rx_isk,  rx_isk_bound,  tx_isk  : std_logic_vector(BYTES-1 downto 0);
   --
   signal finish                          : std_logic;
   signal errors                          : std_logic_vector(4 downto 0);

begin

   -- From 200 MHz differential to 150 MHz single-ended.
   mmcm_inst: entity work.mmcm
   port map (
      CLK_IN1_P => clk_p_i,
      CLK_IN1_N => clk_n_i,
      CLK_OUT1  => sysclk,
      RESET     => rst_i,
      LOCKED    => locked
   );

   rst_gtx  <= not locked;
   loopback <= not pbc_i;

   gbt_i: entity work.Wrapper
   port map (
      clk_i     => sysclk,
      rst_i     => rst_gtx,
      clk_o     => clk,
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

   -- To ensure that we understand *rx_data* in the same order that *tx_data*.
   bound_i: Boundary
   generic map(BYTES => BYTES)
   port map(
      clk_i     => clk,
      pattern_i => (others => '1'),
      comma_i   => rx_isk,
      data_i    => rx_data,
      comma_o   => rx_isk_bound,
      data_o    => rx_data_bound
   );

   rst_loop <= not ready;

   -- For test the loop.
   loop_i: TransLoop
   generic map(
      TSIZE  => 2048,
      DBYTES => BYTES,
      FSIZE  => 512
   )
   port map(
      -- TX side
      tx_clk_i     => clk,
      tx_rst_i     => rst_loop,
      tx_data_i    => (others => '0'),
      tx_data_o    => tx_data,
      tx_isk_o     => tx_isk,
      tx_ready_i   => ready,
      -- RX side
      rx_clk_i     => clk,
      rx_rst_i     => rst_loop,
      rx_data_i    => rx_data_bound,
      rx_isk_i     => rx_isk_bound,
      rx_errors_o  => errors,
      rx_finish_o  => finish,
      rx_cycles_o  => open
   );

   leds_o  <= finish & "00" & errors;
   clk_o   <= clk;

end architecture RTL;
