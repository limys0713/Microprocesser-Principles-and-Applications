#include "p18f4520.inc"

; CONFIG1H
  CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown Out Reset Voltage bits (Minimum setting)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)

    org 0x00
    
goto Initial			    
ISR:				
    org 0x08                
    
    ;timer interrupt
    BTFSC PIR1, TMR2IF
    GOTO timer_interrupt
    
    ;button interrupt
    BTFSC INTCON, INT0IF
    GOTO button_interrupt
    
    cont:
    BCF PIR1, TMR2IF        ; ??????TMR2IF?? (??flag bit)
    BCF INTCON, INT0IF	    ;interrupt flag bits = 0 after finish handling interrupt
    RETFIE
    
timer_interrupt:
    ;forward or backward state
    BTFSC 0x02, 0   ;skip if even
    GOTO state1
    GOTO state2
    
button_interrupt:
    INCF 0x00 ;increase counter
    ;counter = 1    ;timestate1	0.25s
    MOVLW 0x01
    CPFSEQ 0x00
    GOTO contISR1
    GOTO timestate1
    
    ;counter = 2    ;timestate2 0.5s
    contISR1:
    MOVLW 0x02
    CPFSEQ 0x00
    GOTO contISR2
    GOTO timestate2
    
    ;counter = 3    ;timestate3 1s
    contISR2:
    MOVLW 0x03
    CPFSEQ 0x00
    GOTO cont
    GOTO timestate3
    
    
timestate1:	;change from 0.25 to 0.5s delay
    INCF 0x02
    MOVLW D'122'	;0.5s delay	
    MOVWF PR2
    GOTO cont
    
timestate2:	;change from 0.5 to 1s delay
    INCF 0x02
    MOVLW D'244'	;1s delay	
    MOVWF PR2
    GOTO cont

timestate3: ;change from 1s to 0.25s delay
    INCF 0x02
    MOVLW D'61'	;0.25s delay	
    MOVWF PR2
    MOVLW 0x00		;reset counter 0x00
    MOVWF 0x00		;counter for checking the state
    GOTO cont
 
state1:	;forward
    INCF 0x01
    ;check if it is 1
    BTFSC 0x01, 0
    BSF LATA, 3
    BTFSC 0x01, 1
    BSF LATA, 2
    BTFSC 0x01, 2
    BSF LATA, 1
    BTFSC 0x01, 3
    BSF LATA, 0
    ;check if it is 0
    BTFSS 0x01, 0
    BCF LATA, 3
    BTFSS 0x01, 1
    BCF LATA, 2
    BTFSS 0x01, 2
    BCF LATA, 1
    BTFSS 0x01, 3
    BCF LATA, 0
	GOTO cont
    
state2:	;backward
    DECF 0x01
    ;check if it is 1
    BTFSC 0x01, 0
    BSF LATA, 3
    BTFSC 0x01, 1
    BSF LATA, 2
    BTFSC 0x01, 2
    BSF LATA, 1
    BTFSC 0x01, 3
    BSF LATA, 0
    ;check if it is 0
    BTFSS 0x01, 0
    BCF LATA, 3
    BTFSS 0x01, 1
    BCF LATA, 2
    BTFSS 0x01, 2
    BCF LATA, 1
    BTFSS 0x01, 3
    BCF LATA, 0
	GOTO cont
    
Initial:			
    MOVLW 0x0F
    MOVWF ADCON1
    CLRF TRISA
    CLRF LATA
    BSF TRISB,  0	;set the sw as input
    BSF RCON, IPEN
    BCF INTCON, INT0IF	;clear interrupt flag bit
    BSF INTCON, GIE
    BSF INTCON, INT0IE	;open the interrupt0 enable bit
    BCF PIR1, TMR2IF		; ????TIMER2??????????TMR2IF?TMR2IE?TMR2IP?
    BSF IPR1, TMR2IP
    BSF PIE1 , TMR2IE
    MOVLW b'11111111'	        ; ?Prescale?Postscale???1:16???????256??????TIMER2+1
    MOVWF T2CON		; ???TIMER?????????/4????????
    MOVLW D'61'		; ???256 * 4 = 1024?cycles???TIMER2 + 1
    MOVWF PR2			; ??????250khz???Delay 0.5?????????125000cycles??????Interrupt
				; ??PR2??? 125000 / 1024 = 122.0703125? ???122?
    ;244 >> delay 1 second
    ;initial: 62 >> delay 0.25 second
    
    MOVLW D'00100000'
    MOVWF OSCCON	        ;250kHz
    
    MOVLW 0x00
    MOVWF 0x00		;counter for checking the state
    MOVWF 0x01		;counter use in state
    MOVLW 0x01		;counter use in helping the output light
    MOVWF 0x02		;counter use in check whether which state is it for now(forward or backward)
    
main:		
    bra main	    

    
end



