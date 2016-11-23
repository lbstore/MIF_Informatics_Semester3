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

tikrinimas: ;tikrinam ar buvo ivestas nors 1 simbolis
	CMP	cl, 0
	MOV	ah, 9
	JNE ciklas
	MOV	dx, offset errormsg
	INT	21h			;spausdiname rezultato �inut�
	JE pabaiga


ciklas:
	PUSH cx
	XOR ax,ax
	MOV al, [ds:bx]
	MOV cl, 10
	MOV	cx, 10		;kadangi naudojam de�imtaine sistema, tai dalinsim i� 10
	PUSH	"$$"		;kad spausdindami skaitmenis i� steko, galetume rasti pabaiga

 Dalink:
	MOV	dx, 0		;tiesiog i�valom registra, nes jis dalyvaus dalyboje
	DIV	cx		;[DX,AX]:10 = AX(liek DX)
	PUSH	dx		;idedam skaitmeni i steka; deja, negalime ideti 1 baito
	CMP	ax, 0		;ar dar neperskaiteme viso skaiciaus?
	JA	Dalink		;jei ne, skaitom toliau

	;pradedam skaiciaus spausdinima
	MOV	ah, 2		;i AH ira�om simbolio spausdinimo dosines funkcijos numeri
 Spausdink:
	POP	dx		;i�imam skaitmeni i� steko
	CMP	dx, "$$"	;ar i�spausdinome visa skaiciu?
	JE	ciklas2		;jei taip, reikia baigti darba
	ADD	dl, '0'		;liekanos jaunesnysis baitas - tai vienas skaitmuo; prideje simbolini 0 i� skaiciaus (pvz.: 1) gausime simboli ('1')
	INT	21h		;jei ne, spausdinam skaitmeni
	JMP	Spausdink	;spausdink kita skaitmeni
	
	
	
ciklas2:
	MOV	ah, 2			;reikalinga kiekvienos programos pabaigoj
	MOV	dx, " "			;reikalinga kiekvienos programos pabaigoj
	INT	21h			;reikalinga kiekvienos programos pabaigoj
	POP cx
	INC	bx			;perstumiame adres� vienu baitu � priek� -
					;� kit� nuskaityt� simbol�
	DEC	cl			;suma�iname simboli�, kuriuos reikia per�i�r�ti, skai�i�
	CMP	cl, 0			;jei dar yra simboli�, kuriuos reikia per�i�r�ti
	JNE	ciklas			;einam � ciklas	
	JE pabaiga


pabaiga:
	
	

	MOV	ah, 4Ch			;reikalinga kiekvienos programos pabaigoj
	MOV	al, 0			;reikalinga kiekvienos programos pabaigoj
	INT	21h			;reikalinga kiekvienos programos pabaigoj
	


END	Pradzia