/*
* AXI DMA in Simple Mode by polling
*
* Author(s):
* * Rodrigo A. Melo
*
* Copyright (c) 2018 Authors and INTI
* Distributed under the BSD 3-Clause License
*/

#include "xaxidma.h"

#define DDR_BASE_ADDR  XPAR_PS7_DDR_0_S_AXI_BASEADDR
#define TX_BASE_ADDR   DDR_BASE_ADDR + 0x01000000
#define RX_BASE_ADDR   TX_BASE_ADDR + 0x00800000 // 8M

//Select one or add your own size
//#define data_t         u8
//#define data_t         u16
#define data_t         u32
//#define data_t         u64

#define BYTES          (8*1024*1024-1) // Max when "Width of buffer length register" is 23 bits
#define SAMPLES        BYTES / sizeof(data_t)

XAxiDma dma;

int dma_init(int device_id) {
    XAxiDma_Config *cfg;
    int status;
    cfg = XAxiDma_LookupConfig(device_id);
    if (!cfg) {
       xil_printf("No configuration found for AXI DMA with device ID %d\n", device_id);
       return XST_FAILURE;
    }
    status = XAxiDma_CfgInitialize(&dma, cfg);
    if (status != XST_SUCCESS) {
       xil_printf("ERROR: DMA configuration failed\n");
       return XST_FAILURE;
    }
    if (! XAxiDma_HasSg(&dma)) {
       xil_printf("INFO: Device configured in Simple Mode.\n");
    } else {
       xil_printf("ERROR: Device configured in Scatter Gather Mode.\n");
       return XST_FAILURE;
    }
    return XST_SUCCESS;
}

int dma_example() {
    int i, status, try;
    data_t *tx_buf, *rx_buf;

    tx_buf = (data_t *)TX_BASE_ADDR;
    rx_buf = (data_t *)RX_BASE_ADDR;

    for (try = 1; try <= 10; try++) {
        xil_printf("Try %d\n", try);
        for (i = 0; i < SAMPLES; i++) {
            tx_buf[i] = i+try;
        }

        Xil_DCacheFlushRange((UINTPTR)tx_buf, BYTES);
        Xil_DCacheFlushRange((UINTPTR)rx_buf, BYTES);

        status = XAxiDma_SimpleTransfer(&dma,(UINTPTR)tx_buf, BYTES, XAXIDMA_DMA_TO_DEVICE);
        if (status != XST_SUCCESS) {
           xil_printf("DMA TX SimpleTransfer failed\n");
           return XST_FAILURE;
        }
        status = XAxiDma_SimpleTransfer(&dma,(UINTPTR)rx_buf, BYTES, XAXIDMA_DEVICE_TO_DMA);
        if (status != XST_SUCCESS) {
           xil_printf("DMA RX SimpleTransfer failed\n");
           return XST_FAILURE;
        }
        while ((XAxiDma_Busy(&dma,XAXIDMA_DEVICE_TO_DMA)) || (XAxiDma_Busy(&dma,XAXIDMA_DMA_TO_DEVICE)));

        for (i = 0; i < SAMPLES; i++) {
            if (rx_buf[i] != tx_buf[i]) {
               xil_printf("ERROR: mismatch (data %d) between TX(%d) and RX(%d)\n", i+1, rx_buf[i], tx_buf[i]);
               return XST_FAILURE;
            }
        }
        xil_printf("Try %d passed\n", try);
    }
    return XST_SUCCESS;
}
/*****************************************************************************/
int main() {
    int status;
    xil_printf("* DMA Simple Mode by Polling Example\n");
    xil_printf("* Initializing DMA\n");
    status = dma_init(XPAR_AXIDMA_0_DEVICE_ID);
    if (status != XST_SUCCESS) {
       xil_printf("DMA initialization failed\n");
       return XST_FAILURE;
    }
    xil_printf("* Playing with DMA\n");
    status = dma_example();
    if (status != XST_SUCCESS) {
       xil_printf("* Example Failed\n");
       return XST_FAILURE;
    }
    xil_printf("* Example Passed\n");
    return XST_SUCCESS;
}
