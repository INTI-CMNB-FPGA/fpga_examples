#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xgpiops.h"
#include "sleep.h"

#define GPIO_DEVICE_ID      XPAR_XGPIOPS_0_DEVICE_ID
#define OUTPUT              0xA
#define MASK                0xF
#define PS_GPIO_BANK        2
#define PS_GPIO_OFFSET (PS_GPIO_BANK * XGPIOPS_DATA_BANK_OFFSET) + XGPIOPS_DATA_RO_OFFSET


void config_gpio(void);

XGpioPs GPIO;    /* The driver instance for GPIO Device. */

int main(){
   config_gpio();
   while(1){
      /* Set the GPIO Output to High. */
      XGpioPs_Write(&GPIO, PS_GPIO_BANK, OUTPUT&MASK);
      usleep(500000);
      XGpioPs_Write(&GPIO, PS_GPIO_BANK, ~OUTPUT&MASK);
      usleep(500000);
   }
   return 0;
}


void config_gpio(void) {
   // Init and configure GPIOs
   int status;
   XGpioPs_Config *cfg;
   cfg = XGpioPs_LookupConfig(XPAR_PS7_GPIO_0_DEVICE_ID);
   if (!cfg) {
      xil_printf("No configuration found for PS GPIOs with device ID %d\n", XPAR_PS7_GPIO_0_DEVICE_ID);
      return;
   }
   status = XGpioPs_CfgInitialize(&GPIO, cfg, cfg ->BaseAddr);
   if (status != XST_SUCCESS) {
      xil_printf("ERROR: PS GPIO configuration failed\n");
      return;
   }
   XGpioPs_SetDirection(&GPIO, PS_GPIO_BANK, 0xF);    //output
   XGpioPs_SetOutputEnable(&GPIO, PS_GPIO_BANK, 0);   //active low
}
