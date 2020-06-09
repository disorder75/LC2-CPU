;
;shift routines
;
;shl shifts left R0 by 1 bit
;shr shifts right R0 by 1 bit
;
;

; TEST PROGRAM

	.orig	x3000
	LD	R0,mask
	JSR	shr
	JSR	shl
	TRAP	x25

mask	.fill	b0100010101101101

;**************************************************************
shl	ST	R1,saveR1
	ST	R2,saveR2
	ST	R3,saveR3
	ST	R4,saveR4
	ST	R5,saveR5
	AND	R1,R1,#0	;contains the shifting result
	ADD	R1,R1,x02
	AND	R2,R2,#0
	ADD	R2,R2,x01	;contains the shifting mask
	AND	R3,R3,#0	;contains the shifted value
	AND	R4,R4,#0
	ADD	R4,R4,#15	;loop counter
loopl	AND	R5,R2,R0	;looks for value of (i+1)-th bit in R0
	BRZ	nobl
	ADD	R3,R3,R1	;if (i)-th bit is 1, sets (i+1)-th bit
nobl	ADD	R2,R2,R2	;R2 = 2*R2
	ADD	R1,R1,R1	;R1 = 2*R1
	ADD	R4,R4,#-1
	BRP	loopl
	AND	R0,R0,#0
	ADD	R0,R0,R3
	LD	R5,saveR5
	LD	R4,saveR4
	LD	R3,saveR3
	LD	R2,saveR2
	LD	R1,saveR1
	Ret

;**************************************************************
shr	ST	R1,saveR1
	ST	R2,saveR2
	ST	R3,saveR3
	ST	R4,saveR4
	ST	R5,saveR5
	AND	R1,R1,#0	;contains the shifting result
	ADD	R1,R1,x01
	AND	R2,R2,#0
	ADD	R2,R2,x02	;contains the shifting mask
	AND	R3,R3,#0	;contains the shifted value
	AND	R4,R4,#0
	ADD	R4,R4,#15	;loop counter
loopr	AND	R5,R2,R0	;looks for value of (i+1)-th bit in R0
	BRZ	nobr
	ADD	R3,R3,R1	;if (i+1)-th bit is 1, sets i-th bit
nobr	ADD	R1,R1,R1	;R1 = 2*R1
	ADD	R2,R2,R2	;R2 = 2*R2
	ADD	R4,R4,#-1
	BRP	loopr
	AND	R0,R0,#0
	ADD	R0,R0,R3
	LD	R5,saveR5
	LD	R4,saveR4
	LD	R3,saveR3
	LD	R2,saveR2
	LD	R1,saveR1
	RET


;*******  DATA STRUCTURE  *********************
saveR1	.blkw	1
saveR2	.blkw	1
saveR3	.blkw	1
saveR4	.blkw	1
saveR5	.blkw	1

	.end
