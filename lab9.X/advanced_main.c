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

#include <pic18f4520.h>
#include <xc.h>
#include<stdio.h>
#include<stdlib.h>
#include <time.h>

#define _XTAL_FREQ 1000000

void __interrupt(high_priority)H_ISR(){
    
    //step4 //10 bits resolution:ADRESH last two bits, ADRESL 8 bits
    //int value_low = ADRESL;
    //int value_high = ADRESH;
    
    int final_value = (ADRESH * 256) + ADRESL;
    //do things
    //1024(0~1023)/8 = 128
    //2: 0~127
    if(0 <= final_value && final_value <= 127){  
       LATCbits.LC0 = 0;
       LATCbits.LC1 = 1;
       LATCbits.LC2 = 0;
       LATCbits.LC3 = 0;
    }
    //4: 128~255
    else if(128 <= final_value && final_value <= 255){
        LATCbits.LC0 = 0;
        LATCbits.LC1 = 0;
        LATCbits.LC2 = 1;
        LATCbits.LC3 = 0;
    }
    //1: 256~383
    else if(256 <= final_value && final_value <= 383){
        LATCbits.LC0 = 1;
        LATCbits.LC1 = 0;
        LATCbits.LC2 = 0; 
        LATCbits.LC3 = 0;
    }
    //0: 384~511
    else if(384 <= final_value && final_value <= 511){
        LATCbits.LC0 = 0;
        LATCbits.LC1 = 0;
        LATCbits.LC2 = 0; 
        LATCbits.LC3 = 0;
    }
    //5: 512~639
    else if(512 <= final_value && final_value <= 639){
        LATCbits.LC0 = 1;
        LATCbits.LC1 = 0;
        LATCbits.LC2 = 1;
        LATCbits.LC3 = 0;
    }
    //0: 640~767
    else if(640 <= final_value && final_value <= 767){
        LATCbits.LC0 = 0;
        LATCbits.LC1 = 0;
        LATCbits.LC2 = 0; 
        LATCbits.LC3 = 0;
    }
    //3: 768~895
    else if(768 <= final_value && final_value <= 895){
        LATCbits.LC0 = 1;
        LATCbits.LC1 = 1;
        LATCbits.LC2 = 0;
        LATCbits.LC3 = 0;
    }
    //8: 896~1023
    else{
        LATCbits.LC0 = 0;
        LATCbits.LC1 = 0;
        LATCbits.LC2 = 0;
        LATCbits.LC3 = 1;
    }
    //
    
    //LATCbits.LC0 = 0;
       // LATCbits.LC1 = 1;
       // LATCbits.LC2 = 0;
       // LATCbits.LC3 = 0;
     
    //clear flag bit
    PIR1bits.ADIF = 0;  //Clear ADC interrupt flag bit (PIR1.ADIF)
    
    
    //step5 & go back step3
    /*
    delay at least 2tad
     * __delay_ms(10);
    ADCON0bits.GO = 1;
    */
    //__delay_ms(10);
    __delay_us(4);
    ADCON0bits.GO = 1;
    
    return;
}

void main(void) 
{
    //configure OSC and port
    OSCCONbits.IRCF = 0b110; //4MHz *** homework requirement
    //variable resistor /RA0 -> input
    TRISAbits.RA0 = 1;
    //PORTA = 0;  //clear port a
     // RC0/RC1/RC2/RC3 -> Output
    TRISC = 0;  //whole = 0
    LATC = 0;
    
    //step1
    ADCON1bits.VCFG0 = 0;
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110; //AN0 ?analog input,???? digital //what is AN0 indicate for//***
    ADCON0bits.CHS = 0b0000;  //AN0 ?? analog input                                       //***
    ADCON2bits.ADCS = 0b100;  //????100(2.86Mhz < 4Mhz < 5.71Mhz)
    ADCON2bits.ACQT = 0b010;  //Tad = 1 us acquisition time?4Tad = 4 > 2.4
    ADCON0bits.ADON = 1;
    ADCON2bits.ADFM = 1;    //right justified //10-bit resolution //*** homework requirement
    
    
    //step2
    PIE1bits.ADIE = 1;  //A/D interrupt
    PIR1bits.ADIF = 0;  //Clear A/D interrupt flag bit
    INTCONbits.PEIE = 1;    //Enable peripheral interrupt
    INTCONbits.GIE = 1;     //Set GIE bit


    //step3
    ADCON0bits.GO = 1;  //A/D conversion in progress
    
    while(1);
    
    return;
}
