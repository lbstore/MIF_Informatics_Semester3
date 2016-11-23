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
	form	 DB  '16-tainiu formatu: $'

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
					

					
					

tikrinimas: ;tikrinam ar buvo ivestas nors 1 simbolis
	CMP	cl, 0
	MOV	ah, 9
	JNE ciklas0
	MOV	dx, offset errormsg
	INT	21h			;spausdiname rezultato �inut�
	JE pabaiga
ciklas0:
	PUSH ax
	PUSH dx
	XOR ax,ax
	XOR dx,dx
	JMP ciklas
	

ciklas:
	PUSH ax
	PUSH dx
	POP ax
	MOV dh,0Ah
	MUL dh
	PUSH ax
	POP dx
	POP ax
	MOV	al,[ds:bx]	;prie�ingu atveju kei�iame did�i�j� raid� � ma��j�
	SUB al,30h
	ADD dl,al
	
ciklas2:	
	INC	bx			;perstumiame adres� vienu baitu � priek� -
					;� kit� nuskaityt� simbol�
	DEC	cl			;suma�iname simboli�, kuriuos reikia per�i�r�ti, skai�i�
	CMP	cl, 0			;jei dar yra simboli�, kuriuos reikia per�i�r�ti
	JNE	ciklas			;einam � ciklas	
	PUSH ax
	PUSH dx
	POP ax
	POP dx
	
	MOV cx, 16
	PUSH '$$'
	
Dalink:
	MOV	dx, 0		;tiesiog i�valom registr�, nes jis dalyvaus dalyboje
	DIV	cx		;[DX,AX]:10 = AX(liek DX)
	PUSH	dx		;�dedam skaitmen� � stek�; deja, negalime id�ti 1 baito
	CMP	ax, 0		;ar dar neperskait�me viso skai�iaus?
	JA	Dalink		;jei ne, skaitom toliau

	;pradedam skai�iaus spausdinim�
	MOV	ah, 9
	MOV	dx, offset form
	INT	21h			;kursorius nukeliamas � nauj� eilut�
	MOV	ah, 2		;i AH �ra�om simbolio spausdinimo dosin�s funkcijos numer�
Spausdink:
  	POP	dx		;i�imam skaitmen� i� steko
	CMP	dx, "$$"	;ar i�spausdinome vis� skai�i�?
	JE	Pabaiga		;jei taip, reikia baigti darb�
	CMP dx, 9
	JNBE da
maz:
	ADD	dl, '0'		;liekanos jaunesnysis baitas - tai vienas skaitmuo; pridej� simbolini 0 i� skai�iaus (pvz.: 1) gausime simbol� ('1')
	INT	21h		;jei ne, spausdinam skaitmen�
	JMP	Spausdink	;spausdink kit� skaitmen�
da:
	ADD	dl, '7'		;liekanos jaunesnysis baitas - tai vienas skaitmuo; pridej� simbolini 0 i� skai�iaus (pvz.: 1) gausime simbol� ('1')
	INT	21h		;jei ne, spausdinam skaitmen�
	JMP	Spausdink	;spausdink kit� skaitmen�
	
	pop dx
	pop ax
	


pabaiga:
	MOV	ah, 4Ch			;reikalinga kiekvienos programos pabaigoj
	MOV	al, 0			;reikalinga kiekvienos programos pabaigoj
	INT	21h			;reikalinga kiekvienos programos pabaigoj
	


END	Pradzia