; Linas Valiukas, VU MIF programu sistemos, 1 kursas, 4 grupe
;
; Praktine uzduotis nr. 1
;
; "Parasykite programa, kuri atspausdina ivestos simboliu eilutes
; ASCII kodus sesioliktainiu pavidalu"
 
.model Small
.stack 100h    ; 256 baitu stekas
 
.data
 
    ; Skaitoma eilute
    max_ilgis db 254        ; Didziausias eilutes ilgis
    eilutes_ilgis db ?        ; Ivestos eilutes ilgis, pradines reiksmes nera ('?')
    eilute db 255 dup("$")    ; Pati eilute, uzpildyta "$" zenklais
 
    ; Paaiskinimas, ka prasome padaryti
    iveskite_eilute db "Iveskite eilute: $"
 
    ; Help'as
    help1 db "Linas Valiukas, VU MIF programu sistemos, 1 kursas, 4 grupe", 13, 10, "$"
    help2 db "Praktine uzduotis nr. 1 (7)", 13, 10, "$"
    help3 db "Parasykite programa, kuri atspausdina ivestos simboliu eilutes ASCII kodus sesioliktainiu pavidalu.", 13, 10, "$"
 
    ; Kiti    
    br db 13, 10, "$"        ; Line break'as
    h_space db "h $"        ; "h "
 
 
.code
 
start:
 
    ; Irasome 'data' segmento pradzios adresa i DS
    mov ax, @data
    mov ds, ax
 
    mov bx, 0081h    ; Parametrai matyt laikomi nuo 81h
 
 
; "/?" bajeris
ar_rodyti_helpa:
 
    ; Skaitomas ES segmentas nuo BX (81h) baito
    mov ax, es:[bx]
 
    ; Palyginame AL su Enter'iu
    cmp al, 0dh
    je vykdyti_programa        ; ne "/?" - vykdom algoritma
 
    ; Jei ne Enter, gal "/?"?
    cmp ax, "?/"
    je rodyti_helpa
 
    ; (Dar) neradom - padidinam BX, ziuresim i kita simboli
    inc bx
    jmp ar_rodyti_helpa
 
 
; Rodome help'a
rodyti_helpa:
 
    mov ah, 9
 
    ; Spausdiname visas tris help'o eilutes
    mov dx, offset help1
    int 21h
    mov dx, offset help2
    int 21h
    mov dx, offset help3
    int 21h
 
    ; Toliau nebetesiame, baigiame darba
    jmp pabaiga
 
 
 
; Nerodome help'o, vykdome programa
vykdyti_programa:
 
    ; Spausdiname "Iveskite eilute: "
    mov dx, offset iveskite_eilute    ; ta pati darytu ir 'lea dx, ivesk'
    mov ah, 9
    int 21h
 
    ; Skaitome pacia eilute
    mov ah, 0ah                 ; 10-a funkcija
    mov dx, offset max_ilgis    ; Max. eilutes ilgio adresas, irgi galima su 'lea'
    int 21h
 
    ; Nukeliame i kita eilute (\n)
    mov dx, offset br
    mov ah, 9
    int 21h
 
 
    ; Uznuliname CX
    xor cx, cx
 
    ; Perkeliame i CL eilutes ilgi
    mov cl, [eilutes_ilgis]
 
    ; Jei nieko neivesta, shokam i pabaiga
    cmp cl, 0
    je pabaiga
 
    ; Perkeliame i SI pirmojo eilutes simbolio adresa
    mov si, offset eilute
 
 
; Skaitysime po viena simboli ir spausdinsime 16-ainius atitikmenis    
algoritmas:
 
    lodsb    ; Turbut tas pats kas: mov al, [si]; inc si
 
    ; Perskaitytas simbolis yra AL'e
 
    ; Uznuliname AH, kad negadintu dienos
    xor ah, ah
 
    ; Daliname AX is 10, AL = dalybos rezultatas,
    ; AH = liekana
    ; jeigu AX = 2Ah ('*'), tai AL = 2h, AH = 0Ah
    mov dl, 16
    div dl
 
    ; Spausdiname pirmo simbolio hex'a
    call Raide
 
    ; Spausdiname antro simbolio hex'a
    mov al, bh
    call Raide
 
    ; 'h '
    mov dx, offset h_space
    mov ah, 9
    int 21h
 
 
    loop algoritmas    ; is CX atima vieneta ir kartoja
 
 
    ; Spausdiname linebreak'a
    mov dx, offset br
    mov ah, 9
    int 21h
 
    ; Baigiam algoritma
    jmp pabaiga
 
 
 
    ; Procedura, nustatanti sesioliktaine raide is ASCII kodo, i ja spausdinanti
    ; Pati raide yra AL'e
    Raide proc
 
        ; 0-9
        cmp al, 9
        jle nuo_nulio_iki_devyniu
 
        ; a-f
        cmp al, 9
        jg nuo_a_iki_f
 
        nuo_nulio_iki_devyniu:
            add al, 48
 
            jmp Raide_pabaiga
 
        nuo_a_iki_f:
            add al, 55
            jmp Raide_pabaiga
 
        ; Proceduros pabaiga
        Raide_pabaiga:
 
            ; Nusikopijuojame AH i BH, nes DOS'as vel
            ; perrasys ka nors
            mov bh, ah
 
            ; Spausdiname simboli
            mov dl, al
            mov ah, 02h
            int 21h
 
            ret
 
    Raide endp
 
 
 
; Programos pabaiga    
pabaiga:
 
    ; Sakom ate ate DOS'ui
    mov ah, 4ch
    mov al, 0
    int 21h
 
end start