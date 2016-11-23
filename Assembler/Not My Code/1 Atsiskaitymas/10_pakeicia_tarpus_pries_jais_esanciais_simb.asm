; 24 uzduotis: 
; Parasykite programa, kuri ivestoje eiluteje visus tarpo simbolius pakeicia 
; po jais sekanciais simboliais (jei tarpas gale - paliekamas tarpas).
; Pvz.: ivedus "ab 12 oi8" turi atspausdinti "abb122oi8"
.model small
.stack 100h 
.data   

	EIL_PAB equ '$'
	TARPAS equ ' '
	IVEDIMAS equ 0ah
	ISVEDIMAS equ 9h

	db 100h dup (?) 	; stekui isskiria 100h baitu (byte)
	EilBuf db 252, 254 dup (?)	; eilutes bufferiui isskiria 252 baitu
	
.code
	
	; pagrindine procedura
	START:
		; Inicializuojam programos iejimo adresa
		push ds	; Push Word or Doubleword Onto the Stack
		sub ax, ax	; Subtract - atimti
		push ax
		mov ax, ds	;moves the Data SEGMENT is in, into AX
		mov ds, ax		;moves ax into ds (ds=ax)
				;you cannot do this -> mov ds,DSeg
		; Programos kodas
		
		; is klaviaturos nuskaitoma eilute
		lea dx, EilBuf	; Load Effective Address ish eilutes buff i dx, susieja su buferiu
		mov ah, IVEDIMAS	; ivedimas i ah 
		int 21h		; ? close the file
		
		; i ax patalpinamas eilutes ilgis
		xor ax, ax
		mov si, offset EilBuf
		inc si		; Increment by 1
		add al, [si]
		
		; jei eilute tuscia, programa pabaigiama
		cmp ax, 0		; Compare Two Operands 
				; tikrina ar ne failo pabaiga jei pabaiga tai ax=0, 0 kai nuskaito
		je BAIGTI		
		
		; nagrinejama eilute
	NAGR_SIMB:
		inc si		; didinu pradine rodykle (increment by 1)
		dec ax		; mazinu pradine rodykle (decrement by 1)
		cmp ax, 0		; Compare Two Operands
		je TESTI		; jei paskutinis simbolis - iseinama is ciklo
		cmp byte ptr [si], TARPAS	; Compare Two Operands
		je KEISTI_SIMB	; jei randamas tarpas, simbolis pakeiciamas
		jmp NAGR_SIMB	; griztama i ciklo pradzia…
		
		; tarpas pakeiciamas tolesniu simboliu
	KEISTI_SIMB:
		mov bl, byte ptr [si+1]
		mov [si], bl
		jmp NAGR_SIMB	; griztama i ciklo pradzia…
		
	TESTI:
		; buferio gale pridedamas simbolis '$'
		; si rodo i paskutini eilutes simboli
		inc si
		mov cl, EIL_PAB
		mov [si], cl
		
		; eilute isvedama i ekrana…
		lea dx, EilBuf
		add dx, 2		; eilute buferyje prasideda nuo trecio baito
		mov ah, ISVEDIMAS
		int 21h	; funkciju panaudojimui skirta, gale privalu,kad butu


		; Grizti i DOS
	BAIGTI:
		mov  ax, 4c00h                      ;isejimas
		int  21h        



end START

