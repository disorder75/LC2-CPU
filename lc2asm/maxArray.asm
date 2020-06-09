;SPECIFICHE DEL SOTTOPROGRAMMA DA REALIZZARE
;Il candidato scriva un sottoprogramma denominato CONTA_VOLTE che riceve:
;nel registro R0 l’indirizzo della prima cella di una zona di memoria contenente un lista di numeri positivi e negativi
;Il sottoprogramma deve restituire:
;nel registro R1 il valore assoluto maggiore presente nell'array
;Si ricorda che la differenza numerica fra la codifica ASCII di una lettera minuscola e quella della corrispondente lettera MAIUSCOLA espressa in notazione esadecimale è pari a x20 (quindi per convertire una lettera MAIUSCOLA nella corrispondente minuscola basta sommare x20 al ;codice della lettera MAIUSCOLA).
;Qualora per la realizzazione del sottoprogramma fosse necessario utilizzare altri registri della CPU, il sottoprogramma stesso deve restituire il controllo al programma chiamante senza che tali registri risultino alterati.


; macro asm to define entry point
.orig	0x3000

; backup and init

st	r2, r2bck		;	max value
st	r3, r3bck		;	lowercase counter
st 	r4, r4bck		;	the N element from the array
st	r5, r5bck		;	
st	r6, r6bck		;	

and	r2, r2, #0		;

LOOP:
ldr	r4, r0, #0		;	get the element from the array
brz	END
brn	NEG			;
br	POS			;

NEXT:
add	r0, r0, #1		;	go to the next element
br LOOP			;

NEG:
add	r4, r4, r2		;
brzp    NEXT			;	positive? Is not the value encountered  
ldr	r2, r0, #0		;	reload and store into as absolute max
not	r2, r2			;
add	r2, r2, #1		;
br NEXT				;

POS:
not	r4, r4			;
add	r4, r4, #1		;
add	r4, r4, r2		;
brzp 	NEXT			;
ldr	r2, r0, #0		;	reload and store into as max
br NEXT				;

END:

add	r1, r2, #0		;

ld	r2, r2bck		;
ld	r3, r3bck		;
ld	r4, r4bck		;
ld	r5, r5bck		;
ld	r6, r6bck		;

ret				;

; data segment 

r2bck	.blkw	1
r3bck	.blkw	1
r4bck	.blkw	1
r5bck	.blkw	1
r6bck	.blkw	1

; macro asm to instruct compiler/linker for the program end
.end