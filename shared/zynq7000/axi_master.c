/*
* Using the M_AXI_GP interface
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
#include "xscugic.h"    // to use interrupt (with the PS_DMA)
#include "xdmaps.h"     // to use the PS_DMA

#define MEMORY_DEPTH   2048 // According to the BRAM Controller Config.

#define PS_DMA_CHANNEL 0

void using_xilio() {
   int i;
   int src[MEMORY_DEPTH], dst[MEMORY_DEPTH];
   XTime tStart, tEnd;

   for (i = 0; i < MEMORY_DEPTH; i++)
       src[i] = i*2;
   xil_printf("Moving data... ");
   XTime_GetTime(&tStart);
   for (i = 0; i < MEMORY_DEPTH; i++)
       Xil_Out32((UINTPTR)XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + i * sizeof(int), src[i]);
   for (i = 0; i < MEMORY_DEPTH; i++)
       dst[i] = Xil_In32((UINTPTR)XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + i * sizeof(int));
   XTime_GetTime(&tEnd);
   xil_printf("Checking... ");
   for (i = 0; i < MEMORY_DEPTH; i++)
       if (src[i] != dst[i])
          xil_printf("Mismatch (i = %d, src = %d, dst = %d)\n", i, src[i], dst[i]);
   xil_printf("Finished\n");
   printf("Elapsed cycles moving data = %llu\n\n", 2*(tEnd-tStart));
}

void using_memcpy() {
   int i;
   int src[MEMORY_DEPTH], dst[MEMORY_DEPTH];
   XTime tStart, tEnd;

   for (i = 0; i < MEMORY_DEPTH; i++)
       src[i] = i*3;
   xil_printf("Moving data... ");
   XTime_GetTime(&tStart);
   memcpy((UINTPTR *)XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR, src, MEMORY_DEPTH * sizeof(int));
   memcpy(dst, (UINTPTR *)XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR, MEMORY_DEPTH * sizeof(int));
   XTime_GetTime(&tEnd);
   xil_printf("Checking... ");
   for (i = 0; i < MEMORY_DEPTH; i++)
       if (src[i] != dst[i])
          xil_printf("Mismatch (i = %d, src = %d, dst = %d)\n", i, src[i], dst[i]);
   xil_printf("Finished\n");
   printf("Elapsed cycles moving data = %llu\n\n", 2*(tEnd-tStart));
}

void using_psdma() {}

void using_cache() {}

void using_flush() {}

int main() {
   xil_printf("### Wr/rd a BRAM Controller connected to a M_AXI_GP interface ###\n\n");
   xil_printf("* Test 1: using Xil_IO\n");
   using_xilio();
   xil_printf("* Test 2: using memcpy\n");
   using_memcpy();
   xil_printf("* Test 3: using the PS DMA\n");
   using_psdma();
   xil_printf("* Test 4: using memcpy with cache\n");
   using_psdma();
   xil_printf("* Test 5: using memcpy with cache flush\n");
   using_psdma();
   xil_printf("### Finished ###\n\n");
   return 0;
}
