    .model small
    .stack 256
    .data
sakinys DB 0DH, 0Ah, 'Iveskite eilute: ', '$'
pabaiga DB 0DH, 0Ah ,'$'
buf DB 255
    DB 0
    DB 255 DUP('$')

    .code
startas:
mov ax, @data
mov ds, ax

lea si, buf
	
mov ah, 9h
mov dx, offset sakinys
int 21h
	
mov ah, 0Ah
mov dx, offset buf 
int 21h
	
mov ah, 9h
mov dx, offset pabaiga
int 21h  
xor cx, cx  
add si, 2 
tikrina:
   lodsb
   cmp  al, ' '
   jz   tarpas               ;kai zf = 1
   cmp 	al, '$'
   jz	isejimas
   mov  dl,al
   mov  ah, 02h
   int  21h
   jmp  tikrina
tarpas:
  
  mov   dl,cl
  add   dl,30h
  mov   ah,02h
  
  int   21h
  cmp   cx,9
  jz    devyni
  inc   cx
  
  jmp   tikrina

devyni:
  xor cx,cx
  jmp tikrina
isejimas:
  mov ax,4C00h
  int 21h
end startas