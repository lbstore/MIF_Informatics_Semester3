.model small
.stack 100h
.data
   msg1 db "Ivesk eilute: $"      ;isvedama eilute
 
 eilbuf db 220                    ;kiek daugiausia galima nuskityti simboliu
 ilg    db "$"                    ;kiek simboliu buvo nuskaityta
 eil    db 220 dup ("$")          ;nuskaityti simboliai
 ilgis  db "(ilgis    )$"         ;eilute atsakymo isvedimui
 nln  db 13, 10, "$"
 help db "Programavo Julius Markunas", 13, 10, "Programa nuo klaviaturos nuskaito ivesta eilute,", 13, 10, "didziasias raides pavercia mazosiomis ir atspausdina pakeista eilute$" 
 
.code                               
pradzia:
 
        mov ax, @data       
        mov ds, ax
        mov bx,81h    ;isirasome 81 segmento baita;
 
ciklas:    
        mov ax,es:[bx]    ;skaitome es segmente nuo bx baito   ax = s a (ah al)
 
        ;ar al enter
        cmp al,0Dh
        JE neradom    ;parametru;
        cmp ax,"/?"
        JE radom    ;radom 
        inc bx
        jmp ciklas
 
radom:
        mov ah,9
        mov dx,offset help
        int 21h
        jmp pabaiga  
 
neradom:
 
 
 
 
        mov ah, 9
        mov dx, offset msg1   ;pranesimo isvedimas
        int 21h
 
        mov ah, 0Ah
        mov dx, offset eilbuf ;eilutes nuskaitymas
        int 21h
 
 
 
        xor cx, cx         ; cx=0
        mov cl, [ilg]      ; i cl permetame reiksme esancia adresu ilg
 
        cmp cl, 0            ;jei ivesta 0 simboliu,
        JE pabaiga           ;baigia darba
 
 
        mov si, offset eil ; i si permetame eil adresa
        

 
keisk_raide:
        lodsb      ;lobsb :mov al, [si]
                          ;inc si 
 
        cmp al, 24h     ;tikrina ar ne dolerio simbolis,
        JE doleris      ;jai taip tai ji pkeis Sauktuku(!), nes nepakeitus programa daugiua nieko nebespausdintu :)
 
 
        cmp al, 60h			;tikrina ar ascii nr 
        JLE keisk_raide2    ;didesnis uz 60h (61h - pimos mazosios raides numeris)
 
        cmp al, 07Bh		;tikrina ar ascii nr mazesnis 
        JGE keisk_raide2    ;uz 07Bh(07Ah - paskutines mazosios raides simbolis)
 
        sub al, 20h     ;mazaja raide
        mov [si-1], al  ;keicia didziaja
        JMP kartok

keisk_raide2:

        cmp al, 40h     ;tikrina ar ascii nr 
        JLE ne_raide    ;didesnis uz 40h (41h - pimos didziosio raides numeris)
 
        cmp al, 05Bh    ;tikrina ar ascii nr mazesnis 
        JGE ne_raide    ;uz 05Bh(05Ah - paskutines didziosio raides simbolis)
 
        add al, 20h     ;didziaja raide
        mov [si-1], al  ;keicia mazaja
        JMP kartok
        
doleris:  
        mov al, 21h
        mov [si-1], al ;doleri keicia sauktuku (!)
        JMP kartok
 
ne_raide:               ;jei ne didzioji raide,
        mov [si-1], al  ;ja perraso rokia pat
 
 
kartok:
        loop keisk_raide
 
string_ilgis:
 
 
        xor ax, ax              ;
        mov al, [ilg]           ;
        mov bx, 10              ;
        div bl                  ; eilutes ilgio skaiciau pavertimas ascii skaiciu simboliais
        add ah, 30h             ;
        mov [ilgis+9], ah       ;
        xor ah, ah              ;
        div bl                  ;
        add ah, 30h             ;
        mov [ilgis+8], ah       ;
        xor ah, ah              ;
        div bl                  ;
        add ah, 30h             ;
        mov [ilgis+7], ah       ;
 
 
 
        mov ah, 9
        mov dx, offset nln        ;enter
        int 21h
 
 
        mov ah, 9
        mov dx, offset eil        ;eilutes spausdinimas
        int 21h
 
        mov ah, 9
        mov dx, offset nln         ;enter
        int 21h
 
        mov ah, 9
        mov dx, offset ilgis       ;eilutes ilgio spausdinimas
        int 21h
 
pabaiga:
        mov ax, 4C00h
        int 21h                     ;programa baigia darba
 
end pradzia