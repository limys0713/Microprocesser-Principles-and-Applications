List p=18f4520
    #include<p18f4520.inc>  
	CONFIG OSC = INTIO67	
	CONFIG WDT = OFF
	org 0x00 
	
	;initialize
	Load macro value, address
	    MOVLW value
	    MOVWF address
	endm
	Load 0x25, 0x10
	Load 0x1F, 0x11
	Load 0x1D, 0x12
	Load 0x30, 0x13
	Load 0x04, 0x20
	Load 0x03, 0x21
	Load 0x02, 0x22
	Load 0x01, 0x23
	Load 0x04, 0x30	;used to count
	Load 0x02, 0x32	;used to maintain the mul of row of matrix a
	Load 0x00, 0x33	;used to maintain the mul function
	Load 0x01, 0x34	;used to maintain the col of matrix b	;+ 1 address
	Load 0x02, 0x35	;used to maintain the col of matrix b	;- 1 address
	LFSR 0,0x010	;point at the matrix a
	LFSR 1,0x020	;point at the matrix b
	LFSR 2,0x000	;point at the address that used to save the ans
	
	rcall multiply
	GOTO cont
	
	multiply:
	    MOVF INDF0, W   ;save specfic value from matrix a in wreg
	    MULWF INDF1  ;mul with specfic value from matrix b
	    MOVFF PRODL, 0x31	;0x31 used to save the result of the first mul temporarily
	    INCF FSR0L ;address of matrix a + 1
	    INCF FSR1L ;address of matrix b + 2
	    INCF FSR1L
	    MOVF INDF0, W   ;save specfic value from matrix a in wreg
	    MULWF INDF1  ;mul with specfic value from matrix b
	    MOVF PRODL, W   ;move the second mul result to wreg
	    ADDWF 0x31, W   ;the result of addition from 0x31 and upper line
	    MOVWF INDF2	    ;move the result to matrix c
	    INCF FSR2L	;address of matrix c + 1
	    DECF FSR0L ;address of matrix a - 1
	    DECF FSR1L ;address of matrix b - 2
	    DECF FSR1L
	    DECFSZ 0x32	; to control the addtwo function
		DECF 0x33
		INCF 0x33
	    DECFSZ 0x35	;used to maintain the col of matrix b	;+1 -1 +1 ;-1
		INCF FSR1L
		DECF FSR1L
	    TSTFSZ 0x33	;skip if f = 0
		GOTO addtwo
	contfunc:
	    DECFSZ 0x34	;used to maintain the col of matrix b	;+1 -1 +1 ;+1
		DECF FSR1L
		INCF FSR1L
	    DECFSZ 0x30
	    GOTO multiply
	    RETURN
	
	addtwo:
	    INCF FSR0L
	    INCF FSR0L
	    Load 0x02, 0x32 ;load 2 into 0x32
	    Load 0x00, 0x33 ;load 0 into 0x33
	    Load 0x02, 0x34 ;load 2 into 0x34
	    Load 0x02, 0x35 ;load 2 into 0x35
	    GOTO contfunc
	    
	cont:
	end
	


