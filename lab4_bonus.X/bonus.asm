List p=18f4520
    #include<p18f4520.inc>  
	CONFIG OSC = INTIO67	
	CONFIG WDT = OFF
	org 0x00 

	;initialize
	MOVLW 0x00	;ensure 0x00 = 0 
	MOVWF 0x00
	MOVLW 0x05	;value n
	MOVWF 0x01	;n
	;MOVWF 0x02	;count
	MOVLW 0x02	;value k
	MOVWF 0x02	;k
	;MOVWF 0x03	;2nd k
	
	
	Comb macro n_address, k_address
	    MOVF n_address, W	;n value in wreg
	    ;check if n = k, ans = 1
	    CPFSEQ k_address
		GOTO check2
		GOTO cont
	    
	    check2: ;check if 0x03 = 0, skip if = 0 (check if k = 0), ans = 1
	    TSTFSZ k_address	
		GOTO start
		GOTO cont
	    
	    
	    start:
	    ;MOVLW 0x01	;(1,0)
	    ;MOVWF 0x10
	    ;MOVLW 0x01	;(1,1)
	    ;MOVWF 0x11
	    rcall Fact
	    GOTO cont
	    
	    Fact:
		;pascal thm C(n-1, k-1) + C(n-1, k) = C(n, k)
		DECF n_address   ;n-1
		;+1 when n = k and when k = 0
		MOVF n_address, W
		CPFSEQ k_address
		    DECF 0x00
		    INCF 0x00
		TSTFSZ k_address
		    DECF 0x00
		    INCF 0x00 
		DECF k_address	;k-1
		CPFSEQ k_address
		    DECF 0x00
		    INCF 0x00
		TSTFSZ k_address
		    DECF 0x00
		    INCF 0x00
		    
		Comb n_address, k_address
		INCF k_address	;k+1(the beginning k)
		Comb n_address, k_address
		;DECFSZ 0x02
		GOTO Fact
		RETURN
	    
	    cont:
		 MOVLW 0x00	;if freg is = 0, then set the ans = 1
		 CPFSGT 0x00	;if 0x00 > wreg, skip, or else set the ans = 1
		    INCF 0x00
	endm
	
	Comb 0x01, 0x02
	
	end


