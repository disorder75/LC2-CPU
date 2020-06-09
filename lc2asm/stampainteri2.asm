;**********************************************
;* Sottoprogramma per la stampa a video di un *
;*    intero compreso tra -32768 e 32767      *
;*             in assembly LC2.               *
;*             by Nello Scarabottolo          *
;**********************************************


; L'indirizzo di memoria dell'intero deve 
; essere memorizzato in R0 prima della chiamata
; al sottoprogramma

	.orig	xfe00		; il sottoprogramma si trova nell'ultima pagina di memoria

	st	r0, saver0 	; --
	st	r1, saver1 	; |
        st	r2, saver2 	; |
	st	r3, saver3 	; | Salva il contenuto di tutti i registri
	st	r4, saver4 	; |
	st	r5, saver5 	; |
	st	r6, saver6 	; |
	st	r7, saver7 	; --

	and	r4, r4, #0	; pulisce r4              
	st	r4, PCS		; pulisce PCS
 
	ldr	r1, r0, 0	; carica in r1 l'intero da esaminare
	brz	ZERO		; se il numero è 0 vai a ZERO
	brp	POS  		; se il numero è positivo vai a POS
	brn	NEG  		; se il contenuto è negativo vai a NEG

ZERO	ld	r0, ASCII0 	; carica in r0 il codice ascii dello 0
	trap	x21		; chiama il sottoprogramma che stampa un carattere
	brnzp	REGREC		; salta al ripristino dei registri

NEG	ld	r2, MENO	; carica in r2 il codice ascii del "-"
	st	r2, SEGNO	; memorizza in SEGNO il "-"
	not	r1, r1
	add	r1,r1,#1	; complemento a 2 del numero da convertire
	brnzp	C10000		; salta a inizio conversione

POS	ld	r2, PIU		; carica in r2 il codice ascii del "+"
	st	r2, SEGNO	; memorizza in SEGNO il "+"

C10000	ld	r2, DIECIMILA	; carica in r2 il valore -10000
	and	r3, r3, #0	; pulisce r3
	and	r4, r4, #0	; pulisce r4
	add	r4, r1, r4	; copia r1 in r4
L10000	add	r4, r4, r2	; l'intero - 10000
	brn	C1000		; se è negativo passa a esaminare le migliaia
				; in r1 c'è la restante parte da convertire
	add	r3, r3, #1	; altrimenti incrementa r3 di 1 e torna al loop
	add	r1, r1, r2	; aggiorna r1
	brnzp	L10000

C1000	st	r3, N10000	; salva r3 nella cifra delle decine di migliaia
	ld	r2, MILLE	; carica in r2 il valore -1000
	and	r3, r3, #0	; pulisce r3
	and	r4, r4, #0	; pulisce r4
	add	r4, r1, r4	; copia r1 in r4
L1000	add	r4, r4, r2	; l'intero - 1000
	brn	C100		; se è negativo passa a esaminare le centinaia
				; in r1 c'è la restante parte da convertire
	add	r3, r3, #1	; altrimenti incrementa r3 di 1 e torna al loop
	add	r1, r1, r2	; aggiorna r1
	brnzp	L1000

C100	st	r3, N1000	; salva r3 nella cifra delle migliaia
	ld	r2, CENTO	; carica in r2 il valore -1000
	and	r3, r3, #0	; pulisce r3
	and	r4, r4, #0	; pulisce r4
	add	r4, r1, r4	; copia r1 in r4
L100	add	r4, r4, r2	; l'intero - 100
	brn	C10		; se è negativo passa a esaminare le decine
				; in r1 c'è la restante parte da convertire
	add	r3, r3, #1	; altrimenti incrementa r3 di 1 e torna al loop
	add	r1, r1, r2	; aggiorna r1
	brnzp	L100

C10	st	r3, N100	; salva r3 nella cifra delle centinaia
	ld	r2, DIECI	; carica in r2 il valore -10
	and	r3, r3, #0	; pulisce r3
	and	r4, r4, #0	; pulisce r4
	add	r4, r1, r4	; copia r1 in r4
L10	add	r4, r4, r2	; l'intero - 10
	brn	C1		; se è negativo passa a esaminare le unità
				; in r1 c'è la restante parte da convertire
	add	r3, r3, #1	; altrimenti incrementa r3 di 1 e torna al loop
	add	r1, r1, r2	; aggiorna r1
	brnzp	L10

