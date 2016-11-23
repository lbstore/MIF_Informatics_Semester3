.model small
.stack 100h
.data
    msg1        DB "Iveskite simboliu eilute", 13, 10, "$"
    msg2        DB "Pabaiga", "$" 
    msg3        DB "Eiluteje buvo tiek simboliu:   ", "$"
    buferis        DB 255
    ilgis        DB "$"
    eilute        DB 255 dup (?)
    nauja_eil    DB 13, 10, "$"
    help        DB "Asemblerio uzduotis Nr 30", 13, 10, "Parasykite programa, kuri ", 13, 10, "ivesta simboliu eilute suskaido zodziais ir atspausdina eilutes ilgi", 13, 10, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", 13, 10, "Vykintas Vaškys, PS, I kursas, IV grupe", 13, 10, "$"
    skaiciuok   DW 0
    isv         DW ? 
    daliklis    DB 10d
 
.code
start:
    mov AX, @data
    mov DS, AX
 
    mov BX, 81h         ;
                        ;
ciklas:    
    mov AX, ES:[BX]     ;skaitomas ES segmentas nuo BX baito   AX = s a (AH AL)
                        ;
    cmp AL, 0Dh         ;žiūri ar al nėra enter
    je neradom            ;jei nėra papildomų parametrų šoka į neradom
 
    cmp AX, "?/"        ;jei nebuvo enter ziuri, ar parametras nera lygus /?
    je radom            ;radom /? ir nusoka i radom
 
    inc BX              ;jei nei enter, nei /? neranda, padidina BX 
    jmp ciklas          ;jei nerado nei enter nei /? kartoja cikla is naujo.
                        ;BX padidinamas tam, kad toliau skaitytu nuo kito baito. kokia bebūtų eilutė, ji arba turės pabaigą, arba turės /?,
                        ;arba bus per ilga, ko pasekoje turėsite errorą.
 
radom:                  ;jei jau radom /? tai darom sitaip:
    mov AH, 09h         ;standartinė teksto išvedimo funkcija [copy - paste]. AH pusbaičiui priskiriame reikšmę 9.
    mov DX, offset help ;spausdina help žinutę, kurią aprašėme data segmente.
    int 21h             ;iškviečiamas interuptas
    jmp pabaiga         ;šokama į pabaigą, kur programa uždaroma.
 
neradom:                ;jei neranda parametr /?, daro šitaip:
 
    mov AH, 09h            ;vėlgi - eilutes isvedimas
    mov DX, offset msg1    ;priskiria žinutės, kurią spausdina, adresa
    int 21h                ;21 interuptas (dosa)
 
 
skaitymas:
    mov AH, 0ah         ;standartinė eilutės nuskaitymo funkcija
    mov DX, offset buferis    ;galima taip: lea DX, buferis
    int 21h
 
    xor CX, CX            ;užnulina CX (griezta disjukcija)
    mov CL, [ilgis]     ;į CL įkelia eilutės ilgio reikšmę
    cmp CL, 0           ;
    je pabaiga          ;jei eilutė lygi nuliui, tada šoka į programos uždarymą
    mov SI, offset eilute  ;jei yra simbolių, ją įrašo į SI regstrą  
 
    mov AH, 09h         ;čia dėl elementaraus vaizdingumo - enter
    mov DX, offset nauja_eil
    int 21h
 
    mov BX, 00d         ;priskiriu nulio reikšmę BX. čiuo atveju jį naudojų kaip boolean'ą. ir čia jo reikšmė k
 
 
ciklas2:                ;prasideda viklas, kuris tikrins ar nėra tarpų
    lodsb                ;ši funkcija priskiria AL paieliui po vieną eilutės simbolį
                        ;kitaip galima aprašyti šitaip:
                        ;mov AL, [SI]
                        ;inc SI
    inc skaiciuok       ;čia skaičiuojame, kiek simbolių yra eilutėje.
 
    cmp AL, 20h         ;tikrinam, ar AL priskirtas simbolis nėra tarpas
    je keitimas           ;jei tarpas, šokam į 'tarpas'
    jmp spausdinimas1   ;jei ne tarpas - spausdinam simbolį
 
