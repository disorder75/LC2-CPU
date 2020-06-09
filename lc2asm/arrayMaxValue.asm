;SPECIFICHE DEL SOTTOPROGRAMMA DA REALIZZARE
;Il candidato scriva un sottoprogramma denominato CONTA_VOLTE che riceve:
;nel registro R0 l’indirizzo della prima cella di una zona di memoria contenente un lista di numeri positivi e negativi
;Il sottoprogramma deve restituire:
;nel registro R1 il valore assoluto maggiore presente nell'array
;Qualora per la realizzazione del sottoprogramma fosse necessario utilizzare altri registri della CPU, il sottoprogramma stesso deve restituire il controllo al programma chiamante senza che tali registri risultino alterati.


; macro asm to define entry point
.orig	0x3000

; backup and init

st	r2, r2bck		;	max value counter
st	r3, r3bck		;	current array value
st 	r4, r4bck		;	temporary store register
st	r5, r5bck		;	
st	r6, r6bck		;	

and	r2, r2, 0x0000	;	init the counter

lea	r0, VAL0		;	for debug purpouse

LOOP:
ldr	r3, r0, 0x0000	;	get the element from the array
brz	END
brn	GET_ABS		;
br	DIFF			;

NEXT:
add	r0, r0, #1		;	go to the next element
br LOOP			;

GET_ABS:
not	r3, r3		;
add	r3, r3, 0x0001	;

DIFF:
add	r4, r2, 0x0000	;
not	r4, r4		;
add	r4, r4, 0x0001	;
add	r4, r4, r3		;
brn	NEXT		; 
add	r2, r3, 0x0000	;	store new max value
br NEXT			;

END:

add	r1, r2, 0x0000	;

ld	r2, r2bck		;
ld	r3, r3bck		;
ld	r4, r4bck		;
ld	r5, r5bck		;
ld	r6, r6bck		;

ret				;

; data segment 

VAL0	.fill	#-56
VAL1	.fill	#123
VAL2	.fill	#4
VAL3	.fill	#-10
VAL4	.fill	#99
VAL5	.fill	#200
VAL6	.fill	#12657
VAL7	.fill	#-4098
VAL8	.fill	#1
VAL9	.fill	#3
VAL10	.fill	#-30000
NULL	.fill	0x0000

r2bck	.blkw	1
r3bck	.blkw	1
r4bck	.blkw	1
r5bck	.blkw	1
r6bck	.blkw	1

; macro asm to instruct compiler/linker for the program end
.end