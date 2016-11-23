CMP_JE MACRO value1, value2, location
	
	CMP value1, value2
	JE location

ENDM

GetBits MACRO where, andTemplate, source
	
	MOV where, source
	AND where, andTemplate

ENDM


GetBitsSHR MACRO where, andTemplate, shift, source

	GetBits where, andTemplate, source
	SHR where, shift

ENDM

AddRM MACRO regDB

	PUSH	ax
	PUSH	cx
	PUSH	bx
	LEA	bx, regDB
	MOV	cl, 2
	MOV	al, rm
	MUL	cl
	XLAT
	PrintByte al
	MOV	al, rm
	MUL	cl
	INC	al
	XLAT
	PrintByte al
	POP	bx
	POP	cx
	POP	ax
	
ENDM

PrintByte MACRO value

	PUSH	ax
	PUSH	dx
	MOV	ah, 2
	MOV	dl, value
	INT	21h
	POP	dx
	POP	ax

ENDM

PrintString MACRO string

	PUSH	ax
	PUSH	dx
	LEA	dx, string
	MOV	ah, 09h
	INT	21h
	POP	dx
	POP	ax
	
ENDM

.model small

.stack 100h

.data
	sDiv	 db "DIV ", '$'
	sMUL	 db "MUL ", '$'
	sIDIV	 db "IDIV ", '$'
	sIMUL	 db "IMUL ", '$'
	comma	 db ", ", '$'
	Enteris  db 13, 10, "$"
	HexTable db "0123456789ABCDEF", '$'
	Interr	 db  "Zingsniniu rezimas!  ", '$'
	Unknownc  db "Komanda neatpazinta ", '$'
	md	 db ?
	reg	 db ?
	rm	 db ?
	w	 db ?
	recFlag  db 0
	temp1	 dw 0
	temp2	 dw 0
	temp3	 dw 0
	segPreFlag db 0
	temp	 db 0
	reg1DB	 db "al"
		 db "cl"
		 db "dl"
		 db "bl"
		 db "ah"
		 db "ch"
		 db "dh"
		 db "bh"
		 
	reg2DB	 db "ax"
		 db "cx"
		 db "dx"
		 db "bx"
		 db "bp"
		 db "sp"
		 db "si"
		 db "di"


	rmBxSi 		EQU 	000b
	rmBxDi		EQU 	001b
	rmBpSi		EQU 	010b
	rmBpDi		EQU 	011b
	rmSi 		EQU 	100b
	rmDi 		EQU 	101b
	rmBp		EQU 	110b
	rmBx		EQU 	111b
	
	
	sRmBxSi		DB		'[bx+si', '$'
	sRmBxDi		DB		'[bx+di', '$'
	sRmBpSi		DB		'[bp+si', '$'
	sRmBpDi		DB		'[bp+di', '$'
	sRmSi		DB		'[si', '$'
	sRmDi		DB		'[di', '$'
	sRmBp		DB		'[bp', '$'
	sRmBx		DB		'[bx', '$'
	
	SRegDB		DB		'es'
			DB		'cs'
			DB		'ss'
			DB		'ds'

.code
  Pradzia:
	MOV	ax, @data	
	MOV	ds, ax		


	MOV	ax, 0		
	MOV	es, ax		
	MOV	bx, 4		


	PUSH	es:[bx]
	PUSH	es:[bx+2]
	
	LEA	dx, dealWithInterrupt
	MOV	es:[bx], dx		
	MOV	es:[bx+2], cs		


	XOR	bx,bx
	XOR	cx,cx
	XOR	dx,dx


	;MOV	[di], 1
	mov	di, 0
	PUSHF			
	PUSHF			
	POP ax			
	OR ax, 0100h		
	PUSH ax			
	POPF			
	NOP			
	
	div es:[di]
	XOR	ax,ax
	MOV	bl, 2
	mov	al, -3
	MOV	dx, 5
	MOV	cx, 1010h
	div	al
	imul 	cl
	idiv    dl
	mul	cs:[di+bp+2010h]
	div	cx
	MUL	bl
	mul	bl
	mul	ax
	IDIV	ax
	MUL	cx
	MUL	dh
	


	POPF			
				
	NOP
	

	POP	es:[bx+2]
	POP	es:[bx]

	MOV	ax, 4C00h			
	INT	21h		


  PROC dealWithInterrupt
	
	PUSH	ax
	PUSH	bx
	PUSH	dx
	PUSH	bp
	PUSH	es
	PUSH	ds

	MOV	temp1, dx
	MOV	temp2, ax
	MOV	temp3, bx

	
	MOV	ax, @data
	MOV	ds, ax
	

	MOV bp, sp		
	ADD bp, 12		
	MOV si, [bp]		
	MOV es, [bp+2]	  	

	PrintString Interr
	
	CALL AddOffset
	
	CALL checkSegmentChange
	
	CALL disassembly

	CALL addCode

	CMP_JE	recFlag, 0 , @unknwn

	CALL addparam
	
