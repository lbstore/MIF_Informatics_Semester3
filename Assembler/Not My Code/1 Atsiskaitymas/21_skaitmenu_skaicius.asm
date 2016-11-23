; Suskaiciuoti ivestoj eilutej didziasias raides.


.model small
.stack 100h
.data
msg1 db "Iveskite teksta: $"
msg2 db 10,13,"skaitmenu skaicius $"
ten dw 10 		; WORD tipo kintamasis (10), bus naudojamas dalyboje

.code
mov ax, @data 		; paruosiam duomenu segmenta
mov ds, ax

lea dx, msg1 		; i dx pakraunam pirmo pranesimo adresa
mov ah, 09h 		; su 9-ta funcija pranesima isvedame i ekrana
int 21h

sub cx, cx 		; cx = cx - cx, t.y. cx = 0

readin: 
mov ah, 01h 		; 1-os f-jos pagalba skaitome klavisu paspaudimus
int 21h
cmp al, 13 		; jei nuspaustas ENTER - ivedimas baigtas
je endread 		; pereiname prie endread zyma pazymeto kodo
cmp al, '0' 		; tikrinam ar simbolis yra skaicius raide
jb readin 		; jei simbolio kodas mazesnis uz '0' koda tai skaitom toliau
cmp al, ':' 		; tikrinam ar simbolis yra skaicius raide
jb iftrue 		; simbolio kodas yra mazesnis uz ':' ir didesnis uz '0' tai reiskia yra didzioji raide, todel pereinam prie iftrue zyma pazymeto kodo
jmp readin		; jei simbolio kodas didesnis ir uz ':' koda tai skaitom toliau

iftrue:
inc cx 			; kadangi raide, tai padidinam cx vienetu
jmp readin 		; skaitom toliau

endread:
lea dx, msg2 		; i dx pakraunam antro pranesimo adresa
mov ah, 09h 		; isvesime ji i ekrana 
int 21h 

mov ax, cx 		; i ax irasome surastu didziuju raidziu skaiciu
sub cx, cx 		; cx = 0

; konvertuosim int i string

intout:
sub dx, dx 		; dx = 0
div ten 		; ax daliname is 10 (ax = ax div 10, dx = dx mod 10)
add dl, 30h 		; dl tures mod rezultata, t.y. paskutini skaitmeni, pridedam 30h ('0' koda), kad gautume ta skaitmeni atitinkanti simboli
push dx 		; gauta skaitmeni simboliu pavidalu issaugome steke
inc cx 			; cx = cx + 1, uzfiksuojame kiek buvo skaitmenu
cmp ax, 0 		; ziurime, ar ax dar kas nors liko
ja intout 		; jei taip, kartojame ta pati

; skaiciaus isvedimas
intwrite:
pop dx 			; paimam virsutini steko elementa - tai bus pirmas skaitmuo
mov ah, 02h 		; su 2-aja f-ja ji isvesime
int 21h
loop intwrite 		; kartojam tiek kartu, kokia reiksme cx, t.y. kiek buvo skaitmenu

mov ax, 4C00h 		; griztam i DOSa
int 21h
end
