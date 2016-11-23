;Programa iveda simboliu eilute ir atspausdina pozicijas 
;rastu skaitmenu
;   pvz., abs daa52dd => 7 8


           

.model small
.stack 100h 
.data       
    msg1 db "Iveskite eilute: ","$"
    msg2 db "Rastu skaitmenu pozicijos: ","$"

    eilute      db 255,0,255 dup (0)    ;simboliu eilute
    nauja       db 13,10,'$'            ;naujos eilutes pradzia
   

.code

start:
    mov  ax, @data                      
    mov  ds, ax

    mov  ah, 09h                        ;1-as pranesimas 
    lea  dx, msg1                       
    int  21h                            

    mov  ah, 0Ah                        ;nuskaitoma eilute ir
    lea  dx, eilute                     ;issaugomas buferio adresas  
    mov  si, dx                         
    add  si, 2                                                                
    int  21h       

    mov ah, 09h                         ;nauja eilute
    lea dx, nauja                       
    int 21h                            

    mov  ah, 09h                        ;2-as pranesimas
    lea  dx, msg2                        
    int  21h                            

    mov bx, -1                          ;simbolio vieta eiluteje: -1

ciklas:
    lodsb                               ;gaunamas simbolis,
    inc bx                              ;vieta didinama vienetu

    cmp  al, 13                        ;ar jau eilutes pabaiga?
    jz   exit

    cmp  al, 65                         ;ar simbolis nera tarp 'A'..
    jb   ciklas

    cmp  al, 90                         ;..ir 'Z'?
    ja   ciklas

    mov  ax, bx                         ;isvedama pozicija
    mov  cx, 10
    call spausdinti_skaiciu

    mov  ah, 2                          ;isvedamas tarpas 
    mov  dl, 32                         
    int  21h                             

    jmp  ciklas        

exit:
    xor  ax, ax                         ;laukia
    int  16h

    mov  ax, 4c00h                      ;isejimas
    int  21h          

spausdinti_skaiciu proc near                   
    ;konvertuoja registro ax reiksme i simbolini desimtaini sk. 
    ;ir atspausdina
    
skloop:  
    xor  dx, dx
    div  cx              
    push dx

    cmp  ax, 0
    je   undo
    call skloop

undo:
    pop  dx

pdig:			;
    add  dl, 30h                        
    cmp  dl, 39h                        
    jle  pch
    add  al, 7

pch:  			;atskiro simbolio spausdinimui
    mov  ah, 2
    int  21h

    ret

spausdinti_skaiciu endp

    mov ah,4Ch
    mov al,0h
    int 21h		
        
end start
