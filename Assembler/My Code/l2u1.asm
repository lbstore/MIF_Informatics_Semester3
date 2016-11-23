

;lab 2.1 
;var 3
;(2 -> 7 -> 12 -> 17 -> 22) 
;Vienetiniu pirmojo baito bitu skaiciu
; t.y. kiek yra vienetu pirmajame baite

.model small
.stack 1000h
.data
    MSGdetails db "n = a*3, kur n-siboliu skaicius, a - naturalus skaicius ",13,10,'$'
    MSGinsertLine db "Ivesk simboliu(n) eile:$";
    MSGpressAnyKey db "Press any key$";
    MSGconfirm db "Gauta:$";
    MSGsep db ",$";
    MSGstart db "{$";
    MSGend db "}$";
    MSGerror db "Input error$";
    endL db 13, 10, '$';
   
    
    bufferInput     db 127,127 dup ('$')
    bufferResult    db 127,127 dup ('$') 
    byteVal         db 11, 10,10 dup ('$')
    d1 db 6, 00, 5 dup (0)
    d2 db 10, 00, 10 dup (0)

    temp db 0
    temp1 db 0
    b1 db 0
    b2 db 0
    b3 db 0
    
    sum dw 0
    
    source db 0
    result db 0
    
    index dw 2    
    len dw 0
    
    testVal db 64
    
    a db 1001b    
    b db 0
    c db 2
    d db 2
    e db 00
    
    var1 db 123
    var2 db 0
    var3 db 0
    var4 db 0
    var5 db 0
    var6 db 0
    
    s1s db 0
    s10s db 0
    s100s db 0
    s1000s db 0
    s10000s db 0
    
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
    
    printByteValueDecimal MACRO number
        pushReg
        RR
        mov byte ptr[s100s] , 0
        mov byte ptr[s10s]  , 0
        mov byte ptr[s1s]   , 0
        mov al, byte ptr[number]
        mov bl,100
        div bl
        mov bl, 10
        mov byte ptr[s100s], al
        mov al,ah
        xor ah,ah
        div bl
        mov byte ptr[s10s], al
        mov byte ptr[s1s],ah
        printByteValue s100s
        printByteValue s10s
        printByteValue s1s 
        popReg
    ENDM
    
    printWordValueDecimal MACRO number
        pushReg
        RR
        mov byte ptr[s10000s] , 0
        mov byte ptr[s1000s]  , 0
        mov byte ptr[s100s]   , 0
        mov byte ptr[s10s]  , 0
        mov byte ptr[s1s]   , 0
        mov ax,word ptr[number]
        
        mov bx,10000
        div bx
        mov byte ptr[s10000s],al
        mov ax,dx
        xor dx,dx
        
        mov bx,1000
        div bx
        mov byte ptr[s1000s],al
        mov ax,dx
        xor dx,dx
        
        mov bx,100
        div bx
        mov byte ptr[s100s],al
        mov ax,dx
        xor dx,dx
        
        mov bx,10
        div bx
        mov byte ptr[s10s],al
        mov byte ptr[s1s],dl
        printByteValue s10000s
        printByteValue s1000s
        printByteValue s100s
        printByteValue s10s
        printByteValue s1s 
        popReg
    ENDM    
.code

BEGIN:
 

mov ax, @data
mov ds, ax


print MSGdetails
print MSGinsertLine

read bufferInput
print endL
print MSGconfirm
print endl
print MSGstart
print bufferInput+2 
print MSGend
print endl
RR
mov bl, byte ptr[bufferInput + 1]
xor bh,bh
cmp bl,0
jz error1
mov ax,bx
mov cl,3
div cl
cmp ah,0
jnz error1
;mov word ptr [bx + 3 + bufferInput], 240Ah ; LF + '$' -> eilutes galas
add bx,2
mov word ptr[len],bx 
xor si, si
RR
jmp stillCopy
error1:
jmp error



stillCopy:
mov al,[bufferInput + si]
mov [bufferResult + si], al
cmp al,'$'
je endCopy
inc si
xor ax,ax
jmp stillCopy


endCopy:
xor si,si

next:

RR

