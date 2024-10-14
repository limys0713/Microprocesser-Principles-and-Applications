List p=18f4520
    #include<p18f4520.inc>  
	CONFIG OSC = INTIO67	
	CONFIG WDT = OFF
	org 0x00 
	
	;set values
	LFSR 0,0x100	
	LFSR 1,0x101	
	LFSR 2,0x102	
	MOVLW 0x38	
	MOVWF INDF0
	MOVLW 0x23
	MOVWF INDF1
	MOVLW 0x00
	MOVWF INDF2
	LFSR 0,0x103	
	LFSR 1,0x104	
	LFSR 2,0x105	
	MOVLW 0x72	
	MOVWF INDF0
	MOVLW 0x98
	MOVWF INDF1
	MOVLW 0x11
	MOVWF INDF2
	
	LFSR 0,0x100	
	LFSR 1,0x100	;ptr on sort	
	LFSR 2,0x105
	
	loop:
	
	;innerloop1
	MOVF FSR0L, W ;move from fsr0 to wreg
	MOVWF 0x00  ;left (in file reg)	;using file reg to count
	MOVF FSR2L, W ;move from fsr2 to wreg
	MOVWF 0x01  ;right (in file reg)
	CPFSEQ 0x00	;check whether FSR0 is equal to FSR2 at this moment
	GOTO innerloop1	
	GOTO finish
	innerloop1:
	MOVF INDF1, W	;move the ptr value into wreg and check whether it is larger than the right value
	DECF INDF1  ;value of ptr1 - 1		
	INCF POSTINC1 ;value of ptr1 + 1, FSR1 + 1(ptr)
	CPFSGT INDF1 ;F > WREG (if right > left), then skip
	GOTO exchangeloop1
	GOTO cont1
	
	exchangeloop1:
	MOVFF INDF1, 0x11	;move the ptr value into 0x10(temp reg for right)
	DECF INDF1  ;value of ptr1 - 1		
	INCF POSTDEC1 ;value of ptr1 + 1, FSR1 + 1(ptr)
	MOVFF INDF1, 0x10	;move the ptr value into 0x11(temp reg for left)
	MOVFF 0x11, INDF1	;move the right value into left block
	DECF INDF1  ;value of ptr1 - 1		
	INCF POSTINC1 ;value of ptr1 + 1, FSR1 - 1(ptr)	;forward to right
	MOVFF 0x10, INDF1	;move the left value into right block
	
	cont1:
	INCF 0x00   ;0x00 + 1 (left + 1)
	MOVF 0x00, W ;move from 0x00(left) to wreg
	CPFSEQ 0x01	;compare with right(0x01), if =, then skip next line
	GOTO innerloop1
	DECF FSR2L  ;value of ptr2 - 1		>> right--
	DECF FSR1L  ;value of ptr1 - 1		>> ptr1 - 1 (cuz the value of the most right block is the correct answer alrd and so on)
	
	;innerloop2
	MOVF FSR0L, W ;move from fsr0 to wreg
	MOVWF 0x00  ;left (in file reg)	;using file reg to count
	MOVF FSR2L, W ;move from fsr2 to wreg
	MOVWF 0x01  ;right (in file reg)
	CPFSEQ 0x00 ;check whether FSR0 is equal to FSR2 at this moment
	GOTO innerloop2
	GOTO finish
	innerloop2:
	MOVF INDF1, W	;move the ptr value into wreg and check whether it is larger than the right value
	DECF INDF1  ;value of ptr1 - 1		
	INCF POSTDEC1 ;value of ptr1 + 1, FSR1 - 1(ptr)
	CPFSLT INDF1 ;F < WREG (if right > left), then skip
	GOTO exchangeloop2
	GOTO cont2
	
	exchangeloop2:
	MOVFF INDF1, 0x10	;move the ptr value into 0x10(temp reg for left)
	DECF INDF1  ;value of ptr1 - 1		
	INCF POSTINC1 ;value of ptr1 + 1, FSR1 + 1(ptr)
	MOVFF INDF1, 0x11	;move the ptr value into 0x11(temp reg for right)
	MOVFF 0x10, INDF1	;move the left value into right block
	DECF INDF1  ;value of ptr1 - 1		
	INCF POSTDEC1 ;value of ptr1 + 1, FSR1 - 1(ptr)	;back to left
	MOVFF 0x11, INDF1	;move the right value into left block
	
	cont2:
	DECF 0x01   ;0x01 - 1 (right - 1)
	MOVF 0x01, W ;move from 0x01(right) to wreg
	CPFSEQ 0x00	;compare with right(0x01), if =, then skip next line
	GOTO innerloop2
	INCF FSR0L  ;value of ptr0 - 1		>> left++
	INCF FSR1L  ;value of ptr1 + 1	    >> ptr1 - 1 (cuz the value of the most left block is the correct answer alrd and so on)
	
	MOVF FSR0L, W ;move from fsr2 to wreg
	CPFSEQ FSR2L	;compare with FSR2, if =, then skip next line
	GOTO loop
	
	finish:
    
	;save in the specific reg(0x110~0x115)
	LFSR 0, 0x100
	LFSR 1, 0x110
	MOVLW 0x06  ;use to count
	MOVWF 0x21
	translocateloop:
	MOVFF INDF0, INDF1
	INCF FSR0L
	INCF FSR1L
	DECFSZ 0x21
	GOTO translocateloop
	
	end


