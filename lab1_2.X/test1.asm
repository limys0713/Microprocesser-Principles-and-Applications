List p=18f4520
    #include<p18f4520.inc>  
	CONFIG OSC = INTIO67	
	CONFIG WDT = OFF
	org 0x00  
	
	MOVLW b'00001010'
	MOVWF 0x00
	MOVWF 0x01  ;one use in comparison
	MOVLW 0x10
	MOVWF 0x02
	
	loop:
	BTFSS 0x00, 0	;check the specific bit of f, if = 1, skip the next line ;check whether it is even number = 0 > even
	GOTO increase ; +2
	cont:
	DECF 0x02 ;-1
	RRNCF 0x00 ;right rotate
	MOVF 0x01, W	;move from f to WREG
	CPFSEQ 0x00 ;compare 0x01 with 0x00
	GOTO loop
	GOTO finish ;end
	
	increase:
	INCF 0x02   ;+1
	INCF 0x02   ;+1
	GOTO cont
	
	finish:
    
	end

