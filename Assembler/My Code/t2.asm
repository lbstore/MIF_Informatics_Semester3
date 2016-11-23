org 100h

xor ax, ax
mov es, ax

; Save interrupt address so we can restore it later
mov bx, [es:69h*4]
mov [old_int_off], bx
mov bx, [es:69h*4+2]
mov [old_int_seg], bx


; modify interrupt vector table on 0x69th entry to point to our interrupt
mov dx, int_prog
mov [es:69h*4], dx
mov ax, cs
mov [es:69h*4+2], ax

nop

int 69h ; execute our interrupt

;restore old interrupt
mov ax, [old_int_seg]
mov [es:69h*4+2], ax
mov dx, [old_int_off]
mov [es:69h*4], dx

mov ax, 0x4c00 ; Exit
int 21h


; Our interrupt just prints some text :)
int_prog:

pusha ; save old registers, just incase ;)

mov ah, 9
mov dx, our_text
int 21h

popa

iret


our_text db "Bleh... $"

old_int_seg dw 0
old_int_off dw 0
