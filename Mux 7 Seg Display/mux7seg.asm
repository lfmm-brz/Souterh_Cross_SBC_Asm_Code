;***********************************************************************
; MULTIPLEXING 7 SEG DISPLAYS - ROTATING TEXT
; SOUTHERN CROSS SBC - SCM 1.8 - PCB 3.3
;
; Geany 1.38 - https://www.geany.org/
;
; zasm - Z80 Assembler – Version 4.4
; https://k1.spdns.de/Develop/Projects/zasm/Documentation/index.html
;***********************************************************************

		   ORG	   2000H
	
DIS_SEG    EQU     84H             ;DISPLAY SEGMENT DRIVER LATCH
DIS_CATH   EQU     85H             ;DISPLAY CATHODE DRIVER LATCH

;***********************************************************************
; MAIN
;***********************************************************************
START:		LD		HL,MY_TEXT				; HL has the first letter of my msg
			LD		(LTR_ON_FRST_DISP),HL	; LTR_ON_FRST_DISP has the 
											; letter on the first displsy

LOOP1:		LD		DE, 00DEH				; Load DE with the value nnnnH (LOOP1 counter)	
			; LOOP2 starts here
LOOP2:
			; start of my routine inside of LOOP2
			LD		HL,(LTR_ON_FRST_DISP);

LOOP3:      LD      A,(HL)				;Segments A,B,C,E,F and G
            OUT     (DIS_SEG),A			;Send it to LED Segments Latch
            LD      A,(DISPLAY)			;Turn on display
            OUT     (DIS_CATH),A      
            CALL	DELAY
			XOR		A
            OUT     (DIS_CATH),A		;Turn off Segments
            
            INC		HL
            CALL	CHKEND
			LD      A,(DISPLAY)
			RRCA						; shift to right to turn on the next display
			LD		(DISPLAY),A			;
			JR		NC,LOOP3			; if it is not the most right display, do LOOP3
			LD		A,20H				; if it was the most right display, start from the most left
			LD		(DISPLAY),A			;
			LD		HL,(LTR_ON_FRST_DISP) ;repeat the loop with the same letters           
			; end of my routine inside of LOOP2
   
			DEC		DE					; Decrement DE (DE = DE - 1)
			LD      A,D					; Load the high byte of DE (D register) into A
			OR      E					; Logical OR with the low byte (E register)
			JR      NZ,LOOP2			; If DE is not zero (A != 0), jump to LoopStart
			; LOOP2 ends here
			
			INC		HL						; since we have repeated the loop DE times
			LD		(LTR_ON_FRST_DISP),HL	; we go to the next letter
            JR      LOOP1
;***********************************************************************

;***********************************************************************
; CHECK END OF MSG            
;***********************************************************************
CHKEND:		LD		A,(HL)				; load A with the actual letter
			CP		EOT					; check if it is the end of my string
			JP		Z,START				; if yes we start again
			RET
;***********************************************************************

;***********************************************************************
; DELAY
;***********************************************************************
DELAY:		PUSH	AF
			PUSH	BC
			PUSH	DE
			
			LD		BC,0007h			;Loads BC with hex 1000
OUTER:		LD		DE,0007h			;Loads DE with hex 1000
INNER:		DEC		DE					;Decrements DE
			LD		A,D					;Copies D into A
			OR		E					;Bitwise OR of E with A (now, A = D | E)
			JP		NZ,INNER			;Jumps back to Inner: label if A is not zero
			DEC		BC					;Decrements BC
			LD		A,B
			OR		C					;Bitwise OR of C with A (now, A = B | C)
			JP		NZ,OUTER
			
			POP		DE
			POP		BC
			POP		AF
			RET   
;***********************************************************************

;***********************************************************************
; MY TEXT
;***********************************************************************
MY_TEXT:
		DB CHAR_SPC, CHAR_SPC, CHAR_SPC, CHAR_SPC, CHAR_SPC;
		DB CHAR_S, CHAR_O, CHAR_U, CHAR_T, CHAR_H, CHAR_E;
		DB CHAR_R, CHAR_N, CHAR_SPC, CHAR_C, CHAR_R, CHAR_O;
		DB CHAR_S, CHAR_S, CHAR_SPC, CHAR_S, CHAR_B, CHAR_C;
		DB CHAR_SPC, CHAR_S, CHAR_C, CHAR_M, CHAR_1d;
		DB CHAR_8, CHAR_SPC, CHAR_P, CHAR_C, CHAR_B;
		DB CHAR_3d, CHAR_3, CHAR_SPC;
		DB CHAR_SPC, CHAR_SPC, CHAR_SPC, CHAR_SPC, CHAR_SPC, EOT;
;***********************************************************************

;***********************************************************************
; VARIABLES
;***********************************************************************
LTR_ON_FRST_DISP	DW		0000H;
DISPLAY				DB		20H;
;***********************************************************************

;***********************************************************************
; CHARACTERS DEFINITIONS
;***********************************************************************            
CHAR_A	EQU 77H;
CHAR_B	EQU 7CH;
CHAR_C	EQU 39H;
CHAR_D	EQU 5EH;
CHAR_E	EQU 79H;
CHAR_F	EQU 71H;
CHAR_G	EQU 3DH;
CHAR_H	EQU 76H;
CHAR_I	EQU 30H;
CHAR_J	EQU 1EH;
CHAR_K	EQU 75H;
CHAR_L	EQU 38H;
CHAR_M	EQU 37H;
CHAR_N	EQU 54H;
CHAR_O	EQU 3FH;
CHAR_P	EQU 73H;
CHAR_Q	EQU 67H;
CHAR_R	EQU 33H;
CHAR_S	EQU 6DH;
CHAR_T	EQU 78H;
CHAR_U	EQU 3EH;
CHAR_V	EQU 62H;
CHAR_W	EQU 2AH;
CHAR_X	EQU 76H;
CHAR_Y	EQU 6EH;
CHAR_Z	EQU 5BH;
CHAR_0	EQU 3FH;
CHAR_1	EQU 06H;
CHAR_2	EQU 5BH;
CHAR_3	EQU 4FH;
CHAR_4	EQU 66H;
CHAR_5	EQU 6DH;
CHAR_6	EQU 7DH;
CHAR_7	EQU 07H;
CHAR_8	EQU 7FH;
CHAR_9	EQU 6FH;

CHAR_1d	EQU 86H;		1.
CHAR_3d	EQU 0CFH;		3.

CHAR_SPC	EQU 00H;	space
CHAR_DOT	EQU 80H;	dot
EOT			EQU	01H;	end of text
;***********************************************************************

	END
	
