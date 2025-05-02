;----------------------------------------------------
; Project: Add two 8 bit numbers
; Main File: 8bit-add.asm
;----------------------------------------------------

		.ORG 2000H
;
;********************* MAIN ***************************************
		LD A,(ADR1)	;LOAD OPERATOR 1 IN A
		LD HL,ADR2	;LOAD ADDRESS OF OPERATOR 2 INTO HL
		ADD A,(HL)	;ADD OPERATOR 2 TO OPERATOR 1
		; The result will be at 200FH
		LD (ADR3),A	;SAVE RESULT IN A TO ADDRESS ADR3
		LD C,00H
		RST 30H
;------------------------------------------------------------------
;
;******************************************************************
; DATA
;******************************************************************
ADR1:		.DB 22H		;OPERATOR 1
ADR2:		.DB 33H		;OPERATOR 2
ADR3		.DB 00H		;RESULT
;------------------------------------------------------------------

		.END