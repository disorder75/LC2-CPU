;
;Routines for implementing a CALL/RET stack
;
;initsp initializes the stack pointer R6
;push saves the address stored in R0
;pop recovers the first stack entry in R0
;
;Outputs:
;	R5=0	OK
;	R5=1	Stack full
;	R5=-1	Stack empty
;

	.orig	x3000


;***************************************************************************
initsp	LEA	R6,BeginOfStack
	AND	R5,R5,#0	;R5=0: success
	RET

;***************************************************************************
push	ST	R1,saveR1	;saves register needed by PUSH routine
	LEA	R1,EndOfStack
	NOT	R1,R1		;compares EndOfStack with SP
	ADD	R1,R1,#1	;two's complement
	ADD	R1,R1,R6	;if R6>R1, stack is full
	BRp	full
	STR	R0,R6,#0	;pushes return address
	ADD	R6,R6,#1	;updates SP
	AND	R5,R5,#0	;R5=0: success
	LD	R1,saveR1	;recovers register used by PUSH routine
	RET
full	AND	R5,R5,#0
	ADD	R5,R5,#1	;R5=1: stack full
	LD	R1,saveR1	;recovers register used by PUSH routine
	RET

;***************************************************************************
pop	ST	R1,saveR1	;saves register needed by POP routine
	LEA	R1,BeginOfStack
	NOT	R1,R1		;compares BeginOfStack with SP
	ADD	R1,R1,#1	;two's complement
	ADD	R1,R1,R6	;0 if they are equals
	BRz	empty
	ADD	R6,R6,#-1	;updates SP
	LDR	R0,R6,#0	;pops return address
	AND	R5,R5,#0	;R5=0: success
	LD	R1,saveR1	;recovers register used by POP routine
	RET
empty	AND	R5,R5,#0
	ADD	R5,R5,#-1	;R5=1: stack full
	LD	R1,saveR1	;recovers register used by POP routine
	RET

;*******  DATA STRUCTURE  *********************
saveR1	.blkw	1
BeginOfStack
	.blkw	4
EndOfStack
	.blkw	1		;actual stack size: 4+1

	.end