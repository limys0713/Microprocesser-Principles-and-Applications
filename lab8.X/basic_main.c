/*
 * File:   basic_main.c
 * Author: User
 *
 * Created on November 28, 2023, 11:46 PM
 */

// CONFIG1H
#pragma config OSC = INTIO67    // Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
#pragma config FCMEN = OFF      // Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
#pragma config IESO = OFF       // Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

// CONFIG2L
#pragma config PWRT = OFF       // Power-up Timer Enable bit (PWRT disabled)
#pragma config BOREN = SBORDIS  // Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
#pragma config BORV = 3         // Brown Out Reset Voltage bits (Minimum setting)

// CONFIG2H
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config WDTPS = 32768    // Watchdog Timer Postscale Select bits (1:32768)

// CONFIG3H
#pragma config CCP2MX = PORTC   // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = ON      // PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
#pragma config LPT1OSC = OFF    // Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

// CONFIG4L
#pragma config STVREN = ON      // Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
#pragma config XINST = OFF      // Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

// CONFIG5L
#pragma config CP0 = OFF        // Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
#pragma config CP1 = OFF        // Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
#pragma config CP2 = OFF        // Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
#pragma config CP3 = OFF        // Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

// CONFIG5H
#pragma config CPB = OFF        // Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
#pragma config CPD = OFF        // Data EEPROM Code Protection bit (Data EEPROM not code-protected)

// CONFIG6L
#pragma config WRT0 = OFF       // Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
#pragma config WRT1 = OFF       // Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
#pragma config WRT2 = OFF       // Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
#pragma config WRT3 = OFF       // Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

// CONFIG6H
#pragma config WRTC = OFF       // Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
#pragma config WRTB = OFF       // Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
#pragma config WRTD = OFF       // Data EEPROM Write Protection bit (Data EEPROM not write-protected)

// CONFIG7L
#pragma config EBTR0 = OFF      // Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
#pragma config EBTR1 = OFF      // Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
#pragma config EBTR2 = OFF      // Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
#pragma config EBTR3 = OFF      // Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

// CONFIG7H
#pragma config EBTRB = OFF      // Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)

// #pragma config statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.

#include <xc.h>
#include <pic18f4520.h>


//#pragma config OSC = INTIO67    // Oscillator Selection bits
//#pragma config WDT = OFF        // Watchdog Timer Enable bit 
//#pragma config PWRT = OFF       // Power-up Enable bit
//#pragma config BOREN = ON       // Brown-out Reset Enable bit
//#pragma config PBADEN = OFF     // Watchdog Timer Enable bit 
//#pragma config LVP = OFF        // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
//#pragma config CPD = OFF        // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)

#define _XTAL_FREQ 1000000

//global count
unsigned char count = 0;

void __interrupt(high_priority) H_ISR(){
    if(INTCONbits.INT0F == 1){
        count++;
        //-45 to 0 //45 to 0
        if(count % 4 == 1 || count % 4 == 3){
        CCPR1L = 0x0b;
        CCP1CONbits.DC1B = 0b01;
        }
        //0 to 45 >> 1925us
        if(count % 4 == 2){
        CCPR1L = 0x0f;
        CCP1CONbits.DC1B = 0b01;
        }
        //0 to -45 >> 975us
        if(count % 4 == 0){
        CCPR1L = 0x07;
        CCP1CONbits.DC1B = 0b01;
        }
    INTCONbits.INT0F = 0;   //clear external interrupt flag
    }  
}

void main(void)
{
    ADCON1 = 0x0f;
    
    // Timer2 -> On, prescaler -> 4
    T2CONbits.TMR2ON = 0b1;
    T2CONbits.T2CKPS = 0b01;

    // Internal Oscillator Frequency, Fosc = 125 kHz, Tosc = 8 �s
    OSCCONbits.IRCF = 0b001;
    
    // select PWM mode
    CCP1CONbits.CCP1M = 0b1100;
    
    //button/RB0 -> input
    TRISBbits.RB0 = 1;
    PORTB = 0;  //clear port b
    
    // CCP1/RC2 -> Output
    TRISC = 0;
    LATC = 0;
    
    RCONbits.IPEN = 0;
    //enable global interrupt,external interrupt, clear the external interrupt flag
    INTCONbits.INT0E = 1;
    INTCONbits.INT0F = 0;
    INTCONbits.GIE = 1;
    // Set up PR2, CCP to decide PWM period and Duty Cycle
    /** 
     * PWM period
     * = (PR2 + 1) * 4 * Tosc * (TMR2 prescaler)
     * = (0x9b + 1) * 4 * 8�s * 4
     * = 0.019968s ~= 20ms
     */
    PR2 = 0x9b;
    //initial -45 degree
    CCPR1L = 0x07;
    CCP1CONbits.DC1B = 0b01;
    //wait in an infinite loop for an interrupt to occur
    while(1);
    /**
     * Duty cycle
     * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
     * = (0x0b*4 + 0b01) * 8�s * 4
     * = 0.00144s ~= 1450�s
     */
          //  CCPR1L = 0x0b;
        //CCP1CONbits.DC1B = 0b01;
    //}
        //count++;
    //}
    return;
}
