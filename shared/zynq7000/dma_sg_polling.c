/*
* AXI DMA in Scatter Ghater Mode by Polling
*
* Author(s):
* * Rodrigo A. Melo
*
* Copyright (c) 2018 Authors and INTI
* Distributed under the BSD 3-Clause License
*/

#include "xaxidma.h"

#define DDR_BASE_ADDR  XPAR_PS7_DDR_0_S_AXI_BASEADDR+0x01000000

#define TX_BD_ADDR     (DDR_BASE_ADDR)
#define RX_BD_ADDR     (DDR_BASE_ADDR + 0x00001000)
#define TX_BASE_ADDR   (DDR_BASE_ADDR + 0x00100000)
#define RX_BASE_ADDR   (DDR_BASE_ADDR + 0x00300000)

//Select one or add your own size
//#define data_t         u8
//#define data_t         u16
#define data_t         u32
//#define data_t         u64

#define BYTES          (8*1024*1024-1) // Max when "Width of buffer length register" is 23 bits
#define SAMPLES        BYTES / sizeof(data_t)

XAxiDma dma;

static int tx_setup(data_t *tx_buf, XAxiDma_BdRing *tx_ring_ptr) {
    int status, bds;
    XAxiDma_Bd template;
    XAxiDma_Bd *bd_ptr;

    // Determine how many BDs will fit within the given memory constraints
    bds = XAxiDma_BdRingCntCalc(XAXIDMA_BD_MINIMUM_ALIGNMENT, RX_BD_ADDR-TX_BD_ADDR);
    // Creates and setup the BD ring
    status = XAxiDma_BdRingCreate(tx_ring_ptr, TX_BD_ADDR, TX_BD_ADDR, XAXIDMA_BD_MINIMUM_ALIGNMENT, bds);
    if (status != XST_SUCCESS) {
       xil_printf("ERROR: BdRingCreate (TX)\n");
       return XST_FAILURE;
    }
    // Init BDs with the default value
    XAxiDma_BdClear(&template);
    status = XAxiDma_BdRingClone(tx_ring_ptr, &template);
    if (status != XST_SUCCESS) {
       xil_printf("ERROR: BdRingClone (TX)\n");
       return XST_FAILURE;
    }
    // Allocate a BD
    status = XAxiDma_BdRingAlloc(tx_ring_ptr, 1, &bd_ptr);
    if (status != XST_SUCCESS) {
       xil_printf("ERROR: BdRingAlloc (TX)\n");
       return XST_FAILURE;
    }
    // Set up the BD using the information of the packet to transmit
    status = XAxiDma_BdSetBufAddr(bd_ptr, (UINTPTR)tx_buf);
    if (status != XST_SUCCESS) {
       xil_printf("ERROR: BdSetBufAddr (TX)\n");
       return XST_FAILURE;
    }
    status = XAxiDma_BdSetLength(bd_ptr, BYTES, tx_ring_ptr->MaxTransferLen);
    if (status != XST_SUCCESS) {
       xil_printf("ERROR: BdSetLength (TX)\n");
       return XST_FAILURE;
    }
    // For single packet, both SOF and EOF are to be set
    XAxiDma_BdSetCtrl(bd_ptr, XAXIDMA_BD_CTRL_TXEOF_MASK | XAXIDMA_BD_CTRL_TXSOF_MASK);
    //XAxiDma_BdSetId(bd_ptr, tx_buf);
    // Give the BD to DMA
    status = XAxiDma_BdRingToHw(tx_ring_ptr, 1, bd_ptr);
    if (status != XST_SUCCESS) {
       xil_printf("ERROR: BdRingToHw (TX)\n");
       return XST_FAILURE;
    }
    //
    return XST_SUCCESS;
}

