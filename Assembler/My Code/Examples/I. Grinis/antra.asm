; Kompiliavimas: tasm -zi ivesk.asm
;                tlink /v ivesk
; Derinimas:   td ivesk
;
;
; Uzduotis: pakeisti paskutiniji (iki CR) simboli  pirmuoju
;  
  
.model small
       ASSUME CS:kodas, DS:duomenys, SS:stekas
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
stekas segment word stack 'STACK'
       dw 400h dup (00)               ; stekas -> 2 Kb
stekas ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
duomenys segment para public 'DATA'
   
    pranesimas:
       db 'Ivesk eilute'
    naujaEilute:   
       db 0Dh, 0Ah, '$'  ; tekstas ant ekrano
    dar_pranesimas:
       db 'Tu ivedei: $'
    
    rezultato_pranesimas:
       db 'Paskutinis simbolis keiciamas pirmuoju: $'
    
   
    buferisIvedimui:
       db 10, 00, 100 dup ('*')    
duomenys ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
kodas segment para public 'CODE'
    pradzia:

       mov ax,     seg duomenys                   ; "krauname" duomenu segmenta
       mov ds,     ax
       
       mov ah,     09                             ; spausdinimo funkcijos numeris
       mov dx,     offset pranesimas              ; isvedamojo teksto adresas
       int 21h

       mov ah,     0Ah                            ; ivesties funkcija
       mov dx,     offset buferisIvedimui         ; buferis
       int 21h       

       mov ah,     09                             ; spausdinimo funkcijos numeris
       mov dx,     offset naujaEilute             ; isvedamojo teksto adresas
       int 21h

       
      
       ; Skaityk 0Ah int 21h funkcijos aprasa: 
       ; http://spike.scu.edu.au/~barry/interrupts.html#ah0a

       mov bl,     byte ptr [buferisIvedimui + 1] ; bl<-kiek buvo ivesta simboliu
       xor bh,     bh                             ; bh <- 0   
       mov word ptr [bx + 3 + buferisIvedimui], 240Ah ; LF + '$' -> eilutes galas
       
       ; Isvedame ivesta eilute:
       mov ah,     09                             ; spausdinimo funkcijos numeris
       mov dx,     offset dar_pranesimas          ; isvedamojo teksto adresas
       int 21h

       mov ah,     09                             ; spausdinimo funkcijos numeris
       mov dx,     offset naujaEilute             ; isvedamojo teksto adresas
       int 21h

       mov dx,     offset buferisIvedimui + 2
       mov ah,     09
       int 21h
   

       ; Keiciame eilute (turima omenyje, kad DOS issaugojo bx !):
    
       mov al,     byte ptr[buferisIvedimui + 2]   ; al <- pirmas simbolis
       mov byte ptr[buferisIvedimui + bx + 1], al  ; paskutinis <- al

       ; Isvedame pakeista eilute:
       mov ah,     09                             ; spausdinimo funkcijos numeris
       mov dx,     offset rezultato_pranesimas    ; isvedamojo teksto adresas
       int 21h

       mov ah,     09                             ; spausdinimo funkcijos numeris
       mov dx,     offset naujaEilute             ; isvedamojo teksto adresas
       int 21h

       mov dx,     offset buferisIvedimui + 2
       mov ah,     09
       int 21h
   
       mov ah,     4ch                            ; baigimo funkcijos numeris
       int 21h
kodas  ends
    end pradzia 

