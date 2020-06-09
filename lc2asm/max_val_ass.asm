	.orig	x3000
	ld	r2,dieci
	lea	r3,table
	jsr	max_val_ass
	st	r0,result
sto_qui	brnzp	sto_qui

table	.fill	12
	.fill	-32
	.fill	45
	.fill	12
	.fill	-115
	.fill	37
	.fill	0
	.fill	89
	.fill	99
	.fill	100
result	.blkw	1
dieci	.fill	10

;**************************************************************
max_val_ass
	st	r1,saver1
	st	r4,saver4
	and	r0,r0,#0
ciclo	ldr	r1,r3,#0
	brzp	no_ch_sign
	not	r1,r1
	add	r1,r1,#1
no_ch_sign
	not	r1,r1
	add	r1,r1,#1
	add	r4,r0,r1
	brzp	no_new_max
	not	r1,r1
	add	r0,r1,#1
no_new_max
	add	r3,r3,#1
	add	r2,r2,#-1
	brp	ciclo
	ld	r1,saver1
	ld	r4,saver4
	ret

saver1	.blkw	1
saver4	.blkw	1
;***************************************************************

	.end