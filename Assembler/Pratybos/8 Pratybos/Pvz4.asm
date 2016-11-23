;***************************************************************
; Programa, i�spausdinanti pagalbos prane�im�, jei tarp paleidimo parametr� yra /?
;***************************************************************

.model small

.stack 100h

.data
	;Pagalbos prane�imas:
	help	db "Sveiki, jus sveikina asemblerio pavyzdine programa!", 10, 13, "Cia galima ismokti, kaip patikrinti komandos paleidimo parametrus.", 10, 13, "Sekmes$"

.code
  pradzia:
	MOV	ax, @data		;reikalinga kiekvienos programos prad�ioj
	MOV	ds, ax			;reikalinga kiekvienos programos prad�ioj

	MOV	bx, 0081h		;programos paleidimo parametrai ra�omi segmente es pradedant 129 (arba 81h) baitu
  Ieskok:
	MOV	ax, es:[bx]		;� ax �sira�om du baitus, � kuriuos rodo registras bx
	CMP	al, 0Dh			;tikrinam, ar tai ne pabaigos simbolis
	JE	Nera			;jei taip, vadinasi neradau "/?"
	CMP	ax, 3F2Fh		;o gal nuskaityta "/?" - 3F = '?'; 2F = '/'
	JE	Yra			;radau "/?", vadinasi turiu i�vesti pagalbos prane�im�
	INC	bx			;neradau "/?" �iuose baituose, paslenku rodykl� ir tikrinu toliau esancius parametrus
	JMP	Ieskok			;u�ciklinu

	;spausdinu pagalba � ekran� pagalbos prane�im�
   Yra:
	MOV	ah, 9			;� ah �ra�au dosinio pertraukimo funkcijos numer�
	MOV	dx, offset help		;� dx �ra�au nuorod� � spausdinamo teksto prad�i�
	INT	21h			;i�kvie�iu dosin� pertraukim� - spausdinu prane�im�

  Nera:
	MOV	ah, 4Ch			;reikalinga kiekvienos programos pabaigoj
	MOV	al, 0			;reikalinga kiekvienos programos pabaigoj
	INT	21h			;reikalinga kiekvienos programos pabaigoj
END pradzia