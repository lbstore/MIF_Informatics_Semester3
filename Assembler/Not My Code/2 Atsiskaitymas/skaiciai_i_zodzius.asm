.model small 
bufsize	EQU	20
.stack 100h

.data
error1	db  "Error! Lengths of input1 and input2 doesnt match!",10,13,"$"
error2	db  "Error! bad options were inputed!", 10, 13, "$"	
error3	db  "Error openning the first file for reading!",10,13,"$"
error5 	db  "Error openning file for writting",10,13,"$"
error6	db  "Error reading from file ",10,13,"$"
error7	db  "Error writting to file",10,13,"$"
error8	db  "Error closing file for writting!",10,13,"$"
error9	db  "Error closing file for reading!",10,13,"$"
succes  db  "Done!" ,10 ,13, "$"
info	db  "Valerij Bielskij, Informatikos II kursas, I grupe, Nr 25",10,13,"Programa atlieka operacija AND dviems failams ir atsakyma isveda i trecia",10,13, "$"

duom1		db 255 DUP (0)			
rezult  	db 255 DUP (0)
readbuf1	db (0)		
raBuf		db " "	
handle1	 	dw ?
handle3	 	dw ?  

nulis		db "nulis"
vienas		db "vienas"
du		db "du"
trys		db "trys"
keturi		db "keturi"
penki		db "penki"
sesi		db "sesi"
septyni		db "septyni"
astuoni		db "astuoni"
devyni		db "devyni"

;//---------------------------------------------------------------------------------
.code
  begin:
	MOV	ax, @data		
	MOV	ds, ax	

	MOV	bx, 81h
	
parSeek:
        MOV     ax, es:[bx]  
        CMP     al, 0Dh          
        JE      doNotShow            ;jei taip, vadinasi neradau parametru arba visus perziurejau
        
 
        CMP     ax, "?/"        ;radau "/?", vadinasi turiu isvesti pagalba
        JE      showInfo             
 
        CMP     al, 20h            ;radau tarpa?
        JE      parNext         ;tarpas - rasysim kita faila
 
        INC     di                ;perskaitem simboliu daugiau
 
        CMP     si, 1
        JNE     var2
        MOV     [duom1 + di - 1], al         ;irasom i k	INTamaji
        JMP     wrote

var2:
        CMP     si, 2
        JNE 	wrote
           

        MOV     [rezult + di - 1], al         ;irasom i k	INTamaji
 
wrote:
 
        INC     bx                ;paslenku rodykle ir tikrinu toliau esancius parametrus
        JMP     parSeek
 
parNext:
        MOV     di, 0            ;kitas k	INTamasis, jo dar nieko nenuskaite            
        INC	si
        INC     bx
    	JMP     parSeek

    
showInfo:
	MOV	ah, 09h
       	LEA	dx, info
        INT 	21h
	JMP	exitas

doNotShow:
	
;//-------------------------------------------------------------------------------------------
; open file1
reading:
	
	MOV	ah, 3Dh
	MOV	al, 0
	LEA	dx, duom1
	INT	21h
	JNC	open_for_reading1
CALL	 error_open_for_reading1
 
open_for_reading1:
	MOV	[handle1], ax
 
;//------------------------------------------------------------------------------------------
 
;  creating rezult file for writting ;

	MOV	ah, 3Ch
	MOV	cx, 0
	LEA	dx, rezult
	INT	21h
	JNC	creating_to_write
CALL	error_openning_to_write
 
creating_to_write:
	MOV	[handle3], ax

;//---------------------------------------------------------------------------------------------- 
;  reading from file 1

readit:
	MOV	ah, 3Fh
	MOV	bx, handle1
	MOV	cl, 1
	MOV	ch, 0
	LEA	dx, readbuf1
	INT	21h
	JNC	readit1
CALL   	error_reading
 
readit1:
	CMP	ax, 0                                          ; proveriajem, voobshe schitali chego , esli 0 , to zakrivajem lavochku
	JNE	over5
CALL	close_writting	
over5:

JMP	check 
 
;//------------------------------------------------------------------------------------------------
;writing to rezult file
write:				
	MOV	bx, handle3			

	MOV	ah, 40h				
	INT	21h			
	JNC	over
CALL	error_writting
over:	

	JMP	readit

;//------------------------------------------------------------------------------------------------
; Checking information ;
check:
	LEA	si, readbuf1	
	MOV	al, [si]
	
	CMP	al, "0"
	JE	null	
	CMP	al, "1"
	JE	one
	CMP	al, "2"
	JE	two
	CMP	al, "3"
	JE	three	
	CMP	al, "4"
	JE	four	
	CMP	al, "5"
	JE	five	
	CMP	al, "6"
	JE	six	
	CMP	al, "7"
	JE	seven	
	CMP	al, "8"
	JE	eight	
	CMP	al, "9"
	JE	nine		

	MOV	cx, 1
	MOV	[rabuf], al
	LEA	dx, rabuf
	JMP write	
	
null:
	LEA	dx, nulis
	MOV	cx, 5
	JMP write

one:
	LEA	dx, vienas
	MOV	cx, 6
	JMP write		

two:
	LEA	dx, du
	MOV	cx, 2
	JMP write

three:
	LEA	dx, trys
	MOV	cx, 4
	JMP write

four:
	LEA	dx, keturi
	MOV	cx, 6
	JMP write
	
five:
	LEA	dx, penki
	MOV	cx, 5
	JMP write	
	
six:
	LEA	dx, sesi
	MOV	cx, 4
	JMP write
	
seven:
	LEA	dx, septyni
	MOV	cx, 7
	JMP write
	
eight:
	LEA	dx, astuoni
	MOV	cx, 7
	JMP write
	
nine:
	LEA	dx, devyni
	MOV	cx, 6
	JMP write	
		

;//-------------------------------------------------------------------------------------------	

; close writting file

close_writting:
	MOV	ah, 3eh
	MOV	bx, handle3
	INT	21h
	JNC	close1
CALL	error_closing_writting
 
; closing file 1

close1:
	MOV	ah, 3eh
	MOV	bx, handle1
	INT	21h
	JC	error_closing_reading


;//-----------------------------------------------------------------------------------------

; Exitting ;
exitas2:
	MOV	ah, 9
	LEA	dx, succes
	INT	21h

exitas:
	MOV	ax, 4C00h
	INT	21h
 
error_on_length:
	MOV	ah, 9
	LEA	dx, error1
	INT 	21h
	
	JMP	exitas 
 
error_on_data:
	MOV	ah, 9
	LEA	dx, error2
	INT 	21h
	JMP	exitas 

 
error_open_for_reading1:
	MOV	ah,9
	LEA	dx, error3
	INT	21h
	JMP	exitas

 
error_openning_to_write:
	MOV	 ah,9
	LEA	dx, error5
	INT	21h
	JMP	exitas
 
error_reading:
	MOV	ah,9
	LEA	dx, error6
	INT	21h
	JMP	close_writting
 
error_writting:
	MOV	ah,9
	LEA	dx, error7
	INT	21
	JMP	close_writting
 
error_closing_writting:
	MOV	ah,9
	LEA	dx, error8
	INT	21h
	JMP	close1
 
error_closing_reading:
	MOV	ah,9
	LEA	dx, error9
	INT	21h
	JMP	exitas
  
END	begin
