.model small

.stack 100h

.data
	zinute	db "Sveikas pasauli!", 10, 13, "$"

.code
Pradzia:
	MOV	ax, @data
	MOV	ds, ax			; Kad ds rodyt� � duomen� segmento prad�i�
	MOV	ah, 9			; MS Dos'o eilut�s spausdinimo funkcija
	MOV	dx, OFFSET zinute	; Nuoroda � viet�, kur u�ra�yta �inut�
	INT	21h			; I�vedamas prane�imas
	MOV	ah, 4Ch			; MS Dos'o programos pabaigos funkcija
	INT	21h			; Baigiamas programos darbas
END Pradzia
