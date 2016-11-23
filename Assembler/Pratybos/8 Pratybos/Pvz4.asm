;***************************************************************
; Programa, iðspausdinanti pagalbos praneðimà, jei tarp paleidimo parametrø yra /?
;***************************************************************

.model small

.stack 100h

.data
	;Pagalbos praneðimas:
	help	db "Sveiki, jus sveikina asemblerio pavyzdine programa!", 10, 13, "Cia galima ismokti, kaip patikrinti komandos paleidimo parametrus.", 10, 13, "Sekmes$"

.code
  pradzia:
	MOV	ax, @data		;reikalinga kiekvienos programos pradþioj
	MOV	ds, ax			;reikalinga kiekvienos programos pradþioj

	MOV	bx, 0081h		;programos paleidimo parametrai raðomi segmente es pradedant 129 (arba 81h) baitu
  Ieskok:
	MOV	ax, es:[bx]		;á ax ásiraðom du baitus, á kuriuos rodo registras bx
	CMP	al, 0Dh			;tikrinam, ar tai ne pabaigos simbolis
	JE	Nera			;jei taip, vadinasi neradau "/?"
	CMP	ax, 3F2Fh		;o gal nuskaityta "/?" - 3F = '?'; 2F = '/'
	JE	Yra			;radau "/?", vadinasi turiu iðvesti pagalbos praneðimà
	INC	bx			;neradau "/?" ðiuose baituose, paslenku rodyklæ ir tikrinu toliau esancius parametrus
	JMP	Ieskok			;uþciklinu

	;spausdinu pagalba á ekranà pagalbos praneðimà
   Yra:
	MOV	ah, 9			;á ah áraðau dosinio pertraukimo funkcijos numerá
	MOV	dx, offset help		;á dx áraðau nuorodà á spausdinamo teksto pradþià
	INT	21h			;iðkvieèiu dosiná pertraukimà - spausdinu praneðimà

  Nera:
	MOV	ah, 4Ch			;reikalinga kiekvienos programos pabaigoj
	MOV	al, 0			;reikalinga kiekvienos programos pabaigoj
	INT	21h			;reikalinga kiekvienos programos pabaigoj
END pradzia