/*
-- ddr test on CIAA ACC
--
-- Author(s):
-- * Valinoti Bruno
--
-- Copyright (c) 2017 Authors and INTI
-- Distributed under the BSD 3-Clause License
*/

/*
 * ddrtest.c: simple ddr test application, writes and read all the memory
 * space and returns OK if no errors
 *
 */

#include <stdio.h>
#include "xil_io.h"

// should write and read memory from XPAR_PS7_DDR_0_S_AXI_BASEADDR
// to XPAR_PS7_DDR_0_S_AXI_HIGHADDR

#define MEM_SIZE  (XPAR_PS7_DDR_0_S_AXI_HIGHADDR - XPAR_PS7_DDR_0_S_AXI_BASEADDR)
#define MEM_START 0x20000 

int main(){
   int count;
   int read;
   int vec[]={0x5555AAAA,0xAAAA5555};


    print("Write/Read DDR memory test starts!.\n\r");
    print("Testing with 0x5555AAAA.\n\r");


    for(count=MEM_START; count < MEM_SIZE-MEM_START-1; count=count+4)
    	Xil_Out32(XPAR_PS7_DDR_0_S_AXI_BASEADDR + count, vec[count%4]);

    for(count=MEM_START; count < MEM_SIZE-MEM_START-1; count=count+4){
        read = Xil_In32(XPAR_PS7_DDR_0_S_AXI_BASEADDR + count);
    	if(read != vec[count%4]){
           printf("Loop: %d \n",count/4);
           printf("Error: Bad read value, it should be 0x5555AAAA and is: 0x%08X\n",read);
           break;
    	}
    }

    	print("Finished memory test OK!!\n\n\r");
    return 0;
}
