;***************************************************************
; Programa iðvedanti á ekranà dviejø baitø skaièiø deðimtainiu formatu
;***************************************************************

.model small

.stack 100h

.code
  Pradzia:
	;Ði programa netradicinë - ji nedirba su duomenø segmentu, taigi nereikia ir adreso pakrovimo á ds komandø

	MOV	ax, 0ABC9h	;èia áraðykite skaièiø, kurá norite atspausdinti;
	CALL	Skaiciuok	;iðkvieèiame skaièiaus spausdinimo procedûrà

	MOV	ah, 4Ch		;reikalinga kiekvienos programos pabaigoj
	MOV	al, 0		;reikalinga kiekvienos programos pabaigoj
	INT	21h		;reikalinga kiekvienos programos pabaigoj
		
	;Skaièiaus spausdinimo procedûra
  Skaiciuok PROC
	;Korektiðka procedûra privalo po darbo atstatyti panaudotø registrø reikðmes
	;Todël prieð tai turime jas kur nors iðsisaugoti
	;Patogiausia tai daryti steke
	PUSH	ax
	PUSH	cx
	PUSH	dx
	
	MOV	cx, 16		;kadangi naudojam deðimtainæ sistemà, tai dalinsim ið 10
	PUSH	"$$"	;kad spausdindami skaitmenis ið steko, galëtume rasti pabaigà
    Dalink:
	MOV	dx, 0		;tiesiog iðvalom registrà, nes jis dalyvaus dalyboje
	DIV	cx			;{DX,AX}:10 = AX(liek DX)
	PUSH	dx		;ádedam skaitmená á stekà; deja, negalime idëti 1 baito
	CMP	ax, 0		;ar dar neperskaitëme viso skaièiaus?
	JA	Dalink		;jei ne, skaitom toliau

	;pradedam skaièiaus spausdinimà
	MOV	ah, 2		;i AH áraðom simbolio spausdinimo dosinës funkcijos numerá
    Spausdink:
	POP	dx			;iðimam skaitmená ið steko
	CMP	dx, "$$"	;ar iðspausdinome visà skaièiø?
	JE	Pabaiga		;jei taip, reikia baigti darbà
	CMP dl, 10d
	JB maziau10
	ADD dl, 7
	maziau10:
	ADD	dl, '0'		;liekanos jaunesnysis baitas - tai vienas skaitmuo; pridejæ simbolini 0 ið skaièiaus (pvz.: 1) gausime simbolá ('1')
	INT	21h			;jei ne, spausdinam skaitmená
	JMP	Spausdink	;spausdink kità skaitmená

    Pabaiga:
	;Turime atstatyti iðsaugotø registrø reikðmes
	POP	dx
	POP	cx
	POP	ax
	RET			;gráþimo ið procedûros komanda
  Skaiciuok ENDP
END pradzia