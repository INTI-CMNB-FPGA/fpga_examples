--
-- DDR3 example Top-Level
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
use FPGALIB.Verif.all;

entity Top is
   generic (
      SIM_BYPASS_INIT_CAL : string := "OFF";
      DM_WIDTH            : integer := 8;
      DQ_WIDTH            : integer := 64;
      ROW_WIDTH           : integer := 13;
      RANK_WIDTH          : integer := 1;
      BANK_WIDTH          : integer := 3;
      CS_WIDTH            : integer := 1;
      nCS_PER_RANK        : integer := 1;
      CKE_WIDTH           : integer := 1;
      DQS_WIDTH           : integer := 8;
      CK_WIDTH            : integer := 1
   );
   port (
      -- Clock
      sys_clk_p_i     : in    std_logic;
      sys_clk_n_i     : in    std_logic;
      sys_rst_i       : in    std_logic;
      clk_ref_p_i     : in    std_logic;
      clk_ref_n_i     : in    std_logic;
      -- DDR3
      ddr3_dq_io      : inout std_logic_vector(DQ_WIDTH-1 downto 0);
      ddr3_dm_o       : out   std_logic_vector(DM_WIDTH-1 downto 0);
      ddr3_addr_o     : out   std_logic_vector(ROW_WIDTH-1 downto 0);
      ddr3_ba_o       : out   std_logic_vector(BANK_WIDTH-1 downto 0);
      ddr3_ras_n_o    : out   std_logic;
      ddr3_cas_n_o    : out   std_logic;
      ddr3_we_n_o     : out   std_logic;
      ddr3_reset_n_o  : out   std_logic;
      ddr3_cs_n_o     : out   std_logic_vector((CS_WIDTH*nCS_PER_RANK)-1 downto 0);
      ddr3_odt_o      : out   std_logic_vector((CS_WIDTH*nCS_PER_RANK)-1 downto 0);
      ddr3_cke_o      : out   std_logic_vector(CKE_WIDTH-1 downto 0);
      ddr3_dqs_p_io   : inout std_logic_vector(DQS_WIDTH-1 downto 0);
      ddr3_dqs_n_io   : inout std_logic_vector(DQS_WIDTH-1 downto 0);
      ddr3_ck_p_o     : out   std_logic_vector(CK_WIDTH-1 downto 0);
      ddr3_ck_n_o     : out   std_logic_vector(CK_WIDTH-1 downto 0);
      -- App
      rx_errors_o     : out std_logic_vector(4 downto 0)
   );
end entity Top;

architecture RTL of Top is

   constant WRITE_CMD : std_logic_vector(2 downto 0):="000";
   constant READ_CMD  : std_logic_vector(2 downto 0):="001";

   constant ADDR_WIDTH         : integer := 27; -- RANK_WIDTH + BANK_WIDTH + ROW_WIDTH + COL_WIDTH;
   constant PAYLOAD_WIDTH      : integer := 64;
   constant APP_DATA_WIDTH     : integer := PAYLOAD_WIDTH * 4;

   signal sys_clk              : std_logic := '0';
   signal sys_rst              : std_logic := '1';
   signal clk_ref              : std_logic := '0';
   signal stop                 : boolean;

   signal sys_clk_p, sys_clk_n : std_logic;
   signal clk_ref_p, clk_ref_n : std_logic;

   signal phy_init_done       : std_logic;

   signal app_clk             : std_logic;
   signal app_rst             : std_logic;
   --
   signal app_en              : std_logic;
   signal app_cmd             : std_logic_vector(2 downto 0);
   signal app_addr            : std_logic_vector(ADDR_WIDTH-1 downto 0);
   signal app_rdy             : std_logic;
   --
   signal app_wdf_wren        : std_logic;
   signal app_wdf_data        : std_logic_vector(APP_DATA_WIDTH-1 downto 0);
   signal app_wdf_end         : std_logic;
   signal app_wdf_rdy         : std_logic;
   --
   signal app_rd_data         : std_logic_vector(APP_DATA_WIDTH-1 downto 0);
   signal app_rd_data_valid   : std_logic;

   signal rx_data, tx_data    : std_logic_vector(7 downto 0);
   signal rx_stb, tx_stb      : std_logic;

   type state_t is (IDLE_S, WR_LOW_S, WR_HIGH_S, COMMAND_S, RD_LOW_S, RD_HIGH_S, FINISH_S);
   signal state : state_t:=IDLE_S;

