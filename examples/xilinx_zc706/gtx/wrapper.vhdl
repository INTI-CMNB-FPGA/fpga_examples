--
-- Wrapper of gtx example
--
-- Author:
-- * Rodrigo A. Melo, rmelo@inti.gob.ar
--
-- Copyright (c) 2017 Authors and INTI
-- Distributed under the BSD 3-Clause License
--

library IEEE;
use IEEE.std_logic_1164.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity Wrapper is
port (
   gtxclk_i  :  in std_logic;
   sysclk_i  :  in std_logic;
   rst_i     :  in std_logic;
   --
   rxp_i     :  in std_logic;
   rxn_i     :  in std_logic;
   txp_o     : out std_logic;
   txn_o     : out std_logic;
   --
   loopback_i:  in std_logic;
   rx_data_o : out std_logic_vector(39 downto 0);
   tx_data_i :  in std_logic_vector(39 downto 0);
   ready_o   : out std_logic
);
end entity Wrapper;

architecture Structural of Wrapper is

   signal rx_fsm_reset, tx_fsm_reset  : std_logic;
   signal rxresetdone, txresetdone    : std_logic;
   signal txoutclk, txusrclk          : std_logic;
   signal loopback                    : std_logic_vector(2 downto 0);

   signal qplloutclk, qplloutrefclk   : std_logic;
   signal qplllock, qpllrefclklost    : std_logic;
   signal qpllreset                   : std_logic;

