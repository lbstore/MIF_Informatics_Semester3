;***************************************************************
; Programa pakei�ianti did�i�sias raides ma�osiomis
;***************************************************************

.model small

buferioDydis	EQU	121
					
.stack 100h

.data
	;eilut�s nuskaitymo buferis
	bufDydis DB  buferioDydis		;kiek maksimaliai simboli� galima nuskaityti
	nuskaite DB  ?				;�ia bus patalpinta, kiek simboli� nuskaityta
	buferis	 DB  buferioDydis dup (?)	;�ia bus talpinami nuskaityti simboliai

	;kiti duomenys
		 DB  ?
	rezult	 DB  'Rezultatas yra : $'
	ivesk	 DB  'Iveskite eilute: $'
	enteris  DB  13, 10, '$'
	errormsg DB	 'Nebuvo ivestas nei vienas simbolis! $'

.code

Pradzia:
	MOV	ax, @data		;reikalinga kiekvienos programos prad�ioj
	MOV	ds, ax			;reikalinga kiekvienos programos prad�ioj

;****nuskaito eilute****
	MOV	ah, 9
	MOV	dx, offset ivesk
	INT	21h			;spausdinamas pra�ymas �vesti eilut�

	MOV	ah, 0Ah
	MOV	dx, offset bufDydis
	INT	21h			;nuskaitoma �vesta eilut�

	MOV	ah, 9
	MOV	dx, offset enteris
	INT	21h			;kursorius nukeliamas � nauj� eilut�

;****algoritmas****
	XOR	ax, ax			;nunulinamas ax
	MOV	cl, nuskaite		;� cl �dedama kiek simboli� buvo nuskaityta
					;cl - kiek simboli� liko per�i�r�ti
	MOV	bx, offset buferis	;� bx �dedamas pirmojo nuskaityto simbolio adresas
					;bx - einamojo simbolio adresas
	MOV	dl, 'A'
	MOV	dh, 'Z'

tikrinimas: ;tikrinam ar buvo ivestas nors 1 simbolis
	CMP	cl, 0
	MOV	ah, 9
	JNE ciklas
	MOV	dx, offset errormsg
	INT	21h			;spausdiname rezultato �inut�
	JE pabaiga


ciklas:
	CMP	[ds:bx], dl		;jei einamasis simbolis ma�esnis u� 'A'
	JB	nekeisti		;tokiu atveju tai ne did�ioji raid�
	CMP	[ds:bx], dh		;jei einamasis simbolis didesnis u� 'Z'
	JA	nekeisti		;tokiu atveju tai ne did�ioji raid�
	ADD	byte ptr [ds:bx], 20h	;prie�ingu atveju kei�iame did�i�j� raid� � ma��j�
	
nekeisti:
	INC	bx			;perstumiame adres� vienu baitu � priek� -
					;� kit� nuskaityt� simbol�
	DEC	cl			;suma�iname simboli�, kuriuos reikia per�i�r�ti, skai�i�
	CMP	cl, 0			;jei dar yra simboli�, kuriuos reikia per�i�r�ti
	JNE	ciklas			;einam � ciklas	
	MOV byte ptr [ds:bx], '$'	;buferio gale �ra�ome '$'

	MOV	ah, 9
	MOV	dx, offset rezult
	INT	21h			;spausdiname rezultato �inut�

	MOV	ah, 9
	MOV	dx, offset buferis
	INT	21h			;spausdiname pakeist� �vest�j� eilut�

pabaiga:
	MOV	ah, 4Ch			;reikalinga kiekvienos programos pabaigoj
	MOV	al, 0			;reikalinga kiekvienos programos pabaigoj
	INT	21h			;reikalinga kiekvienos programos pabaigoj
	


END	Pradzia