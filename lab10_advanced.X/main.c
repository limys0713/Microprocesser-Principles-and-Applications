#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include "stdio.h"
#include "string.h"
#define _XTAL_FREQ 1000000
// using namespace std;

char str[20];
int state = 0;
//int print_once = 0;
/*void Mode1(){   // Todo : Mode1 
    return ;
}
void Mode2(){   // Todo : Mode2 
    return ;
}*/
void main(void) 
{
    SYSTEM_Initialize() ;
    
    //str[0] = '0';
    //UART_Write('0');
    //__delay_ms(200);
//    UART_Write(' ');
    int print_once = 0;
    while(1) {
        if(print_once == 0){
            str[0] = '0';
             __delay_ms(200);
            UART_Write(str[0]);
            //__delay_ms(200);
            print_once = 1;
        }
        //UART_Write('0');
        //strcpy(str, GetString());  //string copy(from source to dest) : strcpy(char *destination, const char *source)
        // TODO : GetString() in uart.c
       /* if(str[0]=='m' && str[1]=='1'){ // Mode 1
            Mode1();
            ClearBuffer();
        }
        else if(str[0]=='m' && str[1]=='2'){ // Mode 2
            Mode2();
            ClearBuffer();  
        }*/
      // UART_Write(str[0]);
        //__delay_ms(300);
       // if(str[1] != '\0'){
           // UART_Write(str[1]);
           // __delay_ms(300);
       // }
        //__delay_ms(200);
    }
    return;
}
 
 void __interrupt(high_priority) Hi_ISR(void)
{
    if(PIR1bits.CCP1IF == 1) {
        RC2 ^= 1;
        PIR1bits.CCP1IF = 0;
        TMR3 = 0;
    }
    return ;
}*/

void __interrupt(high_priority) H_ISR()
{
    if(INTCONbits.INT0F == 1){
            state++;
            if(state == 0){  
                LATCbits.LC0 = 0;
                LATCbits.LC1 = 0;
                LATCbits.LC2 = 0;
                LATCbits.LC3 = 0;
            }
        //1
            else if(state == 1){
                LATCbits.LC0 = 1;
                LATCbits.LC1 = 0;
                LATCbits.LC2 = 0;
                LATCbits.LC3 = 0;
                str[0] = '1';
                UART_Write(str[0]);
            }
        //2
            else if(state == 2){
                LATCbits.LC0 = 0;
                LATCbits.LC1 = 1;
                LATCbits.LC2 = 0;
                LATCbits.LC3 = 0;
                str[0] = '2';
                UART_Write(str[0]);
            }
            //3
            else if(state == 3){
                LATCbits.LC0 = 1;
                LATCbits.LC1 = 1;
                LATCbits.LC2 = 0;
                LATCbits.LC3 = 0;
                str[0] = '3';
                UART_Write(str[0]);
            }
            //4
            else if(state == 4){
                LATCbits.LC0 = 0;
                LATCbits.LC1 = 0;
                LATCbits.LC2 = 1;  
                LATCbits.LC3 = 0;
                str[0] = '4';
                UART_Write(str[0]);
            }
            //5
            else if(state == 5){
                LATCbits.LC0 = 1;
                LATCbits.LC1 = 0;
                LATCbits.LC2 = 1;
                LATCbits.LC3 = 0;
                str[0] = '5';
                UART_Write(str[0]);
            }
            //6
            else if(state == 6){
                LATCbits.LC0 = 0;
                LATCbits.LC1 = 1;
                LATCbits.LC2 = 1; 
                LATCbits.LC3 = 0;
                str[0] = '6';
                UART_Write(str[0]);
            }
            //7
            else if(state == 7){
                LATCbits.LC0 = 1;
                LATCbits.LC1 = 1;
                LATCbits.LC2 = 1; 
                LATCbits.LC3 = 0;
                str[0] = '7';
                UART_Write(str[0]);
            }
            //8
            else if(state == 8){
                LATCbits.LC0 = 0;
                LATCbits.LC1 = 0;
                LATCbits.LC2 = 0;
                LATCbits.LC3 = 1;
                str[0] = '8';
                UART_Write(str[0]);
            }
            //9
            else if(state == 9){
                LATCbits.LC0 = 1;
                LATCbits.LC1 = 0;
                LATCbits.LC2 = 0;
                LATCbits.LC3 = 1;
                str[0] = '9';
                UART_Write(str[0]);
            }
            //10
            else if(state == 10){
                LATCbits.LC0 = 0;
                LATCbits.LC1 = 1;
                LATCbits.LC2 = 0;
                LATCbits.LC3 = 1;
                str[0] = '1';
                str[1] = '0';
                UART_Write(str[0]);
                UART_Write(str[1]);
            }
            //11
            else if(state == 11){
                LATCbits.LC0 = 1;
                LATCbits.LC1 = 1;
                LATCbits.LC2 = 0;
                LATCbits.LC3 = 1;
                str[0] = '1';
                str[1] = '1';
                UART_Write(str[0]);
                UART_Write(str[1]);
            }
            //12
            else if(state == 12){
                LATCbits.LC0 = 0;
                LATCbits.LC1 = 0;
                LATCbits.LC2 = 1;
                LATCbits.LC3 = 1;
                str[0] = '1';
                str[1] = '2';
                UART_Write(str[0]);
                UART_Write(str[1]);
            }
            //13
            else if(state == 13){
                LATCbits.LC0 = 1;
                LATCbits.LC1 = 0;
                LATCbits.LC2 = 1;
                LATCbits.LC3 = 1;
                str[0] = '1';
                str[1] = '3';
                UART_Write(str[0]);
                UART_Write(str[1]);
            }
            //14
            else if(state == 14){
                LATCbits.LC0 = 0;
                LATCbits.LC1 = 1;
                LATCbits.LC2 = 1;
                LATCbits.LC3 = 1;
                str[0] = '1';
                str[1] = '4';
                UART_Write(str[0]);
                UART_Write(str[1]);
            }
            //15
            else if(state == 15){
                LATCbits.LC0 = 1;
                LATCbits.LC1 = 1;
                LATCbits.LC2 = 1;
                LATCbits.LC3 = 1;
                str[0] = '1';
                str[1] = '5';
                UART_Write(str[0]);
                UART_Write(str[1]);
            }
        INTCONbits.INT0F = 0; //clear flag bit
        //__delay_ms(300);
    }
}
