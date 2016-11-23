; Programa 'ClockInt'

; Programa demonstruoja taimerio pertraukimu apdorojima

; ------------------------------------------------------------------

LOCALS @@ ; Lokalios zymes prasideda @@

.MODEL small ; 64K kodui ir 64K duomenims

.STACK 100h

IntNo = 8h

; ----- Duomenys (kintamieji) --------------------------------------

.DATA

Counter DB 4

ClockCnt DB 0

Msg DB "0...$"

; ----- Kodas ------------------------------------------------------

.CODE

OldISRSeg DW 0

OldISROfs DW 0

Strt:

mov ax,@data

mov ds,ax

; --- es <- 0

mov ax, 0

mov es, ax

; --- Issaugome senos pertraukimo apdorojimo proceduros adresa

mov ax,es:[IntNo*4]

mov cs:[OldISROfs],ax

mov ax,es:[IntNo*4 + 2]

mov cs:[OldISRSeg],ax

; --- "Instaliuojame" nauja pertraukimu apdorojimo procedura

pushf

cli

mov word ptr es:[IntNo*4],offset TimerProc

mov word ptr es:[IntNo*4 + 2],seg TimerProc

popf

@@loop:

cmp [Counter],0

jne @@loop

; --- Atstatome sena pertraukimu apdorojimo procedura

pushf

cli

mov ax,cs:[OldISROfs]

mov word ptr es:[IntNo*4],ax

mov ax,cs:[OldISRSeg]

mov word ptr es:[IntNo*4 + 2],ax

popf

; --- Baigiame darba

mov ax,04C00h

int 21h ; int 21,4C - programos pabaiga
;-------------------------------------------------------------------

TimerProc PROC

push ax

push ds

mov ax,@data

mov ds,ax

mov al,[ClockCnt]

inc al

cmp al,20

jne @@skip

xor al,al

dec [Counter]

call PrintCnt

@@skip:

mov [ClockCnt],al

pop ds

pop ax

push cs:[OldISRSeg]

push cs:[OldISROfs]

retf

TimerProc ENDP

;-------------------------------------------------------------------

PrintCnt PROC

push ax

push dx

mov al,[Counter]

add al,30h

mov [Msg],al

mov dx,OFFSET Msg

mov ah,9h

int 21h

pop dx

pop ax

ret

PrintCnt ENDP

END Strt
