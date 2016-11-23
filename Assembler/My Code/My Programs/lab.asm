;Laimonas Beniuðis, lab. darbas 1, uþduoties variantas 3   
;3) Pirmos eilutes priešpaskutinis simbolis sukeiciamas 
;su antros paskutiniuoju, o pirmas  simbolis antroje 
;eiluteje pakeiciamas  zenklu '*'. Išvedamos abi eilutes
; Bufferis[0] - bufferio dydis
; bufferis[1] - kiek simboliu buvo nuskaityta

.model small
.stack 100h      
.data 
    MSGline1 db "Iveskite pirma eilute: ", '$';    
    MSGline2 db "Iveskite antra eilute: ", '$';
    MSGreturnInput db "Gauta eilute: ", '$';
    MSGparsing db "Apdorojimas...", 13, 10, '$';
    MSGresult db "Isvedamos abi eilutes: ", 13, 10, '$';      
    endL db 13,10,'$'          ;10 - new line, 13 - home, "$" - '/0' (end of string)
    len1 db 0
    len2 db 0
    line1 db 10, 00, 100 dup ('$'); 
    line2 db 10, 00, 100 dup ('$');   
    MSG2tarpai db "  ", '$';

.code

START:
    mov ax, @data;
    mov ds, ax;       kraunamas segmentas
                 
                 
    ; Pirma eilute                     
    mov ah, 09
    mov dx, offset MSGline1
    int 21h
    
    mov ah, 0Ah
    mov dx, offset line1    
    int 21h
    
    mov ah, 09
    mov dx, offset endL
    int 21h
    
    xor bx, bx
    mov bl, [line1 + 1]; ivestu simboliu kiekis 
    mov word ptr[bx + 3 + line1], 240Ah;
    ;Ciklas rasti bufferio ilgiui nr1
	;LEA - Load Effective Address, einam per bufferi kaip per C su pointeriu ir pointeri didinam
    LEA SI,line1
    NEXT1:
    CMP byte ptr[SI],'$'
    JE DONE1
    INC len1
    INC SI
    JMP NEXT1
    DONE1:
    xor ax, ax
    mov al, len1
    sub al, 4 ;du priekyje, pabaigos simbolis ir CR
    mov [len1], al
    xor ax, ax
    
    
    
    
    mov ah, 09
    mov dx, offset MSGreturnInput
    int 21h
    
    mov dx, offset [line1 + 2]
    mov ah, 09
    int 21h
    
    mov ah, 09
    mov dx, offset endL
    int 21h
    
    
    ;Antra eilute
    
    mov ah, 09
    mov dx, offset MSGline2
    int 21h
    
    mov ah, 0Ah
    mov dx, offset line2    
    int 21h
    
    mov ah, 09
    mov dx, offset endL
    int 21h
    
    xor bx, bx
    mov bl, [line2 + 1]; ivestu simboliu kiekis
    mov word ptr[bx + 3 + line2], 240Ah;

    ;Ciklas rasti bufferio ilgiui nr1
    xor si, si
    LEA SI,line2
    NEXT2:
    CMP byte ptr[SI],'$'
    JE DONE2
    INC len2
    INC SI
    JMP NEXT2
    DONE2:
    xor ax, ax
    mov al, len2
    sub al, 4 ;du priekyje, pabaigos simbolis ir CR
    mov [len2], al
    xor ax, ax

    
    mov ah, 09
    mov dx, offset MSGreturnInput
    int 21h
    
    
    mov ah, 09
    mov dx, offset [line2 + 2]
    int 21h
    
    mov ah, 09
    mov dx, offset endL
    int 21h
    
    ;Logika
    
   
	
	; Pirmos eilutes priešpaskutinis simbolis sukeiciamas su antros paskutiniuoju


    xor bh, bh
    xor ax, ax
	mov bl, [len2]
	mov al,	[line2 + bx + 1 ]  ; al <- paskutinis is antros
	
    xor bx, bx
    xor cx, cx
    mov bl, [len1]
    mov cl, [line1 + bx] ;cl <- priespaskutinis is pirmos
    mov [line1 + bx], al
    xor bx, bx
    mov bl, [len2]
    mov [line2 + bx + 1], cl
    
    
    
    ;Pirmas simbolis antroje eiluteje pakeiciams zenklu '*'.
	mov [line2 + 2], '*'
    
    mov ah, 09
    mov dx, offset endL
    int 21h
    
    mov ah, 09
    mov dx, offset MSGparsing
    int 21h
    
    mov ah, 09
    mov dx, offset MSGresult
    int 21h
    
    mov ah, 09
    mov dx, offset line1 + 2
    int 21h
    
;    mov ah, 09
;    mov dx, offset endL
;    int 21h
    
    mov ah, 09
    mov dx, offset MSG2tarpai
    int 21h
    
    mov ah, 09
	mov dx,	offset line2 + 2
	int 21h
    
    mov ah, 4ch
    int 21h
END START                      