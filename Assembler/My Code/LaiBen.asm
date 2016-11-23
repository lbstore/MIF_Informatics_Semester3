    pushReg MACRO
        push ax
        push bx
        push cx
        push dx
    ENDM
    
    popReg MACRO
        pop ax
        pop bx
        pop cx
        pop dx
    ENDM    
        
    PRINT MACRO MSG
        MOV AH,9
        LEA DX,MSG
        INT 21H
    ENDM
    
    printByteValue MACRO numb
        xor dx,dx
        mov dl, byte ptr[numb]
        add dl, 48
        xor ax,ax
        mov ah, 2h
        int 21h
        
    ENDM    
    
    PAK MACRO
        lea dx, MSGpressAnyKey
        mov ah, 9
        int 21h   
        mov ah, 1
        int 21h
    ENDM
       
    READ MACRO BUF
        mov ah, 0Ah
        mov dx, offset BUF
        int 21h
        xor bx,bx
        mov bl, byte ptr[BUF + 1]
        mov word ptr[bx + 2 + BUF], 240Ah;
        
    ENDM    

    RR MACRO
        xor ax,ax
        xor bx,bx
        xor cx,cx
        xor dx,dx
    ENDM
    
    BYTEMODIFICATION MACRO src,res,from,to,left,right
        RR;Reset Registers
        ;src - source of the byte
        ;result - byte portion that will be changed according to the bit from 'orig'
        ;from - bit position in 'orig'
        ;to - bit position in 'res'
        ;shiftLeft - ammount of steps required to shift 'from' to left so that it'll match 'to' position
        ;shitfRight - analogy to shiftLeft just to the right 
        mov al, byte ptr[src]
        mov ah, byte ptr[res]
        mov bl, 1   ;from register  [0..7]
        mov dl, 1   ;to register    [0..7]
        mov cl, from
        shl bl, cl  ;shift left to the 'from' position
        mov cl, to
        shl dl, cl  ;shift left to the 'to' position
        and bl, al  ;extract 'from'
        and dl, ah  ;extract 'to'
        ;move 'from' bit to 'to' corresponding position
        mov cl, left
        shl bl, cl
        mov cl, right
        shr bl, cl
        ;if bits are different, toggle the 'res' bit      
        xor dl, bl    
        xor ah, dl
        mov byte ptr[res],ah
        ;changed bit is stored in ah register
    ENDM    
    
    HammingWeight MACRO src,result
        RR
        mov ah, byte ptr[src]
        mov al, byte ptr[src]
        shr al, 1
        and ah, 01010101b
        and al, 01010101b
        add cl,ah
        add cl,al
        xor ax,ax
        
        mov al,cl
        mov ah,cl
        shr al, 2
        and ah, 00110011b
        and al, 00110011b
        xor cx,cx
        add cl,ah
        add cl,al
        xor ax,ax
        
        mov al,cl
        mov ah,cl
        shr al, 4
        and ah, 00001111b 
        and al, 00001111b
        xor cx,cx
        add cl,ah
        add cl,al
        
        mov byte ptr[result],cl
        
      
    ENDM
      
     printByteBinary MACRO number
        mov cl, byte ptr[number]
        mov al, cl
        and al, 10000000b
        shr al, 7
        add al, 48
        mov byte ptr[byteVal + 2],al
        ;mov byte ptr[temp],al
        ;printByteValue temp
        mov al, cl
        and al, 01000000b
        shr al, 6
        add al, 48
        mov byte ptr[byteVal + 3],al
        ;mov byte ptr[temp],al
        ;printByteValue temp
        mov al, cl
        and al, 00100000b
        shr al, 5
        add al, 48
        mov byte ptr[byteVal + 4],al
        ;mov byte ptr[temp],al
        ;printByteValue temp
        mov al, cl
        and al, 00010000b
        shr al, 4
        add al, 48
        mov byte ptr[byteVal + 5],al
        ;mov byte ptr[temp],al
        ;printByteValue temp
        mov al, cl
        and al, 00001000b
        shr al, 3
        add al, 48
        mov byte ptr[byteVal + 6],al
        ;mov byte ptr[temp],al
        ;printByteValue temp
        mov al, cl
        and al, 00000100b
        shr al, 2
        add al, 48
        mov byte ptr[byteVal + 7],al
        ;mov byte ptr[temp],al
        ;printByteValue temp
        mov al, cl
        and al, 00000010b
        shr al, 1
        add al, 48
        mov byte ptr[byteVal + 8],al
        ;mov byte ptr[temp],al
        ;printByteValue temp
        mov al, cl
        and al, 00000001b
        add al, 48
        mov byte ptr[byteVal + 9],al
        ;mov byte ptr[temp],al
        ;printByteValue temp
        print [byteVal+2]
 
    ENDM  