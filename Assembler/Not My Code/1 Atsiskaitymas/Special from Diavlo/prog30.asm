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
	ilgis DB 'Eilutes ilgis: $'
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
	MOV	dl, '0'
	MOV	dh, '9'

tikrinimas: ;tikrinam ar buvo ivestas nors 1 simbolis
	CMP	cl, 0
	MOV	ah, 9
	JNE ciklas
	MOV	dx, offset errormsg
	INT	21h			;spausdiname rezultato þinutæ
	JMP pabaiga


ciklas:
	MOV dl, [bx]
	CMP	dl, ' '		;jei einamasis simbolis maþesnis uþ 'A'
	JNE	spausdinti		;tokiu atveju tai ne didþioji raidë
	
	MOV	ah, 9
	MOV	dx, offset enteris
	INT	21h			
	

nekeisti:
	INC	bx			;perstumiame adresà vienu baitu á prieká -
					;á kità nuskaitytà simbolá
	DEC	cl			;sumaþiname simboliø, kuriuos reikia perþiûrëti, skaièiø
	CMP	cl, 0			;jei dar yra simboliø, kuriuos reikia perþiûrëti
	JNE	ciklas			;einam á ciklas	
	MOV	ah, 9
	MOV	dx, offset enteris
	INT	21h			;kursorius nukeliamas á naujà eilutæ
	MOV	dx, offset ilgis
	INT	21h
	JMP tes
	
	
spausdinti:
	MOV	ah, 2
	MOV	dx, [ds:bx]
	INT	21h			
	JMP nekeisti

	
tes:
	XOR ax,ax
	XOR bx,bx
	XOR cx,cx
	MOV al, nuskaite
	MOV cl, 10
	MOV	cx, 10		;kadangi naudojam dešimtaine sistema, tai dalinsim iš 10
	PUSH	"$$"		;kad spausdindami skaitmenis iš steko, galetume rasti pabaiga

 Dalink:
	MOV	dx, 0		;tiesiog išvalom registra, nes jis dalyvaus dalyboje
	DIV	cx		;[DX,AX]:10 = AX(liek DX)
	PUSH	dx		;idedam skaitmeni i steka; deja, negalime ideti 1 baito
	CMP	ax, 0		;ar dar neperskaiteme viso skaiciaus?
	JA	Dalink		;jei ne, skaitom toliau

	;pradedam skaiciaus spausdinima
	MOV	ah, 2		;i AH irašom simbolio spausdinimo dosines funkcijos numeri
 Spausdink:
	POP	dx		;išimam skaitmeni iš steko
	CMP	dx, "$$"	;ar išspausdinome visa skaiciu?
	JE	Pabaiga		;jei taip, reikia baigti darba
	ADD	dl, '0'		;liekanos jaunesnysis baitas - tai vienas skaitmuo; prideje simbolini 0 iš skaiciaus (pvz.: 1) gausime simboli ('1')
	INT	21h		;jei ne, spausdinam skaitmeni
	JMP	Spausdink	;spausdink kita skaitmeni
	


pabaiga:
	MOV	ah, 4Ch			;reikalinga kiekvienos programos pabaigoj
	MOV	al, 0			;reikalinga kiekvienos programos pabaigoj
	INT	21h			;reikalinga kiekvienos programos pabaigoj
	


END	Pradzia