spausdinimas1:          ;simbolio spausdinimas
    mov BX, 01d         ;priskiria reikšmę t.
 
    mov AH, 02h         ;taip aprašome, jei spausdiname pavienį simbolį
    mov DX, [SI-1]        ;priskiriam DX tai, ką spausdinsim
    int 21h             ;tradiciškai iškviečiam interuptą
 
    jmp kartojimas
 
keitimas:               ;keičiam tarpą nauja eilute
    cmp BX, 00d         ;tikrinam ar kintamasis neturi reikšmės k. jei turi, vadinasi prieš tai buvo spausdinta nauja eilutė 
    je kartojimas       ;todėl grįžtam atgal į ciklą
 
    mov AH, 09h         ;jei BX turi reikšmę T[1], tai spausdiname naują eilutę.
    mov DX, offset nauja_eil
    int 21h
 
    mov BX, 00d         ;priskiriame BX reikšmę K[0], kad vietoj šalia esančio tarpo nespausdintų naujos eilutės vėl
 
    jmp kartojimas      ;vėl kartojam ciklą
 
kartojimas:
    loop ciklas2        ;liepiam kartoti ciklą. loop iš esamos  reikšmės atima 1 ir nujumpina į nurodytą vietą
 
nulinimas:                ;nunulinam CX registrą
    xor CX, CX               
    mov AX, [skaiciuok] ;priskiriam AX simbolių skaičių
    jmp vertimas        ;dabar šitą skaičių perversim į dešimtainę sistemą.
 
vertimas:               ;keičiam  (12d=ch c/10 = 1 ir 2 liekana. 1/10 = 0 ir 1 liekana. surašom liekanas atvirkščia tvarka - 12]
    div daliklis        ;dalinam AX iš dešimties. liekana keliauja į AH, sveikoji dalis į AL
    xor BX, BX          ;nunulinam BX, kurį anksčiau naudojome
    add AH, 30h         ;prie liekanos skaičio pridedame 30 [pastebime, kad 0, 1, 2... atitinkamai ascii lentelėj lygūs 30h, 31h, 32h...]
    mov BL, AH          ;priskiriame BL liekaną
    push BX             ;ir ją įkeliame į stacką
    xor AH, AH          ;ištrinam liekaną
    inc CX              ;padidiname CX vienetu - skaičiuojam, kiek skaičius turi skaitmenų
    cmp AL, 0           ;palyginam, ar sveikoji dali lygi nuliui
    ja vertimas         ;jei nelygi kartojam ciklą, dalinam ją išnaujo ir t.t.
 
    mov AH, 09h         ;jei lygi nuliui, vadinasi skaičius jau sutvarkytas. stacke sudėlioti tvarkingai skaičiai
    mov DX, offset nauja_eil ;kad tvarkingai atrodytų - praleidžiam eilutę
    int 21h
 
    mov AH, 09h         ;parašome žinutę, kad yra tiek simbolių:
    mov DX, offset msg3
    int 21h
 
    jmp spausdinimas2   ;ir spausdinam simbolių skaičių
 
spausdinimas2:          ;simbolių skaičiaus spausdinimas:
    pop isv             ;iš stacko išimam viršutinį skaitmenį ir jį priskiriam isv wordui
    mov AH, 02h         ;spausdinam tą skaitmenį
    mov DX, [isv]
    int 21h
 
    loop spausdinimas2  ;iš CX atimamas vienetas ir spausdinamas kitas skaitmuo
 
    mov AH, 09h         ;kai CX įgyją reikšmę 0, visi skaitmenys atspausdinti, persikeliam į  naują eilutę
    mov DX, offset nauja_eil
    int 21h  
 
    jmp pabaiga         ;ir uždarinėjam programą
 
pabaiga:     
    mov AH, 09h         ;dėl tvarkos padarom tarpą
    mov DX, offset nauja_eil
    int 21h 
 
    mov AH, 09h         ;atspausdiname žodį pabaiga, kad niekam nekiltų noras tvirkinti programos toliau
    mov DX, offset msg2
    int 21h
 
    mov Ax, 4c00h       ;ir [copy-paste] uždarome programą
    int 21h     
 
end start