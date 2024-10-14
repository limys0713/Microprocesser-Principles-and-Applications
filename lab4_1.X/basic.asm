List p=18f4520
    #include<p18f4520.inc>  
	CONFIG OSC = INTIO67	
	CONFIG WDT = OFF
	org 0x00 
	
	Add_Mul macro xh, xl, yh, yl
	    ;addition 
	    MOVLW yh
	    MOVWF 0x20
	    MOVLW yl
	    MOVWF 0x21
	    MOVLW xh	;save xh in wreg
	    ADDWF 0x20, W  ;addition with yh and save the result in wreg
	    MOVWF 0x00	;move the result to 0x00
	    MOVLW xl	;save xl in wreg
	    ADDWF 0x21, W  ;addition with yl and save the result in wreg
	
	    BC overflow ;check overflow
	    GOTO cont
	
	    overflow:
	    INCF 0x00	;high + 1   
	
	    cont:
	    MOVWF 0x01	;save low 
	    
	    ;signed mul
	    MOVF 0x00, W
	    MULWF 0x01, W  ;mul
	    MOVF 0x01, W    ;check negative op1
	    BTFSC 0x00, 7   ;if op1 < 0
		SUBWF PRODH ;PRODH = PRODH - op2
	    MOVF 0x00, W    ;check negative op2
	    BTFSC 0x01, 7   ; if op2 < 0
		SUBWF PRODH ;PRODH = PRODH - op1
	    MOVFF PRODH, 0x10
	    MOVFF PRODL, 0x11
	    endm
	
	Add_Mul 0xFF, 0xBA, 0xFF, 0xDD
	
	end


