#include"xc.inc"
GLOBAL _lcm
    
PSECT mytext, local, class=CODE, reloc=2
 
_lcm:
    
    MOVFF 0x01, 0x10	;0x10 (low a), 0x11 (high a)
    MOVFF 0x03, 0x12	;0x12 (low b), 0x13 (high b)
    MOVFF 0x01, 0x30
    MOVFF 0x03, 0x32
    MOVLW 0x01
    MOVWF 0x21
    MOVWF 0x22
    ;loop
    loop:
    MOVLW 0x00
    MOVWF 0x20	;count, use to check how many high bit = 0
    ;count a:0x21, count b:0x22, use in temporary save:0x24, use to record which count is used now:0x25
    ;test which one is bigger
    ;first check if both of their high bit = 0
    MOVLW 0x00
    CPFSEQ 0x11	;high a	;skip if = 0
	INCF 0x20
    CPFSEQ 0x13	;high b	;skip if = 0
	INCF 0x20
    
    ;check if 0x20 = 0
    CPFSEQ 0x20
    GOTO cont
    MOVFF 0x10, 0x11	;cuz using high bit to check
    MOVFF 0x12, 0x13
    
    cont:
    
    MOVF 0x11, W    ;move a to wreg for comparing
    CPFSGT 0x13	    ;skip if f>wreg(b>a)
    GOTO a_is_bigger
    GOTO b_is_bigger
    
    a_is_bigger:    ;bigger put at 0x30,0x31 ;smaller 0x32, 0x33
	MOVLW 0x00
	CPFSEQ 0x20 ;test count if = 0, skip
	GOTO cont1
	MOVLW 0x00
	MOVWF 0x11
	MOVLW 0x00
	MOVWF 0x13
	cont1:
	INCF 0x22
	
    GOTO cont2
    
    b_is_bigger:    ;bigger put at 0x30,0x31 ;smaller 0x32, 0x33
	MOVLW 0x00
	CPFSEQ 0x20
	GOTO cont3
	MOVLW 0x00
	MOVWF 0x11
	MOVLW 0x00
	MOVWF 0x13
	cont3:
	INCF 0x21
    
	cont2:
    
    ;multiplication
    ;mul a
	MOVF 0x30, W
	MULWF 0x21  ;mul
	MOVFF PRODL, 0x10
	MOVFF PRODH, 0x11
	
    ;mul b
	MOVF 0x32, W
	MULWF 0x22  ;mul
	MOVFF PRODL, 0x12
	MOVFF PRODH, 0x13
    
    MOVF 0x10, W
    CPFSEQ 0x12
    GOTO again
    MOVF 0x11, W
    CPFSEQ 0x13	;when two ans is equal, then skip
    GOTO again
    GOTO finish
    again:
    GOTO loop
    
    finish:
    ;move the ans to 0x01 0x02
    MOVFF 0x10, 0x01
    MOVFF 0x11, 0x02
    
    RETURN


