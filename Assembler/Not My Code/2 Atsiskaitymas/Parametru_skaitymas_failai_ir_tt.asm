;***************************************************************
; Programai perduodamas vienas paramentras per eilute - duomenu failas. 
; Programa visus skaicius pakeis i $ zenkla ir rezultata isves i ekrana bei i duom.txt faila.
;***************************************************************

.model small

skBufDydis	EQU 20			;konstanta skBufDydis (lygi 20) - skaitymo buferio dydis
raBufDydis	EQU 20			;konstanta raBufDydis (lygi 20) - rašymo buferio dydis

.stack 100h

.data
	openError	db 10, 13, "Klaida atidarant faila.", 10, 13,"$"
    duom    	db 64 dup(?)            ;duomenu; failo pavadinimas, nuskaitomas per komandine eilute
    rez			db 'duom.txt', 0		;rezultatu failo pavadinimas, nuskaitomas per komandine eilute
	skBuf		db skBufDydis dup (?)	;skaitymo buferis
	raBuf		db raBufDydis dup (?)	;rašymo buferis
	dFail		dw ?					;vieta, skirta saugoti duomenu; failo deskriptoriaus numeri; ("handle")
	rFail		dw ?					;vieta, skirta saugoti rezultato failo deskriptoriaus numeri;

.code

  start:
	MOV	ax, @data		;reikalinga kiekvienos programos pradzioj
	MOV	ds, ax			;reikalinga kiekvienos programos pradzioj

;*****************************************************
;Skaitom parametra
;*****************************************************
	
	CALL readParameter
       
;*****************************************************
;Duomenu; failo atidarymas skaitymui
;*****************************************************

	MOV	ah, 3Dh						;21h pertraukimo failo atidarymo funkcijos numeris
	MOV	al, 00						;00 - failas atidaromas skaitymui
	MOV	dx, offset duom				;vieta, kur nurodomas failo pavadinimas, pasibaigiantis nuliniu simboliu
	INT	21h							;failas atidaromas skaitymui
	JC	klaidaAtidarantSkaitymui	;jei atidarant faila; skaitymui i;vyksta klaida, nustatomas carry flag
	MOV	dFail, ax					;atmintyje išsisaugom duomenu; failo deskriptoriaus numeri;

;*****************************************************
;Rezultato failo sukurimas ir atidarymas rašymui
;*****************************************************

	MOV	ah, 3Ch						;21h pertraukimo failo suku-rimo funkcijos numeris
	MOV	cx, 0						;kuriamo failo atributai
	MOV	dx, offset rez				;vieta, kur nurodomas failo pavadinimas, pasibaigiantis nuliniu simboliu
	INT	21h							;sukuriamas failas; jei failas jau egzistuoja, visa jo informacija ištrinama
	JC	klaidaAtidarantRasymui		;jei kuriant faila; skaitymui i;vyksta klaida, nustatomas carry flag
	MOV	rFail, ax					;atmintyje išsisaugom rezultato failo deskriptoriaus numeri;

;*****************************************************
;Duomenu; nuskaitymas iš failo
;*****************************************************

  skaityk:
	MOV	bx, dFail			;i bx irašom duomenu failo deskriptoriaus numeri;
	CALL SkaitykBuf			;iškvieciame skaitymo iš failo procedura;
	CMP	ax, 0				;ax irašoma, kiek baitu buvo nuskaityta, jeigu 0 - pasiekta failo pabaiga
	JE	uzdarytiRasymui

;*****************************************************
;Darbas su nuskaityta informacija
;*****************************************************
	MOV	cx, ax
	MOV	si, offset skBuf
	MOV	di, offset raBuf
  dirbk:
	MOV	dl, [si]
	CMP dl, '0'
	JB	tesk
	CMP dl, '9'
	JA	tesk
	MOV dl, '$'
  tesk:
	MOV	[di], dl
	INC	si
	INC	di
	LOOP	dirbk

