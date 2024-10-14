#include"xc.inc"
GLOBAL _multi_signed
    
PSECT mytext, local, class=CODE, reloc=2
 
_multi_signed:
    	;set values
	MOVWF 0x20  ;move the multiplicand to 0x20(low),(high) at 0x21
	;multiplier at 0x01
	
	;check the sign of multiplicand and multiplier
	BTFSC 0x20, 7
	GOTO sign_multiplicand
	GOTO cont
	
	sign_multiplicand:
	NEGF 0x20
	INCF 0x30   ;use to decide the signed bit of the result
	
	cont:
	BTFSC 0x01, 3	;4 bit multiplier
	GOTO sign_multiplier
	GOTO cont1
	
	sign_multiplier:
	NEGF 0x01;2's complement
	INCF 0x30
	
	cont1:
	
	;set result = 0	;result low 0x10, high 0x11
	MOVLW 0x00
	MOVWF 0x10
	MOVWF 0x11
	
	;loop
	loop:
	BTFSC 0x01, 0	;if multiplier lsb is 1, then undergo addition
	GOTO addition
	GOTO cont2
	
	addition:
	;addition overflow 
	    MOVF 0x11, W
	    ADDWF 0x21, W  ;high bit add
	    MOVWF 0x11	
	    MOVF 0x20, W	;lowbit add
	    ADDWF 0x10, W  ;low bit ans check overflow, save the result in wreg
	
	    BC overflow ;check overflow
	    GOTO cont3
	
	    overflow:
	    INCF 0x11	;high + 1   
	
	    cont3:
	    MOVWF 0x10	;save low 
	
	;ADDWF 0x10, F
	cont2:
	RRNCF 0x01, F	;multiplier rr
	BCF 0x01, 7	;clear  the msb
	BTFSC 0x20, 7	;test msb, if it is 1 then record, skip if 0
	GOTO set_1
	GOTO lr
	
	set_1:
	RLNCF 0x21
	BSF 0x21, 0
	GOTO cont4
	
	lr:
	RLNCF 0x21
	
	cont4:
	RLNCF 0x20, F	;multiplicand lr
	BCF 0x20, 0
	MOVLW 0x00
	CPFSEQ 0x01 ;compare 0 with multiplier, if 0, end
	GOTO loop
	GOTO cont5

	cont5:
	MOVLW 0x01	;if the count of 0x30 is 1, then the ans is negative
	CPFSEQ 0x030
	GOTO cont_end
	NEGF 0x11
	DECF 0x11	;high end -1 cuz('2 complement)
	NEGF 0x10	;if the ans is -ve
	
	BC overflow1 ;check overflow
	GOTO cont_end
	
	overflow1:
	INCF 0x11
	
	;cont_negf:
	;NEGF 0x11
	;DECF 0x11
	
	cont_end:
	MOVFF 0x10, 0x01    ;low bit result save in 0x01
	MOVFF 0x11, 0x02    ;high bit result save in 0x02
    
    RETURN


