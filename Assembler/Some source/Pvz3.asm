;***************************************************************
; Programa i�vedanti � ekran� dviej� bait� skai�i� de�imtainiu formatu
;***************************************************************

.model small

.stack 100h

.code
  Pradzia:
	;�i programa netradicin� - ji nedirba su duomen� segmentu, taigi nereikia ir adreso pakrovimo � ds komand�

	MOV	ax, 0ABC9h	;�ia �ra�ykite skai�i�, kur� norite atspausdinti;
	CALL	Skaiciuok	;i�kvie�iame skai�iaus spausdinimo proced�r�

	MOV	ah, 4Ch		;reikalinga kiekvienos programos pabaigoj
	MOV	al, 0		;reikalinga kiekvienos programos pabaigoj
	INT	21h		;reikalinga kiekvienos programos pabaigoj
		
	;Skai�iaus spausdinimo proced�ra
  Skaiciuok PROC
	;Korekti�ka proced�ra privalo po darbo atstatyti panaudot� registr� reik�mes
	;Tod�l prie� tai turime jas kur nors i�sisaugoti
	;Patogiausia tai daryti steke
	PUSH	ax
	PUSH	cx
	PUSH	dx
	
	MOV	cx, 16		;kadangi naudojam de�imtain� sistem�, tai dalinsim i� 10
	PUSH	"$$"	;kad spausdindami skaitmenis i� steko, gal�tume rasti pabaig�
    Dalink:
	MOV	dx, 0		;tiesiog i�valom registr�, nes jis dalyvaus dalyboje
	DIV	cx			;{DX,AX}:10 = AX(liek DX)
	PUSH	dx		;�dedam skaitmen� � stek�; deja, negalime id�ti 1 baito
	CMP	ax, 0		;ar dar neperskait�me viso skai�iaus?
	JA	Dalink		;jei ne, skaitom toliau

	;pradedam skai�iaus spausdinim�
	MOV	ah, 2		;i AH �ra�om simbolio spausdinimo dosin�s funkcijos numer�
    Spausdink:
	POP	dx			;i�imam skaitmen� i� steko
	CMP	dx, "$$"	;ar i�spausdinome vis� skai�i�?
	JE	Pabaiga		;jei taip, reikia baigti darb�
	CMP dl, 10d
	JB maziau10
	ADD dl, 7
	maziau10:
	ADD	dl, '0'		;liekanos jaunesnysis baitas - tai vienas skaitmuo; pridej� simbolini 0 i� skai�iaus (pvz.: 1) gausime simbol� ('1')
	INT	21h			;jei ne, spausdinam skaitmen�
	JMP	Spausdink	;spausdink kit� skaitmen�

    Pabaiga:
	;Turime atstatyti i�saugot� registr� reik�mes
	POP	dx
	POP	cx
	POP	ax
	RET			;gr��imo i� proced�ros komanda
  Skaiciuok ENDP
END pradzia