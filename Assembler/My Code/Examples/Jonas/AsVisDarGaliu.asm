.model small
.stack 100h
.data
 pranesimas db 13,10, '$'     
 zinute db 'Skaicius dvejetaineje skaiciavimo sistemoje yra: $'
 bufferis db 255, ?, 256 dup ('$')
 atsakymas db 255, ?, 256 dup ('$')
 enteris db 13,10,'$'
.code

mov ax, @data
mov ds, ax

;vykdom nuskaityma
mov ah, 0Ah
mov dx, offset bufferis
int 21h
; 0FFh, ilgis, pirmas elementas


;pereinam i kita eilute
mov ah, 9
mov dx, offset enteris
int 21h  

;spausdinam zinute
mov ah, 9
mov dx, offset zinute
int 21h  

;pereinam i kita eilute
mov ah, 9
mov dx, offset enteris
int 21h                      

;//////////////////////////////////////
;//////////////////////////////////////
                         
;Pradedam Parse'inima
         
mov bl, [bufferis+2]
mov al, bl         
xor ah, ah
sub al, 30h

;Paruosiam ciklui         
mov si, 3

Ciklas:               
mov bl, [bufferis+si]
cmp bl, 0Dh      
je vertimas
inc si
sub bl, 30h 
mov bh, 10d
mul bh
add al, bl           ; negalima rasyt add bl, ax nes dydis neatitinka
jmp ciklas
                         
vertimas:  
xor ah, ah
mov dl, 2
xor si, si

VertimoCiklas:
inc si
div dl
xor ch, ch
mov cl, ah
xor ah, ah
push cx
cmp al, 0
jne VertimoCiklas

Spausdinimas:
mov ah, 02d
pop dx
xor dh, dh
add dl, 30h
int 21h
dec si
cmp si, 0h
je Pabaiga
jmp Spausdinimas                         
                         
;isvedam buferio turini
mov ah, 9
mov dx, offset bufferis
int 21h
                                       
;///////////////////////////////////////
;///////////////////////////////////////
                                       
;uzdarom programa
Pabaiga:
mov ah, 4Ch
int 21h

END