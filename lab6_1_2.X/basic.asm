LIST p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67 ; 1 MHZ
    CONFIG WDT = OFF
    CONFIG LVP = OFF

    L1	EQU 0x14
    L2	EQU 0x15
    org 0x00
	
start:
int:
; let pin can receive digital signal 
MOVLW 0x00  ;0-4
MOVWF 0x00  ;count at 0x00   
MOVLW 0x0f
MOVWF ADCON1            ;set digital IO
CLRF PORTB
BSF TRISB, 0            ;set RB0 as input TRISB = 0000 0001
CLRF LATA
BCF TRISA, 0            ;set RA0 as output TRISA = 0000 0000
BCF TRISA, 1 
BCF TRISA, 2
BCF TRISA, 3
    
; check button
check_process:          
   BTFSC PORTB, 0
   GOTO check_process
   GOTO lightup


light1:
    BTG LATA, 0
    GOTO cont

light2:
    BTG LATA, 0
    BTG LATA, 1
    GOTO cont

light3:
    BTG LATA, 1
    BTG LATA, 2
    GOTO cont
    
light4:
    BTG LATA, 2
    BTG LATA, 3
    GOTO cont

renew:
    BTG LATA, 3
    MOVLW 0x00  ;count 0-4
    MOVWF 0x00
    GOTO check_process
    
lightup:
    MOVLW 0x00
    CPFSGT 0x00		;0 : 0 ( no skip)
    GOTO light1		;count 0, light led 0

    MOVLW 0x01
    CPFSGT 0x00		;1 : 1 ( no skip)
    GOTO light2		;count 1, light led 1, turn off led 0

    MOVLW 0x02
    CPFSGT 0x00		;2 : 2 ( no skip)
    GOTO light3		;count 2, light led 2, turn off led 1

    MOVLW 0x03
    CPFSGT 0x00		;3 : 3 ( no skip)
    GOTO light4		;count 3, light led 3, turn off led 2

    MOVLW 0x04
    CPFSGT 0x00		;4 : 4 ( no skip)
    GOTO renew		;count 4, turn off led 3

    cont:
    INCF 0x00
    GOTO check_process
end



