; Kompiliavimas: tasm -zi ivesk2.asm
;                tlink /v ivesk2
; Derinimas:   td ivesk2
;
;
; Uzduotis: nuskaityti komandines eilutes argumenta (failo vardas be pletinio), 
; atidaryti atitinkama faila skaitymui, perra6yti jo turini pagal
; dizasemblerio schema 
;  
  
.model small
.stack 100h
.data
    komEilIlgis db 00
    komEilutesArgumentas db 100h dup (00)
    skaitomasFailas dw 0FFFh 
    

    eiluteIsvedimui db '      db ' 
    nuskaitytas db 00, 00, 'h$' 
   
    klaidosPranesimas db 'Klaida skaitant argumenta $'

    klaidosApieFailoAtidarymaPranesimas db 'Klaida atidarant faila $'

    klaidosApieFailoSkaitymaPranesimas db 'Klaida skaitant faila $'


    naujaEilute db 0Dh, 0Ah, '$'  ; tekstas ant ekrano
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
writeln   macro eilute
          push ax
          push dx
      
          mov ah, 09
          mov dx, offset eilute
          int 21h
          
          mov ah, 09
          mov dx, offset naujaEilute
          int 21h
          
          pop dx
          pop ax          

          endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
readln    macro eilute
          mov ah, 0Ah
          mov dx, offset eilute
          int 21h
          
          mov ah, 09
          mov dx, offset naujaEilute
          int 21h
         
          endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LOCALS @@

.code

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    atverkFaila proc near
        ; dx - failo vardo adresas
        ; CF yra 1 jeigu klaida 
 
        push ax
        push dx

        mov ah, 3Dh
        mov al, 00h       ; skaitymui
        int 21h

        jc @@pab
        mov word ptr skaitomasFailas, ax

        @@pab:  
        pop dx
        pop ax
        ret   
  
    atverkFaila endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    uzdarykFaila proc near
        ; dx - failo vardo adresas
        ; CF yra 1 jeigu klaida 
        push ax
        push bx

        mov ah, 3Eh
        int 21h

        @@pab:  
        pop dx
        pop ax
        ret     
    uzdarykFaila endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    rasykSimboli proc near
        ; al - simbolis 
        push ax
        push dx
        mov dl, al
        mov ah, 02h
        int 21h
        pop dx
        pop ax
        ret   
  
    rasykSimboli endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   konvertuokI16taine proc near
        ; al - baitas
        ; ax - rezultatas
        mov ah, al
        and ah, 0F0h
        shr ah, 1
        shr ah, 1
        shr ah, 1
        shr ah, 1
        and al, 0Fh

        cmp al, 09
        jle @@plius0
        sub al, 10
        add al, 'A'
        jmp @@AH
        @@plius0:
        add al, '0'
        @@AH:
             
        cmp ah, 09
        jle @@darplius0
        sub ah, 10
        add ah, 'A'
        jmp @@pab
        @@darplius0:
        add ah, '0'
        @@pab:
        xchg ah, al 
        ret     
    konvertuokI16taine endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    skaitykArgumenta proc near
         ; nuskaito ir paruosia argumenta
         ; jeigu jo nerasta, tai CF <- 1, prisingu atveju - 0

         push bx
         push di
         push si 
         push ax

         xor bx, bx
         xor si, si
         xor di, di

         mov bl, es:byte ptr[80h]         
         mov byte ptr komEilIlgis, bl
         mov si, 0081h  
         mov di, offset komEilutesArgumentas
         push cx
         mov cx, bx
         mov ah,00
         cmp cx, 0000
         jne @@pagalVisus
         stc 
         jmp @@pab
   
         @@pagalVisus:
         mov al, byte ptr es:[si]
         cmp al, ' '
         je @@toliau
         cmp al, 0Dh
         je @@toliau
         cmp al, 0Ah
         je @@toliau
         mov byte ptr [di],al
         ; call rasykSimboli  
         mov ah, 01                  ; ah - pozymis, kad buvo bent vienas "netarpas"
         inc di     
         jmp @@kitasZingsnis
         @@toliau:
         cmp ah, 01                  ; gal jau buvo "netarpu"?  
         je @@isejimas 
         @@kitasZingsnis:
         inc si
     
         loop @@pagalVisus
         @@isejimas: 
         cmp ah, 01                  ; ar buvo "netarpu"?  
         je @@pridetCOM
         stc                         ; klaida!   
         jmp @@pab 
         @@pridetCOM:
         mov byte ptr [di],'.'
         mov byte ptr [di+1], 'C'
         mov byte ptr [di+2], 'O'
         mov byte ptr [di+3], 'M'
         clc                         ; klaidos nerasta
         @@pab:
         pop cx
         pop ax
         pop si
         pop di 
         pop dx
         ret
    skaitykArgumenta endp 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    skaitomeFaila proc near
        ; skaitome faila po viena baita 
        ; bx - failo deskriptorius
        ; dx - buferis 
        push ax
        push dx
        push bx
        push cx
        push si
                
        mov si, dx 
        @@kartok:
        mov cx, 01
        mov ah, 3Fh 
        int 21h
        jc @@isejimas           ; skaitymo klaida
        cmp ax, 00
        je @@isejimas           ; skaitymo pabaiga

        mov al, byte ptr [si]   ; is buferio
        
        
        call konvertuokI16taine
        mov word ptr [si], ax  
        writeln eiluteIsvedimui        
        jmp @@kartok
        
        @@isejimas:
        pop si
        pop cx
        pop bx
        pop dx
        pop ax
        ret   
    skaitomeFaila endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    writeASCIIZ proc near
         ; spausdina eilute su nuline pabaiga, dx - jos adresas
         ; 

         push si
         push ax
         push dx
 
         mov  si, dx
 
         @@pagalVisus:
         mov dl, byte ptr [si]  ; krauname simboli
         cmp dl, 00             ; gal jau eilutes pabaiga?
         je @@pab

         mov ah, 02
         int 21h
         inc si
         jmp @@pagalVisus
         @@pab:
         
         writeln naujaEilute
  
         pop dx
         pop ax
         pop si
         ret
    writeASCIIZ endp 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    pradzia:
       ; pradzioje ds ir es rodo i PSP;
       ; PSP+80h -> kiek baitu uzima komandine eilute (be programos pavadinimo)
       ; 
       mov ax,     @data                   ; "krauname" duomenu segmenta
       mov ds,     ax
       
       call skaitykArgumenta
       jnc @@rasykArgumenta
       writeln klaidosPranesimas
       jmp @@Ok

       @@rasykArgumenta: 
       mov dx, offset  komEilutesArgumentas      
       call writeASCIIZ 
       
       ;Atidarome faila
       mov dx, offset  komEilutesArgumentas      
       call atverkFaila
       jnc @@skaitomeFaila
       writeln klaidosApieFailoAtidarymaPranesimas
       jmp @@Ok

       @@skaitomeFaila:
       mov bx, word ptr skaitomasFailas          
       mov dx, offset nuskaitytas          
       call skaitomeFaila
       jnc @@failoUzdarymas
       writeln klaidosApieFailoSkaitymaPranesimas
       ;jmp @@Ok

       @@failoUzdarymas:
       mov bx, word ptr skaitomasFailas          
       call uzdarykFaila

       @@Ok:
       mov ah,     4ch                            ; baigimo funkcijos numeris
       int 21h
    end pradzia 

