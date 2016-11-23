.model small
.stack 100h
.data
	pranesimas1	DB "Iveskite du 16-tainius skaitmenis", 13, 10, "$"	;apsibreziam pranesimus ka noresim spausdinti
	pranesimas2	DB "Neteisinga ivestis", 13, 10, "$"
	pranesimas3 DB "Programa konvertuoja 16taini formata i 10taini", 13, 10, "$"
	buffer 		DB 10, ?, 10 dup (0) ; "10" nurodom kokio dydzio bus bufferis, "?" - paliekam tai kas yra antram baite, ten bus irasyta kiek nuskaite, "10 dup(0)" - sekancius 10 baitu uzpildom 0. Viso bufferis uzima 12B.
	new_line	DB 10, 13, "$" ; 10 - new line, 13 - home, "$" - stringo pabaiga
.code

pradzia:
	MOV AX, @data 	;I AX ikeliam duomenu segmento pradzios adresa
	MOV DS, AX		;i DS ikeliam AX reiksme
					;taip darom todel, kad tiesiogiai kelti i DS nera technines galimybes
	MOV BX, 81h		;i BX ikeliam 81h reiksme, nes programos parametrai saugomi adresu ES:0081h
	
tikrinam:	
	MOV AX, ES:[BX]	;nuskaitom pirmus du parametro baitus
	INC BX			;padidinam bx 1, kad per sekanti skaityma imtume 1 baitu toliau
	
	CMP AL, 13  ;palyginam ar pirmas nuskaitytas simbolis nera new line (ar kartais nepaspaude enter)
	JE toliau	;jei taip, parametru nera ir sokam toliau
	CMP AL, 20h	;palyginam pirma nuskaityta simboli su tarpu
	JE tikrinam ;jei tarpas - ignoruojam ir imam sekancius du
	CMP AX, "?/" ;jei ne tarpas ir ne enter, lyginam AX su "?/", nes skaitant pirmiau uzpildomas jaunesnioji registro dalis, po to vyresnioji.
	JNE toliau ;jei radom kazka, kas nera enter, nera tarpas ir nera "/?" tuomet i tai nereaguojam
	MOV AX, ES:[BX] ;nuskaitom per viena baita toliau, nes BX po praejusio nuskaitymo buvo padidintas 1
	CMP AH, 13 ;patikrinam ar po to kai ivestas "/?" buvo paspaustas enter
	JE help ;jei taip, isvedam help pranesima
	JMP toliau ;jei ne - vygdom program toliau

help:	
	MOV DX, offset pranesimas3 ;atspausdinam tai kas saugoma adresu uztagintu "pranesimas3"
	MOV AH, 09h ;zr google > int 21h > pirmas link
	INT 21h
	
	JMP pabaiga 
	
toliau:
	
	MOV DX, offset pranesimas1 
	MOV AH, 09h ;zr google > int 21h > pirmas link
	INT 21h	
	
	MOV DX, offset buffer ;i DX ikeliam "buffer" adresa ir nuskaitom tai ka ivede vartotojas
	MOV AH, 0Ah ;zr google > int 21h > pirmas link
	INT 21h
	
	PUSH AX ;issisaugom AX
	MOV DX, offset new_line
	MOV AH, 09h ;zr google > int 21h > pirmas link
	INT 21h
	POP AX ;atsistatom buvusia AX reiksme
	
	MOV SI, offset buffer ;i SI registra ikeliam bufferio pradzios adresa
	ADD SI, 2 ;prie SI pridedam 2, nes pirmas baitas skirtas bufferio talpai, o antras saugo kiek simboliu buvo nuskaityta
	MOV AX, [DS:SI] ;i AX ikeliam pirmus du baitus is bufferio
	
	CMP AH, 30h ;lyginam AH su 0 simboliu
	JB klaida
	CMP AH, 3Ah ;lyginam ah su pirmu simboliu po "9"
	JB AHskaicius
	CMP AH, 41h ;lyginam AH su "A"
	JB klaida
	CMP AH, 47h ;lyginam AH su "G"
	JNAE AHraide
	JMP klaida
	
AHskaicius:
	SUB AH, 48 ;Jei AH buvo saugomas skaiciaus simbolis, is jo atimam 48 - "0" reiksme
	JMP prieAL
	
AHraide:
	SUB AH, 55 ;jei AH buvo saugoma raide, atimam 55
	
prieAL:
	CMP AL, 30h
	JB klaida
	CMP AL, 3Ah
	JB ALskaicius
	CMP AL, 41h
	JB klaida
	CMP AL, 47h
	JB ALraide
	JMP klaida
	
ALskaicius:
	SUB AL, 48
	JMP konversija

ALraide:
	SUB AL, 55
	JMP konversija

klaida:
	MOV DX, offset pranesimas2
	MOV AH, 09h ;zr google > int 21h > pirmas link
	INT 21h
	JMP pabaiga	
	
konversija: 			;(tarkim ivesta XY, tuomet mums reikia atlikti veiksma X*16 + Y)
	XOR BX, BX ;nunulinam BX
	MOV BL, 16 ;ikeliam i BL 16, nes mums reikes dauginti is 16
	PUSH AX ;issaugom AX steke
	MUL BL ;AX := AL * BL 
	POP BX ;i BX ikeliam tai ka pirmai issaugojom steke
	ADD AL, BH ;prie 
	
	CMP AL, 10 ;lyginam AL su 10
	JB vienzenklis ;jei jis mazesnis, tada vienzenklis
	CMP AL, 100;lyginam AL su 100
	JB dvizenklis ;jei mazesnis tada jis 2zenklis
	JMP trizenklis ;kitu atveju jis trizenklis
	
vienzenklis:
	ADD AL, 30h ;pridedam 30h, kad gautume skaitmens simboli
	
	MOV DL, AL 
	MOV AH, 2 ;zr google > int 21h > pirmas link
	INT 21h
	
	JMP pabaiga
	
dvizenklis:			;jei skaicius dvizenklis tuomet ji reikia isskaidyti i desimtis ir vienetus
	MOV BL, 10 ;ikeliam i BL 10
	DIV BL ;AL := AX DIV BL; AH := AX MOD BL
	PUSH AX ;Issisaugom AX
	ADD AL, 30h
	
	MOV DL, AL
	MOV AH, 2 ;zr google > int 21h > pirmas link
	INT 21h
	
	POP AX ;Susigrazinam AX reiksme
	ADD AH, 30h
	
	MOV DL, AH 
	MOV AH, 2 ;zr google > int 21h > pirmas link
	INT 21h
	
	JMP pabaiga
	
trizenklis:   ;jei skaicius trizenklis tada ji galima isskaidyti kaip simtus ir dvizenkli skaiciu
	MOV BL, 100
	DIV BL
	PUSH AX
	ADD AL, 30h
	
	MOV DL, AL
	MOV AH, 2 ;zr google > int 21h > pirmas link
	INT 21h
	
	POP AX
	MOV AL, AH ;I AL ikeliam tai kas yra AH, t.y. dvizenkli skaiciu (desimtys ir vienetai)
	XOR AH, AH ;nunulinam AH
	JMP dvizenklis ;vygdom koda lyg turetume dvizenkli skaiciu
	

pabaiga:
	MOV AH, 4Ch ;zr google > int 21h > pirmas link
	INT 21h
	
END pradzia
	