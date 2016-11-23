;***************************************************************
; Programa, perrašanti 1 pertraukimo apdorojimo procedūrą; procedūra atpažįsta komandą MOV ir išveda į ekraną jos bitą w
;***************************************************************

.model small

.stack 100h

.data
	PranMOV	db "Komanda MOV, w= $"
	Enteris db 13, 10, "$"
	PranNe	db "Komanda ne MOV", 13, 10, "$"

.code
  Pradzia:
	MOV	ax, @data	;reikalinga kiekvienos programos pradžioj
	MOV	ds, ax		;reikalinga kiekvienos programos pradžioj

;****************************************************************************
; Nusistatom reikalingas registrų reikšmes
;****************************************************************************
	MOV	ax, 0		;nėra komandos MOV es, 0 - tai reikia daryti per darbinį registrą (ax)
	MOV	es, ax		;į es įsirašome 0, nes pertraukimų vektorių lentelė yra segmente, kurio pradžios adresas yra 00000
	MOV	bx, 4		;į bx įsirašome pertraukimo apdorojimo procedūros adreso poslinkį nuo 0000 segmento pradžios

;****************************************************************************
; Iššisaugome tikrą pertraukimo apdorojimo procedūros adresą, kad programos gale galėtume jį atstatyti
;****************************************************************************
	PUSH	es:[bx]
	PUSH	es:[bx+2]
	
;****************************************************************************
; Pertraukimų vektorių lentelėje suformuojame pertraukimo apdorojimo procedūros adresą
;****************************************************************************
	MOV	dx, offset ApdorokPertr	;į dx įrašome naujos pertraukimo apdorojimo procedūros poslinkį nuo kodo segmento pradžios
	MOV	es:[bx], dx		;į pertraukimų vektorių lentelę įrašome pertraukimo apdorojimo procedūros poslinkį
	MOV	es:[bx+2], cs		;į pertraukimų vektorių lentelę įrašome pertraukimo apdorojimo procedūros segmentą

;****************************************************************************
; Testuojame pertraukimo apdorojimo procedūrą
;****************************************************************************
	INT	1		;Čia iškviečiama pertraukimo apdorojimo procedūra
	MOV	ax, bx		;Šitą komandą prieš tai iškviesta pertraukimo apdorojimo procedūra nagrinės
	INT 1
	MOV	ax, cs
	INT 1
	MOV	al, [0000]
	INT 1
	INC ax

;****************************************************************************
; Atstatome tikrą pertraukimo apdorojimo programos adresą pertraukimų vektoriuje
;****************************************************************************
	POP	es:[bx+2]
	POP	es:[bx]

	MOV	ah, 4Ch		;reikalinga kiekvienos programos pabaigoj
	MOV	al, 0		;reikalinga kiekvienos programos pabaigoj
	INT	21h		;reikalinga kiekvienos programos pabaigoj

;****************************************************************************
; Pertraukimo apdorojimo procedūra
;****************************************************************************
  PROC ApdorokPertr
	;Įdedame registrų reikšmes į steką
	PUSH	ax
	PUSH	bx
	PUSH	dx
	PUSH	bp
	PUSH	es
	PUSH	ds

	;Nustatome DS reikšmę, jei pertraukimą iškviestų kita programa
	MOV	ax, @data
	MOV	ds, ax

	;Į registrą DL įsirašom komandos, prieš kurią buvo iškviestas INT, operacijos kodą
	MOV bp, sp		;Darbui su steku patogiausia naudoti registrq BP
	ADD bp, 12		;Suskaičiuojame kaip giliai steke yra įdėtas grįžimo adresas
	MOV bx, [bp]		;Į bx įdedame grįžimo adreso poslinkį nuo segmento pradžios (IP)
	MOV es, [bp+2]		;Į es įdedame grįžimo adreso segmentą (CS)
	MOV dl, [es:bx]		;Išimame pirmąjį baitą, esantį grįžimo adresu - komandos OPK
	
	;Tikriname, ar INT buvo iškviestas prieš komandą MOV
	MOV al, dl
	AND al, 0FCh		;Tikriname pagal pirmus 6 OPK bitus
	CMP al, 88h		;Ar tai MOV registras <--> registras / atmintis - 1000 10dw
	JE  mov1
	MOV al, dl
	AND al, 0FEh		;Tikriname pagal pirmus 7 OPK bitus
	CMP al, 0C6h		;Ar tai MOV registras / atmintis <- betarpiškas operandas - 1100 011w
	JE 	mov1
	CMP al, 0A0h		;Ar tai MOV akumuliatorius <- atmintis - 1010 000w
	JE	mov1
	CMP al, 0A2h		;Ar tai MOV atmintis <- akumuliatorius - 1010 001w
	JE	mov1
	MOV al, dl
	AND al, 0F0h		;Tikriname pagal pirmus 4 bitus
	CMP al, 0B0h		;Ar tai MOV registras <- betarpiškas operandas - 1011 wreg
	JE	mov2
	MOV al, dl
	AND al, 0FDh		;Tikriname pagal pirmus 6 bitus ir paskutinįjį bitą
	CMP al, 8Ch		;Ar tai MOV registras / atmintis <--> segmento registras - 1000 11d0
	JE	mov3
	
	;Jei INT buvo iškviestas ne prieš komandą MOV, tai išvedame pranešimą
	MOV ah, 9
	MOV dx, offset PranNe
	INT 21h
	JMP pabaiga

	;Jei INT buvo iškviestas prieš komandą MOV, tai tada dl registre suformuojame bito w reikšmę
Mov1:
	AND dl, 1		;Šiuo atveju w yra paskutinis bitas, taigi išvalom kitus bitus
	ADD dl, 30h		;Padarom ASCII kodq
	JMP Spausdink
Mov2:
	SHR dl, 3		;Šiuo atveju w yra ketvirtas bitas iš dešinės, padarom, kad jis būtų paskutinis
	JMP Mov1		;ir elgiamės taip pat kaip ir Mov1 atveju
Mov3:
	MOV dl, 31h		;Šiuo atveju w bito nėra, bet galima laikyti, kad w=1, nes visada veiksmai atliekami su žodžio dydžio registrais

	;Išvedame pranešimą ir bito w reikšmę
Spausdink:
	PUSH dx		;Registre dl suformuota bito w reikšmė, todėl, kad jos nesugadintume, išsaugome į steką
	MOV ah, 9
	MOV dx, offset PranMOV
	INT 21h
	
	MOV ah, 2
	POP dx
	INT 21h
	
	MOV ah, 9
	MOV dx, offset enteris
	INT 21h

	;Atstatome registrų reikšmes ir išeiname iš pertraukimo apdorojimo procedūros
Pabaiga:
	POP ds
	POP es
	POP bp
	POP	dx
	POP bx
	POP	ax
	IRET			;pabaigoje būtina naudoti grįžimo iš pertraukimo apdorojimo procedūros komandą IRET
				;paprastas RET netinka, nes per mažai informacijos išima iš steko
	
ApdorokPertr ENDP

END Pradzia