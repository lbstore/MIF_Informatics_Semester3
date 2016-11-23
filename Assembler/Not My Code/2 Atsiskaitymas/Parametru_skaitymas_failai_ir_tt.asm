;***************************************************************
; Programai perduodamas vienas paramentras per eilute - duomenu failas. 
; Programa visus skaicius pakeis i $ zenkla ir rezultata isves i ekrana bei i duom.txt faila.
;***************************************************************

.model small

skBufDydis	EQU 20			;konstanta skBufDydis (lygi 20) - skaitymo buferio dydis
raBufDydis	EQU 20			;konstanta raBufDydis (lygi 20) - ra�ymo buferio dydis

.stack 100h

.data
	openError	db 10, 13, "Klaida atidarant faila.", 10, 13,"$"
    duom    	db 64 dup(?)            ;duomenu; failo pavadinimas, nuskaitomas per komandine eilute
    rez			db 'duom.txt', 0		;rezultatu failo pavadinimas, nuskaitomas per komandine eilute
	skBuf		db skBufDydis dup (?)	;skaitymo buferis
	raBuf		db raBufDydis dup (?)	;ra�ymo buferis
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
	MOV	dFail, ax					;atmintyje i�sisaugom duomenu; failo deskriptoriaus numeri;

;*****************************************************
;Rezultato failo sukurimas ir atidarymas ra�ymui
;*****************************************************

	MOV	ah, 3Ch						;21h pertraukimo failo suku-rimo funkcijos numeris
	MOV	cx, 0						;kuriamo failo atributai
	MOV	dx, offset rez				;vieta, kur nurodomas failo pavadinimas, pasibaigiantis nuliniu simboliu
	INT	21h							;sukuriamas failas; jei failas jau egzistuoja, visa jo informacija i�trinama
	JC	klaidaAtidarantRasymui		;jei kuriant faila; skaitymui i;vyksta klaida, nustatomas carry flag
	MOV	rFail, ax					;atmintyje i�sisaugom rezultato failo deskriptoriaus numeri;

