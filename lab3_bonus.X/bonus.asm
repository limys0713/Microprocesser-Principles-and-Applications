List p=18f4520
    #include<p18f4520.inc>  
	CONFIG OSC = INTIO67	
	CONFIG WDT = OFF
	org 0x00 
	
	;set values
	MOVLW 0x03
	MOVWF TRISA
	MOVWF 0x00
	MOVLW 0x0F
	MOVWF TRISB
	MOVWF 0x01
	
	;set result = 0
	MOVLW 0x00
	MOVWF TRISC
	;1st add
	MOVF 0x00, W   ;move multiplicand into wreg
	BTFSC 0x01, 0	;if multiplier lsb is 1, then undergo addition
	ADDWF TRISC, F
	RRNCF 0x01, F
	BCF 0x01, 7
	RLNCF 0x00, F
	BCF 0x00, 0
	
	;2nd 
	MOVF 0x00, W   ;move multiplicand into wreg
	BTFSC 0x01, 0	;if multiplier lsb is 1, then undergo addition
	ADDWF TRISC, F
	RRNCF 0x01, F
	BCF 0x01, 7
	RLNCF 0x00, F
	BCF 0x00, 0
	
	;3rd
	MOVF 0x00, W   ;move multiplicand into wreg
	BTFSC 0x01, 0	;if multiplier lsb is 1, then undergo addition
	ADDWF TRISC, F
	RRNCF 0x01, F
	BCF 0x01, 7
	RLNCF 0x00, F
	BCF 0x00, 0
	
	;4th 
	MOVF 0x00, W   ;move multiplicand into wreg
	BTFSC 0x01, 0	;if multiplier lsb is 1, then undergo addition
	ADDWF TRISC, F
	RRNCF 0x01, F
	BCF 0x01, 7
	RLNCF 0x00, F
	BCF 0x00, 0
	
	end


