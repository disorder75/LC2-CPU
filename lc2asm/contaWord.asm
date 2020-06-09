;SPECIFICHE DEL SOTTOPROGRAMMA DA REALIZZARE 
;Il candidato scriva un sottoprogramma denominato CONTA_WORD che riceve nel registro R0 l’indirizzo della prima cella di una zona di memoria contenente una stringa S di caratteri ASCII (terminata dal valore NULL = 0) costituita da lettere MAIUSCOLE, cifre, spazi e altri caratteri.
;Il sottoprogramma deve contare il numero di parole contenute nella frase, ovvero le sequenze di sole lettere maiuscole separate da almeno uno spazio, e restituire in R0 tale conteggio. Si ricorda che la codifica ASCII della prima lettera maiuscola è A=65 (in decimale) quella
;dell’ultima lettera maiuscola è Z=90 e la codifica dello spazio è SP=32.
;Qualora per la realizzazione del sottoprogramma fosse necessario utilizzare altri registri della CPU, il sottoprogramma stesso deve restituire il controllo al programma chiamante senza che tali registri risultino alterati.

;ESEMPI DI FUNZIONAMENTO DEL SOTTOPROGRAMMA
;Input Output
;S = “QUESTA FRASE CONTIENE 6 PAROLE E 2 NUMERI” 	R0 = 6
;Input Output
;S = “QUESTA FRASE CONTIENE UNA SIGLA RS232” 		R0 = 5
;Input Output
;S = “1234 RS232 89898 56454 23,56”					R0 = 0


; macro asm to define our entry point

.orig	0x3000

; back registers and init (not all registers here could be required by the program)

st	r1, r1bck		;	word's counter
st	r2, r2bck		;	uppercase start value range
st	r3, r3bck		;	lower end value range
st	r4, r4bck		;	blank value
st	r5, r5bck		;	current char
st	r6, r6bck		;

and	r1, r1, #0		;

ld	r2, CHAR_A	;
not	r2, r2		;
add	r2, r2, #1		;

ld	r3, CHAR_Z	;
not	r3, r3		;
add	r3, r3, #1		;

ld	r4, CBLANK	;
not	r4, r4		;
add	r4, r4, #1		;

LEA	r0, TEXT		;	R0 now point out test string (not required by the specs, is for debug)

LOOP:
ldr	r5, r0, #0		;
brz	END			;	end of string

add	r5, r5, r2		;
brzp	VER_Z		;	current char is equal or over the 'A' check if is equal or lower than 'Z'
br	WAIT_BLANK	;	consume all characters unitl a blank is found

NEXT:
add	r0, r0, #1		;
br	LOOP		;

VER_Z:
ldr	r5, r0, #0		;
add	r5, r5, r3		;
brp	NOT_OK		;
add	r1, r1, #1		;

NOT_OK:
br WAIT_BLANK	;

WAIT_BLANK:
add	r0, r0, #1		;	loop unitl a blank is found
ldr	r5, r0, #0		;
brz	END			;	null terminator reached, was the last char in the string
add	r5, r5, r4		;
brz	NEXT		;
br	WAIT_BLANK	; 

END:

add	r0, r1, #0		; return value function
ld	r1, r1bck		;
ld	r2, r2bck		;
ld	r3, r3bck		;
ld	r4, r4bck		;
ld	r5, r5bck		;
ld	r6, r6bck		;

ret				;

; segment data area

TEXT	.stringz	"QUESTA FRASE CONTIENE 6 PAROLE E 2 NUMERI"

CBLANK	.fill	#32		;	blank char
CHAR_A	.fill	#65		;	char 'A'
CHAR_Z	.fill	#90		;	char 'Z'

r1bck	.blkw	1	;
r2bck	.blkw	1	;
r3bck	.blkw	1	;
r4bck	.blkw	1	;
r5bck	.blkw	1	;
r6bck	.blkw	1	;

; macro asm to instruct compiler/linker for the end of out program
.end