begin

   mig_inst : entity work.mig
   generic map(
      SIM_BYPASS_INIT_CAL  => SIM_BYPASS_INIT_CAL,
      CLKFBOUT_MULT_F      => 6,
      DIVCLK_DIVIDE        => 1, -- 2; -- Coregen assumes sys_clk = 400 MHz but we use 200 MHz
      CLKOUT_DIVIDE        => 3,
      RST_ACT_LOW          => 0
   )
   port map(
      sys_clk_p            => sys_clk_p_i,
      sys_clk_n            => sys_clk_n_i,
      clk_ref_p            => clk_ref_p_i,
      clk_ref_n            => clk_ref_n_i,
      sys_rst              => sys_rst_i,
      ddr3_ck_p            => ddr3_ck_p_o,
      ddr3_ck_n            => ddr3_ck_n_o,
      ddr3_addr            => ddr3_addr_o,
      ddr3_ba              => ddr3_ba_o,
      ddr3_ras_n           => ddr3_ras_n_o,
      ddr3_cas_n           => ddr3_cas_n_o,
      ddr3_we_n            => ddr3_we_n_o,
      ddr3_cs_n            => ddr3_cs_n_o,
      ddr3_cke             => ddr3_cke_o,
      ddr3_odt             => ddr3_odt_o,
      ddr3_reset_n         => ddr3_reset_n_o,
      ddr3_dm              => ddr3_dm_o,
      ddr3_dq              => ddr3_dq_io,
      ddr3_dqs_p           => ddr3_dqs_p_io,
      ddr3_dqs_n           => ddr3_dqs_n_io,
      ui_clk               => app_clk,
      ui_clk_sync_rst      => app_rst,
      app_wdf_wren         => app_wdf_wren,
      app_wdf_data         => app_wdf_data,
      app_wdf_mask         => (others => '0'),
      app_wdf_end          => app_wdf_end,
      app_addr             => app_addr,
      app_en               => app_en,
      app_cmd              => app_cmd,
      app_rdy              => app_rdy,
      app_wdf_rdy          => app_wdf_rdy,
      app_rd_data          => app_rd_data,
      app_rd_data_end      => open,
      app_rd_data_valid    => app_rd_data_valid,
      sda                  => '1',
      scl                  => '1',
      phy_init_done        => phy_init_done
   );

   loop_i: LoopCheck
   generic map (DWIDTH => 8)
   port map(
      -- TX side
      tx_clk_i    => app_clk,
      tx_rst_i    => app_rst,
      tx_stb_i    => tx_stb,
      tx_data_i   => (others => '0'),
      tx_data_o   => tx_data,
      -- RX side
      rx_clk_i    => app_clk,
      rx_rst_i    => app_rst,
      rx_stb_i    => rx_stb,
      rx_data_i   => rx_data,
      rx_errors_o => rx_errors_o
   );

   do_fsm: process(app_clk) is
   begin
      if rising_edge(app_clk) then
         if app_rst='1' then
            state        <= IDLE_S;
            app_addr     <= (others => '0');
            app_en       <= '0';
            app_wdf_wren <= '0';
            app_wdf_data <= (others => '0');
         else
            app_en       <= '0';
            app_wdf_wren <= '0';
            app_wdf_end  <= '0';
            case state is
                 when IDLE_S     =>
                    if phy_init_done='1' then
                       state   <= WR_LOW_S;
                    end if;
                 when WR_LOW_S   =>
                    app_cmd      <= WRITE_CMD;
                    app_wdf_wren <= '1';
                    app_wdf_data <= X"0123456789012345678901234567890123456789012345678901234567890123";
                    if app_wdf_rdy='1' then
                       state <= WR_HIGH_S;
                    end if;
                 when WR_HIGH_S  =>
                    app_wdf_wren <= '1';
                    app_wdf_end  <= '1';
                    app_wdf_data <= X"ABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCD";
                    if app_wdf_rdy='1' then
                       state <= COMMAND_S;
                    end if;
                 when COMMAND_S  =>
                    app_wdf_data <= (others => '0');
                    app_en  <= '1';
                    if app_rdy='1' then
                       state <= RD_LOW_S;
                       --if app_en='1' then
                       --   app_en  <= '0';
                       --end if;
                    end if;
                 when RD_LOW_S   =>
                    app_cmd      <= READ_CMD;
                    state <= RD_HIGH_S;
                 when RD_HIGH_S  =>
                    app_en       <= '1';
                    if app_rdy='1' then
                       state <= FINISH_S;
                    end if;
                 when FINISH_S   =>
            end case;
         end if;
      end if;
   end process do_fsm;

end architecture RTL;
