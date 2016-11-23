; Kompiliavimas: tasm -zi pirma.asm
;                tlink /v pirma
; Derinimas:   td pirma
;
.model small
       ASSUME CS:kodas, DS:duomenys, SS:stekas
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
duomenys segment para public 'DATA'
    pranesimas:
       db 'Labas, tai pirmoji programa', 0Dh, 0Ah, '$'  ; tekstas ant ekrano
duomenys ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
kodas segment para public 'CODE'
    pradzia:

       mov ax,     seg duomenys                   ; "krauname" duomenu segmenta
       mov ds,     ax

       mov ah,     09                             ; spausdinimo funkcijos numeris
       mov dx,     offset pranesimas              ; isvedamojo teksto adresas
       int 21h

       mov ah,     4ch                            ; baigimo funkcijos numeris
       int 21h
kodas  ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
stekas segment para stack 'STACK'
       dw 400h dup ('**')               ; stekas -> 2 kb
stekas ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    end pradzia
