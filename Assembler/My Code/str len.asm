    DATA SEGMENT
    STR DB 10,?,10 dup (0);
    endL db 13,10,"$" 
    MSG1 DB 10,13,'THE STRING IN THE MEMORY IS : $'
    MSG2 DB 10,13,'LENGTH OF THE STRING IS : $'
    LEN DB 0H
    DATA ENDS
    DISPLAY MACRO MSG
    MOV AH,9
    LEA DX,MSG
    INT 21H
    ENDM
    CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
    START:
    
    MOV AX,DATA
    MOV DS,AX
    ;DISPLAY MSG1
    mov ah, 0Ah
    mov dx, offset STR   
    int 21h
    
    mov ah, 09
    mov dx, offset endL
    int 21h
    
    xor bx, bx
    mov bl, byte ptr [str + 1]; ivestu simboliu kiekis 
    mov word ptr[bx + 3 + str], 240Ah;
    
    
    DISPLAY STR+2
    LEA SI,STR
    NEXT:
    CMP [SI],'$'
    JE DONE
    INC LEN
    INC SI
    JMP NEXT
    DONE:
    DISPLAY MSG2
    MOV AL,LEN
    ADD AL,30H
    SUB AL, 4
    MOV DL,AL
    MOV AH,2
    INT 21H
    MOV AH,4CH
    INT 21H
    CODE ENDS
    END START