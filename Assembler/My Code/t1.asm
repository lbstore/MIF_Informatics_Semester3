; Programa 'KbdShift'.
; Programa demonstruoja klaviaturos pertraukimu apdorojima.
; Paleista ji pakeicia int 15h vektoriu ir baigia darba
; pasilikdama atmintyje (zr. TSR, int 27h). Nuo tada,
; paspaustu klavisu kodai bus didinami 1, t.y. paspaude
; 'a' matysime 's' ir t.t.
; ------------------------------------------------------------------
.MODEL small ; 64K kodui ir 64K duomenims
.STACK 100h
; ----- Kodas ------------------------------------------------------
.CODE
  OldHandlerSeg DW 0
  OldHandlerOffs DW 0
; ----- NewHandler -------------------------------------------------
NewHandler PROC
  cmp ah,4fh ; Klaviaturos pertraukimo (int 9) apdorojimo
  jne @@skip ; procedura generuoja int 15, ah=4fh
  inc al ; al = klaviso kodas
@@skip:
  push [cs:OldHandlerSeg]
  push [cs:OldHandlerOffs]
  retf ; Iskviesti sena pertraukimu apdorojimo proc.
NewHandler ENDP
; ------------------------------------------------------------------
Strt:
  mov ax,3515h ; Issaugoti senos pertraukimu apdorojimo
  int 21h ; proceduros adresa (int 15h)
  mov [cs:OldHandlerSeg],es
  mov [cs:OldHandlerOffs],bx
  push cs
  pop ds
  mov dx,OFFSET NewHandler
  mov ax,2515h ; Nustatyti nauja pertraukimo vektoriu
  int 21h ; (int 15h apdorojimo proceduros adresa)
  mov dx,OFFSET Strt + 100h
  ; Baigti darba ir pasilikti atmintyje
  int 27h ; (TSR - terminate and stay resident)
  ; Atmintis issaugoma iki adreso cs:dx
; ------------------------------------------------------------------
END Strt
