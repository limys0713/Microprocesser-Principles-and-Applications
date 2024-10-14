List p=18f4520
    #include<p18f4520.inc>  
	CONFIG OSC = INTIO67	
	CONFIG WDT = OFF
	org 0x00 
	
	;set values
	;7408
	MOVLW 0x76	
	MOVWF 0x00
	MOVLW 0x12
	MOVWF 0x01
	;4046
	MOVLW 0x44	
	MOVWF 0x10
	MOVLW 0x93
	MOVWF 0x11
	
	;addition 
	MOVF 0x00, W	;save 0x00 in wreg
	ADDWF 0x10, W  ;addition with 0x10 and save the result in wreg
	MOVWF 0x20	;move the result to 0x20
	MOVF 0x11, W	;save 0x00 in wreg
	ADDWF 0x01, W  ;addition with 0x01 and save the result in wreg
	
	BC overflow ;check overflow ;branch if got carry
	GOTO cont
	
	overflow:
	INCF 0x20   
	
	cont:
	MOVWF 0x21  
	
	end


