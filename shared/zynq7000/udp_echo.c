/* Inspired in FreeRTOS lwIP UDP client/server examples from Xilinx */

#include <sleep.h>
#include "netif/xadapter.h"
#include "xil_printf.h"
#include "lwip/init.h"
#include "lwip/inet.h"

static int complete_nw_thread;

void start_application();

#define THREAD_STACKSIZE 1024

#define IP_ADDRESS "192.168.1.10"
#define IP_MASK    "255.255.255.0"
#define GW_ADDRESS "192.168.1.1"
#define CONN_PORT  1000

struct netif server_netif;

/* Application */


/* Configs */

static void assign_default_ip(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw) {
   int err;
   xil_printf("Configuring IP %s \r\n", IP_ADDRESS);
   err = inet_aton(IP_ADDRESS, ip);
   if(!err)
      xil_printf("Invalid IP address: %d\r\n", err);
   err = inet_aton(IP_MASK, mask);
   if(!err)
      xil_printf("Invalid IP MASK: %d\r\n", err);
   err = inet_aton(GW_ADDRESS, gw);
   if(!err)
      xil_printf("Invalid GW address: %d\r\n", err);
}

void network_thread(void *p) {
   u8_t mac_ethernet_address[] = { 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };

   /* Add network interface to the netif_list, and set it as default */
   if (!xemac_add(&server_netif, NULL, NULL, NULL, mac_ethernet_address, XPAR_XEMACPS_0_BASEADDR)) {
      xil_printf("Error adding N/W interface\r\n");
      return;
   }

   netif_set_default(&server_netif);

   /* specify that the network if is up */
   netif_set_up(&server_netif);

   /* required for lwIP operation */
   sys_thread_new("xemacif_input_thread",
         (void(*)(void*))xemacif_input_thread, &server_netif,
         THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);

   complete_nw_thread = 1;

   vTaskDelete(NULL);
}

int main_thread() {
   xil_printf("* Initializing lwIP in UDP socket mode (FreeRTOS APP)\r\n");

   lwip_init();
   sys_thread_new("nw_thread", network_thread, NULL, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);

   while (!complete_nw_thread)
      usleep(50);

   assign_default_ip(&(server_netif.ip_addr), &(server_netif.netmask), &(server_netif.gw));

   start_application();

   vTaskDelete(NULL);
   return 0;
}

int main() {
   sys_thread_new("main_thread", (void(*)(void*))main_thread, 0, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
   vTaskStartScheduler();
   while(1);
   return 0;
}
