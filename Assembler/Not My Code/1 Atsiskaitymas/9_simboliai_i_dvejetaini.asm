; asc2bin.asm
; Autorius : Igoris Azanovas
; Data : 2007-09-29
 
.model small
.stack 100h
 
.data
 
    welcome    db 'Sveiki, si programa "kovertuoja" simbolius i binarini koda', 0Dh, 0Ah, 'prasome ivesti simboliu eilute', 0Dh, 0Ah, '$'
    Klaida1    db 'Leistina tik 5 simboliai $'
    buffer    db 100,?, 100 dup (0)
    eol        db 0Dh, 0Ah, '$'
    press    db 0Dh, 0Ah, 'Press any key ... Wheres the anykey :D ?$'
 
 
.code
 
start:
 
    MOV ax, @data                    ; perkeliam data i registra ax
    MOV ds, ax                        ; perkeliam ax (data) i data segmenta
 
    ; isvedame pasisveikinima
    MOV ah, 09h
    MOV dx, offset welcome
    int 21h
 
    ; skaitom stringa
    MOV dx, offset buffer            ; skaitys i buffer offseta 
    MOV ah, 0Ah                        ; stringo skaitymo subprograma
    INT 21h                            ; dos'o INTeruptas
 
    ; loopinam procesa
    MOV si, offset buffer            ; priskiriam source index'ui bufferio koordinates
    INC si                            ; pridedam 1 prie si , nes pirmas kiek simboliu ish viso
    MOV bh, [si]                    ; idedam i bh kiek simboliu ish viso
    INC si                            ; pereiname prie pacio simbolio
 
    Char:
        LODSB                        ; imame ish es:si stringo dali ir dedame i al 
        CMP al,0dh                    ; jei char'as 0
        JZ Klaida01                    ; tai sokame i klaida
 
 
    ; "konvertuojam" i binarine sistema
 
    binarine:
        MOV bl, al                    ; perkeliam simboli i bl
        MOV cx, 7                    ; nustatome counteri kiek kartu suksis loop'as
        SHL bl, 1                    ; binarineje sistemoje perstumiame per viena vieta i kaire
 
    spausdinti:
        MOV ah, 2                    ; ishvedimui vieno simbolio
        MOV dl, '0'                    ; idedame '0' ish anksto
        TEST bl, 10000000b            ; ishvesim '0' arba '1' pagal pirmaji bita
        JZ nulis                    ; jei nulis sokam , keisti nieko nereikia
        MOV dl, '1'                    ; kitokiu atveju idedame '1'
 
    nulis:
        INT 21h                        ; dos'o INTeruptas
        SHL bl, 1                    ; binarineje sistemoje perstumiame per viena vieta i kaire
 
    loop spausdinti                    ; loop'inam kol cx = 7 kartus
 
    MOV dl, " "                        ; iterpiame tarpa , kad atskirtume char'us
    INT 21h                            ; dos'o INTerruptas
    DEC bh                            ; atemame 1 ish stringo char'u kiekio
    JZ galas                        ; jei bh = 0 , programa baigia darba
    JMP Char                        ; kitaip sokame link kito char'o
 
    Klaida01:
        MOV ah, 09h
        MOV dx, offset Klaida1
        INT 21h
        JMP start
 
    galas:
        MOV dx, offset press
        MOV ah, 09h
        INT 21h
        MOV ah, 01h
        INT 21h
        MOV ax, 4c00h                ; griztame i dos'a
        INT 21h                        ; dos'o INTeruptas
 
end start