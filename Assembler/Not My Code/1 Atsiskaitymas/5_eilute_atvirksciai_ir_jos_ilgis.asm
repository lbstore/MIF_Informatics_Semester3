.model small
.stack 100h
.data
 
 help db 'Asemblerio uzduotis Nr.1.5',13,10,'Programa vartotojo ivesta teksto eilute atvirksciai isveda i ekrana',13,10,'ir paraso simboliu skaiciu eiluteje.',13,10,'***********************',13,10,'Povilas Liubauskas, PS, I kursas, IV grupe',13,10,'$'
 iveskite db "Iveskite eilute: $"
 skaicius db 13,10,"Simboliu skaicius eiluteje: $"
 eilute db 100h dup(0)                ; Rezervuojam 256 baitus eilutei saugot
 
.code
 
TikrinkParam    PROC                ; Funckija is pavyzdzio internete
    MOV    bx, 0081h
  ieskok:
    MOV    ax, es:[bx]
    CMP    al, 0Dh             ;ar ne pabaigos simbolis
    JE    nera                ;jei taip, vadinasi neradau "/?"
    CMP    ax, 3F2Fh            ;gal "?"
    JE    yra                ;radau "?", isvedu pagalba
    INC    bx                ;neradau, ieskau toliau
    JMP    ieskok
   nera:
    MOV    dl, 0
    JMP    endas
   yra:
    MOV    dx, offset help         ;adresas teksto
    MOV    ah, 9
    INT    21h
    MOV    dl, 1
   endas:
    RET
TikrinkParam    ENDP
 
 
start:
    mov    ax,@data            ; Keiciam data segmenta
    mov    ds,ax
 
    call    TikrinkParam            ; Tikrinam parametrus
    cmp    dl,1                ; DL - funkcijos atsakymas
    je    exitas
 
    mov    dx,offset iveskite        ; Paprasom ivest eilute
    mov    ah,9
    int    21h
 
    sub    bx,bx                ; Nuskaitom eilute.
    mov    dx,offset eilute        ; Siaip si funkcija skirta skaityt
    mov    ah,3fh                ; is failo, bet ji tinka ir is klaviaturos
    int    21h                ; skaityt kai BX=0 ir ji labai patogi,
                        ; todel ja ir naudoju :)
 
    dec    ax                ; Sumazinam AX per 1...
 
    push    ax                ; Issaugom ateiciai simb. sk. eiluteje
 
    mov    bx,ax
 
 atgal:                     ; Isvedinejam eilute atbulai:
    dec    bx                ; Isvedam po 1 simboli
    mov    al,[bx+offset eilute]        ; pradedami nuo eilutes pabaigos,
    int    29h                ; mazindami bx po 1
    cmp    bx,0                ; ir tikrindami, ar isvedem
    jnz    atgal                ; reikiama kieki simboliu
 
 
    mov    dx,offset skaicius        ; Parasom "Simboliu skaicius eiluteje: "
    mov    ah,9
    int    21h
 
    pop    ax                ; Pasiimam atgal simb. skaiciu
    dec    ax                ; ... ir darsyk -1, taip atsikratome ENTER
 
    cmp    ax,0                ; Tikrinam, ar nors 1 simb. buvo ivestas
    jnz    kitas_etapas            ; Jei taip - teks isvest ju skaiciu,
    mov    al,'0'                ; o jei ne - tai tiesiog parasom 0 ...
    int    29h
    jmp    pabaiga             ; ... ir baigiam darba
 
 kitas_etapas:
    sub    si,si                ; SI <- 0
 
 skaiciuot_skaicius:                ; Verciam po 1 skaitmeni nuo galo
    cmp    ax,0                ; i simboli ir "stumiam" i steka
    jz    isvestsk            ; kad paskui galetume apkeist
    sub    bx,bx                ; skaitmenis vietomis
    sub    dx,dx
    mov    cx,10
    div    cx                ; As taip darau, nes taip paprasciausia:
    xchg    ax,dx                ; uztenka visada dalint is 10 ir liekana
    add    al,30h                ; bus skaitmuo
    push    ax
    inc    si
    mov    ax,dx
    jmp    skaiciuot_skaicius
 
 isvestsk:
    cmp    si,0                ; Imam skaitmenis is steko ir
    jz    pabaiga             ; atvaizduojam juos
    pop    ax
    dec    si
    mov    dl,al
    mov    ah,2
    int    21h                ; AH=2 INT 21h - isveda simboli,
                        ; kurio kodas yra DL
    jmp    isvestsk
 
 pabaiga:
    sub    bx,bx                ; Palaukiam pries issijungdami,
    mov    dx,offset eilute        ; kad vartotojas spetu
    mov    ah,3fh                ; pamatyt rezultatus
    int    21h
 
 exitas:
    mov    ax,4c00h            ; iseinam [ 00 - viskas gerai :) ]
    int    21h
 
end start