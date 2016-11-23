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
	buferis2	 DB  buferioDydis dup (?)

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


;nuskaitom eilute
	mov ah, 9
	mov dx, offset ivesk ;pranesimas ivesk
	INT 21h
	
	mov ah, 0Ah
	mov dx, offset bufDydis
	INT 21h		;nuskaitom ivesta eilute
	
	mov ah, 9
	mov dx, offset enteris
	INT 21h		;nauja eilute
	
;programos algoritmas

	XOR ax, ax 		;nunulinimas
	mov cl, nuskaite
	mov bx, offset buferis
	
	MOV dl, ' '
	
	
;tikrinam ar buvo ivestas nors 1 simbolis
	CMP cl, 0
	JNE ciklas
	MOV ah, 9
	MOV dx, offset errormsg
	INT 21h	
	JE pabaiga
	
ciklas:
	CMP [ds:bx], dl
	JB nekeisti
	CMP [ds:bx], dl
	JA nekeisti
	MOV byte ptr [ds:bx], dh	
nekeisti:
MOV dh, byte ptr [ds:bx]
	INC bx
	DEC cl
	CMP cl,0
	
	JNE ciklas

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