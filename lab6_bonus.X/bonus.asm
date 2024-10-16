LIST p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67 ; 1 MHZ
    CONFIG WDT = OFF
    CONFIG LVP = OFF

    L1	EQU 0x14
    L2	EQU 0x15
    org 0x00
	
; Total_cycles = 2 + (2 + 7 * num1 + 2) * num2 cycles
; num1 = 200, num2 = 180, Total_cycles = 252360
; Total_delay ~= Total_cycles/1M = 0.25s
DELAY macro num1, num2 
    local LOOP1         ; innerloop
    local LOOP2         ; outerloop
    MOVLW num2          ; 2 cycles
    MOVWF L2
    LOOP2:
	MOVLW num1          ; 2 cycles
	MOVWF L1
    LOOP1:
	NOP                 ; 7 cycles
	NOP
	NOP
	NOP
	NOP
	NOP
	DECFSZ L1, 1
	BRA LOOP1
	DECFSZ L2, 1        ; 2 cycles
	BRA LOOP2
endm

	
start:
int:
; let pin can receive digital signal   
MOVLW 0x0f
MOVWF ADCON1            ;set digital IO
CLRF PORTB
BSF TRISB, 0            ;set RB0 as input TRISB = 0000 0001
CLRF LATA
BCF TRISA, 0            ;set RA0 as output TRISA = 0000 0000
BCF TRISA, 1 
BCF TRISA, 2
BCF TRISA, 3
    
loopcheck:
   BTFSC PORTB, 0
   GOTO loopcheck 
   DELAY d'200', d'180'
   
;loop
loop:
MOVLW 0x00
MOVWF 0x00  ;count state 1 at 0x00
MOVWF 0x01  ;count state 2 at 0x01
   
;state 1
check_process:          
   BTFSS PORTB, 0
   GOTO check_process2
   
   firstloop:
    BTFSS PORTB, 0
    GOTO check_process2
    MOVLW 0x00
    CPFSEQ 0x00 ;if same, then skip, means is the first time of the loop
    GOTO light1
    
    ;light1(first)
    BTG LATA, 0
    INCF 0x00
    DELAY d'250', d'250' ;delay 0.5s
    BTFSS PORTB, 0
    GOTO check_process2
    GOTO first_cont
    
    light1:
    ;light1(cont)
    BTG LATA, 3
    BTG LATA, 0
    DELAY d'250', d'250' ;delay 0.5s
    BTFSS PORTB, 0
    GOTO check_process2
    
    first_cont:
   ;light2
    BTG LATA, 0
    BTG LATA, 1
    DELAY d'250', d'250' ;delay 0.5s
    BTFSS PORTB, 0
    GOTO check_process2
    
   ;light3
    BTG LATA, 1
    BTG LATA, 2
    DELAY d'250', d'250' ;delay 0.5s
    BTFSS PORTB, 0
    GOTO check_process2
    
   ;light4   
    BTG LATA, 2
    BTG LATA, 3
    DELAY d'250', d'250' ;delay 0.5s
    BTFSS PORTB, 0
    GOTO check_process2
    
    GOTO firstloop

; state 2
check_process2:    
   BCF LATA, 0
   BCF LATA, 1
   BCF LATA, 2
   BCF LATA, 3
   DELAY d'200', d'180'
   BTFSS PORTB, 0
   GOTO check_process3
   
   secondloop:
    BTFSS PORTB, 0
    GOTO check_process3
    MOVLW 0x00
    CPFSEQ 0x01 ;if same, then skip, means is the first time of the loop
    GOTO light1_state2
    
    ;light1(first)
    BTG LATA, 3
    INCF 0x01
    DELAY d'250', d'250' ;delay 0.5s
    BTFSS PORTB, 0
    GOTO check_process3
    GOTO first_cont1
    
    light1_state2:
    ;light1
    BTG LATA, 0
    BTG LATA, 3
    DELAY d'250', d'250' ;delay 0.5s
    BTFSS PORTB, 0
    GOTO check_process3
    
    first_cont1:
   ;light2
    BTG LATA, 2
    BTG LATA, 3
    DELAY d'250', d'250' ;delay 0.5s
    BTFSS PORTB, 0
    GOTO check_process3
    
   ;light3
    BTG LATA, 1
    BTG LATA, 2
    DELAY d'250', d'250' ;delay 0.5s
    BTFSS PORTB, 0
    GOTO check_process3
    
   ;light4   
    BTG LATA, 0
    BTG LATA, 1
    DELAY d'250', d'250' ;delay 0.5s
    BTFSS PORTB, 0
    GOTO check_process3
    
    GOTO secondloop

;initial state
check_process3:          
   ;change to initial state
   BCF LATA, 0
   BCF LATA, 1
   BCF LATA, 2
   BCF LATA, 3
   DELAY d'200', d'180'
   
   ;check button to cont to the first state
check:
   BTFSC PORTB, 0
   GOTO check
   DELAY d'200', d'180'
   
   GOTO loop
end


