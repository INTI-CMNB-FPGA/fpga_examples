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
library FPGALIB;
use FPGALIB.Simul.all;

entity Top_tb is
end entity Top_tb;

architecture Behavioral of Top_tb is

   constant nCS_PER_RANK       : integer := 1;
   constant BANK_WIDTH         : integer := 3;
   constant CK_WIDTH           : integer := 1;
   constant CKE_WIDTH          : integer := 1;
   constant CS_WIDTH           : integer := 1;
   constant DM_WIDTH           : integer := 8;
   constant DQ_WIDTH           : integer := 64;
   constant DQS_WIDTH          : integer := 8;
   constant ROW_WIDTH          : integer := 13;
   constant MEMORY_WIDTH       : integer := 16;
   constant NUM_COMP           : integer := DQ_WIDTH/MEMORY_WIDTH;

   signal sys_clk              : std_logic;
   signal sys_rst              : std_logic;
   signal clk_ref              : std_logic;
   signal stop                 : boolean;

   signal sys_clk_p, sys_clk_n : std_logic;
   signal clk_ref_p, clk_ref_n : std_logic;

   signal ddr3_dq             : std_logic_vector(DQ_WIDTH-1 downto 0);
   signal ddr3_addr           : std_logic_vector(ROW_WIDTH-1 downto 0);
   signal ddr3_ba             : std_logic_vector(BANK_WIDTH-1 downto 0);
   signal ddr3_ras_n          : std_logic;
   signal ddr3_cas_n          : std_logic;
   signal ddr3_we_n           : std_logic;
   signal ddr3_cs_n           : std_logic_vector((CS_WIDTH*nCS_PER_RANK)-1 downto 0);
   signal ddr3_odt            : std_logic_vector((CS_WIDTH*nCS_PER_RANK)-1 downto 0);
   signal ddr3_cke            : std_logic_vector(CKE_WIDTH-1 downto 0);
   signal ddr3_dm             : std_logic_vector(DM_WIDTH-1 downto 0);
   signal ddr3_dqs_p          : std_logic_vector(DQS_WIDTH-1 downto 0);
   signal ddr3_dqs_n          : std_logic_vector(DQS_WIDTH-1 downto 0);
   signal ddr3_ck_p           : std_logic_vector(CK_WIDTH-1 downto 0);
   signal ddr3_ck_n           : std_logic_vector(CK_WIDTH-1 downto 0);
   signal ddr3_reset_n        : std_logic;

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

begin

   do_clk_ref: Clock
      generic map(PERIOD => 5 ns)
      port map(clk_o => clk_ref, rst_o => sys_rst, stop_i => stop);

   do_sys_clk: Clock
      generic map(PERIOD => 5 ns)
      port map(clk_o => sys_clk, rst_o => open, stop_i => stop);

   sys_clk_p <= sys_clk;
   sys_clk_n <= not sys_clk;

   clk_ref_p <= clk_ref;
   clk_ref_n <= not clk_ref;

   -- Memory model instantiation as in the generated coregen example
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

   dut_inst : entity work.top
   generic map(
      SIM_BYPASS_INIT_CAL=> "SKIP"
   )
   port map(
      sys_clk_p_i          => sys_clk_p,
      sys_clk_n_i          => sys_clk_n,
      clk_ref_p_i          => clk_ref_p,
      clk_ref_n_i          => clk_ref_n,
      sys_rst_i            => sys_rst,
      ddr3_ck_p_o          => ddr3_ck_p,
      ddr3_ck_n_o          => ddr3_ck_n,
      ddr3_addr_o          => ddr3_addr,
      ddr3_ba_o            => ddr3_ba,
      ddr3_ras_n_o         => ddr3_ras_n,
      ddr3_cas_n_o         => ddr3_cas_n,
      ddr3_we_n_o          => ddr3_we_n,
      ddr3_cs_n_o          => ddr3_cs_n,
      ddr3_cke_o           => ddr3_cke,
      ddr3_odt_o           => ddr3_odt,
      ddr3_reset_n_o       => ddr3_reset_n,
      ddr3_dm_o            => ddr3_dm,
      ddr3_dq_io           => ddr3_dq,
      ddr3_dqs_p_io        => ddr3_dqs_p,
      ddr3_dqs_n_io        => ddr3_dqs_n
   );

end architecture Behavioral;