;*****************************************************
;Rezultato irašymas i faila;
;*****************************************************
	MOV	cx, ax				;cx - kiek baitu; reikia irašyti
	CALL printToOutput
	MOV	bx, rFail			;i bx irašom rezultato failo deskriptoriaus numeri;
	CALL	RasykBuf		;iškviec(iame rašymo i faila procedura;
	CMP	ax, raBufDydis		;jeigu vyko darbas su pilnu buferiu -> iš duomenu faila buvo nuskaitytas pilnas buferis ->
	JE	skaityk				;-> reikia skaityti toliau

;*****************************************************
;Rezultato failo uždarymas
;*****************************************************

  uzdarytiRasymui:
	MOV	ah, 3Eh				;21h pertraukimo failo uždarymo funkcijos numeris
	MOV	bx, rFail			;i; bx i;rašom rezultato failo deskriptoriaus numeri;
	INT	21h				;failo uždarymas
	JC	klaidaUzdarantRasymui		;jei uždarant faila; i;vyksta klaida, nustatomas carry flag

;*****************************************************
;Duomenu failo uždarymas
;*****************************************************

  uzdarytiSkaitymui:
	MOV	ah, 3Eh				;21h pertraukimo failo uždarymo funkcijos numeris
	MOV	bx, dFail			;i; bx irašom duomenu; failo deskriptoriaus numeri;
	INT	21h				;failo uždarymas
	JC	klaidaUzdarantSkaitymui		;jei uždarant faila; i;vyksta klaida, nustatomas carry flag

  pabaiga:
	MOV	ah, 4Ch				;reikalinga kiekvienos programos pabaigoj
	MOV	al, 0				;reikalinga kiekvienos programos pabaigoj
	INT	21h				;reikalinga kiekvienos programos pabaigoj

;*****************************************************
;Klaidu; apdorojimas
;*****************************************************

  klaidaAtidarantSkaitymui:
	MOV	ah, 09h				;i ah irašau dosinio pertraukimo funkcijos numeri;
	LEA	dx, openError		;i dx irašau nuoroda i spausdinamo teksto pradžia;
	INT	21h					;iškvieciu dosini pertraukima - spausdinu pranešima;
	JMP	pabaiga
  klaidaAtidarantRasymui:
	;<klaidos pranešimo išvedimo kodas>
	JMP	uzdarytiSkaitymui
  klaidaUzdarantRasymui:
	;<klaidos pranešimo išvedimo kodas>
	JMP	uzdarytiSkaitymui
  klaidaUzdarantSkaitymui:
	;<klaidos pranešimo išvedimo kodas>
	JMP	pabaiga

;*****************************************************
;Procedura nuskaitanti informacija iš failo
;*****************************************************
PROC SkaitykBuf
;i; BX paduodamas failo deskriptoriaus numeris
;i; AX bus gra;žinta, kiek simboliu; nuskaityta

	PUSH	cx
	PUSH	dx

	MOV	ah, 3Fh			;21h pertraukimo duomenu; nuskaitymo funkcijos numeris
	MOV	cl, skBufDydis		;cx - kiek baitu; reikia nuskaityti iš failo
	MOV	ch, 0			;išvalom vyresniji; cx baita;
	MOV	dx, offset skBuf	;vieta, i kuria irašoma nuskaityta informacija
	INT	21h			;skaitymas iš failo
	JC	klaidaSkaitant		;jei skaitant iš failo ivyksta klaida, nustatomas carry flag

  SkaitykBufPabaiga:
	POP	dx
	POP	cx
	RET

  klaidaSkaitant:
	;<klaidos pranešimo išvedimo kodas>
	MOV     ax, 0			;Pažymime registre ax, kad nebuvo nuskaityta ne. vieno simbolio
	JMP	SkaitykBufPabaiga
SkaitykBuf ENDP

;*****************************************************
;Procedura, irašanti buferi i faila;
;*****************************************************
PROC RasykBuf
;i; BX paduodamas failo deskriptoriaus numeris
;i; CX - kiek baitu; irašyti
;i; AX bus gražinta, kiek baitu; buvo irašyta
	PUSH	dx

	MOV	ah, 40h				;21h pertraukimo duomenu i;rašymo funkcijos numeris
	MOV	dx, offset raBuf	;vieta, iš kurios rašom i faila;
	INT	21h					;rašymas i faila;
	JC	klaidaRasant		;jei rašant i faila; i;vyksta klaida, nustatomas carry flag
	CMP	cx, ax				;jei cx nelygus ax, vadinasi buvo i;rašyta tik dalis informacijos
	JNE	dalinisIrasymas

  RasykBufPabaiga:
	POP	dx
	RET

  dalinisIrasymas:
	;<klaidos pranešimo išvedimo kodas>
	JMP	RasykBufPabaiga
  klaidaRasant:
	;<klaidos pranešimo išvedimo kodas>
	MOV	ax, 0				;Pažymime registre ax, kad nebuvo irašytas ne vienas simbolis
	JMP	RasykBufPabaiga
RasykBuf ENDP


;*****************************************************
;Print to output
;*****************************************************
PROC printToOutput
; CX - kiek baitu rasyti i ekrana - priskiriame isoreje

	PUSH ax
	
	MOV	ah, 40h				;DOS funkcijos numeris
	MOV	bx, 1				;STDOUT (Standart output) irenginio deskriptoriaus numeris
	LEA	dx, raBuf			;Is kur imti isvedamus baitus
	INT	21h
	
	POP ax
	
	RET

printToOutput ENDP


;*****************************************************
;Print to output
;*****************************************************
PROC readParameter

    MOV	bx, 0082h			;programos paleidimo parametrai rašomi segmente es pradedant 129 (arba 81h) baitu
    XOR si, si           	;skaitliukas pirmam parametrui
	
  readFirst:
  
	MOV	ax, es:[bx]			;i ax isirašom du baitus, i kuriuos rodo registras bx
	CMP al, 0Dh				; 0Dh - pabaigos simbolis
    JE  parameterRead      ;jeigu pabaigos simbolis - reiskias paramentro pabaiga

    MOV [duom + si], al     ;jei neradom "/?" ir tarpo reiskias vis dar skaitome pirma parametra

    INC si                  ;padidinu skaitliuka
	INC	bx					;paslenku rodykle ir tikrinu toliau esancius simbolius
	JMP	readFirst			;uzciklinu

  parameterRead:
    MOV [duom + si], 0      ;failo pavadinimas turi baigtis 0
	RET
	
readParameter ENDP	

END start

