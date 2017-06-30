; trans.asm
;
DATA51 EQU 308H             ;8251A DATA PORT
CTRL51 EQU 309H             ;8251A COMMOND PORT
;
CODE    SEGMENT
MAIN    PROC    FAR
ASSUME  CS:CODE,DS:DATA
START:  PUSH    DS
        XOR     AX,AX
        PUSH    AX
        MOV     AX,DATA
        MOV     DS,AX
        call    timer
 ;
 ;INIT 8251A
        MOV     DX,CTRL51
        XOR     AX,AX
        OUT     DX,AL
        MOV     CX,1000
        LOOP    $
        OUT     DX,AL
        MOV     CX,1000
        LOOP    $
        OUT     DX,AL
        MOV     CX,1000
        LOOP    $
        MOV     AL,40H            ;RESET 8251A
        OUT     DX,AL
        MOV     CX,1000
        LOOP    $
        mov     al,01001101b      ;DATA 8 BIT,STOP 1 BIT,FACTOR=1
        OUT     DX,AL
        MOV     CX,1000
        LOOP    $
        MOV     AL,27H            ;ENABLE INPUT AND OUTPUT
        OUT     DX,AL
        MOV     CX,1000
        LOOP    $
;
        mov     al,'0'
        PUSH    AX
key:    MOV     DX,CTRL51
TRAN:   IN      AL,DX               ;IF TXRAY=1 IN 8251A?
        nop
        nop
        nop
        TEST    AL,01
        JZ      TRAN
        MOV     DX,DATA51
        POP     AX
        OUT     DX,AL              ;CPU OUTPUT THE CHAR TO 8251A
        inc     ax
        PUSH    AX
RECE:   mov     cx,10
        loop    $
       MOV DX,CTRL51          ;IF RXRAY=1 IN 8251A?
       IN AL ,DX
       nop
       nop
       nop
       TEST AL,02
       JZ dwa
       MOV DX,DATA51          ;CPU GET A CHAR FROM 8251A
       IN AL,DX
       nop
       nop
       nop
       nop
       nop
       MOV DL,AL              ;CPU PUT THE CHAR ON THE SCREEN
       MOV AH,02
       INT 21H
       CMP     AL,'z'
       JNE     DWA
       POP      AX
       MOV      AL,'0'
       PUSH     AX
       MOV      DL,0AH
       MOV AH,02
       INT 21H
       MOV      DL,0DH
       MOV AH,02
       INT 21H

dwa:   mov     ah,0bh                  ; ¼üÅÌ×´Ì¬¼ì²é
        int     21h
        cmp     al,0
        jne     retu
             jmp key
retu:   pop     ax
        RETF
;
timer:  MOV     DX,303H         ; INITIAL 8253 9600Hz
        MOV     AL,36H          ; T0
        OUT     DX,AL
        MOV     DX,300H
        MOV     AL,b1
        OUT     DX,AL
        MOV     AL,b2
        OUT     DX,AL
back:   retn
;
MAIN    ENDP
CODE    ENDS
DATA    SEGMENT
b1      db      106
b2      db      0
DATA    ENDS
        END
