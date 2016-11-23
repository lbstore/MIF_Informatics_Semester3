.MODEL SMALL
.STACK 1000h

.DATA
  HEX_Map   DB  '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
  HEX_Out   DB  "00", 13, 10, '$'   ; string with line feed and '$'-terminator

.CODE

main PROC
    mov ax, @DATA                   ; Initialize DS
    mov ds, ax

    ; Example No. 1 with output
    mov di, OFFSET HEX_Out          ; First argument: pointer
    mov ax, 10101100b               ; Second argument: Integer
    call IntegerToHexFromMap        ; Call with arguments
    mov ah, 09h                     ; Int 21h / 09h: Write string to STDOUT
    mov dx, OFFSET HEX_Out          ; Pointer to '$'-terminated string
    int 21h                         ; Call MS-DOS

    ; Example No. 2 with output
    mov di, OFFSET HEX_Out          ; First argument: pointer
    mov ax, 10101100b               ; Second argument: Integer
    call IntegerToHexCalculated     ; Call with arguments
    mov ah, 09h                     ; Int 21h / 09h: Write string to STDOUT
    mov dx, OFFSET HEX_Out          ; Pointer to '$'-terminated string
    int 21h                         ; Call MS-DOS

    mov ax, 4C00h                   ; Int 21h / 4Ch: Terminate program (Exit code = 00h)
    int 21h                         ; Call MS-DOS
main ENDP

IntegerToHexFromMap PROC
    mov si, OFFSET Hex_Map          ; Pointer to hex-character table

    mov bx, ax                      ; BX = argument AX
    and bx, 00FFh                   ; Clear BH (just to be on the safe side)
    shr bx, 4                       ; Isolate high nibble (i.e. 4 bits)
    mov dl, [si+bx]                 ; Read hex-character from the table
    mov [di+0], dl                  ; Store character at the first place in the output string

    mov bx, ax                      ; BX = argument AX (just to be on the safe side)
    and bx, 00FFh                   ; Clear BH (just to be on the safe side)
    and bl, 0Fh                     ; Isolate low nibble (i.e. 4 bits)
    mov dl, [si+bx]                 ; Read hex-character from the table
    mov [di+1], dl                  ; Store character at the second place in the output string

    ret
IntegerToHexFromMap ENDP

IntegerToHexCalculated PROC
    mov si, OFFSET Hex_Map          ; Pointer to hex-character table

    mov bx, ax                      ; BX = argument AX
    shr bl, 4                       ; Isolate high nibble (i.e. 4 bits)
    cmp bl, 10                      ; Hex 'A'-'F'?
    jl .1                           ; No: skip next line
    add bl, 7                       ; Yes: adjust number for ASCII conversion
    .1:
    add bl, 30h                     ; Convert to ASCII character
    mov [di+0], bl                  ; Store character at the first place in the output string

    mov bx, ax                      ; BX = argument AX (just to be on the safe side)
    and bl, 0Fh                     ; Isolate low nibble (i.e. 4 bits)
    cmp bl, 10                      ; Hex 'A'-'F'?
    jl .2                           ; No: skip next line
    add bl, 7                       ; Yes: adjust number for ASCII conversion
    .2:
    add bl, 30h                     ; Convert to ASCII character
    mov [di+1], bl                  ; Store character at the second place in the output string

    ret
IntegerToHexCalculated ENDP

END main                            ; End of assembly with entry-procedure