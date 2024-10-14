List p=18f4520
    #include<p18f4520.inc>  
	CONFIG OSC = INTIO67	
	CONFIG WDT = OFF
	org 0x00 
	
	MOVLW b'11110000'
	MOVWF TRISA
	
	;arithmetic shift ;msb does not change
	RRCF TRISA, F	;rotate
	BTFSC TRISA, 6	;check if the seventh bit(before rotate, it is msb) is 0 or 1, if is 0 >> skip, 1 >> set the signed bit as 1
	BSF TRISA, 7
	BTFSS TRISA, 6 ;check if the seventh bit(before rotate, it is msb) is 0 or 1, if is 1 >> skip, 0 >> set the signed bit as 0
	BCF TRISA, 7
	
	;logical shift ;true shift, fill 0
	RRNCF TRISA, F
	BCF TRISA, 7
	
	end


