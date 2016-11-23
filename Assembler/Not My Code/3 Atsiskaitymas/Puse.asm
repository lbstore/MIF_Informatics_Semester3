;***************************************************************
; Programa, perrašanti 1 pertraukimo apdorojimo procedūrą; procedūra atpažįsta komandą MOV ir išveda į ekraną jos bitą w
;***************************************************************

.model small

.stack 100h

.data
	PranMOV	db "Komanda CALL$"
	Enteris db 13, 10, "$"
	PranNe	db "Komanda ne CALL", 13, 10, "$"

.code
  Pradzia:
	MOV	ax, @data	;reikalinga kiekvienos programos pradžioj
	MOV	ds, ax		;reikalinga kiekvienos programos pradžioj
	
;****************************************************************************
; Nusistatom reikalingas registrų reikšmes
;****************************************************************************
	MOV	ax, 0		;nėra komandos MOV es, 0 - tai reikia daryti per darbinį registrą (ax)
	MOV	es, ax		;į es įsirašome 0, nes pertraukimų vektorių lentelė yra segmente, kurio pradžios adresas yra 00000
	MOV	bx, 16		; A) į bx įsirašome pertraukimo apdorojimo procedūros adreso poslinkį nuo 0000 segmento pradžios

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
; Testuojame pertraukimo apdorojimo procedūrą (A)
;****************************************************************************
	INT	4		;Čia iškviečiama pertraukimo apdorojimo procedūra
	MOV	ax, bx		;Šitą komandą prieš tai iškviesta pertraukimo apdorojimo procedūra nagrinės
	INT 4
	CALL Testas
	INT 4
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
	;Įdedame registrų reikšmes į steką (B)
	PUSH	ax
	PUSH	bx
	PUSH	cx
	PUSH	dx
	PUSH	si
	PUSH	di
	PUSH	bp
	PUSH	es
	PUSH	ds

	; Nunulinam (B)
	XOR ax, ax
	XOR bx, bx
	XOR cx, cx
	XOR dx, dx
	XOR si, si
	XOR di, di 
	XOR bp, bp
	
	;Nustatome DS reikšmę, jei pertraukimą iškviestų kita programa
	MOV	ax, @data
	MOV	ds, ax

	;Į registrą DL įsirašom komandos, prieš kurią buvo iškviestas INT, operacijos kodą
	MOV bp, sp		;Darbui su steku patogiausia naudoti registrq BP
	ADD bp, 18		;Suskaičiuojame kaip giliai steke yra įdėtas grįžimo adresas
	MOV bx, [bp]		;Į bx įdedame grįžimo adreso poslinkį nuo segmento pradžios (IP)
	MOV es, [bp+2]		;Į es įdedame grįžimo adreso segmentą (CS)
	MOV dl, [es:bx]		;Išimame pirmąjį baitą, esantį grįžimo adresu - komandos OPK
	
	;Tikriname, ar INT buvo iškviestas prieš komandą CALL
	CMP dl, 0E8h		;Ar tai CALL vidinis tiesioginis
	JE  callKom
	CMP dl, 9Ah			;Ar tai CALL isorinis tiesioginis
	JE	callKom

	
	;Jei INT buvo iškviestas ne prieš komandą MOV, tai išvedame pranešimą
	MOV ah, 9
	MOV dx, offset PranNe
	INT 21h
	JMP pabaiga

	;Jei INT buvo iškviestas prieš komandą CALL, tai atspauzdiname pranesima
callKom:
	MOV ah, 9
	MOV dx, offset PranMOV
	INT 21h
	
	MOV ah, 9
	MOV dx, offset enteris
	INT 21h

	;Atstatome registrų reikšmes ir išeiname iš pertraukimo apdorojimo procedūros
Pabaiga:
	POP ds
	POP es
	POP bp
	POP di
	POP si
	POP	dx
	POP	cx
	POP bx
	POP	ax
	IRET			;pabaigoje būtina naudoti grįžimo iš pertraukimo apdorojimo procedūros komandą IRET
				;paprastas RET netinka, nes per mažai informacijos išima iš steko
	
ApdorokPertr ENDP

PROC Testas
  
  RET
  
Testas ENDP

END Pradzia