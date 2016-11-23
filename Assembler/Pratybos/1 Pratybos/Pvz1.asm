;***************************************************************
;Pavyzdinë programa. Parodo pirmàjá vartotojo ávestà simbolá
;***************************************************************

.model small

.stack 100h

.data
	ivesk	db "Iveskite simboliu eilute: ", 10, 13, "$"
	buferis	db 255, ?, 255 dup (?)
	rezult	db "Pirmasis ivestas simbolis yra: $"
	
.code
  pradzia:
	MOV	ax, @data		;reikalinga kiekvienos programos pradþioj
	MOV	ds, ax			;reikalinga kiekvienos programos pradþioj
	
	;Iðvedame á ekranà pirmàjá praneðimà
	MOV ah, 9			;9 - eilutës iðvedimo funkcijos numeris
	MOV dx, offset ivesk		;á dx ádemdame iðvedamos eilutës adresà (poslinká nuo segmento pradþios)
	INT	21h			;kvieèiame pertraukimà; po ðitos eilutës praneðimas atsiranda ekrane
	
	;Nuskaitome simboliø eilutæ á buferá
	MOV ah, 0Ah			;0Ah - eilutës nuskaitymo funkcijos numeris
	MOV	dx, offset buferis
	INT	21h
	
	;Iðvedame praneðimà "rezult"
	MOV ah, 9
	MOV dx, offset rezult
	INT	21h

	;Iðvedame pirmàjá á buferá nuskaitytos eilutës simbolá
	MOV	bx, offset buferis	;á bx áraðome buferio pradþios adresà
	MOV dl, [bx+2]			;á dl áraðome baità, kuris yra nutolæs per du baitus nuo buferio pradþios - treèiàjá baità; 
					;pirmame buferio baite saugoma kiek simboliø maksimaliai galima nuskaityti, o antrajame - kiek jø nuskaityta
	MOV	ah, 2			;2 - simbolio iðvedimo á ekranà funkcijos numeris
	INT 21h

	MOV	ah, 4Ch			;reikalinga kiekvienos programos pabaigoj
	MOV	al, 0			;reikalinga kiekvienos programos pabaigoj
	INT	21h			;reikalinga kiekvienos programos pabaigoj
END pradzia