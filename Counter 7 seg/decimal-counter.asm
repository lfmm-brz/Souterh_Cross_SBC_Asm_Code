;****************************************************
; Southern Cross Monitor version 1.8 demo program
; Counting in Decimal
;
; Geany 1.38 - https://www.geany.org/
;
; zmac version 18oct2022 http://48k.ca/zmac.html
;****************************************************

		ORG		2000h

;****************************************************
; MAIN
;****************************************************
START:
		LD	C,CLRBUF	;clear the display buffer
		RST	30H

		LD	HL,0000H	;clear the counter, you can preset the counter here
		
COUNT1:					;address display
		LD	C,DISADD	;convert HL to 7 segment code
		RST 30H	        ;and put in display buffer

		LD	B,0FFH		;scan the display B times, change counting speed
				
LOOP:	
		LD	C,SCAND	    ;scan the display
		RST	30H
		DJNZ	LOOP

		INC	L			;increment the count and display again
		CALL CHK_REG_LH
		JR	COUNT1
;****************************************************

;****************************************************
; CHECK IF REGs L and H ARE GREATTER THAN 9
;****************************************************
CHK_REG_LH:							;check if low nibble of reg L is greatter than 09h
		LD	A,L
		AND 0FH						;mask 00001111b
		CP	0AH						;if reg A == 0Ah it is greatter than 09h
		JP	Z,INC_HG_NIB_REG_L		;low nibble reg L is greatter than 09h
		RET
		
INC_HG_NIB_REG_L:					;low nibble of L is greatter than 09h
		LD	A,L						;lets reset it and increment the high nibble
		AND 0F0H					;mask 11110000b
		ADD 10H						;increment high nibble of reg L
		CP	0A0H					;if reg A == A0h it is greatter than 09h
		JP	Z,INC_LW_NIB_REG_H		;high nibble reg L is greatter than 09h
		LD 	L,A						;if not, recover value of reg L
		RET
		
INC_LW_NIB_REG_H:					;high nibble of L is greatter than 09h
		LD	L,00H					;lets reset reg L and increment the low nibble of reg H
		INC	H
		LD	A,H
		AND 0FH						;mask 00001111b
		CP	0AH						;if reg A == 0Ah it is greatter than 09h
		JP	Z,INC_HG_NIB_REG_H		;low nibble reg H is greatter than 09h
		RET
		
INC_HG_NIB_REG_H:					;low nibble of H is greatter than 09h
		LD	A,H						;lets reset it and increment the high nibble
		AND	0F0H					;mask 11110000b
		ADD	10H						;increment high nibble of reg H
		CP	0A0H					;if reg A == A0h it is greatter than 09h
		JP	Z,RST_REG_H				;high nibble reg H is greatter than 09h
		LD	H,A						;if not, recover value of reg H
		RET

RST_REG_H:							;reset reg H
		LD	H,00H
		RET
;****************************************************

;****************************************************
		INCLUDE		"SCM18_Include.asm"
;****************************************************

	END
