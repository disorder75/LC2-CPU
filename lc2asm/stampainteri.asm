;-------------------------------------------------------------------------------------------
;                          Sottoprogramma per la stampa a video di un 
;                              intero compreso tra -32768 e 32767      
;                                      in assembly LC2.               
;                                    by Fabio Cometti
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;                          L'indirizzo di memoria dell'intero deve 
;                       essere memorizzato in R0 prima della chiamata
;                                     al sottoprogramma
;-------------------------------------------------------------------------------------------
;    Ora il programma è composta da 2 parti principali: la prima converte il numero e la  
;        seconda lo stampa. Entrambe sono state ottimizzate con dei cicli iterativi
;-------------------------------------------------------------------------------------------	



;-------------------------------------------------------------------------------------------
	.orig	xfe00		; il sottoprogramma si trova nell'ultima pagina di memoria
;-------------------------------------------------------------------------------------------
	st	r0, saver0 	; __
	st	r1, saver1 	;   |
        st	r2, saver2 	;   |
	st	r3, saver3 	;   |__Salva il contenuto di tutti i registri
	st	r4, saver4 	;   |
	st	r5, saver5 	;   |
	st	r6, saver6 	;   |
	st	r7, saver7 	; __|
;-------------------------------------------------------------------------------------------
	and	r4, r4, #0	; pulisce r4              
	st	r4, PCS		; pulisce PCS
;-------------------------------------------------------------------------------------------
	ldr	r1, r0, 0	; carica in r1 l'intero da esaminare
	brz	ZERO		; se il numero è 0 vai a ZERO
	brp	POS  		; se il numero è positivo vai a POS
	brn	NEG  		; se il contenuto è negativo vai a NEG
;-------------------------------------------------------------------------------------------
ZERO	ld	r0, ASCII0 	; carica in r0 il codice ascii dello 0
	trap	x21		; chiama il sottoprogramma che stampa un carattere
	brnzp	REGREC		; salta al ripristino dei registri
;-------------------------------------------------------------------------------------------
NEG	ld	r2, MENO	; carica in r2 il codice ascii del "-"
	st	r2, SEGNO	; memorizza in SEGNO il "-"
	not	r1, r1
	add	r1,r1,#1	; complemento a 2 del numero da convertire
	brnzp	CONV		; salta a inizio conversione
;-------------------------------------------------------------------------------------------
POS	ld	r2, PIU		; carica in r2 il codice ascii del "+"
	st	r2, SEGNO	; memorizza in SEGNO il "+"
;-------------------------------------------------------------------------------------------
CONV	lea 	r3, VALORI	; carica in r3 il valore dell'indirizzo di valori
	lea	r4, POSIZIONE	; carica in r4 il valore dell'indirizzo di posizione
	ld	r5, COUNTER	; inizializza il counter

LOOP1	ldr	r2, r3, #0	; carica in r2 il valore da sottrarre
	and	r6, r6, #0	; pulisce r6

LOOP2	add	r1, r1, r2	; sottrae dall'intero il valore
	brn	CHCFR		; se negativo vai a chcfr
	add	r6, r6, #1	; incrementa r6
	brnzp	LOOP2		; torna a loop2

CHCFR	not	r2, r2
	add	r2, r2, #1	; complemento a 2 del valore
	add	r1, r1, r2	; fa tornare positivo l'intero da esaminare
	str	r6, r4, #0	; salva r6 nella cella puntata da r4
	add	r5, r5, #-1	; decrementa il counter
	brz	STAMPA		; ha finito le cifre? se sì va a stamparle
	add	r3, r3, #1
	add	r4, r4, #1	; altrimenti incrementa i 2 registri
	brnzp	LOOP1		; e torna a loop1
;-------------------------------------------------------------------------------------------
STAMPA	ld	r0, SEGNO	; carica il segno dell'intero in r0
	trap	x21		; stampa il segno
	ld	r1, ASCII0	; carica in r1 il codice ascii di 0
	lea	r4, POSIZIONE	; carica l'indirizzo della prima cifra da stampare
	ld	r5, COUNTER	; inizializza il counter

LOOP3	ldr	r0, r4, #0	; carica la cifra in r0
	brz     CONTROL		; se zero passa al controllo del flag
	st	r0, PCS		; rende diverso da 0 il flag PCS
	add	r0, r0, r1	; somma a r0 il codice ascii di 0
	trap	x21		; stampa la cifra
	brnzp	INC

CONTROL	ld	r2, PCS		; carica il flag di controllo in r2
	brz	INC		; se è zero passa alla cifra successiva
	ld	r0, ASCII0	; altrimenti carica in r0 il codice ascii di 0
	trap	x21		; e lo stampa

INC	add	r5, r5, #-1	; decrementa il counter
	brz	REGREC		; se ha finito va a regrec
	add	r4, r4, #1	; altrimenti incrementa r4
	brnzp	LOOP3		; e va a loop3
;-------------------------------------------------------------------------------------------
REGREC	ld	r0, saver0	; --
	ld	r1, saver1	;  |
	ld	r2, saver2	;  |
	ld	r3, saver3	;  | Ripristina il contenuto di tutti i registri
	ld	r4, saver4	;  |
	ld	r5, saver5	;  |
	ld	r6, saver6	;  |
	ld	r7, saver7	; --

	ret			; ritorna al programma chiamante



;-------------------------------------------------------------------------------------------
;-------------------------I-N-I-Z-I-O-----A-R-E-A-----D-A-T-I-------------------------------
;-------------------------------------------------------------------------------------------

saver0		.blkw	1
saver1		.blkw	1
saver2		.blkw	1
saver3		.blkw	1
saver4		.blkw	1
saver5		.blkw	1
saver6		.blkw	1
saver7		.blkw	1

VALORI  	.fill	#-10000
		.fill	#-1000
		.fill	#-100
		.fill	#-10
		.fill	#-1

SEGNO		.blkw	1
POSIZIONE	.blkw	1
		.blkw	1
		.blkw	1
		.blkw	1
		.blkw	1

PCS		.blkw	1
ASCII0		.fill	#48
PIU		.fill	#43
MENO		.fill	#45
COUNTER         .fill   #5

.end
