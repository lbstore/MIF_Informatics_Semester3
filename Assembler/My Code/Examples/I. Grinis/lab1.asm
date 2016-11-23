; Kompiliavimas: tasm -zi ivesk.asm
;                tlink /v ivesk
; Derinimas:   td ivesk
;
;
;  

;4) Pirmos eilutės paskutinis simbolis sukeičiamas su 
;antros 3-u, o antras nuo galo  simbolis pirmoje eilutėje 
;pakeičiamas  tarpu. Išvedamos abi eilutės
  
.model small
       ASSUME CS:kodas, DS:duomenys, SS:stekas
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
stekas segment word stack 'STACK'
       dw 400h dup (00)               ; stekas -> 2 Kb
stekas ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
duomenys segment para public 'DATA'
    pranesimas2:
		db 'Ivesk antra eilute','$'
	pranesimas1:
		db 'Ivesk pirma eilute','$'
	
    naujaEilute:   
		db 0Dh, 0Ah, '$'  ; tekstas ant ekrano
    dar_pranesimas:
		db 'Tu ivedei: $'
    
    rezultato_pranesimas:
		db 'Paskutinis simbolis keiciamas pirmuoju: $'
    
   
    buferisIvedimui1:
		db 10, 00, 100 dup ('*')
	buferisIvedimui2:
		db 10, 00, 100 dup ('*')
duomenys ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
kodas segment para public 'CODE'
    pradzia:

		mov ax,		seg duomenys                   ; "krauname" duomenu segmenta
		mov ds,		ax							  ; data segment (custom defined)
       
	   
   ;PIRMA EILUTE
	;	mov ah,     09                             ; spausdinimo funkcijos numeris
	;	mov dx,     offset naujaEilute             ; isvedamojo teksto adresas
	;	int 21h
		
		mov ah,		09                             ; spausdinimo funkcijos numeris
		mov dx,		offset pranesimas1              ; isvedamojo teksto adresas
		int 21h

		mov ah,		0Ah                            ; ivesties funkcija
		mov dx,		offset buferisIvedimui1         ; buferis
		int 21h
		
		mov ah,     09                             ; spausdinimo funkcijos numeris
		mov dx,     offset naujaEilute             ; isvedamojo teksto adresas
		int 21h
		
	
	   
      
       ; Skaityk 0Ah int 21h funkcijos aprasa: 
       ; http://spike.scu.edu.au/~barry/interrupts.html#ah0a

		mov bl,     byte ptr [buferisIvedimui1 + 1] ; bl<-kiek buvo ivesta simboliu
		xor bh,     bh                             ; bh <- 0   
		mov word ptr [bx + 3 + buferisIvedimui1], 240Ah ; LF + '$' -> eilutes galas
			
		
		mov dx,     offset buferisIvedimui1 + 2
		mov ah,     09
		int 21h
		
		
		;ANTRA EILUTE
		
		
		
		mov ah,		09
		mov dx, 	offset pranesimas2
		int 21h
	   
		mov ah,		0Ah
		mov dx, 	offset buferisIvedimui2
		int 21h
	   
		mov ah,     09                             ; spausdinimo funkcijos numeris
		mov dx,     offset naujaEilute             ; isvedamojo teksto adresas
		int 21h
		
		
		mov ah,     09                             ; spausdinimo funkcijos numeris
		mov dx,     offset naujaEilute             ; isvedamojo teksto adresas
		int 21h
		
		mov bl,     byte ptr [buferisIvedimui2 + 1] ; bl<-kiek buvo ivesta simboliu
		xor bh,     bh                             ; bh <- 0   
		mov word ptr [bx + 3 + buferisIvedimui2], 240Ah ; LF + '$' -> eilutes galas
	
		
		
		mov dx,     offset buferisIvedimui2 + 2
		mov ah,     09
		int 21h
		
       
       mov ah,     4ch                            ; baigimo funkcijos numeris
       int 21h
kodas  ends
    end pradzia 

