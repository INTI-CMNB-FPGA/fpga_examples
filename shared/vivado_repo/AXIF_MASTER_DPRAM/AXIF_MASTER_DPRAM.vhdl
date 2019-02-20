library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXIF_MASTER_DPRAM is
   generic (
      -- Users to add parameters here

      -- User parameters ends
      -- Parameters of Axi Slave Bus Interface S_AXIL
      C_S_AXIL_ADDR_WIDTH   : integer   := 4;
      -- Parameters of Axi Master Bus Interface M_AXIF
      C_M_AXIF_TARGET_SLAVE_BASE_ADDR   : std_logic_vector   := x"40000000";
      C_M_AXIF_BURST_LEN    : integer   := 16;
      C_M_AXIF_ID_WIDTH     : integer   := 1;
      C_M_AXIF_AWUSER_WIDTH : integer   := 1;
      C_M_AXIF_ARUSER_WIDTH : integer   := 1;
      C_M_AXIF_WUSER_WIDTH  : integer   := 4;
      C_M_AXIF_RUSER_WIDTH  : integer   := 4;
      C_M_AXIF_BUSER_WIDTH  : integer   := 1
   );
   port (
      -- Users to add ports here
      aclk           : in std_logic;
      aresetn        : in std_logic;
      -- User ports ends
      -- Ports of Axi Slave Bus Interface S_AXIL
      s_axil_awaddr  : in std_logic_vector(C_S_AXIL_ADDR_WIDTH-1 downto 0);
      s_axil_awprot  : in std_logic_vector(2 downto 0);
      s_axil_awvalid : in std_logic;
      s_axil_awready : out std_logic;
      s_axil_wdata   : in std_logic_vector(31 downto 0);
      s_axil_wstrb   : in std_logic_vector((32/8)-1 downto 0);
      s_axil_wvalid  : in std_logic;
      s_axil_wready  : out std_logic;
      s_axil_bresp   : out std_logic_vector(1 downto 0);
      s_axil_bvalid  : out std_logic;
      s_axil_bready  : in std_logic;
      s_axil_araddr  : in std_logic_vector(C_S_AXIL_ADDR_WIDTH-1 downto 0);
      s_axil_arprot  : in std_logic_vector(2 downto 0);
      s_axil_arvalid : in std_logic;
      s_axil_arready : out std_logic;
      s_axil_rdata   : out std_logic_vector(31 downto 0);
      s_axil_rresp   : out std_logic_vector(1 downto 0);
      s_axil_rvalid  : out std_logic;
      s_axil_rready  : in std_logic;
      -- Ports of Axi Master Bus Interface M_AXIF
      m_axif_awid    : out std_logic_vector(C_M_AXIF_ID_WIDTH-1 downto 0);
      m_axif_awaddr  : out std_logic_vector(31 downto 0);
      m_axif_awlen   : out std_logic_vector(7 downto 0);
      m_axif_awsize  : out std_logic_vector(2 downto 0);
      m_axif_awburst : out std_logic_vector(1 downto 0);
      m_axif_awlock  : out std_logic;
      m_axif_awcache : out std_logic_vector(3 downto 0);
      m_axif_awprot  : out std_logic_vector(2 downto 0);
      m_axif_awqos   : out std_logic_vector(3 downto 0);
      m_axif_awuser  : out std_logic_vector(C_M_AXIF_AWUSER_WIDTH-1 downto 0);
      m_axif_awvalid : out std_logic;
      m_axif_awready : in std_logic;
      m_axif_wdata   : out std_logic_vector(31 downto 0);
      m_axif_wstrb   : out std_logic_vector(32/8-1 downto 0);
      m_axif_wlast   : out std_logic;
      m_axif_wuser   : out std_logic_vector(C_M_AXIF_WUSER_WIDTH-1 downto 0);
      m_axif_wvalid  : out std_logic;
      m_axif_wready  : in std_logic;
      m_axif_bid     : in std_logic_vector(C_M_AXIF_ID_WIDTH-1 downto 0);
      m_axif_bresp   : in std_logic_vector(1 downto 0);
      m_axif_buser   : in std_logic_vector(C_M_AXIF_BUSER_WIDTH-1 downto 0);
      m_axif_bvalid  : in std_logic;
      m_axif_bready  : out std_logic;
      m_axif_arid    : out std_logic_vector(C_M_AXIF_ID_WIDTH-1 downto 0);
      m_axif_araddr  : out std_logic_vector(31 downto 0);
      m_axif_arlen   : out std_logic_vector(7 downto 0);
      m_axif_arsize  : out std_logic_vector(2 downto 0);
      m_axif_arburst : out std_logic_vector(1 downto 0);
      m_axif_arlock  : out std_logic;
      m_axif_arcache : out std_logic_vector(3 downto 0);
      m_axif_arprot  : out std_logic_vector(2 downto 0);
      m_axif_arqos   : out std_logic_vector(3 downto 0);
      m_axif_aruser  : out std_logic_vector(C_M_AXIF_ARUSER_WIDTH-1 downto 0);
      m_axif_arvalid : out std_logic;
      m_axif_arready : in std_logic;
      m_axif_rid     : in std_logic_vector(C_M_AXIF_ID_WIDTH-1 downto 0);
      m_axif_rdata   : in std_logic_vector(31 downto 0);
      m_axif_rresp   : in std_logic_vector(1 downto 0);
      m_axif_rlast   : in std_logic;
      m_axif_ruser   : in std_logic_vector(C_M_AXIF_RUSER_WIDTH-1 downto 0);
      m_axif_rvalid  : in std_logic;
      m_axif_rready  : out std_logic
   );
