.model small

.stack 100h

.data
	zinute	db "Sveikas pasauli!", 10, 13, "$"

.code
Pradzia:
	MOV	ax, @data
	MOV	ds, ax			; Kad ds rodytø á duomenø segmento pradþià
	MOV	ah, 9			; MS Dos'o eilutës spausdinimo funkcija
	MOV	dx, OFFSET zinute	; Nuoroda á vietà, kur uþraðyta þinutë
	INT	21h			; Iðvedamas praneðimas
	MOV	ah, 4Ch			; MS Dos'o programos pabaigos funkcija
	INT	21h			; Baigiamas programos darbas
END Pradzia
