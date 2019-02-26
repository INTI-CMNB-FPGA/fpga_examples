/*
* Using the S_AXI_GP, S_AXI_ACP and S_AXI_HP interfaces
*
* Author(s):
* * Rodrigo A. Melo
*
* Copyright (c) 2018-2019 Authors and INTI
* Distributed under the BSD 3-Clause License
*/

#include <stdio.h>      // to use printf
#include "xil_printf.h" // to define xil_printf
#include "xil_io.h"     // to use Xil_In32 and Xil_out32
#include "xtime_l.h"    // to use Xtime_GetTime
#include "xil_cache.h"  // to use Xil_DCacheFlushRange

#define MEMORY_DEPTH    16*11//2048

int src[MEMORY_DEPTH] __attribute__ ((aligned (32)));
int dst[MEMORY_DEPTH] __attribute__ ((aligned (32)));

void using_gp_hp_acp(UINTPTR Addr) {
   int i;
   XTime tStart, tEnd;

   for (i = 0; i < MEMORY_DEPTH; i++)
       src[i] = i*2;
   Xil_Out32(Addr + 0x4, MEMORY_DEPTH); // length
   Xil_Out32(Addr + 0x8, (UINTPTR)src); // rd addr
   Xil_Out32(Addr + 0xC, (UINTPTR)dst); // wr addr
   Xil_DCacheFlushRange((UINTPTR)dst,MEMORY_DEPTH * sizeof(int));
   xil_printf("Moving data... ");
   XTime_GetTime(&tStart);
   Xil_Out32(Addr, 1); // start
   while(Xil_In32(Addr)); // busy
   XTime_GetTime(&tEnd);
   xil_printf("Checking... ");
   for (i = 0; i < MEMORY_DEPTH; i++)
       if (src[i] != dst[i])
          xil_printf("\nMismatch (i = %d, src = %d, dst = %d)", i, src[i], dst[i]);
   xil_printf("Finished\n");
   printf("Elapsed cycles moving data = %llu\n\n", 2*(tEnd-tStart));
}

int main() {
   xil_printf("### Wr/rd a PL RAM trougth S_AXI interfaces ###\n\n");
   xil_printf("* Test 1: using S_AXI_GP\n");
   using_gp_hp_acp(XPAR_AXIF_MASTER_DPRAM_1_BASEADDR);
   xil_printf("* Test 2: using S_AXI_ACP\n");
   using_gp_hp_acp(XPAR_AXIF_MASTER_DPRAM_0_BASEADDR);
   xil_printf("* Test 3: using S_AXI_HP\n");
   using_gp_hp_acp(XPAR_AXIF_MASTER_DPRAM_2_BASEADDR);
   xil_printf("### Finished ###\n\n");
   return 0;
}
