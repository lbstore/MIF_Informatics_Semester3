
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

; ivedam skaiciu abcde
; D1 = a + 5*b + 7*c
; D2 = dee % 9 + bea / 15 

.model small
.stack 100h
.data
    MSGinsertLine db "Ivesk penkiazenkli skaiciu: ", 13,10,'$';
    endL db 13, 10, '$';
    buffer db 6, 00, 10 dup ('$')
    bk db 3, 00, 10 dup ('$')
    d1 db 6, 00, 5 dup ('0')
    d2 db 10, 00, 10 dup ('0')
        
    result1 db 00
    result2 db 00   
    a db 00
    b db 00
    c db 00
    d db 00
    e db 00
        
    PRINT MACRO MSG
    MOV AH,9
    LEA DX,MSG
    INT 21H
    ENDM
    
    BREAK MACRO BUF
    mov ah, 0Ah
    mov dx, offset BUF
    int 21h
    ENDM    
    
;    varToBuffer MACRO buff, number
;        xor cx,cx
;        mov cl, [buff+1]
;        
;        mov byte ptr[d1 + cl],'$'
;        lea si,[d1 + cl]
;        mov bx, 10
;        mov ax, [number]
;        
;        
;    ENDM    
.code

;mov byte ptr[d1 + 5],'$'
;lea si,[d1 + 5]
;
;mov ax, cx
;mov bx, 10


;    asc2:
;    mov dx, 0
;    div bx
;    add dx, '0'
;    dec si
;    mov [si],dl
;    cmp ax,0
;    JZ EXTT     ; End if AX = 0
;    JMP asc2
;
;EXTT:
;    mov word ptr[result1], si

BEGIN:
  


      


mov ax, @data
mov ds, ax


PRINT MSGinsertLine

mov ah, 0Ah
mov dx, offset buffer
int 21h

mov word ptr[12 + d1], 240Ah
mov word ptr[12 + d2], 240Ah
;
;mov ah, 9
;mov dx, offset endL
;int 21h
;
;mov dx,     offset buffer + 2
;mov ah,     09
;int 21h


PRINT endL



;Buferio nuskaitymas i kintamuosius
xor bx, bx
mov bl,byte ptr[buffer  + 2 +0]
sub bl,'0'
mov [a],bl

xor bx, bx
mov bl,byte ptr[buffer  + 2 + 1]
sub bl,'0'
mov [b],bl

xor bx, bx
mov bl,byte ptr[buffer  + 2 + 2]
sub bl,'0'
mov [c],bl

xor bx, bx
mov bl,byte ptr[buffer  + 2 + 3]
sub bl,'0'
mov [d],bl

xor bx, bx
mov bl,byte ptr[buffer  + 2 + 4]
sub bl,'0'
mov [e],bl



; D1 = a + 5*b + 7*c


;1)
    xor cx,cx
    xor bx,bx
    xor ax,ax
    
    mov cl, byte ptr[a]; cx = a
    
;2)    
    mov bl,byte ptr[b]
    mov al, 05
    mul bl
    add cx,ax ;cx+= 5b


;3)
    xor ax,ax
    xor bx,bx
    
    mov bl,byte ptr[c]
    mov al, 07
    mul bl
    add cx,ax ;cx+= 7c

mov word ptr[result1], cx   ;DONE D1





xor ax,ax
xor bx,bx
xor cx,cx
xor dx,dx
xor si,si

mov byte ptr[d1 + 5],'$'
lea si,[d1 + 5]

mov ax, word ptr[result1]
mov bx, 10

asc1:
    mov dx, 0
    div bx
    add dx, '0'
    dec si
    mov [si],dl
    cmp ax,0
    JZ EXT1     ; End if AX = 0
    JMP asc1

EXT1:
PRINT [si]
PRINT endl
    ;mov word ptr[result1], si
    
xor ax,ax
xor bx,bx
xor cx,cx
xor dx,dx
;abcde
;12345
;4*5*5=100 
;100%9 = 1
;2*5*1 = 10
;10/15 = 0;





;54321
;abcde
;
;211 % 9 = 4

;
;415 / 15 = 10


;D2 = dee % 9 + bea / 15 
;5
;1) dee % 9
    xor cx,cx
 
 
    xor ax,ax
    xor bx,bx
    xor dx,dx
    mov bx,10          ; dx 10
    
    mov al,byte ptr[d]  ; ax = 0d00
    mul bx
    mul bx
    add cx,ax           ; cx = ax
    xor ax,ax
    
    mov al,byte ptr[e]  ;al = 0e
    mul bx              ;al = e0
    add cx,ax
    
    xor ax,ax
    mov al,byte ptr[e]
    add cx,ax
    
    xor ax,ax
    mov ax,cx
    xor cx,cx
    
    
    xor dx,dx
    xor bx,bx
    mov bl,09
    div bx              ; ax = ax/9
    add cx,dx           ; dx = ax % 9
    
    
    mov word ptr[result2],cx  ;  dee % 9
    
   
    
    ;BREAK bk
 ;2)   bea / 15 
 ;415 / 15 = 27
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx    
    
    
    mov al,byte ptr[b] ; al = b
    mov bl,10
    mul bx
    mul bx
    add cx,ax
    
    xor ax,ax
    mov al,byte ptr[e]
    mul bx
    add cx,ax
    
    xor ax,ax
    mov al,byte ptr[a]
    add cx,ax

    xor bx, bx
    mov ax,cx
    
    mov bl, 15         
    div bx              ; ax = bea / 15
                        ; dx = bea % 15
    add word ptr[result2], ax   ;DONE D2
    
     ;Pakeitimas atsiskaitinejimo metu
    xor ax,ax
    
    mov ax, word ptr[result2]

    
    xor cx,cx
    mov cx, 123
    mul cl
    mov word ptr[result2],ax
    ;BREAK bk
xor ax,ax
xor bx,bx
xor cx,cx
xor dx,dx
xor si,si

mov ax,word ptr[result2]
mov byte ptr[d2 + 5],'$'
lea si,[d2 + 5]

mov ax, word ptr[result2]
mov bx, 10

asc2:
    mov dx, 0
    div bx
    add dx, '0'
    dec si
    mov [si],dl
    cmp ax,0
    JZ EXT2     ; End if AX = 0
    JMP asc2

EXT2:
    ;mov word ptr[result2], si
    


PRINT [si]
PRINT endL




mov ah,     4ch                            ; baigimo funkcijos numeris
int 21h

END




