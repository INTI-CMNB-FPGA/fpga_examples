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

void using_psdma() {
   int i, status;
   static int src[MEMORY_DEPTH], dst[MEMORY_DEPTH]; // without static it fails!
   XTime tStart, tEnd;
   // PS DMA
   XDmaPs_Config *dma_cfg;
   XDmaPs_Cmd dma_cmd;
   XDmaPs dma_ptr;
   // GIC
   XScuGic_Config *GicConfig;
   XScuGic gic_ptr;

   // PS DMA
   dma_cfg = XDmaPs_LookupConfig(XPAR_XDMAPS_1_DEVICE_ID);
   if (dma_cfg == NULL) {
      xil_printf("ERROR: No configuration found for PS DMA device ID %d\n", XPAR_XDMAPS_1_DEVICE_ID);
      return;
   }
   status = XDmaPs_CfgInitialize(&dma_ptr, dma_cfg, dma_cfg->BaseAddress);
   if (status != XST_SUCCESS) {
      xil_printf("ERROR: PS DMA configuration failed\n");
      return;
   }
   // GIC
   GicConfig = XScuGic_LookupConfig(XPAR_SCUGIC_SINGLE_DEVICE_ID);
   if (NULL == GicConfig) {
      xil_printf("ERROR: No configuration found for GIC device ID %d\n", XPAR_SCUGIC_SINGLE_DEVICE_ID);
      return;
   }
   status = XScuGic_CfgInitialize(&gic_ptr, GicConfig, GicConfig->CpuBaseAddress);
   if (status != XST_SUCCESS) {
      xil_printf("ERROR: GIC configuration failed\n");
      return;
   }
   Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT, (Xil_ExceptionHandler)XScuGic_InterruptHandler, &gic_ptr);
   status = XScuGic_Connect(&gic_ptr, XPAR_XDMAPS_0_DONE_INTR_0, (Xil_InterruptHandler)XDmaPs_DoneISR_0, &dma_ptr);
   if (status != XST_SUCCESS) {
      xil_printf("ERROR: XScuGic_Connect failed\n");
      return;
   }
   XScuGic_Enable(&gic_ptr, XPAR_XDMAPS_0_DONE_INTR_0);
   Xil_ExceptionEnable();
   // PS DMA Configs
   memset(&dma_cmd, 0, sizeof(XDmaPs_Cmd));
   dma_cmd.ChanCtrl.SrcBurstSize = 4;
   dma_cmd.ChanCtrl.SrcBurstLen = 16;
   dma_cmd.ChanCtrl.SrcInc = 1;
   dma_cmd.ChanCtrl.DstBurstSize = 4;
   dma_cmd.ChanCtrl.DstBurstLen = 16;
   dma_cmd.ChanCtrl.DstInc = 1;
   dma_cmd.BD.Length = MEMORY_DEPTH * sizeof(int);

   // Doing transfers
   for (i = 0; i < MEMORY_DEPTH; i++)
       src[i] = i*4;
   xil_printf("Moving data... ");
   XTime_GetTime(&tStart);
   dma_cmd.BD.SrcAddr = (u32) src;
   dma_cmd.BD.DstAddr = (u32) XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR;
   XDmaPs_Start(&dma_ptr, PS_DMA_CHANNEL, &dma_cmd, 0);
   while (XDmaPs_IsActive(&dma_ptr, PS_DMA_CHANNEL));
   //
   dma_cmd.BD.SrcAddr = (u32) XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR;
   dma_cmd.BD.DstAddr = (u32) dst;
   XDmaPs_Start(&dma_ptr, PS_DMA_CHANNEL, &dma_cmd, 0);
   while (XDmaPs_IsActive(&dma_ptr, PS_DMA_CHANNEL));
   XTime_GetTime(&tEnd);
   xil_printf("Checking... ");
   for (i = 0; i < MEMORY_DEPTH; i++)
       if (src[i] != dst[i])
          xil_printf("Mismatch (i = %d, src = %d, dst = %d)\n", i, src[i], dst[i]);
   xil_printf("Finished\n");
   printf("Elapsed cycles moving data = %llu\n\n", 2*(tEnd-tStart));
}

int main() {
   xil_printf("### Wr/rd a BRAM Controller connected to a M_AXI_GP interface ###\n\n");
   xil_printf("* Test 1: using Xil_IO\n");
   using_xilio();
   xil_printf("* Test 2: using memcpy\n");
   using_memcpy();
   xil_printf("* Test 3: using the PS DMA\n");
   using_psdma();
   xil_printf("### Finished ###\n\n");
   return 0;
}
