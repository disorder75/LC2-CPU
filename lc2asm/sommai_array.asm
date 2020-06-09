;SPECIFICHE DEL SOTTOPROGRAMMA DA REALIZZARE
;Il candidato scriva un sottoprogramma denominato SOMMA_ARRAY che riceve:
;1. nei registri R0 e R1 gli indirizzi dei primi elementi di due array A0 e A1 di numeri a 16 bit in complemento a due; i due array hanno uguale lunghezza e il valore zero è il “tappo” finale per entrambi;
;2. nel registro R2 l’indirizzo di inizio di una zona di memoria libera destinata a contenere l’array A2.
;Il sottoprogramma deve:
;1. assegnare a ogni elemento di posto i di A2 il valore A2(i) = A0(i) + A1(i);
;2. restituire in R0 il numero di traboccamenti verificatisi, non importa se positivi o negativi.
;Qualora per la realizzazione del sottoprogramma fosse necessario utilizzare altri registri della CPU, il sottoprogramma stesso deve restituire il controllo al programma chiamante senza che tali registri risultino alterati.


; macro asm in order to store user program at specified memory address
.orig 0x3000

; back-up registers in order to restore at the end of the job
st	r3, r3bck
st	r4, r4bck
st	r5, r5bck

; init
and	r5, r5, #0	; r5 will be used as counter

; main
LOOP:
ldr 	r3, r0, #0	; load first operand from r0 current address
brz	END		; on zero we've reached the end of the array
brzp	FPOS		; first operand is positive (well, zero is not necessary cause is used as NULL TERMINATOR into the array)
nop			; falldown - first operand is NEGATIVE
ldr	r4, r1, #0	; load second operand from r1 current address
brn	CUNDER		; operands with same sign: NEGATIVE. Do the math and check for underflow	
nop			; operand's sign mismatch, is possibile to do the math without any kind of memory problem
SAFE_OPS:
add	r3, r3, r4	; math ops
STORE:
str	r3, r2, #0	; write the destination array
br NEXT			; go to next vectors elements

FPOS:
ldr	r4, r1, #0	; load second operand from r1 current address
brzp	COVER		; operands with same sign: POSITIVE. Do the math and check for overflow	
br SAFE_OPS		; do the math without any problem

CUNDER:
add	r3, r3, r4	; math ops
brzp	UNDER		; underflow!	
br STORE		; negative plus negative = negative, Ops ok.

COVER:
add	r3, r3, r4	; math ops
brn	OVER		; overflow!	
br STORE		; positive plus positive = positive, Ops ok.

UNDER:
	nop		;
OVER:
add r5, r5, #1	; increase error counter
br STORE

NEXT:
add 	r0,r0, #1	; increase vector's index
add 	r1,r1, #1
add 	r2,r2, #1
br LOOP


END:
add	r0, r5, #0	; store into R0 the overflow/underflow counter's value. REMEBER: not "copy register to register" instruction in LC2 are available. The "add" is a workaround.
ld	r3, r3bck	; restore r3 initial value	
ld	r4, r4bck	; restore r4 initial value	
ld	r5, r5bck	; restore r5 initial value	
ret

;backup and data vars
r3bck	.blkw	1
r4bck	.blkw	1
r5bck	.blkw	1

; macro asm to instruct compiler and linker
.end
