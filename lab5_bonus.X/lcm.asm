#include"xc.inc"
GLOBAL _lcm
    
PSECT mytext, local, class=CODE, reloc=2
 
_lcm:
    ;find hcf
    ;test which one is bigger
    MOVF 0x01, W    ;move a to wreg for comparing
    CPFSGT 0x03	    ;skip if f>wreg(b>a)
    GOTO a_is_bigger
    GOTO b_is_bigger
    
    a_is_bigger:    ;bigger put at 0x10
	MOVFF 0x01, 0x10	;a move to 0x10
	MOVFF 0x01, 0x12	;a move to 0x12(r)
	MOVFF 0x03, 0x11	;b move to 0x11
	MOVFF 0x03, 0x15	;b move to 0x11	;2nd divisor
	
    GOTO cont
    
    b_is_bigger:    ;bigger put at 0x10
	MOVFF 0x03, 0x10	;b move to 0x10
	MOVFF 0x03, 0x12	;b move to 0x12(r)
	MOVFF 0x01, 0x11	;a move to 0x11
	MOVFF 0x01, 0x15	;a move to 0x11	;2nd divisor
	;quotient at 0x13
    
    cont:
    
    hcf:
    MOVLW 0x08
    MOVWF 0x20	;use to count in divider (8 bit, so at most 8 repetition in divider)
    MOVLW 0x00
    MOVWF 0x13	;quotient = 0
   
    ;loop
    loop:
	;division	;dividend 0x10, divisor 0x11, remainder 0x12, quotient 0x13, 
	MOVF 0x11, W
	SUBWF 0x12, W   ;remainder-divisor and save it in wreg
	MOVWF 0x14	;0x14 use in temporary save the result of subtraction
	BTFSS 0x14, 7	;test if 0x14 is negative, if it is negative then sgoto remainder less than 0(skip if bit is 1)
	GOTO remainder_greatereqthan0
	GOTO remainder_lessthan0
    
	remainder_greatereqthan0:
	    MOVFF 0x14, 0x12	;change the remainder to the temp sub ans
	    RLNCF 0x13, F   ;shift quotient to left	
	    BSF 0x13, 0	    ;set the lsb to 1
	    
	GOTO cont1
    
	remainder_lessthan0:
	    RLNCF 0x13, F
	    BCF 0x13, 0    ;set the lsb to 0
    
	cont1:
	    RRNCF 0x11, F   ;shift divisor to right
	    ;BCF 0x11, 7	    ;clear msb(divisor)
	    MOVLW 0x00
	    DECFSZ 0x20
	    GOTO loop
    
    MOVFF 0x15, 0x10	;divisor change into dividend
    MOVFF 0x12, 0x11	;remainder change into divisor
    MOVFF 0x12, 0x15	;remainder change into divisor	(2nd divisor)
    MOVFF 0x10, 0x12	;for division use   (dividend in remainder)
    MOVLW 0x00
    CPFSEQ 0x11	;skip if remainder = 0
    GOTO hcf
    
    ;lcm = a*b/hcf
    
    MOVFF 0x10, 0x01	;hcf at 0x10
    
    RETURN

