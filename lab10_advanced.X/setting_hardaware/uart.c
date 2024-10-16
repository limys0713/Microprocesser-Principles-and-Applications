#include <xc.h>
#define _XTAL_FREQ 1000000
    //setting TX/RX

char mystring[20];
int lenStr = 0;
//int state = 0;
//int delay = 0;

void UART_Initialize() {
           
    /*       TODObasic   
           Serial Setting      
        1.   Setting Baud rate
        2.   choose sync/async mode 
        3.   enable Serial port (configures RX/DT and TX/CK pins as serial port pins)
        3.5  enable Tx, Rx Interrupt(optional)
        4.   Enable Tx & RX
          */ 
    TRISCbits.RC6 = 1 ;  //TX          
    TRISCbits.RC7 = 1 ;  //RX      
    
    //  Setting baud rate
    TXSTAbits.SYNC = 0;      //asynchronous mode = 0     
    BAUDCONbits.BRG16 = 0;          
    TXSTAbits.BRGH = 0;
    SPBRG = 51;      //**** //only need to modify this
    
   //   Serial enable
    RCSTAbits.SPEN = 1;         //enable asynchronous serial port    //open once
    RCSTAbits.CREN = 1;             //will be cleared when error occured    //open once
    TXSTAbits.TXEN = 1;           //enable transmission //open once
   // PIR1bits.TXIF = 1;          //**** //flag bit  //1:txreg = blank
   // PIR1bits.RCIF = 0;              //receiver flag bit  //set when reception is complete   
    //IPR1bits.RCIP = 0;    // high priority interrupt
    //PIE1bits.RCIE = 1;      //receiver interrupt enable bit 
   // IPR1bits.TXIP = 0;      //low priority interrupt
   // PIE1bits.TXIE = 1;    //interrupt  //when this pin is on and TXIF is 1, then the interrupt is activated  
    
    //init mystring[0]
    for(int i = 0; i < 20 ; i++)
        mystring[i] = '\0';
    mystring[0] = '0';
    //int state = 0;
    }

void UART_Write(unsigned char data)  // Output on Terminal  //sender/transmitter
{
    while(!TXSTAbits.TRMT); //TRMT reg is set when TSR reg(data that gonna transferred) is empty
    TXREG = data;              //write to TXREG will send data 
}


/*void UART_Write_Text(char* text) { // Output on Terminal, limit:10 chars
    for(int i=0;text[i]!='\0';i++)
        UART_Write(text[i]);
}*/

/*void ClearBuffer(){
    for(int i = 0; i < 10 ; i++)
        mystring[i] = '\0';
    lenStr = 0;
}*/

/*void MyusartRead()  //receiver
{
     //TODObasic: try to use UART_Write to finish this function 
    mystring[lenStr] = RCREG;
    if (mystring[lenStr] == '\r')
        UART_Write('\n');
    UART_Write(mystring[lenStr]);   //write
    
    //UART_Write(RCREG);
    lenStr++;   //???
    lenStr %= 10;   //???
    
    return ;
}*/

char *GetString(){
    
    return mystring;
   
}
// void interrupt low_priority Lo_ISR(void)
/*void __interrupt(high_priority) H_ISR()
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
                mystring[0] = '1';
            }
        //2
            else if(state == 2){
                LATCbits.LC0 = 0;
                LATCbits.LC1 = 1;
                LATCbits.LC2 = 0;
                LATCbits.LC3 = 0;
                mystring[0] = '2';
            }
            //3
            else if(state == 3){
                LATCbits.LC0 = 1;
                LATCbits.LC1 = 1;
                LATCbits.LC2 = 0;
                LATCbits.LC3 = 0;
                mystring[0] = '3';
            }
            //4
            else if(state == 4){
                LATCbits.LC0 = 0;
                LATCbits.LC1 = 0;
                LATCbits.LC2 = 1;  
                LATCbits.LC3 = 0;
                mystring[0] = '4';
            }
            //5
            else if(state == 5){
                LATCbits.LC0 = 1;
                LATCbits.LC1 = 0;
                LATCbits.LC2 = 1;
                LATCbits.LC3 = 0;
                mystring[0] = '5';
            }
            //6
            else if(state == 6){
                LATCbits.LC0 = 0;
                LATCbits.LC1 = 1;
                LATCbits.LC2 = 1; 
                LATCbits.LC3 = 0;
                mystring[0] = '6';
            }
            //7
            else if(state == 7){
                LATCbits.LC0 = 1;
                LATCbits.LC1 = 1;
                LATCbits.LC2 = 1; 
                LATCbits.LC3 = 0;
                mystring[0] = '7';
            }
            //8
            else if(state == 8){
                LATCbits.LC0 = 0;
                LATCbits.LC1 = 0;
                LATCbits.LC2 = 0;
                LATCbits.LC3 = 1;
                mystring[0] = '8';
            }
            //9
            else if(state == 9){
                LATCbits.LC0 = 1;
                LATCbits.LC1 = 0;
                LATCbits.LC2 = 0;
                LATCbits.LC3 = 1;
                mystring[0] = '9';
            }
            //10
            else if(state == 10){
                LATCbits.LC0 = 0;
                LATCbits.LC1 = 1;
                LATCbits.LC2 = 0;
                LATCbits.LC3 = 1;
                mystring[0] = '1';
                mystring[1] = '0';
            }
            //11
            else if(state == 11){
                LATCbits.LC0 = 1;
                LATCbits.LC1 = 1;
                LATCbits.LC2 = 0;
                LATCbits.LC3 = 1;
                mystring[0] = '1';
                mystring[1] = '1';
            }
            //12
            else if(state == 12){
                LATCbits.LC0 = 0;
                LATCbits.LC1 = 0;
                LATCbits.LC2 = 1;
                LATCbits.LC3 = 1;
                mystring[0] = '1';
                mystring[1] = '2';
            }
            //13
            else if(state == 13){
                LATCbits.LC0 = 1;
                LATCbits.LC1 = 0;
                LATCbits.LC2 = 1;
                LATCbits.LC3 = 1;
                mystring[0] = '1';
                mystring[1] = '3';
            }
            //14
            else if(state == 14){
                LATCbits.LC0 = 0;
                LATCbits.LC1 = 1;
                LATCbits.LC2 = 1;
                LATCbits.LC3 = 1;
                mystring[0] = '1';
                mystring[1] = '4';
            }
            //15
            else if(state == 15){
                LATCbits.LC0 = 1;
                LATCbits.LC1 = 1;
                LATCbits.LC2 = 1;
                LATCbits.LC3 = 1;
                mystring[0] = '1';
                mystring[1] = '5';
            }
        INTCONbits.INT0F = 0; //clear flag bit
        __delay_ms(300);
    }
    //wprocess other interrupt sources here, if required
    return;
}*/