;*****************************************************
;Duomenu; nuskaitymas i� failo
;*****************************************************

  skaityk:
	MOV	bx, dFail			;i bx ira�om duomenu failo deskriptoriaus numeri;
	CALL SkaitykBuf			;i�kvieciame skaitymo i� failo procedura;
	CMP	ax, 0				;ax ira�oma, kiek baitu buvo nuskaityta, jeigu 0 - pasiekta failo pabaiga
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
;Rezultato ira�ymas i faila;
;*****************************************************
	MOV	cx, ax				;cx - kiek baitu; reikia ira�yti
	CALL printToOutput
	MOV	bx, rFail			;i bx ira�om rezultato failo deskriptoriaus numeri;
	CALL	RasykBuf		;i�kviec(iame ra�ymo i faila procedura;
	CMP	ax, raBufDydis		;jeigu vyko darbas su pilnu buferiu -> i� duomenu faila buvo nuskaitytas pilnas buferis ->
	JE	skaityk				;-> reikia skaityti toliau

;*****************************************************
;Rezultato failo u�darymas
;*****************************************************

  uzdarytiRasymui:
	MOV	ah, 3Eh				;21h pertraukimo failo u�darymo funkcijos numeris
	MOV	bx, rFail			;i; bx i;ra�om rezultato failo deskriptoriaus numeri;
	INT	21h				;failo u�darymas
	JC	klaidaUzdarantRasymui		;jei u�darant faila; i;vyksta klaida, nustatomas carry flag

;*****************************************************
;Duomenu failo u�darymas
;*****************************************************

  uzdarytiSkaitymui:
	MOV	ah, 3Eh				;21h pertraukimo failo u�darymo funkcijos numeris
	MOV	bx, dFail			;i; bx ira�om duomenu; failo deskriptoriaus numeri;
	INT	21h				;failo u�darymas
	JC	klaidaUzdarantSkaitymui		;jei u�darant faila; i;vyksta klaida, nustatomas carry flag

  pabaiga:
	MOV	ah, 4Ch				;reikalinga kiekvienos programos pabaigoj
	MOV	al, 0				;reikalinga kiekvienos programos pabaigoj
	INT	21h				;reikalinga kiekvienos programos pabaigoj

;*****************************************************
;Klaidu; apdorojimas
;*****************************************************

  klaidaAtidarantSkaitymui:
	MOV	ah, 09h				;i ah ira�au dosinio pertraukimo funkcijos numeri;
	LEA	dx, openError		;i dx ira�au nuoroda i spausdinamo teksto prad�ia;
	INT	21h					;i�kvieciu dosini pertraukima - spausdinu prane�ima;
	JMP	pabaiga
  klaidaAtidarantRasymui:
	;<klaidos prane�imo i�vedimo kodas>
	JMP	uzdarytiSkaitymui
  klaidaUzdarantRasymui:
	;<klaidos prane�imo i�vedimo kodas>
	JMP	uzdarytiSkaitymui
  klaidaUzdarantSkaitymui:
	;<klaidos prane�imo i�vedimo kodas>
	JMP	pabaiga

;*****************************************************
;Procedura nuskaitanti informacija i� failo
;*****************************************************
PROC SkaitykBuf
;i; BX paduodamas failo deskriptoriaus numeris
;i; AX bus gra;�inta, kiek simboliu; nuskaityta

	PUSH	cx
	PUSH	dx

	MOV	ah, 3Fh			;21h pertraukimo duomenu; nuskaitymo funkcijos numeris
	MOV	cl, skBufDydis		;cx - kiek baitu; reikia nuskaityti i� failo
	MOV	ch, 0			;i�valom vyresniji; cx baita;
	MOV	dx, offset skBuf	;vieta, i kuria ira�oma nuskaityta informacija
	INT	21h			;skaitymas i� failo
	JC	klaidaSkaitant		;jei skaitant i� failo ivyksta klaida, nustatomas carry flag

  SkaitykBufPabaiga:
	POP	dx
	POP	cx
	RET

  klaidaSkaitant:
	;<klaidos prane�imo i�vedimo kodas>
	MOV     ax, 0			;Pa�ymime registre ax, kad nebuvo nuskaityta ne. vieno simbolio
	JMP	SkaitykBufPabaiga
SkaitykBuf ENDP

;*****************************************************
;Procedura, ira�anti buferi i faila;
;*****************************************************
PROC RasykBuf
;i; BX paduodamas failo deskriptoriaus numeris
;i; CX - kiek baitu; ira�yti
;i; AX bus gra�inta, kiek baitu; buvo ira�yta
	PUSH	dx

	MOV	ah, 40h				;21h pertraukimo duomenu i;ra�ymo funkcijos numeris
	MOV	dx, offset raBuf	;vieta, i� kurios ra�om i faila;
	INT	21h					;ra�ymas i faila;
	JC	klaidaRasant		;jei ra�ant i faila; i;vyksta klaida, nustatomas carry flag
	CMP	cx, ax				;jei cx nelygus ax, vadinasi buvo i;ra�yta tik dalis informacijos
	JNE	dalinisIrasymas

  RasykBufPabaiga:
	POP	dx
	RET

  dalinisIrasymas:
	;<klaidos prane�imo i�vedimo kodas>
	JMP	RasykBufPabaiga
  klaidaRasant:
	;<klaidos prane�imo i�vedimo kodas>
	MOV	ax, 0				;Pa�ymime registre ax, kad nebuvo ira�ytas ne vienas simbolis
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

    MOV	bx, 0082h			;programos paleidimo parametrai ra�omi segmente es pradedant 129 (arba 81h) baitu
    XOR si, si           	;skaitliukas pirmam parametrui
	
  readFirst:
  
	MOV	ax, es:[bx]			;i ax isira�om du baitus, i kuriuos rodo registras bx
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

