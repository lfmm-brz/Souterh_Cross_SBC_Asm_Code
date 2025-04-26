;****************************************************
; Southern Cross Monitor version 1.8 demo program
; Counting in Decimal Using Instruction DAA
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
		LD C,CLRBUF     ;clear the display buffer
		RST 30H

		LD HL,0000H      ;clear the counter, you can preset the counter here
		
COUNT1:                 ;address display
		LD C,DISADD     ;convert HL to 7 segment code
		RST 30H         ;and put in display buffer

		LD B,0FFH       ;scan the display B times, change counting speed here
				
LOOP:	
		LD C,SCAND      ;scan the display
		RST 30H
		DJNZ LOOP

		CALL REGLBCD    ;will work on reg L
		CP 00H          ;reg A (reg L) is equal to zero?
		CALL Z,REGHBCD  ;if yes, we work on reg H

		JR COUNT1
;****************************************************

;****************************************************
; DAA - ADJUSTS THE ACCUMULATOR FOR BCD
; REGISTER L HOLDS TENS AND UNITS
;****************************************************
REGLBCD:
		LD A,L
		INC A
		DAA
		LD L,A
		RET
;****************************************************

;****************************************************
; DAA - ADJUSTS THE ACCUMULATOR FOR BCD
; REGISTER H HOLDS THOUSANDS AND HUNDREDS
;****************************************************
REGHBCD:
		LD A,H
		INC A
		DAA
		LD H,A
		RET
;****************************************************

;****************************************************
		INCLUDE "SCM18_Include.asm"
;****************************************************

;****************************************************
; Detailed info DAA
; http://www.z80.info/z80syntx.htm#DAA
;****************************************************

	END
