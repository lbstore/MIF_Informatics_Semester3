.model small	;PRIVAL_EIL Pasakom kiek atminties nuskaitinėja
.stack 100h		;PRIVAL_EIL Nurodom Steko dydį
.data			;PRIVAL_EIL Data Segmento pradžia, čia rašysim savo kintamuosius
 hello db 'Iveskite skaiciu nuo 0 iki 255: $'
 zinute db 'Skaicius dvejetaineje skaiciavimo sistemoje yra: ', 13, 10, '$'
 perDidelis db 'Skaicius yra per didelis!!!$'
 neSkaicius db 'Ne desimtainis skaicius!!!','$'
 bufferis db 256 dup ('$')	;Buferis, kuriame talpinsime vartotojo įvestą skaičių
 enteris db 13,10,'$'		;Carriage return, New Line, End Of Line
;-------------------------------------------------------------------------------
.code			;PRIVAL_EIL Kodo Segmento pradžia, čia rašysim savo kodą
;Privalomos eilutės
mov ax, @data	;pasakom Assembleriui, kur mūsų kintamieji aprašyti
mov ds, ax		;negalima tiesiogiai pagal pagr taisyklę komandų - abu operandai negali būti adresai

;spausdinam Pasisveikinimo Žinutę (int 21h, AH 09h)
mov ah, 9
mov dx, offset hello
int 21h  

;vykdom nuskaitymą (int 21h, AH 0Ah)
mov ah, 0Ah
mov dx, offset bufferis
int 21h
; Bufferio turinys: buf_dydis, kiek_nuskaityta,

;pereinam į kitą eilutę spausdindami enteris simbolių seką
mov ah, 9
mov dx, offset enteris
int 21h  
                
;Nuskaitymas ir pirminių žinučių išvedimas baigtas

;-------------------------------------                         
;Apdorojame nuskaitytus duomenis     
    
;Idėja tokia, į imti po vieną skaitmenį iš buferio ir konstruoti skaičių
;skaičius konstruojamas taip: skaičius dauginamas iš 10 ir pridedamas einamasis skaitmuo
;ciklas sukasi tol, kol baigiasi simboliai (šiuo atveju, kai prieina enter'io simbolį)
xor ax, ax
mov si, 2

Ciklas:               
mov bl, [bufferis+si]	; Pasiimam Bufferis[si] elementą

cmp bl, 13d	 	;ciklas sukasi tol, kol bufferis[si] nelygu enter'iui      
je tikrinimas	;jei pasiekėm enter'į, tai ciklas turi sustot

;tikrinam, ar ten dešimtainis skaitmuo (ascii lentėje 30h - 39h yra dešimtainiai skaitmenys)
cmp bl, 30h
jl skaiciausKlaida
cmp bl, 39h
jg skaiciausKlaida

inc si		 ;padidinam einamąjį indeksą vienetu
sub bl, 30h  ;iš einamojo elemento atimam 30h, kad jis įgautų "tikrąją" reikšmę assembleryje
mov bh, 10d	 ;perkeliam į bh 10d, nes MUL galima vykdyti tik su registrais
mul bh		 ;dauginam ah'ą iš bh (10d) (einamąjį skaičių iš 10)
xor dx,dx	 ; PAKEITIMAS, prasivalau papildomą registrą DX 
mov dl, bl	 ; į jaunesnyjį DX baitą DL keliuosi bl (skaitmenį), kadangi sudėties operandai privalo būti to paties dydžio
add ax, dx   ;pridedam einamąjį skaitmenį prie skaičiaus ir vėl sukam ciklą
			 ; PAKEITIMAS baigtas
jmp ciklas



;klaidos žinutė, kai gavom ne dešimtainį skaičių
skaiciausKlaida:
mov ah, 09h	;jei skaičius didesnis, tai spausdinam klaidos žinutę ir šokam į pabaigą
mov dx, offset neSkaicius
int 21h
jmp Pabaiga

;KĄ TURIM:
;Dabar mes AL'e turime įvestąjį skaičių "grynuoju", 
;o ne simboliniu formatu (t.y. turime realią reikšmę)
;Reikia dabar versti į 2-tainę, kaip tai darėm per pirmą paskaitą (dalindami)


;reikia patikrinti ar skaičius didesnis už 255
tikrinimas:
cmp ax, 100h
jl vertimas	;jei skaičius tinkamas, tęsiam darbą
mov ah, 09h	;jei skaičius didesnis, tai spausdinam klaidos žinutę ir šokam į pabaigą
mov dx, offset perDidelis
int 21h
jmp Pabaiga

vertimas:  

xor ah, ah	;prasivalom ah'ą dėl visą ko 
mov bl, 2	;į bl'ą keliamės 2, kad galėtume dalint
xor si, si	;prasivalom indeksiuką, jis skaičiuos, kiek skaitmenų dvejetainių turės

VertimoCiklas:
inc si		;didinam skaitmenų kiekį vienetu
div bl		;dalinam savo skaičių iš dviejų
xor ch, ch	;prasivalom ch'ą dėl visą ko (nebūtina)
mov cl, ah	;į cl'ą įsimetam liekaną
xor ah, ah	;prasivalom ah'ą, kad liekanos neliktų
push cx		;į steką padedam cx'ą (liekaną), reikia dėt CX'ą, nes būtinai turime pushinti 'žodį'
cmp al, 0	;jei skaičius nelygus nuliui, reiškia reikia toliau dalint
jne VertimoCiklas

;KĄ TURIM:
;Dabar mes steke turime visus dvejetainius skaitmenis
;Kadangi mes naudojames standartiniu vertimo į 2-aine metodu,
;reikia skaitmenis rašyti iš kitos pusės, bet steke laikoma priešinga tvarka
;tai kai iš steko trauksime duomenis, viskas bus teisinga tvarka

;spausdinam Žinutę (int 21h, AH 09h)
mov ah, 9
mov dx, offset zinute
int 21h  

;pereinam į kitą eilutę spausdindami enteris simbolių seką
mov ah, 9
mov dx, offset enteris
int 21h      

Spausdinimas:

pop dx		;į DX'ą pop'inam dvejetainį skaitmenį
xor dh, dh	;profilaktiškai prasivalom dh'ą
add dl, 30h	;prie skaitmens pridedam 30h, kad atitiktų ASCII simbolį
mov ah, 02d	;į AH'ą metam 02d, tam, kad galėtume spausdinti simbolį
int 21h		
dec si		;mažinam si vienetu, kai pasiekiam nulį, reiškia, visus simbolius atspausdinom
cmp si, 0h
je Pabaiga
jmp Spausdinimas                         
                         
;Išvedame buferio turinį (INT 21h AH 09h)
mov ah, 9
mov dx, offset bufferis
int 21h
                                       
;///////////////////////////////////////
;///////////////////////////////////////
                                       
;Uždarom programą
Pabaiga:
mov ah, 4Ch
int 21h

END