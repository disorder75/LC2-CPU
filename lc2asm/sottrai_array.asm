;SPECIFICHE DEL SOTTOPROGRAMMA DA REALIZZARE
;Il candidato scriva un sottoprogramma denominato SOTTRAI_ARRAY che riceve:
;1. nei registri R0 e R1 gli indirizzi dei primi elementi di due array A0 e A1 di numeri a 16 bit in complemento a due; i due array hanno uguale lunghezza e il valore zero è il “tappo” finale per entrambi;
;2. nel registro R2 l’indirizzo di inizio di una zona di memoria libera destinata a contenere l’array A2.
;Il sottoprogramma deve:
;1. assegnare a ogni elemento di posto i di A2 il valore A2(i) = A0(i) — A1(i);
;2. restituire in R0 il numero di traboccamenti verificatisi, non importa se positivi o negativi.
;Qualora per la realizzazione del sottoprogramma fosse necessario utilizzare altri registri della CPU, il sottoprogramma stesso deve restituire il controllo al programma chiamante senza che tali registri risultino alterati.
.orig 0x3000

; back-up cpu registers
st	r3, r3bck
st	r4, r4bck
st	r5, r5bck

;	init data
and	r5, r5, #0

;	main 
LOOP:
ldr	r3, r0, #0
brz	END;
brn	FIRST_NEG
ldr	r4, r1, #0		; here first operard is positive, let's check the second
not	r4, r4
add	r4, r4, #1
brp	VER_OFLOW	; same sign, possibly overflow

EXE_OP:
add	r3, r3, r4		; do the sum with discordant sign, no problem for the math operation

STORE:
str	r3, r2, #0
br	NEXT

FIRST_NEG:
ldr	r4, r1, #0		; here first operard is negative, let's check the second
not	r4, r4
add	r4, r4, #1
brn	VER_UFLOW	; same sign, possibly underflow
br EXE_OP

VER_UFLOW:
add	r3, r3, r4
brzn	NOUFLOW
add	r5, r5, #1
NOUFLOW
br	STORE

VER_OFLOW:
add	r3, r3, r4
brzp	NOOFLOW
add	r5, r5, #1
NOOFLOW
br	STORE


NEXT:
add	r0, r0, #1
add	r1, r1, #1
add	r2, r2, #1
br	LOOP


;	all the array's elements are consumed
END:
str	r5, r1, #0	; numer of overflow/underflow
st	r3, r3bck	; restore registers
st	r4, r4bck	;
st	r5, r5bck	;

ret

; declare user memory data for back-up and variables (assembler macro instruction)
r3bck	.blkw	1
r4bck	.blkw	1
r5bck	.blkw	1

.end

