/* Inspired in FreeRTOS lwIP echo server example from Xilinx */

#include "netif/xadapter.h"
#include "xil_printf.h"
#include "lwip/sockets.h"

void lwip_init();

#define THREAD_STACKSIZE 1024

#define CONN_PORT  1000

#define DDR_BASE_ADDR  XPAR_PS7_DDR_0_S_AXI_BASEADDR
#define BUFFER_ADDR    DDR_BASE_ADDR + 0x01000000

static struct netif server_netif;
struct netif *echo_netif;

/* thread spawned for each connection */
void process_echo_request(void *p) {
   int sd = (int)p;
   int param[2];
   int i, count, samples, index;
   int *buf;

   while (1) {
      if ((count = read(sd, param, 2 * sizeof(int))) <= 0) {
         xil_printf("%s: error reading from socket %d, closing socket\r\n", __FUNCTION__, sd);
         break;
      }
      samples = param[0];
      index   = param[1];
      xil_printf("Samples: %d - Index: %d\r\n", samples, index);
      buf = (int *)BUFFER_ADDR;
      for (i = 0; i < samples; i++) buf[i] = i + index;

      if ((count = write(sd, buf, samples*sizeof(int))) < 0) {
         xil_printf("ERROR in write (%d)\r\n", count);
         xil_printf("Closing socket %d\r\n", sd);
         break;
      }

      xil_printf("%d samples were sent\r\n", count);
   }

   close(sd);
   vTaskDelete(NULL);
}

void echo_application_thread() {
   int sock, new_sd;
   int size;
   struct sockaddr_in address, remote;

   memset(&address, 0, sizeof(address));

   if ((sock = lwip_socket(AF_INET, SOCK_STREAM, 0)) < 0)
      return;

   address.sin_family = AF_INET;
   address.sin_port = htons(CONN_PORT);
   address.sin_addr.s_addr = INADDR_ANY;

   if (lwip_bind(sock, (struct sockaddr *)&address, sizeof (address)) < 0)
      return;

   lwip_listen(sock, 0);

   size = sizeof(remote);

   while (1) {
      if ((new_sd = lwip_accept(sock, (struct sockaddr *)&remote, (socklen_t *)&size)) > 0) {
         sys_thread_new("echos", process_echo_request, (void*)new_sd, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
      }
   }
}

void print_ip(char *msg, ip_addr_t *ip) {
   xil_printf(msg);
   xil_printf("%d.%d.%d.%d\n\r", ip4_addr1(ip), ip4_addr2(ip), ip4_addr3(ip), ip4_addr4(ip));
}

void print_ip_settings(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw) {
   print_ip("Board IP: ", ip);
   print_ip("Netmask : ", mask);
   print_ip("Gateway : ", gw);
}

void network_thread(void *p) {
   struct netif *netif;
   /* the mac address of the board. this should be unique per board */
   unsigned char mac_ethernet_address[] = { 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };
   ip_addr_t ipaddr, netmask, gw;

   netif = &server_netif;

   xil_printf("\r\n\r\n");
   xil_printf("-----lwIP Socket Mode Echo server Demo Application ------\r\n");

   /* initliaze IP addresses to be used */
   IP4_ADDR(&ipaddr,  192, 168, 0, 10);
   IP4_ADDR(&netmask, 255, 255, 255,  0);
   IP4_ADDR(&gw,      192, 168, 0, 1);
   print_ip_settings(&ipaddr, &netmask, &gw);

   /* Add network interface to the netif_list, and set it as default */
   if (!xemac_add(netif, &ipaddr, &netmask, &gw, mac_ethernet_address, XPAR_XEMACPS_0_BASEADDR)) {
      xil_printf("Error adding N/W interface\r\n");
      return;
   }

   netif_set_default(netif);
   /* specify that the network if is up */
   netif_set_up(netif);

   /* start packet receive thread - required for lwIP operation */
   sys_thread_new("xemacif_input_thread", (void(*)(void*))xemacif_input_thread, netif, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);

   xil_printf("\r\n");
   sys_thread_new("echod", echo_application_thread, 0, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
   vTaskDelete(NULL);

   return;
}

int main_thread() {
   xil_printf("* Initializing lwIP in TCP socket mode (FreeRTOS APP)\r\n");

   lwip_init();
   sys_thread_new("nw_thread", network_thread, NULL, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);

   vTaskDelete(NULL);
   return 0;
}

int main() {
   sys_thread_new("main_thread", (void(*)(void*))main_thread, 0, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
   vTaskStartScheduler();
   while(1);
   return 0;
}
