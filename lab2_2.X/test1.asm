List p=18f4520
    #include<p18f4520.inc>  
	CONFIG OSC = INTIO67	
	CONFIG WDT = OFF
	org 0x00 
	
	;declare 
	MOVLW 0x08  ;used to count
	MOVWF 0x20
	
	LFSR 0,0x000	
	LFSR 1,0x018	
	LFSR 2,0x001	
	MOVLW 0x05	
	MOVWF INDF0
	MOVLW 0x02
	MOVWF INDF1
	
	loop:
	MOVF INDF0, W	;move from file to wreg
	ADDWF INDF1, W	;sum FSR0 + FSR1
	MOVWF INDF2	;move the answer from wreg to specific f
	MOVF INDF1, W	;move from file to wreg
	SUBWF INDF0, W	;subtraction: FSR0-FSR1
	DECF INDF1  ;value of ptr1 - 1
	INCF POSTDEC1 ;value of ptr1 + 1, FSR1 - 1(ptr)
	MOVWF INDF1	;move the answer from wreg to specific f
	DECF INDF0  ;value of ptr0 - 1
	INCF POSTINC0 ;value of ptr0 + 1, FSR0 + 1(ptr)
	DECF INDF2  ;value of ptr2 - 1
	INCF POSTINC2 ;value of ptr2 + 1, FSR2 + 1(ptr)

	DECFSZ 0x20 ;check if 0x20 = 0
	GOTO loop
	
	end


