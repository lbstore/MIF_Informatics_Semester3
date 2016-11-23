PRINT MACRO MSG
	MOV AH,9
	LEA DX,MSG
	INT 21H
ENDM
    
printAsciiDigit MACRO numb
        xor dx,dx
        mov dl, byte ptr[numb]
        add dl, 48
        xor ax,ax
        mov ah, 2h
        int 21h
ENDM 