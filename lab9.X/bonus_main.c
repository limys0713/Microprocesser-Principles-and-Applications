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
    int value = (ADRESH * 256) + ADRESL;
    //unsigned char final_value =  ADRESL;
    //do things
    //1024(0~1023)/16 = 
    //1: 
    if(0 <= value && value <= 63){  
        //0us
        CCPR1L = 0x00;  //0
        CCP1CONbits.DC1B = 0b00;    //0
    }
    //1: 64~127
    else if(64 <= value && value <= 127){
        //160us
        CCPR1L = 0x01;  //1 >> 4
        CCP1CONbits.DC1B = 0b01;    //1
    }
    //2: 128~191
    else if(128 <= value && value <= 191){
        //320us
        CCPR1L = 0x02;  //2 >> 8
        CCP1CONbits.DC1B = 0b10;    //2
    }
    //3: 192~255
    else if(192 <= value && value <= 255){
        //480us
        CCPR1L = 0x03;  //3 >> 12
        CCP1CONbits.DC1B = 0b11;    //3
    }
    //4: 256~319
    else if(256 <= value && value <= 319){
        //640us
        CCPR1L = 0x05;  //5 >> 20
        CCP1CONbits.DC1B = 0b00;    //0
    }
    //5: 320~383
    else if(320 <= value && value <= 383){
        //800us
        CCPR1L = 0x6;  //6 >> 24
        CCP1CONbits.DC1B = 0b01;    //1
    }
    //6: 384~447
    else if(384 <= value && value <= 447){
        //960us
        CCPR1L = 0x07;  //7 >> 28
        CCP1CONbits.DC1B = 0b10;    //2
    }
    //7: 448~511
    else if(448 <= value && value <= 511){
        //1120us
        CCPR1L = 0x08;  //8 >> 32
        CCP1CONbits.DC1B = 0b11;    //3
    }
    //8: 512~575
    else if(512 <= value && value <= 575){
        //1280us
        CCPR1L = 0x0a;  //10 >> 40
        CCP1CONbits.DC1B = 0b00;    //0
    }
    //9: 576~639
    else if(576 <= value && value <= 639){
        //1440us
        CCPR1L = 0x0b;  //11 >> 44
        CCP1CONbits.DC1B = 0b01;    //1
    }
    //10: 640~703
    else if(640 <= value && value <= 703){
        //1600us
        CCPR1L = 0x0c;  //12 >> 48
        CCP1CONbits.DC1B = 0b10;    //2
    }
    //11: 704~767
    else if(704 <= value && value <= 767){
        //1760us
        CCPR1L = 0x0d;  //13 >> 52
        CCP1CONbits.DC1B = 0b11;    //3
    }
    //12: 768~831
    else if(768 <= value && value <= 831){
        //1920us
        CCPR1L = 0x0e;  //15 >> 60
        CCP1CONbits.DC1B = 0b00;    //0
    }
    //13: 832~895
    else if(832 <= value && value <= 895){
        //2080us
        CCPR1L = 0x10;  //16 >> 64
        CCP1CONbits.DC1B = 0b01;    //1
    }
    //14: 896~959
    else if(896 <= value && value <= 959){
        //2240us
        CCPR1L = 0x11;  //17 >> 68
        CCP1CONbits.DC1B = 0b10;    //2
    }
    //15: 960~1023
    else if(960 <= value && value <= 1023){
        //2400us
        CCPR1L = 0x12;  //18 >> 72
        CCP1CONbits.DC1B = 0b11;    //3
    }
    
    //LATCbits.LC0 = 0;
    //LATCbits.LC1 = 1;
    //LATCbits.LC2 = 0;
    //LATCbits.LC3 = 0;
     
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
     // Timer2 -> On, prescaler -> 4
    T2CONbits.TMR2ON = 0b1;
    T2CONbits.T2CKPS = 0b01; //1x:prescaler -> 16
    //configure OSC and port
    // Internal Oscillator Frequency, Fosc = 125 kHz, Tosc = 8 탎
    OSCCONbits.IRCF = 0b001; //4MHz *** homework requirement    //Tosc = 0.25 us
    // PWM mode, P1A, P1C active-high; P1B, P1D active-high
    CCP1CONbits.CCP1M = 0b1100;
    //variable resistor /RA0 -> input
    TRISAbits.RA0 = 1;
    PORTA = 0;  //clear port a
     // CCP1/RC2 -> Output
    //TRISCbits.RC0 = 0;
    //TRISCbits.RC1 = 0;
    TRISCbits.RC2 = 0;
    //TRISCbits.RC3 = 0;
    LATC = 0;
    
    RCONbits.IPEN = 0;
    //enable global interrupt,external interrupt, clear the external interrupt flag
    //INTCONbits.INT0E = 1;
    //INTCONbits.INT0F = 0;
    INTCONbits.GIE = 1;
    // Set up PR2, CCP to decide PWM period and Duty Cycle
    /** 
     * PWM period
     * = (PR2 + 1) * 4 * Tosc * (TMR2 prescaler)
     * = (0x9b + 1) * 4 * 8탎 * 4
     * = 0.019968s ~= 20ms
     */
    PR2 = 0x9b;
    /**
     * Duty cycle
     * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
     * = (0x0b*4 + 0b01) * 8탎 * 4
     * = 0.00144s ~= 1450탎
     */
    //500us
    CCPR1L = 0x00;  //0
    CCP1CONbits.DC1B = 0b00;    //0
    //step1
    ADCON1bits.VCFG0 = 0;
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110; //AN0 ?analog input,???? digital //what is AN0 indicate for//***
    ADCON0bits.CHS = 0b0000;  //AN0 ?? analog input                                       //***
    ADCON2bits.ADCS = 0b000;  //????100(2.86Mhz < 4Mhz < 5.71Mhz)
    ADCON2bits.ACQT = 0b001;  //Tad = 16 us acquisition time?4Tad = 32 > 2.4
    ADCON0bits.ADON = 1;
    ADCON2bits.ADFM = 1;    //right justified //10-bit resolution //*** homework requirement
    
    
    //step2
    PIE1bits.ADIE = 1;  //A/D interrupt
    PIR1bits.ADIF = 0;  //Clear A/D interrupt flag bit
    INTCONbits.PEIE = 1;    //Enable peripheral interrupt
    //INTCONbits.GIE = 1;     //Set GIE bit


    //step3
    ADCON0bits.GO = 1;  //A/D conversion in progress
    
    while(1);
    
    return;
}
