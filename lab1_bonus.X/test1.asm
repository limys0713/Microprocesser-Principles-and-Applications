List p=18f4520
    #include<p18f4520.inc>  
	CONFIG OSC = INTIO67	
	CONFIG WDT = OFF
	org 0x00 
	

	MOVLW b'11111111'
	MOVWF 0x00
	MOVWF 0x01

	RRNCF WREG  ;right rotate WREG
	BCF WREG, 7 ;clear the MSB bit
	COMF 0x01, F	;xor action
	ANDWF 0x01, F
	COMF WREG, W
	ANDWF 0x00, W
	IORWF 0x01, F
	
	
	end


