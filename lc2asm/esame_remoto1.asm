;SPECIFICHE DEL SOTTOPROGRAMMA DA REALIZZARE
;Il candidato scriva un sottoprogramma denominato che riceve:
;1. nel registro R0 l’indirizzo della prima cella di una zona di memoria contenente una sequenza di numeri n(i) a 16 bit in complemento a due;
;2. nel registro R1 l’indirizzo della cella contenente l’ultimo numero della sequenza di cui al punto 1.

;Il sottoprogramma deve in R0 il conteggio dei numeri pari ed in R1 dei numeri dispari
;Qualora per la realizzazione del sottoprogramma fosse necessario utilizzare altri registri della CPU, il sottoprogramma stesso deve restituire il controllo al programma chiamante senza che tali registri risultino alterati


; macro asm to instruct the entry point
.orig	0x3000

; backup and init (not all will be used)

st	r2, r2bck		;	odd counter
st	r3, r3bck		;	even counter
st	r4, r4bck		;	address sentinel 
st	r5, r5bck		;	current address pointer
st	r6, r6bck		;

and	r2, r2, #0		;
and	r3, r3, #0		;
add	r4, r1, #0		;	load address sentinel
not	r4, r4			;
add	r4, r4, #1		;

LOOP:
ldr	r5, r0, #0		;
and	r5, r5, 0x0001		;
brp	ODD			;
add	r3, r3, #1		;

NEXT:
add	r5, r0, #0		;	check current address vs sentinel
add	r5, r5, r4		;
brz	END			;

add	r0, r0, #1		;
br LOOP				;

ODD:
add	r2, r2, #1		;
br NEXT				;

END:

add	r0, r2, #0		;
add	r1, r3, #0		;

ld	r2, r2bck		;
ld	r3, r3bck		;
ld	r4, r4bck		;
ld	r5, r5bck		;
ld	r6, r6bck		;

ret				;

; define data segment for vars

codd	.fill	0x0001

r2bck	.blkw	1
r3bck	.blkw	1
r4bck	.blkw	1
r5bck	.blkw	1
r6bck	.blkw	1

; macro asm to instruct the compiler/linker for end of program
.end