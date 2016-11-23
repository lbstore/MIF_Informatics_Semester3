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
	ivesk	 DB  'Iveskite 10-taini skaiciu: $'
	enteris  DB  13, 10, '$'
	errormsg DB	 'Pasitikrinkite ar gerai suvedete duomenis! :D $'
	form	 DB  '16-tainiu formatu: $'

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
					

					
					

tikrinimas: ;tikrinam ar buvo ivestas nors 1 simbolis
	CMP	cl, 0
	MOV	ah, 9
	JNE ciklas0
	MOV	dx, offset errormsg
	INT	21h			;spausdiname rezultato þinutæ
	JE pabaiga
	
klaida:
	MOV	ah, 9
	MOV	dx, offset errormsg
	INT	21h			;spausdiname rezultato þinutæ
	JMP pabaiga
ciklas0:
	PUSH ax
	PUSH dx
	XOR ax,ax
	XOR dx,dx
	JMP ciklas
	

ciklas:
	MOV dh,0Ah
	MUL dh
	MOV	dl,[ds:bx]	
	cmp dl, '0'
	JB klaida
	cmp dl, '9'
	JA klaida
	
	SUB dl,30h
	ADD al,dl
	
ciklas2:	
	INC	bx			;perstumiame adresà vienu baitu á prieká -
					;á kità nuskaitytà simbolá
	DEC	cl			;sumaþiname simboliø, kuriuos reikia perþiûrëti, skaièiø
	CMP	cl, 0			;jei dar yra simboliø, kuriuos reikia perþiûrëti
	JNE	ciklas			;einam á ciklas	
	
	MOV cx, 16
	PUSH '$$'
	
Dalink:
	MOV	dx, 0		;tiesiog iðvalom registrà, nes jis dalyvaus dalyboje
	DIV	cx		;[DX,AX]:10 = AX(liek DX)
	PUSH	dx		;ádedam skaitmená á stekà; deja, negalime idëti 1 baito
	CMP	ax, 0		;ar dar neperskaitëme viso skaièiaus?
	JA	Dalink		;jei ne, skaitom toliau

	;pradedam skaièiaus spausdinimà
	MOV	ah, 9
	MOV	dx, offset form
	INT	21h			;kursorius nukeliamas á naujà eilutæ
	MOV	ah, 2		;i AH áraðom simbolio spausdinimo dosinës funkcijos numerá
Spausdink:
  	POP	dx		;iðimam skaitmená ið steko
	CMP	dx, "$$"	;ar iðspausdinome visà skaièiø?
	JE	Pabaiga		;jei taip, reikia baigti darbà
	CMP dx, 9
	JNBE da
maz:
	ADD	dl, '0'		
	INT	21h		
	JMP	Spausdink	
da:
	ADD	dl, '7'		
	INT	21h	
	JMP	Spausdink	
	
	pop dx
	pop ax
	


pabaiga:
	MOV	ah, 4Ch			;reikalinga kiekvienos programos pabaigoj
	MOV	al, 0			;reikalinga kiekvienos programos pabaigoj
	INT	21h			;reikalinga kiekvienos programos pabaigoj
	


END	Pradzia