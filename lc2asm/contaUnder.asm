;SPECIFICHE DEL SOTTOPROGRAMMA DA REALIZZARE
;Il candidato scriva un sottoprogramma denominato CONTA_UNDER che riceve:
;1. nel registro R0 l’indirizzo della prima cella di una zona di memoria contenente una sequenza di numeri n(i) a 16 bit in complemento a due;
;2. nel registro R1 l’indirizzo della cella contenente l’ultimo numero della sequenza di cui al punto 1.
;3. nel registro R2 un numero negativo N a 16 bit in complemento a due.
;Il sottoprogramma deve sostituire nella sequenza ogni numero n(i) con il risultato della somma n(i)+N e restituire in R2 il conteggio delle somme che hanno generato traboccamento negativo (underflow).
;Qualora per la realizzazione del sottoprogramma fosse necessario utilizzare altri registri della CPU, il sottoprogramma stesso deve restituire il controllo al programma chiamante senza che tali registri risultino alterati.


; asm macro instruction to allocate program at specified address
.orig 0x3000

; init and backup data, registers

st	r3, r3bck	;	error counter
st	r4, r4bck	;	end value
st	r5, r5bck	;	current value

and	r4, r4, #0	;
add	r4, r1, #0	;	when find this value into the array then to stop the loop
not	r4, r4	;
add	r4, r4, #1	;
and	r3, r3, #0	;	init the error counter

; main loop
LOOP:

ldr	r5, r0, #0	;
brn	COVER	;	check underflow ops
add	r5, r5, r2	;	sum wiht mismatching sign

NEXT:

str	r5, r0, #0	;

and	r5, r5, #0	;	check if we are on the last element into the array (we are working with memory address, not the content of)
add	r5, r0, #0	;	
add	r5, r5, r4	;
brz	END		;

add	r0, r0, #1	;	go to the next element
br	LOOP;

COVER:
add	r5, r5, r2	;	sum with same sign
brn	OK		;
add	r3, r3, #1	;	increase error counter
OK:
br	NEXT	;

END:
; restore data before return to the caller

and	r2, r2, #0	;
add	r2, r2, r3	;

ld	r3, r3bck	;
ld	r4, r4bck	;
ld	r5, r5bck	;
ret			;

r3bck	.blkw	1	;
r4bck	.blkw	1	;
r5bck	.blkw	1	;


.end






