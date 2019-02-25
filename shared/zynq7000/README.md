# Firmware for Zynq-7000 projects

* axi_master.c: Using the M_AXI_GP interface with Xil_In32/Xil_Out32, memcpy and PS DMA
* ddr_test.c: Memory coherence test by writing and reading all the DDR space.
* gpio_emio.c GPIO usage by firmware through EMIO mapped to board outputs.
* dma_sg_polling.c:
* dma_simple_interrupt.c: AXI DMA in Simple Mode by interrupts
* dma_simple_polling.c: AXI DMA in Simple Mode by polling
