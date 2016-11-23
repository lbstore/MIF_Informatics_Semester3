_stack        SEGMENT    STACK
              db         32 DUP ('STACK   ')
_stack        ENDS



_code        SEGMENT PARA 'CODE'
             ASSUME  CS:_code,  SS:_stack

Lstart  LABEL  NEAR

        JMP    Linstall

;+---------------------------------------------
;| My New 1Ch INT
;| Print 'random' chars to the first video line

new_Int PROC   FAR

        DEC    BYTE PTR CS:Counter

        CLD
        PUSH   AX

        MOV    AX, 0B800h
        MOV    ES,AX                   ; ES = b800h
        MOV    DI,000h                 ; DI = 0000h

        MOV    AH,CS:Counter           ; set foreground and background color
        MOV    AL,CS:Counter           ; set char

        MOV    CX,80
        REP    STOSW                   ; From AX to ES:DI

        POP    AX
        STI

        IRET

new_Int ENDP

Counter DB     0Fh

;+-----------------------------------------
;| Store old INT and Install the new one
;|

Linstall    LABEL    NEAR

old_INT     DD       00000000h

        MOV    AL,01Ch                 ;+-
        MOV    AH,35h                  ;| Save old_INT
        INT    21h                     ;|
        MOV    WORD PTR [old_INT],BX
        MOV    WORD PTR [old_INT][2],ES



        CLI                            ;+-
        PUSH   CS                      ;| Install
        POP    DS                      ;|
        LEA    DX,new_INT
        MOV    AL,1Ch
        MOV    AH,25h
        INT    21h


        MOV    AH,0                    ;+-
        INT    16H                     ;| Wait for a keypress



;+-----------------------------------------
;| Disinstall and exit

        CLI
        PUSH   DS
        LDS    DX,CS:[old_INT]         ;+-
        MOV    AL,1Ch                  ;| Disinstall int
        MOV    AH,25h                  ;|
        INT    21h                     ;|
        POP    DS
        STI

        MOV    AL,0                    ;+-
        MOV    AH,4Ch                  ;| Exit
        INT    21h                     ;|


_code   ENDS
        END    Lstart