mov bx, word ptr[index]
mov dl, byte ptr[bufferResult + bx + 2]
mov byte ptr[temp1], dl
;printByteBinary temp1
;print MSGsep
mov bx,word ptr[index]
mov dl, byte ptr[bufferResult + bx + 1]
mov byte ptr[temp1], dl
;printByteBinary temp1
;print MSGsep
mov bx,word ptr[index]
mov dl, byte ptr[bufferResult + bx + 0]
mov byte ptr[temp1], dl
;printByteBinary temp1
RR
;(2 -> 7 -> 12 -> 17 -> 22) 
;23,22,21,20,19,18,17,16,15,14,13,12,11,10,09,08,07,06,05,04,03,02,01,00
;c7,c6,c5,c4,c3,c2,c1,c0,b7,b6,b5,b4,b3,b2,b1,b0,a7,a6,a5,a4,a3,a2,a1,a0
;bitu pakeitimai
;17 -> 22

mov bx,word ptr[index]
mov ah, byte ptr[bufferResult + bx + 2]; result
mov al, byte ptr[bufferResult + bx + 2]; source

mov byte ptr[result], ah
mov byte ptr[source], al
byteModification source,result,1,6,5,0

;mov ah, byte ptr[result]
;mov al, byte ptr[source]
xor bx,bx
mov bx,word ptr[index]
mov byte ptr[bufferResult + bx + 2], ah


;12 -> 17
RR
mov bx,word ptr[index]
mov ah, byte ptr[bufferResult + bx + 2]; result
mov al, byte ptr[bufferResult + bx + 1]; source

mov byte ptr[result], ah
mov byte ptr[source], al

;printByteBinary source
;print MSGsep
;printByteBinary result
;print MSGsep

byteModification source,result,4,1,0,3

xor bx,bx
mov bx,word ptr[index]
mov byte ptr[bufferResult + bx + 2], ah



;7 -> 12
RR
mov bx,word ptr[index]
mov ah, byte ptr[bufferResult + bx + 1]; result
mov al, byte ptr[bufferResult + bx + 0]; source

mov byte ptr[result], ah
mov byte ptr[source], al

byteModification source,result,7,4,0,3

xor bx,bx
mov bx,word ptr[index]
mov byte ptr[bufferResult + bx + 1], ah


;(2 -> 7 -> 12 -> 17 -> 22) 
;23,22,21,20,19,18,17,16,15,14,13,12,11,10,09,08,07,06,05,04,03,02,01,00
;c7,c6,c5,c4,c3,c2,c1,c0,b7,b6,b5,b4,b3,b2,b1,b0,a7,a6,a5,a4,a3,a2,a1,a0

;2 -> 7
RR
mov bx,word ptr[index]
mov ah, byte ptr[bufferResult + bx + 0]; result
mov al, byte ptr[bufferResult + bx + 0]; source

mov byte ptr[result], ah
mov byte ptr[source], al

byteModification source,result,2,7,5,0

xor bx,bx
mov bx,word ptr[index]
mov byte ptr[bufferResult + bx + 0], ah

;print endL
mov bx,word ptr[index]
mov dl, byte ptr[bufferResult + bx + 2]
mov byte ptr[temp1], dl
;printByteBinary temp1
;print MSGsep
mov bx,word ptr[index]
mov dl, byte ptr[bufferResult + bx + 1]
mov byte ptr[temp1], dl
;printByteBinary temp1
;print MSGsep
mov bx,word ptr[index]
mov dl, byte ptr[bufferResult + bx + 0]
mov byte ptr[temp1], dl
;printByteBinary temp1

RR
mov bx,word ptr[index]
mov al,byte ptr[bufferResult + bx + 0]
mov [a], al
;print endL
HammingWeight a,a
xor ax,ax
mov al,byte ptr[a]
add sum, ax
;print endL
;print endL


RR
add index,3

mov ax, word ptr[len]
mov bx, word ptr[index]
sub ax,bx
;cmp ax,0

jz done
jmp next


done:
print bufferInput+2
print endL
print bufferResult+2
print endL

printWordValueDecimal sum
print endl
jmp exit
error:
print MSGerror
print endl
jmp exit
;Vienetiniu visu pirmojo baito bitu skaiciu
; t.y. kiek yra vienetu pirmajame baite
exit:
pak
mov ah,     4ch                            ; baigimo funkcijos numeris
int 21h

END Begin