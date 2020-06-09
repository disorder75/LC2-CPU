;SPECIFICHE DEL SOTTOPROGRAMMA DA REALIZZARE
;Il candidato scriva un sottoprogramma denominato CONTA_OVER che riceve:
;1. nel registro R0 l’indirizzo della prima cella di una zona di memoria contenente una sequenza di numeri n(i) a 16 bit in complemento a due;
;2. nel registro R1 l’indirizzo della cella contenente l’ultimo numero della sequenza di cui al punto 1.
;3. nel registro R2 un numero positivo N a 16 bit in complemento a due.
;Il sottoprogramma deve sostituire nella sequenza ogni numero n(i) con il risultato della somma n(i)+N e restituire in R2 il conteggio delle somme che hanno generato traboccamento positivo (overflow).
;Qualora per la realizzazione del sottoprogramma fosse necessario utilizzare altri registri della CPU, il sottoprogramma stesso deve restituire il controllo al programma chiamante senza che tali registri risultino alterati

; macro asm to allocate program at specified address

.orig 0x3000

; backup and init vars

st	r3, r3bck		;	will be used as error counter
st	r4, r4bck		;	will be used to chekc the end address of the array element 
st	r5, r5bck		;	will be used to track and load the N element of the array

and	r3, r3, #0		;
add	r4, r1, #0		;
not	r4, r4		;
add	r4, r4, #1		;

LOOP:

ldr	r5, r0, #0		;	load the value at address 0xXXXX
brzp	COVER		;	check overflow
add	r5, r5, r2		;

NEXT:

str	r5, r0, #0		;	store che current value

add	r5, r0, #0		;	copy the current address value pointed by R0 in R5 anche check agaist R4
add	r5, r5, r4		;
brz END;

add r0, r0, #1		;	next element
br LOOP			;

COVER:
add	r5, r5, r2		;
brzp	OK			;
add	r3, r3, #1		;	overflow!
OK:
br	NEXT		;

END:
add	r2, r3, #0		;	copy value from register to register
st	r3, r3bck		;
st	r4, r4bck		;
st	r5, r5bck		;
ret				;

; data segment definition

r3bck	.blkw	1
r4bck	.blkw	1
r5bck	.blkw	1

; masco asm for the compiler/linker 

.end





