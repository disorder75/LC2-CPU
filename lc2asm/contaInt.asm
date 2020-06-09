;SPECIFICHE DEL SOTTOPROGRAMMA DA REALIZZARE
;Il candidato scriva un sottoprogramma denominato CONTA_INT che riceve nel registro R0 l’indirizzo della prima cella di una zona di memoria contenente una stringa S di caratteri ASCII (terminata dal valore NULL = 0) costituita da lettere MAIUSCOLE, cifre, spazi e altri caratteri.
;Il sottoprogramma deve contare il numero di numeri interi contenuti nella frase, ovvero le sequenze di sole cifre (senza virgole o altro) separate da almeno uno spazio, e restituire in R0 tale conteggio. Si ricorda che la codifica ASCII della prima cifra è 0=48 (in decimale) quella
;dell’ultima cifra è 9=57 e la codifica dello spazio è SP=32.
;Qualora per la realizzazione del sottoprogramma fosse necessario utilizzare altri registri della CPU, il sottoprogramma stesso deve restituire il controllo al programma chiamante senza che tali registri risultino alterati.


; macro asm to define the entry point
.orig	0x3000

; backup and init vars (not all registers will be used, we do the backup anyway for future use)

st	r1, r1bck		;	current char
st	r2, r2bck		;	control char "1"
st 	r3, r3bck		;	control char "9"
st	r4, r4bck		;	control char blank " "
st	r5, r5bck		;	counter 
st	r6, r6bck		;

lea	r0, text		;
ld	r2, N0			;
not	r2, r2			;
add	r2, r2, #1		;
ld	r3, N9			;
not	r3, r3			;
add	r3, r3, #1		;
ld	r4, BLK			;
not	r4, r4			;
add	r4, r4, #1		;
and	r5, r5, #0		;

LOOP:
ldr	r1, r0, #0		;
brz	END			;	end of string

add	r1, r1, r2		;	check if we are on, or over, the char "1"
brn	CONSUMEBLANK		;

ldr	r1, r0, #0		;
add	r1, r1, r3		;	check if we are on, or under, the char "9"
brp	CONSUMEBLANK		;

nop				;	ok, we are in range, wait for blank char
add	r0, r0, #1		;
br 	LOOPBLANK		;

NEXT:
add	r0, r0, #1		;
br 	LOOP			;

CONSUMEBLANK:
ldr	r1, r0, #0		;
brz	END			;	end of string
add	r1, r1, r4		;
brz	NEXT			;
add	r0, r0, #1		;
br 	CONSUMEBLANK		;	wait for a blank

LOOPBLANK:
ldr	r1, r0, #0		;
brz	END			;	end of string
add	r1, r1, r4		;
brz	INC			;
add	r0, r0, #1		;
br 	LOOPBLANK		;	still consuming the current word

INC:
add	r5, r5, #1		;
br 	NEXT			;	go to next char in the array

END:

add	 r0, r5, #0		;

ld	r1, r1bck		;
ld	r2, r2bck		;
ld 	r3, r3bck		;
ld	r4, r4bck		;
ld	r5, r5bck		;
ld	r6, r6bck		;

ret				;

; data segmet

text		.stringz	"QUESTA FRASE CONTIENE 6 PAROLE E 2 NUMERI"

N0		.fill		#48
N9		.fill		#57
BLK		.fill		#32

r1bck	.blkw	1
r2bck	.blkw	1
r3bck	.blkw	1
r4bck	.blkw	1
r5bck	.blkw	1
r6bck	.blkw	1

; macro asm for compiler/linker to instruct the end of the program
.end 