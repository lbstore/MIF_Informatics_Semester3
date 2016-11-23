;***************************************************************
; Programa pakeièianti didþiàsias raides maþosiomis
;***************************************************************

.model small

buferioDydis	EQU	121
					
.stack 100h

.data
	;eilutës nuskaitymo buferis
	bufDydis DB  buferioDydis		;kiek maksimaliai simboliø galima nuskaityti
	nuskaite DB  ?				;èia bus patalpinta, kiek simboliø nuskaityta
	buferis	 DB  buferioDydis dup (?)	;èia bus talpinami nuskaityti simboliai

	;kiti duomenys
		 DB  ?
	rezult	 DB  'Rezultatas yra : $'
	ivesk	 DB  'Iveskite eilute: $'
	enteris  DB  13, 10, '$'
	errormsg DB	 'Nebuvo ivestas nei vienas simbolis! $'

.code

Pradzia:
	MOV	ax, @data		;reikalinga kiekvienos programos pradþioj
	MOV	ds, ax			;reikalinga kiekvienos programos pradþioj

;****nuskaito eilute****
	MOV	ah, 9
	MOV	dx, offset ivesk
	INT	21h			;spausdinamas praðymas ávesti eilutæ

	MOV	ah, 0Ah
	MOV	dx, offset bufDydis
	INT	21h			;nuskaitoma ávesta eilutë

	MOV	ah, 9
	MOV	dx, offset enteris
	INT	21h			;kursorius nukeliamas á naujà eilutæ

;****algoritmas****
	XOR	ax, ax			;nunulinamas ax
	MOV	cl, nuskaite		;á cl ádedama kiek simboliø buvo nuskaityta
					;cl - kiek simboliø liko perþiûrëti
	MOV	bx, offset buferis	;á bx ádedamas pirmojo nuskaityto simbolio adresas
					;bx - einamojo simbolio adresas
	MOV	dl, 'A'
	MOV	dh, 'Z'

tikrinimas: ;tikrinam ar buvo ivestas nors 1 simbolis
	CMP	cl, 0
	MOV	ah, 9
	JNE ciklas
	MOV	dx, offset errormsg
	INT	21h			;spausdiname rezultato þinutæ
	JE pabaiga


ciklas:
	CMP	[ds:bx], dl		;jei einamasis simbolis maþesnis uþ 'A'
	JB	nekeisti		;tokiu atveju tai ne didþioji raidë
	CMP	[ds:bx], dh		;jei einamasis simbolis didesnis uþ 'Z'
	JA	nekeisti		;tokiu atveju tai ne didþioji raidë
	ADD	byte ptr [ds:bx], 20h	;prieðingu atveju keièiame didþiàjà raidæ á maþàjà
	
nekeisti:
	INC	bx			;perstumiame adresà vienu baitu á prieká -
					;á kità nuskaitytà simbolá
	DEC	cl			;sumaþiname simboliø, kuriuos reikia perþiûrëti, skaièiø
	CMP	cl, 0			;jei dar yra simboliø, kuriuos reikia perþiûrëti
	JNE	ciklas			;einam á ciklas	
	MOV byte ptr [ds:bx], '$'	;buferio gale áraðome '$'

	MOV	ah, 9
	MOV	dx, offset rezult
	INT	21h			;spausdiname rezultato þinutæ

	MOV	ah, 9
	MOV	dx, offset buferis
	INT	21h			;spausdiname pakeistà ávestàjà eilutæ

pabaiga:
	MOV	ah, 4Ch			;reikalinga kiekvienos programos pabaigoj
	MOV	al, 0			;reikalinga kiekvienos programos pabaigoj
	INT	21h			;reikalinga kiekvienos programos pabaigoj
	


END	Pradzia