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
	nulis DB 'nulis$'
	vienas DB 'vienas$'
	du DB 'du$'
	trys DB 'trys$'
	keturi DB 'keturi$'
	penki DB 'penki$'
	sesi DB 'sesi$'
	septyni DB 'septyni$'
	astuoni DB 'astuoni$'
	devyni DB 'devyni$'

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
	CMP	dl, '0'		
	JB	spausdinti		
	CMP	dl, '9'	
	JA	spausdinti		
	CMP	dl, '0'
	JE nuli
	CMP	dl, '1'
	JE viena
	CMP	dl, '2'
	JE d
	CMP	dl, '3'
	JE try
	CMP	dl, '4'
	JE ketur
	CMP	dl, '5'
	JE penk
	CMP	dl, '6'
	JE ses
	CMP	dl, '7'
	JE septyn
	CMP	dl, '8'
	JE astuon
	CMP	dl, '9'
	JE devyn
	

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
	INT	21h			;kursorius nukeliamas á naujà eilutæ
	JMP nekeisti
	
nuli:
	MOV	ah, 9
	MOV	dx, offset nulis
	INT	21h			;kursorius nukeliamas á naujà eilutæ
	JMP nekeisti
	
viena:
	MOV	ah, 9
	MOV	dx, offset vienas
	INT	21h			;kursorius nukeliamas á naujà eilutæ
	JMP nekeisti
	
d:
	MOV	ah, 9
	MOV	dx, offset du
	INT	21h			;kursorius nukeliamas á naujà eilutæ
	JMP nekeisti
	
try:
	MOV	ah, 9
	MOV	dx, offset trys
	INT	21h			;kursorius nukeliamas á naujà eilutæ
	JMP nekeisti
	
ketur:
	MOV	ah, 9
	MOV	dx, offset keturi
	INT	21h			;kursorius nukeliamas á naujà eilutæ
	JMP nekeisti
	
penk:
	MOV	ah, 9
	MOV	dx, offset penki
	INT	21h			;kursorius nukeliamas á naujà eilutæ
	JMP nekeisti
	
ses:
	MOV	ah, 9
	MOV	dx, offset sesi
	INT	21h			;kursorius nukeliamas á naujà eilutæ
	JMP nekeisti
	
septyn:
	MOV	ah, 9
	MOV	dx, offset septyni
	INT	21h			;kursorius nukeliamas á naujà eilutæ
	JMP nekeisti
	
astuon:
	MOV	ah, 9
	MOV	dx, offset astuoni
	INT	21h			;kursorius nukeliamas á naujà eilutæ
	JMP nekeisti
	
devyn:
	MOV	ah, 9
	MOV	dx, offset devyni
	INT	21h			;kursorius nukeliamas á naujà eilutæ
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