@unknwn:

	PrintString enteris
	
	POP ds
	POP es
	POP bp
	POP dx
	POP bx
	POP ax
	IRET			
				
	
ENDP

PROC	checkSegmentChange

	MOV dl, [es:si]
	GetBits bl, 11100111b, dl
	CMP	bl, 00100110b
	JNE	@noSegChange
	MOV	segPreFlag, 1
	MOV	temp, dl
	INC	si
  @noSegChange:
	RET

ENDP

PROC	AddSegChange
	MOV	dl, temp
	GetBitsSHR bl, 00011000b, 3, dl
	MOV	bh, rm
	MOV	rm, bl
	AddRM	sregDB
	MOV	rm, bh
	PrintByte ':'
	RET
ENDP

PROC addparam
	PrintByte ' '
	PrintByte ';'
	PrintByte ' '
	MOV	ax, temp2
	MOV	dl, [rm]
	MOV	[rm], 000b
	CALL checkWbit
	PrintByte '='
	CMP_JE	w, 0, @Only1B
	MOV	dh, ah
	CALL AddBin2Hex
@Only1B:
	MOV	dh, al
	CALL AddBin2Hex
	PrintByte 'h'	
	CMP_JE md, 11b, @ok2
	RET
@ok2:
	MOV	[rm], dl
	MOV	dx, temp1
	MOV	bx, temp3
	PrintByte ' '
	PrintByte ';'
	PrintByte ' '

	CALL checkWbit
	PrintByte '='
	CMP_JE	w, 1, @w2
	CMP_JE rm, 000b, @al
	CMP_JE rm, 001b, @cl
	CMP_JE rm, 010b, @dl
	CMP_JE rm, 011b, @bl
	CMP_JE rm, 100b, @ah
	CMP_JE rm, 101b, @ch
	CMP_JE rm, 110b, @dh
	
	MOV	dh, bh
	CALL AddBin2Hex
	JMP @thatsAll
	
@al:
	MOV	dh, al
	CALL AddBin2Hex
	JMP @thatsAll

@cl:
	MOV	dh, cl
	CALL AddBin2Hex
	JMP @thatsAll
	
@dl:
	MOV	dh, dl
	CALL AddBin2Hex
	JMP @thatsAll
@bl:
	MOV	dh, bl
	CALL AddBin2Hex
	JMP @thatsAll
@ah:
	MOV	dh, ah
	CALL AddBin2Hex
	JMP @thatsAll
@ch:
	MOV	dh, ch
	CALL AddBin2Hex
	JMP @thatsAll	
@dh:
	CALL AddBin2Hex
	JMP @thatsAll
	
@w2:
	CMP_JE rm, 000b, @ax
	CMP_JE rm, 001b, @cx
	CMP_JE rm, 010b, @dx
	
	MOV	dh, bh
	CALL AddBin2Hex
	MOV	dh, bl
	CALL AddBin2Hex
	JMP @thatsAll
	
@ax:
	MOV	dh, ah
	CALL AddBin2Hex
	MOV	dh, al
	CALL AddBin2Hex
	JMP @thatsAll
@cx:
	MOV	dh, ch
	CALL AddBin2Hex
	MOV	dh, cl
	CALL AddBin2Hex
	JMP @thatsAll
@dx:
	MOV	dh, dh
	CALL AddBin2Hex
	MOV	dh, dl
	CALL AddBin2Hex
	
@thatsAll:
	PrintByte 'h'	
	RET
ENDP

PROC AddBin2Hex
	
	PUSH 	ax
	PUSH	bx				
    	LEA 	bx, hexTable			
	
	GetBitsSHR al, 11110000b, 4, dh 		
	XLAT							
	 
	PrintByte al						
	
	GetBits al, 00001111b, dh  			
	XLAT							 
	PrintByte al			
	POP 	bx
	POP	ax
	RET

ENDP