C1	st	r3, N10		; salva r3 nella cifra delle decine
	ld	r2, UNO		; carica in r2 il valore -1
	and	r3, r3, #0	; pulisce r3
	and	r4, r4, #0	; pulisce r4
	add	r4, r1, r4	; copia r1 in r4
L1	add	r4, r4, r2	; l'intero - 1
	brn	STAMPA		; se è negativo passa a stampare il risultato
				; in r1 c'è la restante parte da convertire
	add	r3, r3, #1	; altrimenti incrementa r3 di 1 e torna al loop
	add	r1, r1, r2	; aggiorna r1
	brnzp	L1


STAMPA	st	r3, N1		; finisce di memorizzare il numero delle unità
	ld	r0, SEGNO	; carica il segno dell'intero in r0
	trap	x21		; stampa il segno
	ld	r1, ASCII0	; carica in r1 il codice ascii di 0
ST10000	ld	r0, N10000	; carica le decimigliaia
	brz	ST1000		; se zero passa alle migliaia
	st	r0, PCS		; rende diverso da 0 il flag PCS
	add	r0, r0, r1	; somma a r0 il codice ascii di 0
	trap	x21		; stampa le decimigliaia

ST1000	ld	r0, N1000	; carica le migliaia
	brz	PCS1		; se zero passa al controllo del flag
	st	r0, PCS		; rende diverso da 0 il flag PCS
	add	r0, r0, r1	; somma a r0 il codice ascii di 0
	trap	x21		; stampa le migliaia
	brnzp	ST100		; passa al controllo delle centinaia
PCS1	ld	r2, PCS		; carica il flag di controllo in r2
	brz	ST100		; se è zero passa alle centinaia
	ld	r0, ASCII0	; altrimenti carica in r0 il codice ascii di 0
	trap	x21		; e lo stampa

ST100	ld	r0, N100	; carica le centinaia
	brz	PCS2		; se zero passa al controllo del flag
	st	r0, PCS		; rende diverso da 0 il flag PCS
	add	r0, r0, r1	; somma a r0 il codice ascii di 0
	trap	x21		; stampa le centinaia
	brnzp	ST10		; passa al controllo delle decine
PCS2	ld	r2, PCS		; carica il flag di controllo in r2
	brz	ST10		; se è zero passa alle decine
	ld	r0, ASCII0	; altrimenti carica in r0 il codice ascii di 0
	trap	x21		; e lo stampa

ST10	ld	r0, N10		; carica le decine
	brz	PCS3 		; se zero passa al controllo del flag
	st	r0, PCS		; rende diverso da 0 il flag PCS
	add	r0, r0, r1	; somma a r0 il codice ascii di 0
	trap	x21		; stampa le decine
	brnzp	ST1		; passa al controllo delle unità
PCS3	ld	r2, PCS		; carica il flag di controllo in r2
	brz	ST1		; se è zero passa alle unità
	ld	r0, ASCII0	; altrimenti carica in r0 il codice ascii di 0
	trap	x21		; e lo stampa

ST1	ld	r0, N1		; carica le unità
	add	r0, r0, r1	; somma a r0 il codice ascii di 0
	trap	x21		; stampa le unità

REGREC	ld	r0, saver0	; --
	ld	r1, saver1	; |
	ld	r2, saver2	; |
	ld	r3, saver3	; | Ripristina il contenuto di tutti i registri
	ld	r4, saver4	; |
	ld	r5, saver5	; |
	ld	r6, saver6	; |
	ld	r7, saver7	; --

	ret			; ritorna al programma chiamante



;****************************
;   Inizio dell'area dati
;****************************

DIECIMILA	.fill	#-10000
MILLE		.fill	#-1000
CENTO		.fill	#-100
DIECI		.fill	#-10
UNO		.fill	#-1

ASCII0		.fill	#48
PIU		.fill	#43
MENO		.fill	#45

saver0		.blkw	1
saver1		.blkw	1
saver2		.blkw	1
saver3		.blkw	1
saver4		.blkw	1
saver5		.blkw	1
saver6		.blkw	1
saver7		.blkw	1

SEGNO		.blkw	1
N10000		.blkw	1
N1000		.blkw	1
N100		.blkw	1
N10		.blkw	1
N1		.blkw	1
PCS		.blkw	1

.end
