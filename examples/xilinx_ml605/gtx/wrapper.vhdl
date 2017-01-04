--
-- Wrapper of gtx example
--
-- Author:
-- * Rodrigo A. Melo, rmelo@inti.gob.ar
--
-- Copyright (c) 2016 INTI
-- Copyright (c) 2016 Rodrigo A. Melo
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity Wrapper is
port (
   clk_i     : in  std_logic;
   rst_i     : in  std_logic;
   clk_o     : out std_logic;
   --
   rxp_i     : in  std_logic;
   rxn_i     : in  std_logic;
   txp_o     : out std_logic;
   txn_o     : out std_logic;
   --
   loopback_i: in  std_logic;
   rx_data_o : out std_logic_vector(15 downto 0);
   rx_isk_o  : out std_logic_vector(1 downto 0);
   tx_data_i : in  std_logic_vector(15 downto 0);
   tx_isk_i  : in  std_logic_vector(1 downto 0);
   ready_o   : out std_logic
);
end entity Wrapper;

architecture Structural of Wrapper is
   signal refclk                      : std_logic_vector(1 downto 0);
   signal outclk                      : std_logic;
   signal rx_plllkdet                 : std_logic;
   signal usrclk2                     : std_logic;
   signal rx_ready, tx_ready          : std_logic;
   signal loopback                    : std_logic_vector(2 downto 0);
begin

   txoutclk_bufg0_i : BUFG
   port map (
      I => outclk,
      O => usrclk2
   );

   refclk <= '0' & clk_i;
   loopback <= '0' & loopback_i & '0';

   gtx_v6_i : entity work.v6_gtx
   generic map (
      GTX_SIM_GTXRESET_SPEEDUP        => 1,
      GTX_TX_CLK_SOURCE               => "RXPLL",
      GTX_POWER_SAVE                  => "0000110100"
   )
   port map (
      LOOPBACK_IN                     => loopback, -- Near-End PMA Loopback
      -- RX 8b10b Decoder
      RXCHARISK_OUT                   => rx_isk_o,
      RXDISPERR_OUT                   => open,
      RXNOTINTABLE_OUT                => open,
      -- RX Comma Detection and Alignment
      RXBYTEISALIGNED_OUT             => open,
      RXENMCOMMAALIGN_IN              => '1',
      RXENPCOMMAALIGN_IN              => '1',
      -- RX Data Path interface
      RXDATA_OUT                      => rx_data_o,
      RXUSRCLK2_IN                    => usrclk2,
      -- RX Driver
      RXN_IN                          => rxn_i,
      RXP_IN                          => rxp_i,
      -- RX PLL Ports
      GTXRXRESET_IN                   => rst_i,
      MGTREFCLKRX_IN                  => refclk,
      PLLRXRESET_IN                   => '0',
      RXPLLLKDET_OUT                  => rx_plllkdet,
      RXRESETDONE_OUT                 => rx_ready,
      -- TX 8b10b Encoder Control Ports
      TXCHARISK_IN                    => tx_isk_i,
      -- TX Data Path interface
      TXDATA_IN                       => tx_data_i,
      TXOUTCLK_OUT                    => outclk,
      TXUSRCLK2_IN                    => usrclk2,
      -- TX Driver
      TXN_OUT                         => txn_o,
      TXP_OUT                         => txp_o,
      TXPOSTEMPHASIS_IN               => "00000",
      TXPREEMPHASIS_IN                => "0000",
      -- TX PLL Ports
      GTXTXRESET_IN                   => rst_i,
      MGTREFCLKTX_IN                  => refclk,
      PLLTXRESET_IN                   => '0',
      TXPLLLKDET_OUT                  => open,
      TXRESETDONE_OUT                 => tx_ready
   );

   clk_o   <= usrclk2;
   ready_o <= rx_ready and tx_ready and rx_plllkdet;

end architecture Structural;