end AXIF_MASTER_DPRAM;

architecture arch_imp of AXIF_MASTER_DPRAM is

begin

   S_AXIL_inst : entity work.AXIF_MASTER_DPRAM_S_AXIL
   generic map (
      C_S_AXI_DATA_WIDTH => 32,
      C_S_AXI_ADDR_WIDTH => C_S_AXIL_ADDR_WIDTH
   )
   port map (
      S_AXI_ACLK    => aclk,
      S_AXI_ARESETN => aresetn,
      S_AXI_AWADDR  => s_axil_awaddr,
      S_AXI_AWPROT  => s_axil_awprot,
      S_AXI_AWVALID => s_axil_awvalid,
      S_AXI_AWREADY => s_axil_awready,
      S_AXI_WDATA   => s_axil_wdata,
      S_AXI_WSTRB   => s_axil_wstrb,
      S_AXI_WVALID  => s_axil_wvalid,
      S_AXI_WREADY  => s_axil_wready,
      S_AXI_BRESP   => s_axil_bresp,
      S_AXI_BVALID  => s_axil_bvalid,
      S_AXI_BREADY  => s_axil_bready,
      S_AXI_ARADDR  => s_axil_araddr,
      S_AXI_ARPROT  => s_axil_arprot,
      S_AXI_ARVALID => s_axil_arvalid,
      S_AXI_ARREADY => s_axil_arready,
      S_AXI_RDATA   => s_axil_rdata,
      S_AXI_RRESP   => s_axil_rresp,
      S_AXI_RVALID  => s_axil_rvalid,
      S_AXI_RREADY  => s_axil_rready
   );

   M_AXIF_inst : entity work.AXIF_MASTER_DPRAM_M_AXIF
   generic map (
      C_M_TARGET_SLAVE_BASE_ADDR => C_M_AXIF_TARGET_SLAVE_BASE_ADDR,
      C_M_AXI_BURST_LEN    => C_M_AXIF_BURST_LEN,
      C_M_AXI_ID_WIDTH     => C_M_AXIF_ID_WIDTH,
      C_M_AXI_ADDR_WIDTH   => 32,
      C_M_AXI_DATA_WIDTH   => 32,
      C_M_AXI_AWUSER_WIDTH => C_M_AXIF_AWUSER_WIDTH,
      C_M_AXI_ARUSER_WIDTH => C_M_AXIF_ARUSER_WIDTH,
      C_M_AXI_WUSER_WIDTH  => C_M_AXIF_WUSER_WIDTH,
      C_M_AXI_RUSER_WIDTH  => C_M_AXIF_RUSER_WIDTH,
      C_M_AXI_BUSER_WIDTH  => C_M_AXIF_BUSER_WIDTH
   )
   port map (
      INIT_AXI_TXN  => '1',
      TXN_DONE      => open,
      ERROR         => open,
      M_AXI_ACLK    => aclk,
      M_AXI_ARESETN => aresetn,
      M_AXI_AWID    => m_axif_awid,
      M_AXI_AWADDR  => m_axif_awaddr,
      M_AXI_AWLEN   => m_axif_awlen,
      M_AXI_AWSIZE  => m_axif_awsize,
      M_AXI_AWBURST => m_axif_awburst,
      M_AXI_AWLOCK  => m_axif_awlock,
      M_AXI_AWCACHE => m_axif_awcache,
      M_AXI_AWPROT  => m_axif_awprot,
      M_AXI_AWQOS   => m_axif_awqos,
      M_AXI_AWUSER  => m_axif_awuser,
      M_AXI_AWVALID => m_axif_awvalid,
      M_AXI_AWREADY => m_axif_awready,
      M_AXI_WDATA   => m_axif_wdata,
      M_AXI_WSTRB   => m_axif_wstrb,
      M_AXI_WLAST   => m_axif_wlast,
      M_AXI_WUSER   => m_axif_wuser,
      M_AXI_WVALID  => m_axif_wvalid,
      M_AXI_WREADY  => m_axif_wready,
      M_AXI_BID     => m_axif_bid,
      M_AXI_BRESP   => m_axif_bresp,
      M_AXI_BUSER   => m_axif_buser,
      M_AXI_BVALID  => m_axif_bvalid,
      M_AXI_BREADY  => m_axif_bready,
      M_AXI_ARID    => m_axif_arid,
      M_AXI_ARADDR  => m_axif_araddr,
      M_AXI_ARLEN   => m_axif_arlen,
      M_AXI_ARSIZE  => m_axif_arsize,
      M_AXI_ARBURST => m_axif_arburst,
      M_AXI_ARLOCK  => m_axif_arlock,
      M_AXI_ARCACHE => m_axif_arcache,
      M_AXI_ARPROT  => m_axif_arprot,
      M_AXI_ARQOS   => m_axif_arqos,
      M_AXI_ARUSER  => m_axif_aruser,
      M_AXI_ARVALID => m_axif_arvalid,
      M_AXI_ARREADY => m_axif_arready,
      M_AXI_RID     => m_axif_rid,
      M_AXI_RDATA   => m_axif_rdata,
      M_AXI_RRESP   => m_axif_rresp,
      M_AXI_RLAST   => m_axif_rlast,
      M_AXI_RUSER   => m_axif_ruser,
      M_AXI_RVALID  => m_axif_rvalid,
      M_AXI_RREADY  => m_axif_rready
   );

   -- Add user logic here

   -- User logic ends

end arch_imp;
