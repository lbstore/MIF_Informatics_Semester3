; Kompiliavimas: tasm -zi pvz3.asm
;                tlink /v pvz3
; Derinimas:   td pvz3
;
;
; Uzduotis: ivesti trizenkli skaiciu, 
; rasti jo skaitmenu sandauga. Atsakyme gali buti nereiksmingu nuliu prekyje
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
       db 'Ivesk skaiciu'

    naujaEilute:   
       db 0Dh, 0Ah, '$'  ; tekstas ant ekrano
       
    buferisIvedimui:
       db 4, 00, 10 dup ('*')  ; uzteks 4 baitu  
       
    buferisAtsakymui:
    sk1  db  00
    sk2  db  00      
    sk3  db  00
         db  0Dh, 0Ah, '$'  ; eilutes pabaiga
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

       mov word ptr [6 + buferisIvedimui], 240Ah ; LF + '$' -> eilutes galas
       
       ; Isvedame ivesta eilute:
       mov dx,     offset buferisIvedimui + 2
       mov ah,     09
       int 21h
   

       ; Krauname vieneta i al:
       mov al,     1
       ; Krauname pirma skaitmeni:
       mov bl,     byte ptr[buferisIvedimui + 2]   ; bl <- pirmas simbolis
       ; Gauname is ASCII skaitine reiksme:
       sub bl,     '0'
       ; Dauginame al is bl:
       mul bl
       
       ; Krauname antra skaitmeni:
       mov bl,     byte ptr[buferisIvedimui + 3]   ; bl <- 2-s simbolis
       ; Gauname is ASCII skaitine reiksme:
       sub bl,     '0'
       ; Dauginame al is bl:
       mul bl

       ; Krauname trecia skaitmeni:
       mov bl,     byte ptr[buferisIvedimui + 4]   ; bl <- 3-s simbolis
       ; Gauname is ASCII skaitine reiksme:
       sub bl,     '0'
       ; Dauginame al is bl:
       mul bl
       
       
       ; Dalinant is 10 galime gauti dalybos klaida, jegu AX div 10 > FFh
       ; Todel naudojame DX:AX pora
       
       mov dx,     0000
       mov bx,     word ptr 10
       div bx                             ; dx <- AX mod 10, ax <- AX div 10

       ; Konvertuojame i ASCII ir saugojame paskutini skaitmeni:       
       add dl, '0'       
       mov byte ptr sk3,  dl
       
       ; Vel daliname is 10:
       mov dx,     0000
       div bx

       ; Konvertuojame i ASCII ir saugojame antra skaitmeni:      
       add dl, '0'       
       mov byte ptr sk2,  dl
       
       ; Vel daliname is 10:
       mov dx,     0000
       div bx

       ; Konvertuojame i ASCII ir saugojame pirma skaitmeni:      
       add dl, '0'       
       mov byte ptr sk1,  dl
       
       ; Isvedame atsakyma:
       mov dx,     offset buferisAtsakymui
       mov ah,     09
       int 21h
  
 
       mov ah,     4ch                            ; baigimo funkcijos numeris
       int 21h
kodas  ends
    end pradzia 

