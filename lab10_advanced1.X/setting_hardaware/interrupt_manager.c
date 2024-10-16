#include <xc.h>
#include <pic18f4520.h>

void INTERRUPT_Initialize (void)
{
    RCONbits.IPEN = 1;      //enable Interrupt Priority mode
//    INTCONbits.GIEH = 1;    //enable high priority interrupt
//    INTCONbits.GIEL = 1;     //disable low priority interrupt
    
    INTCONbits.GIE = 1;
    
    //button, INT0
    INTCONbits.INT0F = 0; //flag
    INTCONbits.INT0E = 1; //enable
    TRISB = 0;
}