static int rx_setup(data_t *rx_buf, XAxiDma_BdRing *rx_ring_ptr) {
    int i, status, bds, free_bds;
    XAxiDma_Bd template;
    XAxiDma_Bd *bd_ptr;
    XAxiDma_Bd *bd_cur_ptr;

    // Determine how many BDs will fit within the given memory constraints
    bds = XAxiDma_BdRingCntCalc(XAXIDMA_BD_MINIMUM_ALIGNMENT, TX_BASE_ADDR-RX_BD_ADDR);
    // Creates and setup the BD ring
    status = XAxiDma_BdRingCreate(rx_ring_ptr, RX_BD_ADDR, RX_BD_ADDR, XAXIDMA_BD_MINIMUM_ALIGNMENT, bds);
    if (status != XST_SUCCESS) {
       xil_printf("ERROR: BdRingCreate (RX)\n");
       return XST_FAILURE;
    }
    // Init BDs with the default value
    XAxiDma_BdClear(&template);
    status = XAxiDma_BdRingClone(rx_ring_ptr, &template);
    if (status != XST_SUCCESS) {
       xil_printf("ERROR: BdRingClone (RX)\n");
       return XST_FAILURE;
    }
    // Attach buffers to RxBD ring so we are ready to receive packets
    free_bds = XAxiDma_BdRingGetFreeCnt(rx_ring_ptr);
    status = XAxiDma_BdRingAlloc(rx_ring_ptr, free_bds, &bd_ptr);
    if (status != XST_SUCCESS) {
       xil_printf("ERROR: BdRingAlloc (RX)\n");
       return XST_FAILURE;
    }
    bd_cur_ptr = bd_ptr;
    for (i = 0; i < free_bds; i++) {
        status = XAxiDma_BdSetBufAddr(bd_cur_ptr, (UINTPTR)rx_buf);
        if (status != XST_SUCCESS) {
           xil_printf("ERROR: BdSetBufAddr (RX)\n");
           return XST_FAILURE;
        }
        status = XAxiDma_BdSetLength(bd_cur_ptr, BYTES, rx_ring_ptr->MaxTransferLen);
        if (status != XST_SUCCESS) {
           xil_printf("ERROR: BdSetLength (RX)\n");
           return XST_FAILURE;
        }
        //XAxiDma_BdSetCtrl(bd_cur_ptr, 0);
        //XAxiDma_BdSetId(bd_cur_ptr, rx_buf);
        rx_buf += BYTES;
        bd_cur_ptr = (XAxiDma_Bd *)XAxiDma_BdRingNext(rx_ring_ptr, bd_cur_ptr);
    }
    status = XAxiDma_BdRingToHw(rx_ring_ptr, free_bds, bd_ptr);
    if (status != XST_SUCCESS) {
       xil_printf("ERROR: BdRingToHw (RX)\n");
       return XST_FAILURE;
    }
    // Start the DMA RX channel
    status = XAxiDma_BdRingStart(rx_ring_ptr);
    if (status != XST_SUCCESS) {
       xil_printf("ERROR: BdRingStart (RX)\n");
       return XST_FAILURE;
    }
    return XST_SUCCESS;
}

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
       xil_printf("DMA configuration failed\n");
       return XST_FAILURE;
    }
    if (XAxiDma_HasSg(&dma)) {
       xil_printf("INFO: Device configured in Scatter Gather Mode.\n");
    } else {
       xil_printf("ERROR: Device configured in Simple Mode.\n");
       return XST_FAILURE;
    }
    return XST_SUCCESS;
}

int dma_example() {
    int i, status, cnt;
    XAxiDma_BdRing *tx_ring_ptr, *rx_ring_ptr;
    XAxiDma_Bd *bd_ptr;
    data_t *tx_buf, *rx_buf;

    tx_buf = (data_t *)TX_BASE_ADDR;
    rx_buf = (data_t *)RX_BASE_ADDR;

    tx_ring_ptr = XAxiDma_GetTxRing(&dma);
    rx_ring_ptr = XAxiDma_GetRxRing(&dma);

    for (i = 0; i < SAMPLES; i ++) {
        tx_buf[i] = i;
    }

    Xil_DCacheFlushRange((UINTPTR)tx_buf, BYTES);
    Xil_DCacheFlushRange((UINTPTR)rx_buf, BYTES);

    status = tx_setup(tx_buf, tx_ring_ptr);
    if (status != XST_SUCCESS) {
       return XST_FAILURE;
    }
    status = rx_setup(rx_buf, rx_ring_ptr);
    if (status != XST_SUCCESS) {
       return XST_FAILURE;
    }
    // Start the DMA TX channel
    status = XAxiDma_BdRingStart(tx_ring_ptr);
    if (status != XST_SUCCESS) {
       xil_printf("ERROR: BdRingStart (TX)\n");
       return XST_FAILURE;
    }

    while ((cnt = XAxiDma_BdRingFromHw(tx_ring_ptr, XAXIDMA_ALL_BDS, &bd_ptr)) == 0);
    xil_printf("%d TX BDs processed.\n", cnt);
    while ((cnt = XAxiDma_BdRingFromHw(rx_ring_ptr, XAXIDMA_ALL_BDS, &bd_ptr)) == 0);
    xil_printf("%d RX BDs processed.\n", cnt);
    for (i = 0; i < SAMPLES; i++) {
        if (rx_buf[i] != tx_buf[i]) {
           xil_printf("Data error %d: %x/%x\n", i, rx_buf[i], tx_buf[i]);
           return XST_FAILURE;
        }
    }
    return XST_SUCCESS;
}
/*****************************************************************************/
int main(void) {
    int status;
    xil_printf("* DMA Scatter Gather Example\n");
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
