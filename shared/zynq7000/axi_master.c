#include <stdio.h>
#include "xil_printf.h"
#include "xil_io.h"
#include "xtime_l.h"

#define MEMORY_DEPTH 2048

int main() {
   int i;
   int src[MEMORY_DEPTH], dst[MEMORY_DEPTH];
   XTime tStart, tEnd;

   xil_printf("* Wr/rd a BRAM Controller connected to a M_AXI_GP interface\n");
   //
   xil_printf("* Test 1: using Xil_IO\n");
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
   xil_printf("PASS!\n");
   printf("Elapsed cycles moving data = %llu\n\n", 2*(tEnd-tStart));
   //
   xil_printf("* Test 2: using memcpy\n");
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
   xil_printf("PASS!\n");
   printf("Elapsed cycles moving data = %llu\n\n", 2*(tEnd-tStart));
   //
   xil_printf("* Test 3: using the PS DMA\n");
   //
   return 0;
}
