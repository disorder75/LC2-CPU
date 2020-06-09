;SPECIFICHE DEL SOTTOPROGRAMMA DA REALIZZARE
;Il candidato scriva un sottoprogramma denominato TROVA_OCC_SUCC che riceve:
; - nel registro R0 l’indirizzo della prima cella di una zona di memoria contenente una stringa di caratteri S codificati in codice ASCII terminata dal valore 0 (corrispondente al carattere NUL);
; - nel registro R1 il codice ASCII di un carattere C.
; - nel registro R2 il numero intero N = 1;
;Il sottoprogramma deve restituire nel registro R0 la posizione della prima occorrenza del carattere C successiva alla N-esima occorrenza dello stesso carattere nella stringa S, tenendo presente che il primo carattere della stringa ha posizione 1, il secondo 2, e così via. Se tale  
; occorrenza non viene trovata, il sottoprogramma deve restituire i valore 0.
; Qualora per la realizzazione del sottoprogramma fosse necessario utilizzare altri registri della CPU, il sottoprogramma stesso deve restituire il controllo al programma chiamante senza che tali registri risultino alterati.



; macro asm for the entry point

.orig	0x3000

; backup and init data (not all registers are required, we do the backup and restore anyway)

st	r2, r2bck		;	the starting position
st	r3, r3bck		;	position counter
st	r4, r4bck		;	counter char
st	r5, r5bck		;	current char
st	r6, r6bck		;	char to find

lea	r0, text		;

not	r2, r2			;
add	r2, r2, #1		;
and	r3, r3, #0		;
add	r3, r3, #1		;
and	r4, r4, #0		;
add	r6, r1, #0		;
not	r6, r6			;
add	r6, r6, #1		;

LOOP:
ldr	r5, r0, #0		;
brz	NFOUND			;

add	r5, r5, r6		;
brz	FOUND			;

NEXT:
add 	r0, r0, #1		;
add 	r3, r3, #1		;
br	LOOP			;


FOUND:
add	r4, r4, #1		;	check if the currect char is at the position over the minimum required
add	r2, r4, r2		;
brp	END			;
ld	r2, r2bck		;	reload r2 
not	r2, r2			;
add	r2, r2, #1		;
br	NEXT			;	go to next element

NFOUND:
and	r3, r3, #0		;

END:

add	r0, r3, #0		;

ld	r2, r2bck		;
ld	r3, r3bck		;	
ld	r4, r4bck		;	
ld	r5, r5bck		;
ld	r6, r6bck		;

ret				;

; data segment for vars

text	.stringz	"Le giornate estive sono spesso afose"

r2bck	.blkw	1
r3bck	.blkw	1
r4bck	.blkw	1
r5bck	.blkw	1
r6bck	.blkw	1

; macro asm to instruct the compiler/linker for end of program
.end
