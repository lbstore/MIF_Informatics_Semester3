;programa isveda ivestos eilutes zodziu ilgius
	.model small
	.stack 256 
	.data                                       

ivesk   DB 0Dh, 0Ah, 'Ivesk eilute: ', '$'
buff db 255
     db 0
     db 255 dup (?) 
clrf DB 10, 13,   '$' 

	.code 
startas:

  mov	ax, @data                             	; ax <- @data
  mov	ds, ax				     	; ds <- ax
  lea	si, buff                              	; i SI registra irasom eilutes vykdoma adresa   
  
  mov	ah, 9h
  mov	dx, offset ivesk                        ; atspausdins 'ivesk' eilute
  int	21h

  mov   ah, 0ah
  mov   dx, offset buff
  int 21h

  mov   si, offset buff
  xor   ax, ax
  mov   al, [buff + 1]
  mov   cx, ax
  xor   bx, bx
  add   si, 2
  cld
  mov   ah, 09h
  mov  dx, offset clrf
  int  21h

  zodis:
    lodsb
    cmp   al, ' '
    jz    spaus
    inc   bx
    jmp   kartojimas

  spaus:
    call   print
    xor    bx, bx
    jmp    kartojimas 
   
  print proc
    push ax
    push dx
    push cx
    push bx
    xor  cx, cx
    mov ax, bx
    mov bl, 10
    dalinimas:
       div   bl
       mov   dx, ax
       xor   al, al
       xchg  ah, al
       push  ax 				;reikia ah; ah (liekana turiu steke)	
       inc   cx
       mov   al, dl      
       cmp   al, 0				;jei padalinus sveikoji dalis nulis, spausdint
       jz    atspaus
       jmp dalinimas				;jei ne zodzio pabaiga, tai dar dalinam
    atspaus:
       pop ax
       mov dx, ax
       add dl, 30h
       mov ah, 02h
       int 21h
       cmp   cx, 0
       jz    skpab
           
    loop atspaus  				
    skpab:
      lea   dx, clrf
      mov   ah, 09h					;persoku i kita eilute	
      int   21h
        
    pop bx
    pop cx 
    pop dx
    pop ax
    ret
  print endp

 kartojimas:
  loop zodis 
 
call  print

 
exit:
  mov	ax, 4c00h
  int 	21h
end