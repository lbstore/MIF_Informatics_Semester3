

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pushall macro
    push    ax
    push    bx
    push    cx
    push    dx
    push    ds
    push    es
    push    si
    push    di
    push    bp
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
popall  macro
    pop bp
    pop di
    pop si
    pop es
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CSEG segment
   assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
   org 100h

Start:
   jmp     Nustatymas
Senas_I1C:
    dw      0, 0

write   proc    near
    jmp toliau

    Tekstas:
    db  'Laikas baigesi',0Dh, 0Ah,'$'

    ciklai:
    dw 0

    toliau:
    push ds
    push cs
    pop ds
    inc word ptr ciklai
    cmp word ptr ciklai,  0060
    jl toliau2
    mov word ptr ciklai, 0000
    mov ah, 09
    mov dx, offset Tekstas
    int 21h
    push    ds
    mov     ax, word ptr Senas_I1C + 2
    mov     dx, word ptr Senas_I1C
    mov     ds, ax
    mov     ax, 251Ch                 ; Atstatome IV
    int     21h
    pop     ds

    toliau2:

    pop ds
    ret
write   endp

write2 proc near
  cmp ah,09
  jne endthis
  pushall
  mov ah,09
  mov dx,offset Tekstas
  int 21h
  popall
  endthis:
  ret
write2 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Naujas_I1C:
    ;pushall
    call write2
    ;;popall
    ;jmp dword ptr cs:[Senas_I1C]
    iret
    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Nustatymas:

        push    cs
        pop     ds
        mov     ax, 3521h                 ; gauname IV
        int     21h
        mov     word ptr Senas_I1C, bx
        mov     word ptr [Senas_I1C + 2], es
        lea     dx, Naujas_I1C
        mov     ax, 2521h                 ; Nustatome IV
        int     21h
        lea     dx, Nustatymas
        inc     dx
        int     27h
CSEG ends
end Start