PROC AddOffset
	PUSH	dx
	MOV	dx, cs
	CALL AddBin2Hex
	MOV	dx, cs
	MOV	dh, dl
	CALL AddBin2Hex
	PrintByte ':'
	MOV	dx, si
	CALL AddBin2Hex
	MOV	dx, si
	MOV	dh, dl
	CALL AddBin2Hex
	PrintByte ' '
	PrintByte ' '
	POP	dx
	RET
ENDP

PROC checkWbit
	CMP_JE	w, 1, @w1
	AddRM	reg1DB
	RET
@w1:
	AddRM	reg2DB
	RET
ENDP

PROC	addCode	;[es:si]
	PrintByte ' '
	PrintByte ' '
	CMP_JE segPreFlag, 0, @noChange
	MOV dh, [es:si-1]
	CALL AddBin2Hex
	PrintByte ' '
	MOV	segPreFlag, 0
@noChange:
	MOV dh, [es:si]
	CALL AddBin2Hex
	PrintByte ' '
	MOV dh, [es:si+1]
	CALL AddBin2Hex
	PrintByte ' '
	CMP	md, 1b
	JE	@addb1
	CMP	md, 10b
	JE	@addb10
	RET
@addb1:
	MOV dh, [es:si+2]
	CALL AddBin2Hex
	RET
@addb10:
	MOV dh, [es:si+2]
	CALL AddBin2Hex
	PrintByte ' '
	MOV dh, [es:si+3]
	CALL AddBin2Hex	
	RET
ENDP

PROC disassembly
	MOV dl, [es:si]
	GetBits w, 00000001b, dl
	GetBits dh, 11111110b, dl
	CMP_JE	dh, 11110110b, @ok
	JMP @notOk
@ok:
	MOV dl, [es:si+1]
	GetBits rm, 00000111b, dl
	GetBitsSHR reg, 00111000b, 3, dl
	GetBitsSHR md, 11000000b, 6, dl
	CMP_JE reg, 110b, @DivFound
	CMP_JE reg, 111b, @IDivFound
	CMP_JE reg, 100b, @MULFound
	CMP_JE reg, 101b, @IMULFound
@notOk:
	PrintString Unknownc
	MOV	[md], 0
	MOV	[recFlag], 0
  	RET
	
  @DivFound:
  	PrintString sDIV
  	JMP @further	

  @IDivFound:
  	PrintString sIDIV
  	JMP @further

  @MULFound:
  	PrintString sMUL
  	JMP @further
  	
  @IMULFound:
  	PrintString sIMUL
  	
  @further:
	MOV	recFlag, 1
  	CMP	md, 11b
  	JNE	@modnot11
  	CALL checkWbit
	RET
	
@modnot11:
	CMP_JE segPreFlag, 0, @noSegChange2
	CALL AddSegChange
	
@noSegChange2:
	
	CMP_JE	rm, RmBxSi, @sRmBxSi
	CMP_JE	rm, RmBxDi, @sRmBxDi
	CMP_JE	rm, RmBpSi, @sRmBpSi
	CMP_JE	rm, RmBpDi, @sRmBpDi
	CMP_JE	rm, RmSi, @sRmSi
	CMP_JE	rm, RmDi, @sRmDi
	CMP_JE	rm, RmBp, @sRmBp
	CMP_JE	rm, RmBx, @sRmBx

@sRmBxSi:
	PrintString sRmBxSi
	JMP @next
@sRmBxDi:
	PrintString sRmBxDi
	JMP @next
@sRmBpSi:
	PrintString sRmBpSi
	JMP @next
@sRmBpDi:
	PrintString sRmBpDi
	JMP @next
@sRmSi:
	PrintString sRmSi
	JMP @next
@sRmDi:
	PrintString sRmDi
	JMP @next
@sRmBp:	PrintString sRmBp
	JMP @next
@sRmBx:
	PrintString sRmBx
	

@next:

  	CMP_JE	md, 01b, @mod01
  	CMP_JE	md, 10b, @mod10

	JMP @AddBracketsEnd
	
@mod01:
	MOV dh, [es:si+2]
	PrintByte '+'
	CALL AddBin2Hex
	PrintByte 'h'
	JMP @AddBracketsEnd

@mod10:
	PrintByte '+'
	MOV dh, [es:si+3]
	CALL AddBin2Hex	
	MOV dh, [es:si+2]
	CALL AddBin2Hex	
	PrintByte 'h'

@AddBracketsEnd:
	PrintByte ']'	
  	RET
ENDP  	
 
END Pradzia
