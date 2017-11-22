--
-- Top level of gtx example
--
-- Author:
-- * Rodrigo A. Melo
--
-- Copyright (c) 2017 Authors and INTI
-- Distributed under the BSD 3-Clause License
--

library IEEE;
use IEEE.std_logic_1164.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity Top is
port (
   sysclk_p_i  :  in std_logic;
   sysclk_n_i  :  in std_logic;
   gtxclk_p_i  :  in std_logic;
   gtxclk_n_i  :  in std_logic;
   rx_p_i      :  in std_logic;
   rx_n_i      :  in std_logic;
   tx_p_o      : out std_logic;
   tx_n_o      : out std_logic;
   pbc_i       :  in std_logic;
   dips_i      :  in std_logic_vector(3 downto 0);
   leds_o      : out std_logic_vector(3 downto 0)
);
end entity Top;

architecture RTL of top is

   signal gtxclk, sysclk           : std_logic;
   signal ready, loopback          : std_logic;
   -- GBT data
   signal rx_data, tx_data         : std_logic_vector(39 downto 0);

begin

   gtxclk_i : IBUFGDS
   port map (O => gtxclk, I => gtxclk_p_i, IB => gtxclk_n_i);

   sysclk_i : IBUFGDS
   port map (I => sysclk_p_i, IB => sysclk_n_i, O => sysclk);

   loopback <= '0';--not pbc_i;

   gbt_i: entity work.Wrapper
   port map (
      gtxclk_i  => gtxclk,
      sysclk_i  => sysclk,
      rst_i     => '0',
      --
      rxp_i     => rx_p_i,
      rxn_i     => rx_n_i,
      txp_o     => tx_p_o,
      txn_o     => tx_n_o,
      --
      loopback_i=> loopback,
      rx_data_o => rx_data,
      tx_data_i => tx_data,
      ready_o   => ready
   );

   tx_data <= dips_i & dips_i & dips_i & dips_i & dips_i &
              dips_i & dips_i & dips_i & dips_i & dips_i
              when ready='1' else X"AAAAAAAAAA";

   leds_o  <= rx_data(3 downto 0) when ready='1' else "0000";

end architecture RTL;
