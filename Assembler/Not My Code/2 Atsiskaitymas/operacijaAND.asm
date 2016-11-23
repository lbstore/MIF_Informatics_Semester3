.model small 
bufsize	EQU	20
.stack 100h

.data
error1	db  "Error! Lengths of input1 and input2 doesnt match!",10,13,"$"
error2	db  "Error! bad options were inputed!", 10, 13, "$"	
error3	db  "Error openning the first file for reading!",10,13,"$"
error4	db  "Error openning the second file for reading!",10,13,"$"
error5 	db  "Error openning file for writting",10,13,"$"
error6	db  "Error reading from file ",10,13,"$"
error7	db  "Error writting to file",10,13,"$"
error8	db  "Error closing file for writting!",10,13,"$"
error9	db  "Error closing file for reading!",10,13,"$"
succes  db  "Done!" ,10 ,13, "$"
info	db  "Valerij Bielskij, Informatikos II kursas, I grupe, Nr 25",10,13,"Programa atlieka operacija AND dviems failams ir atsakyma isveda i trecia",10,13, "$"

duom1		db 255 DUP (0)		
duom2		db 255 DUP (0)		
rezult  	db 255 DUP (0)
readbuf1	db bufsize dup (0)	
readbuf2	db bufsize dup (0)	
raBuf		db bufsize dup (" ")	
handle1	 	dw ?
handle2	 	dw ?
handle3	 	dw ?  
	
;//---------------------------------------------------------------------------------
.code
  begin:
	MOV	ax, @data		
	MOV	ds, ax	

	MOV	bx, 81h

parSeek:
        MOV     ax, es:[bx]  
        CMP     al, 0Dh          
        JE      doNotShow          
 
        CMP     ax, "?/"      
        JE      showInfo             
 
        CMP     al, 20h       
        JE      parNext      
 
        INC     di       
 
        CMP     si, 1
        JNE     var2
        MOV     [duom1 + di - 1], al   
        JMP     wrote
var2:
        CMP     si, 2
        JNE     var3
        MOV     [duom2 + di - 1], al      
        JMP     wrote
var3:
        CMP     si, 3
        JNE 	wrote
           

        MOV     [rezult + di - 1], al     
 
        wrote:
 
        INC     bx            
        JMP     parSeek
 
parNext:
        MOV     di, 0                   
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
 
; open file2

;//-------------------------------------------------------------------------------------------

	MOV	ah, 3Dh
	MOV	al, 0
	LEA	dx, duom2
	INT	21h
	JNC	open_to_read2
CALL	error_open_for_reading2
 
open_to_read2:
	MOV	[handle2], ax

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
	MOV	cl, bufsize
	MOV	ch, 0
	LEA	dx, readbuf1
	INT	21h
	JNC	readit1
CALL   	error_reading
 
readit1:
	CMP	ax, 0                                    
	JE	close_writting	
	PUSH	ax

;//------------------------------------------------------------------------------------------------

; reading from file 2

	MOV	ah, 3Fh
	MOV	bx, handle2
	LEA	dx, readbuf2
	INT	21h
	JNC	readit2
CALL	error_reading
 
readit2:
	CMP	ax, 0
	JE	close_writting
	MOV	cx, ax
	POP	ax
	CMP	ax, cx
	JE	over2
CALL	error_on_length
over2:
	JMP	check 
 
;//------------------------------------------------------------------------------------------------
;writing to rezult file
write:
	MOV	cx, ax				
	MOV	bx, handle3			

	MOV	ah, 40h			
	LEA	dx, raBuf	
	INT	21h			
	JNC	over
CALL	error_writting
over:	
	CMP	ax, bufsize
	JB	close_writting
	JMP	readit

;//------------------------------------------------------------------------------------------------
; Checking information ;
check:
	LEA	si, readbuf1
	LEA	di, readbuf2
	XOR	bx, bx

	PUSH	ax

do_it:
	MOV	al, [si]
	MOV	ah, [di]

	CMP	cx, 1
	JE	ok
	
	cmp	ah, "1"
	je	more
	cmp	ah, "0"
	jne	error
more:	cmp	al, "1"
	je	ok
	cmp	al, "0"
	je	ok

error:	
	JMP	error_on_data
	
ok:
	AND	al, ah
	MOV	[rabuf+bx], al
	
	INC	bx
	INC	si
	INC	di
	
	LOOP	do_it

	POP ax
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
	JNC	close_to_read2
CALL	error_closing_reading
 
; closing file 2

close_to_read2:
	MOV	ah, 3eh				
	MOV	bx, handle2
	INT	21h
	JNC	exitas2
CALL	error_closing_reading

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
 
error_open_for_reading2:
	MOV	ah,9
	LEA	dx, error4
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
