; multi-segment executable file template.

.model small
.stack 100h
.data
    resultString        db 11, 10,10 dup ('$')
    a db 123
    endL db 13, 10, '$';
    pushReg MACRO
        push ax
        push bx
        push cx
        push dx
    ENDM
    printByteValue MACRO numb
        xor dx,dx
        mov dl, byte ptr[numb]
        add dl, 48
        xor ax,ax
        mov ah, 2h
        int 21h
    ENDM 
    popReg MACRO
        pop ax
        pop bx
        pop cx
        pop dx
    ENDM 
    RR MACRO
        xor ax,ax
        xor bx,bx
        xor cx,cx
        xor dx,dx
    ENDM
    PRINT MACRO MSG
        mov ah,09
        lea DX, MSG
        INT 21H
    ENDM    
    printBdecimal MACRO number
        LOCAL hundredLabel,decimalLabel,onesLabel,exitLabel
        pushReg
        rr
        mov bh,0 ;hundreds
        mov bl,0 ;decimals
        mov cl,0 ;ones
        mov al,byte ptr[number]
        hundredLabel:
            cmp al, 100 
            jl decimalLabel
            sub al, 100
            inc bh
        jmp hundredLabel
        
        
        decimalLabel:
            cmp al, 10
            jl onesLabel
            sub al, 10
            inc bl
        jmp decimalLabel
        
        onesLabel:
            cmp al,0
            jz exitLabel
            sub al,1
            inc cl
        jmp onesLabel
        
        exitLabel:
        add bh,48
        add bl,48
        add cl,48
        mov byte ptr[resultString + 2],bh
        mov byte ptr[resultString + 3],bl
        mov byte ptr[resultString + 4],cl
        ;mov byte ptr[resultString + 5], '$';
        print [resultString+2]
        print endl        
        popReg
     endm
.code

start:
; set segment registers:
    mov ax, @data
    mov ds, ax
    
    printBdecimal [a]
    printBdecimal [a]
    mov ax, 4c00h ; exit to operating system.
    int 21h    


end start ; set entry point and stop the assembler.
