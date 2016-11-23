;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Naudingi makrosai
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
    org 100h                                     ;Bus COM failas
Start:
   jmp     Nustatymas                           ;Pirmas paleidimas
Senas_I1C dw      0, 0

Rasyk   proc    near                            ;Nadosime doroklyje 
    jmp toliau                                  ;Parleidziame teksta
    
    Tekstas:
    db  'Laikas ...',0Dh, 0Ah
    CR:
    db   0Dh, 0Ah,'$' 
    
    ciklai:                                     ;Kiek laikmacio ciklu jau praejo
    dw 0
    
    toliau:                                     ;Pradedame apdorojima
    push ds
    push cs
    pop ds
    inc word ptr ciklai                          ; ciklai++
    cmp word ptr ciklai,  0060                   ; cikla >= 60?
    jl toliau2                                   ; jeigu ne - iseiname
    mov word ptr ciklai, 0000                    ; ciklai = 0  
    call  RaudonasEkranas
    mov ah, 09
    mov dx, offset Tekstas
    int 21h                                      ; isvedame  teksta
    toliau2:    
    pop ds
    ret                                          ; griztame is proceduros
Rasyk   endp

RaudonasEkranas   proc    near                            ;Nadosime doroklyje 
    jmp daryk
    rezimas:
    dw  0013h
    
    daryk:
    pushall
    
    cmp word ptr cs:[rezimas], 0003h                      ; 03 -> tekstinis rezimas
    jne t1
    mov word ptr cs:[rezimas], 0013h                      ; 13 -> 320x200x256 rezimas
    jmp t2
    t1:
    mov word ptr cs:[rezimas], 0003h
    t2:
    mov ax, word ptr cs:[rezimas]                         ; nustatome reikiama rezima
    int 10h
    mov di,0000h
    mov ax,0A000h                                         ; Nuo A0000 - grafine atmintis
    mov es, ax
    mov cx, 7FFFh
    mov ax, 0C0Ch
    rep stosw                                             ; pildome grafine atminti  
      
    ;mov ax, 0003h
    ;int 10h
    popall    
    ret 
RaudonasEkranas   endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
Naujas_I1C:                                      ; Doroklis prasideda cia
    
    pushall                                      ; Sagome registrus
    call  Rasyk                                  ; Tikriname ciklus ir rasome 
    popall                                       ; 
    
    ;jmp dword ptr cs:[Senas_I1C]                ;  
    iret                                         ; Griztame is pertraukimo 
    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
Nustatymas:
        
        push    cs
        pop     ds
        mov     ax, 351Ch                 ; gauname IV
        int     21h
        mov     Senas_I1C, bx
        mov     Senas_I1C +2, es
        lea     dx, Naujas_I1C
        mov     ax, 251Ch                 ; Nustatome IV
        int     21h
        lea     dx, Nustatymas            ; dx - kiek baitu  
        int     27h                       ; Padarome rezidentu
CSEG ends
end Start        


