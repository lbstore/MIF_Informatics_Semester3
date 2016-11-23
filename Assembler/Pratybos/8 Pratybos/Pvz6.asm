;***************************************************************
; Programa, iðvedanti á egranà praneðimà, naudojant INT 21, 40 funkcijà
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
	MOV	bx, 1			;STDOUT (Standart output) árenginio deskriptoriaus numeris
	MOV	cx, 30			;Kiek baitø iðvesti
	MOV	dx, offset buferis	;Ið kur imti iðvedamus baitus
	INT	21h
	
	MOV	ah, 4Ch			;reikalinga kiekvienos programos pabaigoj
	MOV	al, 0			;reikalinga kiekvienos programos pabaigoj
	INT	21h			;reikalinga kiekvienos programos pabaigoj
END pradzia	