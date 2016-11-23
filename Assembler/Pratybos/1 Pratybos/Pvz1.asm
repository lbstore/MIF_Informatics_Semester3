;***************************************************************
;Pavyzdin� programa. Parodo pirm�j� vartotojo �vest� simbol�
;***************************************************************

.model small

.stack 100h

.data
	ivesk	db "Iveskite simboliu eilute: ", 10, 13, "$"
	buferis	db 255, ?, 255 dup (?)
	rezult	db "Pirmasis ivestas simbolis yra: $"
	
.code
  pradzia:
	MOV	ax, @data		;reikalinga kiekvienos programos prad�ioj
	MOV	ds, ax			;reikalinga kiekvienos programos prad�ioj
	
	;I�vedame � ekran� pirm�j� prane�im�
	MOV ah, 9			;9 - eilut�s i�vedimo funkcijos numeris
	MOV dx, offset ivesk		;� dx �demdame i�vedamos eilut�s adres� (poslink� nuo segmento prad�ios)
	INT	21h			;kvie�iame pertraukim�; po �itos eilut�s prane�imas atsiranda ekrane
	
	;Nuskaitome simboli� eilut� � bufer�
	MOV ah, 0Ah			;0Ah - eilut�s nuskaitymo funkcijos numeris
	MOV	dx, offset buferis
	INT	21h
	
	;I�vedame prane�im� "rezult"
	MOV ah, 9
	MOV dx, offset rezult
	INT	21h

	;I�vedame pirm�j� � bufer� nuskaitytos eilut�s simbol�
	MOV	bx, offset buferis	;� bx �ra�ome buferio prad�ios adres�
	MOV dl, [bx+2]			;� dl �ra�ome bait�, kuris yra nutol�s per du baitus nuo buferio prad�ios - tre�i�j� bait�; 
					;pirmame buferio baite saugoma kiek simboli� maksimaliai galima nuskaityti, o antrajame - kiek j� nuskaityta
	MOV	ah, 2			;2 - simbolio i�vedimo � ekran� funkcijos numeris
	INT 21h

	MOV	ah, 4Ch			;reikalinga kiekvienos programos pabaigoj
	MOV	al, 0			;reikalinga kiekvienos programos pabaigoj
	INT	21h			;reikalinga kiekvienos programos pabaigoj
END pradzia