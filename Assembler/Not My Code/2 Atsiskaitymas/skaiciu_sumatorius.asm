getLength MACRO handle, length
	MOV	ah, 42h
	MOV	al, 2
	MOV	cx, 0
	MOV	dx, 0
	MOV	bx, handle
	INT	21h
	MOV	[length], ax
	
ENDM

mvToStart MACRO handle
	MOV	ah, 42h
	MOV	al, 0
	MOV	bx, handle
	INT	21h

ENDM


.model small 
wBufSize	EQU	1000
.stack 100h

.data
error2	db  "Error! bad options were inputed!", 10, 13, "$"	
error3	db  "Error openning the first file for reading!",10,13,"$"
error4	db  "Error openning the second file for reading!",10,13,"$"
error5 	db  "Error openning file for writting",10,13,"$"
error6	db  "Error reading from file ",10,13,"$"
error7	db  "Error writting to file",10,13,"$"
error8	db  "Error closing file for writting!",10,13,"$"
error9	db  "Error closing file for reading!",10,13,"$"
succes  db  "Done!" ,10 ,13, "$"
info	db  "Dveju skaiciu sumatorius",10,13, "$"

duom1		db 255 DUP (0)		
duom2		db 255 DUP (0)		
rezult  	db 255 DUP (0)
readbuf1	db wBufSize dup (?)	
readbuf2	db wBufSize dup (?)	
raBuf		db wBufSize dup (?)
auxFlag		db 0	
handle1	 	dw ?
handle2	 	dw ?
handle3	 	dw ?  
len1		dw ?
len2		dw ?
len		dw ?
	
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
	getLength handle1, len1
	getLength handle2, len2
	mvToStart handle1
	mvToStart handle2
	SUB	len1, 1
	SUB	len2, 1
	MOV	ax, len1
	MOV	cx, len2
	MOV	len, cx
	CMP	ax, cx
	JB	@higherCX
	MOV	len, ax

@higherCX:
	
readit:
	MOV	ah, 3Fh
	MOV	bx, handle1
	MOV	cx, wBufSize
	LEA	dx, readbuf1
	INT	21h
	JNC	readit1
CALL   	error_reading
 
readit1:
	CMP	ax, 0                                    
	JNE	@a
call	close_writting	
@a:
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
	JNE	over10
	call	close_writting
over10:
		
	JMP	check 
 
;//------------------------------------------------------------------------------------------------
;writing to rezult file
write:
	MOV	ah, 40h			
	MOV	bx, handle3			
	LEA	dx, raBuf	
	INT	21h	

	JNC	over
CALL	error_writting
over:	
	JMP	exitas2

;//------------------------------------------------------------------------------------------------
; Checking information ;
check:
	MOV	cx, len
	
	LEA	si, readbuf1
	LEA	di, readbuf2
	MOV	bx, cx
	ADD	si, len1
	ADD	di, len2
	DEC	si
	DEC	di
	MOV	dl, 10
	
  @work:
	CALL checkOrValid
	CALL checkIfEmpty
	MOV	al, [si]
	MOV	ah, [di]

	CMP	auxFlag, 1
	JNE	@ok2
	INC	al
	MOV	auxFlag, 0
@ok2:

	SUB	al, 30h
	SUB	ah, 30h
	ADD	al, ah
	MOV	ah, 0
	DIV	dl
	
	CMP	al, 1
	JNE	noAux
	MOV	auxFlag, 1
noAux:
	ADD	ah, 30h
	MOV	[rabuf+bx], ah

	DEC	bx
	DEC	si
	DEC	di
	LOOP @work	
		
	
	CMP	auxFlag, 1
	JNE	@space
	MOV	byte ptr [raBuf], '1'
	JMP	@further
@space:
	MOV	byte ptr [raBuf], ' '

@further:	
	MOV	cx, len
	INC	cx
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


checkOrValid proc
	CMP	byte ptr [si], 0
	JE	@RET
	CMP	byte ptr [di], 0
	JE	@RET
	CMP 	byte ptr [si], 48
	JB	@error
	CMP	byte ptr [si], 57
	JA	@error
	CMP 	byte ptr [di], 48
	JB	@error
	CMP	byte ptr [di], 57
	JA	@error
@RET:
	RET
	
@error:
	CALL error_on_data
ENDP  

checkIfEmpty proc
	CMP	byte ptr [si], 0
	JE @writebuf1
	CMP	byte ptr [di], 0
	JE @writebuf2
  	RET
  	
@writebuf1:
	CMP	auxFlag, 1
	JNE @workbuf1
	INC	byte ptr [di]
	
@workbuf1:
	MOV	al, byte ptr [di]
	MOV	[raBuf+bx], al
	DEC	bx
	DEC	di
	LOOP @workbuf1
	CALL @space
	
@writebuf2:
	CMP	auxFlag, 1
	JNE @workbuf2
	INC	byte ptr [si]
	
@workbuf2:
	MOV	al, byte ptr [si]
	MOV	[raBuf+bx], al
	DEC	bx
	DEC	si
	LOOP @workbuf2
	CALL @space
	
ENDP  
  
END	begin
