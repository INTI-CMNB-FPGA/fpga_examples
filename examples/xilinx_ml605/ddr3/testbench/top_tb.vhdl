--
-- Xilinx ml605 DDR3 Testbench
--
-- Author:
-- * Rodrigo A. Melo
--
-- Copyright (c) 2017 INTI
-- Distributed under the BSD 3-Clause License
--

library IEEE;
use IEEE.std_logic_1164.all;

entity Top_tb is
end entity Top_tb;

architecture Behavioral of Top_tb is

   constant WRITE_CMD : std_logic_vector(2 downto 0):="000";
   constant READ_CMD  : std_logic_vector(2 downto 0):="001";

   type state_t is (IDLE_S, WR_LOW_S, WR_HIGH_S, COMMAND_S, RD_LOW_S, RD_HIGH_S, FINISH_S);
   signal state : state_t:=IDLE_S;

   constant REFCLK_FREQ           : real := 200.0;
   constant nCS_PER_RANK          : integer := 1;
   constant RANK_WIDTH            : integer := 1;
   constant BANK_WIDTH            : integer := 3;
   constant CK_WIDTH              : integer := 1;
   constant CKE_WIDTH             : integer := 1;
   constant COL_WIDTH             : integer := 10;
   constant CS_WIDTH              : integer := 1;
   constant DM_WIDTH              : integer := 8;
   constant DQ_WIDTH              : integer := 64;
   constant DQS_WIDTH             : integer := 8;
   constant ROW_WIDTH             : integer := 13;
   constant CLKFBOUT_MULT_F       : integer := 6;
   constant DIVCLK_DIVIDE         : integer := 2;
   constant CLKOUT_DIVIDE         : integer := 3;
   constant tCK                   : integer := 2500;
   constant ADDR_WIDTH            : integer := RANK_WIDTH + BANK_WIDTH + ROW_WIDTH + COL_WIDTH;
   constant PAYLOAD_WIDTH         : integer := 64;

   constant MEMORY_WIDTH          : integer := 16;
   constant NUM_COMP              : integer := DQ_WIDTH/MEMORY_WIDTH;
   constant CLK_PERIOD            : time    := tCK * 1000 fs;
   constant REFCLK_HALF_PERIOD    : time := (1000000.0/(2.0*REFCLK_FREQ)) * 1 ps;
   constant APP_DATA_WIDTH        : integer := PAYLOAD_WIDTH * 4;

   component ddr3_model
   port(
      rst_n   : in    std_logic;
      ck      : in    std_logic;
      ck_n    : in    std_logic;
      cke     : in    std_logic;
      cs_n    : in    std_logic;
      ras_n   : in    std_logic;
      cas_n   : in    std_logic;
      we_n    : in    std_logic;
      dm_tdqs : inout std_logic_vector((MEMORY_WIDTH/16) downto 0);
      ba      : in    std_logic_vector(BANK_WIDTH-1 downto 0);
      addr    : in    std_logic_vector(ROW_WIDTH-1 downto 0);
      dq      : inout std_logic_vector(MEMORY_WIDTH-1 downto 0);
      dqs     : inout std_logic_vector((MEMORY_WIDTH/16) downto 0);
      dqs_n   : inout std_logic_vector((MEMORY_WIDTH/16) downto 0);
      tdqs_n  : out   std_logic_vector((MEMORY_WIDTH/16) downto 0);
      odt     : in    std_logic
      );
   end component ddr3_model;

   signal sys_clk   : std_logic := '0';
   signal sys_rst   : std_logic := '1';
   signal clk_ref   : std_logic := '0';

   signal sys_clk_p : std_logic;
   signal sys_clk_n : std_logic;
   signal clk_ref_p : std_logic;
   signal clk_ref_n : std_logic;

   signal phy_init_done    : std_logic;
   signal ddr3_reset_n     : std_logic;

   signal ddr3_dq          : std_logic_vector(DQ_WIDTH-1 downto 0);
   signal ddr3_addr        : std_logic_vector(ROW_WIDTH-1 downto 0);
   signal ddr3_ba          : std_logic_vector(BANK_WIDTH-1 downto 0);
   signal ddr3_ras_n       : std_logic;
   signal ddr3_cas_n       : std_logic;
   signal ddr3_we_n        : std_logic;
   signal ddr3_cs_n        : std_logic_vector((CS_WIDTH*nCS_PER_RANK)-1 downto 0);
   signal ddr3_odt         : std_logic_vector((CS_WIDTH*nCS_PER_RANK)-1 downto 0);
   signal ddr3_cke         : std_logic_vector(CKE_WIDTH-1 downto 0);
   signal ddr3_dm          : std_logic_vector(DM_WIDTH-1 downto 0);
   signal ddr3_dqs_p       : std_logic_vector(DQS_WIDTH-1 downto 0);
   signal ddr3_dqs_n       : std_logic_vector(DQS_WIDTH-1 downto 0);
   signal ddr3_ck_p        : std_logic_vector(CK_WIDTH-1 downto 0);
   signal ddr3_ck_n        : std_logic_vector(CK_WIDTH-1 downto 0);

   signal clk                   : std_logic;
   signal rst                   : std_logic;
   --
   signal app_en                : std_logic;
   signal app_cmd               : std_logic_vector(2 downto 0);
   signal app_addr              : std_logic_vector(ADDR_WIDTH-1 downto 0);
   signal app_rdy               : std_logic;
   --
   signal app_wdf_wren          : std_logic;
   signal app_wdf_data          : std_logic_vector(APP_DATA_WIDTH-1 downto 0);
   signal app_wdf_end           : std_logic;
   signal app_wdf_rdy           : std_logic;
   --
   signal app_rd_data           : std_logic_vector(APP_DATA_WIDTH-1 downto 0);
   signal app_rd_data_valid     : std_logic;

