;dato un array il cui indirizzo della prima cella è fornito in r0 e l'indirizzo dell'ultima cella è fornito in r1, calcolare quanti elementi sono dispari e quanti pari

; assumption of ODD number in boolean notation:	a number with the least significative bit equal to "1" (not zero)
; at the end of the program the register snapshots will be:
; R0 will contains the ODD counter
; R1 will contains the EVEN counter
; all the rest of registers will be restored with values before the call to the subroutine

; macro asm to define out entry point

.orig	0x3000

; backup and init 


st	r0, r0bck			;	array of numbers
st	r1, r1bck			;	address of the last array's cell
st	r2, r2bck			;	current cell address
st	r3, r3bck			;	current cell value
st	r4, r4bck			;	even counter
st	r5, r5bck			;	odd counter
st	r6, r6bck			;
st	r7, r7bck			;

and	r4, r4	0x0000		;
and	r5, r5, 0x0000		;

lea	r0,	VAL0		;
lea	r1,	VAL10		;

LOOP:

ldr	r2, r0, #0		;	current value address
and	r2, r2, 0x0001		;
brp	ODD			;

add	r4, r4, 0x00001		;


NEXT:

and	r2, r2, 0x0000		;
add	r2, r1, 0x0000		;
not	r2, r2			;
add	r2, r2, 0x0001		;	end of array
add	r3, r0, 0x0000		;	current cell address
add	r2, r2, r3		;
brz	END			;

add	r0, r0, #1		;
br	LOOP			;

ODD:
add	r5, r5, 0x00001		;
br	NEXT			;

END:

add	r0, r5, 0x0000		;
add	r1, r4, 0x0000		;

ld	r2, r2bck			;
ld	r3, r3bck			;
ld	r4, r4bck			;
ld	r5, r5bck			;
ld	r6, r6bck			;
ld	r7, r7bck			;

ret					;

; data segment

r0bck	.blkw	1	;
r1bck	.blkw	1	;
r2bck	.blkw	1	;
r3bck	.blkw	1	;
r4bck	.blkw	1	;
r5bck	.blkw	1	;
r6bck	.blkw	1	;
r7bck	.blkw	1	;

;	for debug
VAL0	.fill		#0	;
VAL1	.fill		#1	;
VAL2	.fill		#2	;
VAL3	.fill		#3	;
VAL4	.fill		#4	;
VAL5	.fill		#5	;
VAL6	.fill		#6	;
VAL7	.fill		#7	;
VAL8	.fill		#8	;
VAL9	.fill		#9	;
VAL10	.fill		#10	;


; macro asm for compiler/linker to define end of the program

.end