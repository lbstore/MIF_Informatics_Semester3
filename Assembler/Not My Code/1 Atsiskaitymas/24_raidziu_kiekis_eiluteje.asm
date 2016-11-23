.model small
.stack 100h
.data          
    msg0    DB  "Programa skaiciuoja, kiek ivesta raidziu.",10,13,"Programa parase Zygimantas Bruzgys, I kurso, 4 grupes studentas",10,13,"$"
    msg1    DB  "Programa skaiciuoja, kiek ivesta raidziu.",10,13,"?eilte: $"
    msg2    DB  "Raidziu kiekis eiluteje: "
    msg3    DB  "   ",10,13,"$"    
    divisor DB  10
    lfeed   DB  10,13,"$"
    buffer  DB  255
    slength  DB  ?
    string  DB  255 dup('$')
 
.code
main:
    mov ax, @data
    mov ds, ax
 
    call params
 
    mov ah, 09h
    lea dx, msg1
    int 21h
 
    mov ah, 0Ah
    lea dx, buffer
    int 21h
 
    mov ah, 09h
    lea dx, lfeed
    int 21h
 
    xor bl, bl
    xor cx, cx
    mov cl, [slength]
    lea si, string
 
    cmp cl, 0
    je pabaiga
 
    ciklas:
        lodsb
        cmp al, 'A'
        jb continue
        cmp al, 'Z'
        ja mazoji
        jmp raide
 
        mazoji:
            cmp al, 'a'
            jb continue
            cmp al, 'z'
            ja continue
            jmp raide
 
        raide:
            inc bl
            loop ciklas
            jmp pabaiga    
 
        continue:
            loop ciklas
            jmp pabaiga
 
pabaiga:   
    call print
exit:
    mov ax, 4C00h
    int 21h
 
print proc    
    xor ax, ax
    xor cx, cx
    lea si, msg3
 
    mov al, bl
    cmp al, 100
    jae tzenklis
    cmp al, 10
    jae dzenklis
 
    vzenklis:
        mov cl, 1
        jmp cfor
    dzenklis:
        mov cl, 2
        add si, 1
        jmp cfor
    tzenklis:
        mov cl, 3
        add si, 2               
 
    cfor:        
        div divisor
        add ah, 30h
        mov [si], ah
        dec si
        mov ah, 0
        loop cfor
 
    mov ah, 09h
    lea dx, msg2
    int 21h
 
    ret
print endp 
 
params proc        
    mov bx, 81h
 
    cwhile:
        mov ax, es:[bx]
 
        cmp al, 13
        je paramsexit  
 
        cmp ax, 'h-'
        je paramsprint
        inc bx
        jmp cwhile
 
    paramsprint:
        mov ah, 09h
        lea dx, msg0
        int 21h
        jmp exit
 
    paramsexit:
        ret
params endp
 
end main