begin

  --**************************************************************************--
  -- Clock generation and reset
  --**************************************************************************--

   sys_rst <= '0' after 120000 ps;

   -- Generate system clock = twice rate of CLK
   sys_clk <= not sys_clk after (CLK_PERIOD/2);

   -- Generate IDELAYCTRL reference clock (200MHz)
   clk_ref <= not clk_ref after (REFCLK_HALF_PERIOD);

   sys_clk_p <= sys_clk;
   sys_clk_n <= not sys_clk;

   clk_ref_p <= clk_ref;
   clk_ref_n <= not clk_ref;

   mig_inst : entity work.mig
   generic map(
      RST_ACT_LOW        => 0,
      BURST_MODE         => "8",
      CLKFBOUT_MULT_F    => CLKFBOUT_MULT_F,
      DIVCLK_DIVIDE      => DIVCLK_DIVIDE,
      CLKOUT_DIVIDE      => CLKOUT_DIVIDE,
      SIM_BYPASS_INIT_CAL=> "SKIP",
      ADDR_WIDTH         => ADDR_WIDTH
   )
   port map(
      sys_clk_p            => sys_clk_p,
      sys_clk_n            => sys_clk_n,
      clk_ref_p            => clk_ref_p,
      clk_ref_n            => clk_ref_n,
      sys_rst              => sys_rst,
      ddr3_ck_p            => ddr3_ck_p,
      ddr3_ck_n            => ddr3_ck_n,
      ddr3_addr            => ddr3_addr,
      ddr3_ba              => ddr3_ba,
      ddr3_ras_n           => ddr3_ras_n,
      ddr3_cas_n           => ddr3_cas_n,
      ddr3_we_n            => ddr3_we_n,
      ddr3_cs_n            => ddr3_cs_n,
      ddr3_cke             => ddr3_cke,
      ddr3_odt             => ddr3_odt,
      ddr3_reset_n         => ddr3_reset_n,
      ddr3_dm              => ddr3_dm,
      ddr3_dq              => ddr3_dq,
      ddr3_dqs_p           => ddr3_dqs_p,
      ddr3_dqs_n           => ddr3_dqs_n,
      ui_clk               => clk,
      ui_clk_sync_rst      => rst,
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

   mem_rank : for r in 0 to CS_WIDTH-1 generate
      gen_mem : for i in 0 to NUM_COMP-1 generate
         ddr3_inst : ddr3_model
         port map(
            rst_n   => ddr3_reset_n,
            ck      => ddr3_ck_p((i*MEMORY_WIDTH)/72),
            ck_n    => ddr3_ck_n((i*MEMORY_WIDTH)/72),
            cke     => ddr3_cke(((i*MEMORY_WIDTH)/72)+(nCS_PER_RANK*r)),
            cs_n    => ddr3_cs_n(((i*MEMORY_WIDTH)/72)+(nCS_PER_RANK*r)),
            ras_n   => ddr3_ras_n,
            cas_n   => ddr3_cas_n,
            we_n    => ddr3_we_n,
            dm_tdqs => ddr3_dm((2*(i+1)-1) downto (2*i)),
            ba      => ddr3_ba,
            addr    => ddr3_addr,
            dq      => ddr3_dq(16*(i+1)-1 downto 16*(i)),
            dqs     => ddr3_dqs_p((2*(i+1)-1) downto (2*i)),
            dqs_n   => ddr3_dqs_n((2*(i+1)-1) downto (2*i)),
            tdqs_n  => open,
            odt     => ddr3_odt(((i*MEMORY_WIDTH)/72)+(nCS_PER_RANK*r))
         );
      end generate gen_mem;
   end generate mem_rank;

   do_fsm: process(clk) is
   begin
      if rising_edge(clk) then
         if rst='1' then
            state        <= IDLE_S;
            app_addr     <= (others => '0');
            app_en       <= '0';
            app_wdf_wren <= '0';
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
                    app_wdf_data <= X"0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF";
                    if app_wdf_rdy='1' then
                       state <= WR_HIGH_S;
                    end if;
                 when WR_HIGH_S  =>
                    app_wdf_wren <= '1';
                    app_wdf_end  <= '1';
                    app_wdf_data <= X"CAFEB0CACAFEB0CACAFEB0CACAFEB0CACAFEB0CACAFEB0CACAFEB0CACAFEB0CA";
                    if app_wdf_rdy='1' then
                       state <= COMMAND_S;
                    end if;
                 when COMMAND_S  =>
                    app_en  <= '1';
                    if app_rdy='1' then
                       state <= RD_LOW_S;
                       if app_en='1' then
                          app_en  <= '0';
                       end if;
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

end architecture Behavioral;
