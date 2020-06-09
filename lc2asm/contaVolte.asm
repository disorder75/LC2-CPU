;SPECIFICHE DEL SOTTOPROGRAMMA DA REALIZZARE
;Il candidato scriva un sottoprogramma denominato CONTA_VOLTE che riceve:
;nel registro R0 l’indirizzo della prima cella di una zona di memoria contenente una stringa di caratteri codificati ASCII (un carattere per cella). La stringa è terminata dal valore 0;
;nel registro R1 il codice ASCII di una lettera minuscola (le lettere minuscole hanno codifiche esadecimali da “a”=x61 a “z”=x7A).
;Il sottoprogramma deve restituire:
;nel registro R0 il conteggio del numero di volte in cui la lettera ricevuta in ingresso compare nella stringa, come lettera MAIUSCOLA;
;nel registro R1 il conteggio del numero di volte in cui la lettera ricevuta in ingresso compare nella stringa, come lettera minuscola.
;Si ricorda che la differenza numerica fra la codifica ASCII di una lettera minuscola e quella della corrispondente lettera MAIUSCOLA espressa in notazione esadecimale è pari a x20 (quindi per convertire una lettera MAIUSCOLA nella corrispondente minuscola basta sommare x20 al ;codice della lettera MAIUSCOLA).
;Qualora per la realizzazione del sottoprogramma fosse necessario utilizzare altri registri della CPU, il sottoprogramma stesso deve restituire il controllo al programma chiamante senza che tali registri risultino alterati.


; macro asm to define entry point
.orig	0x3000

; backup and init

st	r2, r2bck		;	uppercase counter
st	r3, r3bck		;	lowercase counter
st 	r4, r4bck		;	the N element from the array
st	r5, r5bck		;	the lowercase char to search
st	r6, r6bck		;	the uppercase char to search

and	r2, r2, #0		;
and	r3, r3, #0		;

add	r5, r1, #0		;	reverse lower case char
not	r5, r5		;
add	r5, r5, #1		;

ld	r6, charoffset		;
not	r6, r6			;
add	r6, r6, #1		;
add	r6, r6, r1		;	reverse upper case char
not	r6, r6			;
add	r6, r6, #1		;

LOOP:
ldr	r4, r0, #0		;	get the element from the array
brz	END

add	r4, r4, r5		;
brz	LOWER		;
ldr	r4, r0, #0		;	get the element from the array again
add	r4, r4, r6		;
brz	UPPER		;

NEXT:
add	r0, r0, #1		;	go to the next element
br LOOP			;

LOWER:
add r2, r2, #1		;
br NEXT			;

UPPER:
add r3, r3, #1		;
br NEXT			;

END:

add	r0, r2, #0		;
add	r1, r3, #0		;

ld	r2, r2bck		;
ld	r3, r3bck		;
ld	r4, r4bck		;
ld	r5, r5bck		;
ld	r6, r6bck		;

ret				;

; data segment

charoffset	.fill	0x20	;

 
r2bck	.blkw	1
r3bck	.blkw	1
r4bck	.blkw	1
r5bck	.blkw	1
r6bck	.blkw	1

; macro asm to instruct compiler/linker for the program end
.end