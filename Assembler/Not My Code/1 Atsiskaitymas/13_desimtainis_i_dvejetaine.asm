.model small
.stack 100h 
.data

	msg 		db 	"Iveskite skaiciu nuo 0 iki 65535: $"
	help		db 	"Cia vardas pavarde grupe uzduotis$"
	ans 		db 	"Jo dvejetainis pavidalas: $"
	answer		db  16 dup('0'), '$'
	new_line   	db 	0Ah, 0Dh, '$'     	; kursoriaus nukelimas i pradzia kitos eilutes
.code

	begin:	

		mov ax, @data		; perkelia duomenis i segmenta ax
		mov ds, ax
		mov bx, 81h		; reikalinga kai ieskosim simboliu "/?"



;<<<<<<<<<<<<Tikrina ar yra ivesti simboliai "?/" >>>>>>>>>>>>>


the_help:				

	mov ax, es:[bx]		
	cmp al, 0Dh		
	je move_on		
	cmp ax, 3F2Fh		; tikrinam ar rado simbolius 
	je found			
	inc bx			; pereinam prie sekancio elemento
	jmp the_help

found:

	mov ah, 9
	mov dx, offset help	; isveda pranesima
	int 21h
	jmp the_end

		
;<<<<<<<<<<<Vykdoma pagrindine programa >>>>>>>>>>>>
	

move_on:

	lea dx, msg		; isspausdina pranesima, kuris aprasytas virsuje		
	mov ah, 9		; nurodo ivesti skaiciu
	int 21h			
	lea dx, new_line
	int 21h

	xor cx, cx
	xor bx, bx		; BX registre bus saugomas nuskaitytas skaicius
	jmp read_another_char

non_number_error2:
	dec cl
	
non_number_error:
	mov ah, 2
	mov dl, 8
	int 21h
	mov ah, 2
	mov dl, ' '
	int 21h
	mov dl, 8
	int 21h
	jmp read_another_char  
	
backspace_used:
	mov ah, 2
	mov dl, ' '
	int 21h
	mov dl, 8
	int 21h
	cmp cl, 0
	je read_another_char
	dec cl
	jmp division
	
read_another_char:
	mov ah, 1
	int 21h
	cmp al, 8
	je backspace_used   
	cmp al, 0Dh
	je finish_reading
	cmp al, 30h
	jb non_number_error
	cmp al, 39h
	ja non_number_error
	inc cl
	cmp cl, 6
	jae non_number_error2
	jmp multiplication
	jmp read_another_char
	
multiplication:
	xor dx, dx	; laikinai sunulinam DX
	mov ch, al	; laikinai idedam nuskaityto skaitmens (is AL) reiksme i CH
	mov ax, bx	; daugybos MUL rezultatas saugomas AX registre, todel rezultato registra ikeliam i ji
	xor bx, bx
	mov bl, 0Ah	; nurodom, kad dauginsim is 10
	mul bx		; dauginam AX := AX * BX = AX * 10
	mov bx, ax	; ikeliam gauta rezultata atgal i musu skaiciaus registra
	mov al, ch	; grazinam nuskaityta skaitmeni i AL, nes dabar ji naudosime sudeciai
	sub al, 30h ; padarom normalu skaiciu
	xor ah, ah	; sunulinam AH, nes reikes sudeti du 16 bitu registrus
	add bx, ax	; prie rezultato registro pridedam musu AL
	jmp read_another_char ; skaitome skaiciu toliau...
	
division:
	mov ax, bx
	mov dx, 0
	mov bx, 0Ah
	div bx
	mov bx, ax
	jmp read_another_char
	
	
finish_reading:
	lea si, answer
	mov cx, 0
	mov ax, 1000000000000000b
	
loop_it:
	mov dx, bx
	and dx, ax
	cmp dx, 0
	ja enter_answer
	
come_back_here:
	inc cx
	shr ax, 1
	cmp cx, 10h
	jb loop_it
	jmp print_answer
	
enter_answer:
	push bx
	mov bx, cx
	mov byte ptr [si+bx], '1'
	pop bx
	jmp come_back_here
	
print_answer:
	lea dx, new_line
	mov ah, 9
	int 21h
	lea dx, ans
	int 21h
	lea dx, answer
	int 21h

the_end:	

	mov ah, 4Ch
	mov al, 0
	int 21h


end begin