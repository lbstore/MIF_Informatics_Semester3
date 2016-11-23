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

tikrinimas: ;tikrinam ar buvo ivestas nors 1 simbolis
	CMP	cl, 0
	MOV	ah, 9
	JNE ciklas
	MOV	dx, offset errormsg
	INT	21h			;spausdiname rezultato þinutæ
	JE pabaiga


ciklas:
	PUSH cx
	XOR ax,ax
	MOV al, [ds:bx]
	MOV cl, 16
	MOV	cx, 16		;kadangi naudojam dešimtaine sistema, tai dalinsim iš 10
	PUSH	"$$"		;kad spausdindami skaitmenis iš steko, galetume rasti pabaiga

Dalink:
	MOV	dx, 0		;tiesiog iðvalom registrà, nes jis dalyvaus dalyboje
	DIV	cx		;[DX,AX]:10 = AX(liek DX)
	PUSH	dx		;ádedam skaitmená á stekà; deja, negalime idëti 1 baito
	CMP	ax, 0		;ar dar neperskaitëme viso skaièiaus?
	JA	Dalink		;jei ne, skaitom toliau

	;pradedam skaièiaus spausdinimà
	
	MOV	ah, 2		;i AH áraðom simbolio spausdinimo dosinës funkcijos numerá
Spausdink:
  	POP	dx		;iðimam skaitmená ið steko
	CMP	dx, "$$"	;ar iðspausdinome visà skaièiø?
	JE	ciklas2	;jei taip, reikia baigti darbà
	CMP dx, 9
	JNBE da
maz:
	ADD	dl, '0'		;liekanos jaunesnysis baitas - tai vienas skaitmuo; pridejæ simbolini 0 ið skaièiaus (pvz.: 1) gausime simbolá ('1')
	INT	21h		;jei ne, spausdinam skaitmená
	JMP	Spausdink	;spausdink kità skaitmená
da:
	ADD	dl, '7'		;liekanos jaunesnysis baitas - tai vienas skaitmuo; pridejæ simbolini 0 ið skaièiaus (pvz.: 1) gausime simbolá ('1')
	INT	21h		;jei ne, spausdinam skaitmená
	JMP	Spausdink	;spausdink kità skaitmená
	
	
	
ciklas2:
	MOV	ah, 2			;reikalinga kiekvienos programos pabaigoj
	MOV	dx, " "			;reikalinga kiekvienos programos pabaigoj
	INT	21h			;reikalinga kiekvienos programos pabaigoj
	POP cx
	INC	bx			;perstumiame adresà vienu baitu á prieká -
					;á kità nuskaitytà simbolá
	DEC	cl			;sumaþiname simboliø, kuriuos reikia perþiûrëti, skaièiø
	CMP	cl, 0			;jei dar yra simboliø, kuriuos reikia perþiûrëti
	JNE	ciklas			;einam á ciklas	
	JE pabaiga


pabaiga:
	
	

	MOV	ah, 4Ch			;reikalinga kiekvienos programos pabaigoj
	MOV	al, 0			;reikalinga kiekvienos programos pabaigoj
	INT	21h			;reikalinga kiekvienos programos pabaigoj
	


END	Pradzia