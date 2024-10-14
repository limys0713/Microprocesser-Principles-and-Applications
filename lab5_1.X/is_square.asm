#include"xc.inc"
GLOBAL _is_square
    
PSECT mytext, local, class=CODE, reloc=2
 
_is_square:
    MOVWF 0x00	;move the input to 0x00
    
    MOVLW 0x01	;use to count for checking
    MOVWF 0x10
    
    ;loop checking
    loop:
	MOVF 0x10, W	;move the value of count into wreg
	MULWF 0x10	;use to cal the square of the count value
	MOVFF PRODL, 0x20   ;square ans move to 0x20 and compare with the input
	MOVF 0x20, W	;move the comparing value into wreg
	INCF 0x10	;increase the count
	
	CPFSLT 0x00	;comparing the value with input
	GOTO checkequal
	GOTO no_squareans
	
	checkequal:
	    CPFSEQ 0x00
	    GOTO loop
	    GOTO has_squareans
	    
	no_squareans:
	    MOVLW 0xFF
	    MOVWF 0x01	;ans
	    GOTO finish
	
	has_squareans:
	    MOVLW 0x01
	    MOVWF 0x01  ;ans 
	   
    finish:
    
    RETURN


