;***************************************************************
; Programa, i�vedanti � egran� prane�im�, naudojant INT 21, 40 funkcij�
;***************************************************************

.model small

.stack 100h

.data
	buferis	db "Sveiki, stai Jusu pranesimas!!"

.code
  pradzia:
	MOV	ax, @data		;reikalinga kiekvienos programos pradzioj
	MOV	ds, ax			;reikalinga kiekvienos programos pradzioj

	MOV	ah, 40h			;DOS funkcijos numeris
	MOV	bx, 1			;STDOUT (Standart output) �renginio deskriptoriaus numeris
	MOV	cx, 30			;Kiek bait� i�vesti
	MOV	dx, offset buferis	;I� kur imti i�vedamus baitus
	INT	21h
	
	MOV	ah, 4Ch			;reikalinga kiekvienos programos pabaigoj
	MOV	al, 0			;reikalinga kiekvienos programos pabaigoj
	INT	21h			;reikalinga kiekvienos programos pabaigoj
END pradzia	