begin

   loopback <= '0' & loopback_i & '0';
   ready_o <= rxresetdone and txresetdone and rx_fsm_reset and tx_fsm_reset;

   gbt1_i : entity work.gbt1
   port map (
      sysclk_in                       => sysclk_i,
      soft_reset_tx_in                => '0',
      soft_reset_rx_in                => '0',
      dont_reset_on_data_error_in     => '0',
      gt0_tx_fsm_reset_done_out       => tx_fsm_reset,
      gt0_rx_fsm_reset_done_out       => rx_fsm_reset,
      gt0_data_valid_in               => '0',
      ---------------------------- Channel - DRP Ports  --------------------------
      gt0_drpaddr_in                  => "000000000",
      gt0_drpclk_in                   => sysclk_i,
      gt0_drpdi_in                    => "0000000000000000",
      gt0_drpdo_out                   => open,
      gt0_drpen_in                    => '0',
      gt0_drprdy_out                  => open,
      gt0_drpwe_in                    => '0',
      --------------------------- Digital Monitor Ports --------------------------
      gt0_dmonitorout_out             => open,
      ------------------------------- Loopback Ports -----------------------------
      gt0_loopback_in                 => loopback,
      --------------------- RX Initialization and Reset Ports --------------------
      gt0_eyescanreset_in             => '0',
      gt0_rxuserrdy_in                => '0',
      -------------------------- RX Margin Analysis Ports ------------------------
      gt0_eyescandataerror_out        => open,
      gt0_eyescantrigger_in           => '0',
      ------------------ Receive Ports - FPGA RX Interface Ports -----------------
      gt0_rxusrclk_in                 => txusrclk,
      gt0_rxusrclk2_in                => txusrclk,
      ------------------ Receive Ports - FPGA RX interface Ports -----------------
      gt0_rxdata_out                  => rx_data_o,
      --------------------------- Receive Ports - RX AFE -------------------------
      gt0_gtxrxp_in                   => rxp_i,
      ------------------------ Receive Ports - RX AFE Ports ----------------------
      gt0_gtxrxn_in                   => rxn_i,
      --------------------- Receive Ports - RX Equalizer Ports -------------------
      gt0_rxdfelpmreset_in            => '0',
      gt0_rxmonitorout_out            => open,
      gt0_rxmonitorsel_in             => "00",
      --------------- Receive Ports - RX Fabric Output Control Ports -------------
      gt0_rxoutclkfabric_out          => open,
      ------------- Receive Ports - RX Initialization and Reset Ports ------------
      gt0_gtrxreset_in                => '0',
      gt0_rxpmareset_in               => '0',
      -------------- Receive Ports -RX Initialization and Reset Ports ------------
      gt0_rxresetdone_out             => rxresetdone,
      --------------------- TX Initialization and Reset Ports --------------------
      gt0_gttxreset_in                => '0',
      gt0_txuserrdy_in                => '0',
      ------------------ Transmit Ports - FPGA TX Interface Ports ----------------
      gt0_txusrclk_in                 => txusrclk,
      gt0_txusrclk2_in                => txusrclk,
      ------------------ Transmit Ports - TX Data Path interface -----------------
      gt0_txdata_in                   => tx_data_i,
      ---------------- Transmit Ports - TX Driver and OOB signaling --------------
      gt0_gtxtxn_out                  => txn_o,
      gt0_gtxtxp_out                  => txp_o,
      ----------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
      gt0_txoutclk_out                => txoutclk,
      gt0_txoutclkfabric_out          => open,
      gt0_txoutclkpcs_out             => open,
      ------------- Transmit Ports - TX Initialization and Reset Ports -----------
      gt0_txresetdone_out             => txresetdone,
      --
      gt0_qplllock_in                 => qplllock,
      gt0_qpllrefclklost_in           => qpllrefclklost,
      gt0_qpllreset_out               => qpllreset,
      gt0_qplloutclk_in               => qplloutclk,
      gt0_qplloutrefclk_in            => qplloutrefclk
   );

   txoutclk_i : BUFG
   port map (I => txoutclk, O => txusrclk);

   gtxe2_common_i : GTXE2_COMMON
   generic map (
      -- Simulation attributes
      SIM_RESET_SPEEDUP        => ("TRUE"),
      SIM_QPLLREFCLK_SEL       => "111", -- "010"
      SIM_VERSION              => ("4.0"),
      ------------------COMMON BLOCK Attributes---------------
      BIAS_CFG                 => (x"0000040000001000"),
      COMMON_CFG               => (x"00000000"),
      QPLL_CFG                 => (x"0680181"),
      QPLL_CLKOUT_CFG          => ("0000"),
      QPLL_COARSE_FREQ_OVRD    => ("010000"),
      QPLL_COARSE_FREQ_OVRD_EN => ('0'),
      QPLL_CP                  => ("0000011111"),
      QPLL_CP_MONITOR_EN       => ('0'),
      QPLL_DMONITOR_SEL        => ('0'),
      QPLL_FBDIV               => ("0101110000"),
      QPLL_FBDIV_MONITOR_EN    => ('0'),
      QPLL_FBDIV_RATIO         => ('1'),
      QPLL_INIT_CFG            => (x"000006"),
      QPLL_LOCK_CFG            => (x"21E8"),
      QPLL_LPF                 => ("1111"),
      QPLL_REFCLK_DIV          => (2)
   )
   port map (
      ------------- Common Block  - Dynamic Reconfiguration Port (DRP) -----------
      DRPADDR                  => "00000000",
      DRPCLK                   => '0',
      DRPDI                    => "0000000000000000",
      DRPDO                    => open,
      DRPEN                    => '0',
      DRPRDY                   => open,
      DRPWE                    => '0',
      ---------------------- Common Block  - Ref Clock Ports ---------------------
      GTGREFCLK                => gtxclk_i,
      GTNORTHREFCLK0           => '0',
      GTNORTHREFCLK1           => '0',
      GTREFCLK0                => '0',
      GTREFCLK1                => '0',
      GTSOUTHREFCLK0           => '0',
      GTSOUTHREFCLK1           => '0',
      ------------------------- Common Block -  QPLL Ports -----------------------
      QPLLDMONITOR             => open,
      ----------------------- Common Block - Clocking Ports ----------------------
      QPLLOUTCLK               => qplloutclk,
      QPLLOUTREFCLK            => qplloutrefclk,
      REFCLKOUTMONITOR         => open,
      ------------------------- Common Block - QPLL Ports ------------------------
      QPLLFBCLKLOST            => open,
      QPLLLOCK                 => qplllock,
      QPLLLOCKDETCLK           => sysclk_i,
      QPLLLOCKEN               => '1',
      QPLLOUTRESET             => '0',
      QPLLPD                   => '0',
      QPLLREFCLKLOST           => qpllrefclklost,
      QPLLREFCLKSEL            => "111", -- "010"
      QPLLRESET                => qpllreset,
      QPLLRSVD1                => "0000000000000000",
      QPLLRSVD2                => "11111",
      --------------------------------- QPLL Ports -------------------------------
      BGBYPASSB                => '1',
      BGMONITORENB             => '1',
      BGPDB                    => '1',
      BGRCALOVRD               => "11111",
      PMARSVD                  => "00000000",
      RCALENB                  => '1'
   );

end architecture Structural;
