List p=18f4520
    #include<p18f4520.inc>  
	CONFIG OSC = INTIO67	
	CONFIG WDT = OFF
	org 0x00 

	MOVLW 0x07  ;used to count
	MOVWF 0x01
	
	LFSR 0,0x100	;FSR0 point to 0x100
	LFSR 1,0x101	;FSR1 point to 0x101
	LFSR 2,0x101	;use in checking whether it is even or odd
	MOVLW 0x15  
	MOVWF INDF0
	MOVLW 0x12
	MOVWF INDF1
	MOVWF INDF2
	
	
	loop:
	DECF INDF2  ;value of ptr2 - 1
	INCF POSTINC2 ;FSR2(value + 1) & (address + 1)(ptr)
	BTFSS FSR2L, 0	;check the specific bit of f, if = 1, skip the next line ;check whether it is even number = 0 > even
	GOTO even
	
	;undergo event of odd number ;subtraction of the values from the previous address
	MOVF INDF0, W	;move from file to wreg 
	SUBWF INDF1, W	;subtraction: FSR1-FSR0(WREG) and store at wreg temporarily and store in FSR1
	MOVWF INDF2	;move the answer from wreg to specific f
	DECF INDF0  ;value of ptr1 - 1
	INCF POSTINC0 ;FSR1 + 1(ptr)
	DECF INDF1  ;value of ptr0 - 1
	INCF POSTINC1 ;FSR0 + 1(ptr)
	GOTO cont
	
	;undergo event of even number ;sum of the values from previous address
	even:
	MOVF INDF0, W	;move from file to wreg
	ADDWF INDF1, W	;addition of WREG and FSR1 and store in FSR1
	MOVWF INDF2	;move the answer from wreg to specific f
	DECF INDF0  ;value of ptr1 - 1
	INCF POSTINC0 ;FSR1 + 1(ptr)
	DECF INDF1  ;value of ptr0 - 1
	INCF POSTINC1 ;FSR0 + 1(ptr)
	
	cont:
	DECFSZ 0x01 ;check if 0x01 = 0
	GOTO loop

	end