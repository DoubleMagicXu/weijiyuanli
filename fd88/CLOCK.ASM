; clock.asm
; 8279
; display second and minute
; clk connect to 1MHz
;
C8259   =       20H
D8279   =       10H
C8279   =       11H
;
dseg    segment
count   db      38
second  db      0
minute  db      0
dseg    ends
;
cseg    segment
main    proc    far
        assume  cs:cseg, ds:dseg, es:dseg
start:
        mov     ax,dseg
        mov     ds,ax
        mov     count,38
        mov     second,0
        mov     minute,0

;initial 8279
        MOV     AL,11011111B   ; CLEAR
        MOV     DX,C8279
        OUT     DX,AL
WN:     IN      AL,DX
        AND     AL,80H
        CMP     AL,80H
        JE      WN
        MOV     AL,00000000B   ; LEFT IN 8*8 DECODE
        OUT     DX,AL
        MOV     AL,00101010B
        OUT     DX,AL           ; F/10
;
        PUSH    DS
        XOR     AX,AX
        MOV     DS,AX
        LEA     AX,RING
        MOV     DS:20H,AX
        MOV     AX,CS
        MOV     DS:22H,AX
        CALL    TIMER
        MOV     DX,C8259
        MOV     AL,00010011B   ; ICW1
        OUT     DX,AL
        INC     DX
        MOV     AL,00001000B    ; ICW2
        OUT     DX,AL
        MOV     AL,00001101B    ; ICW4
        OUT     DX,AL
        MOV     AL,11111110B    ; OCW1
        OUT     DX,AL
        MOV     AL,20H          ; EOI
        OUT     20H,AL
        POP     DS

        MOV     DX,C8259
        MOV     AL,00010011B   ; ICW1
        OUT     DX,AL
        INC     DX
        MOV     AL,00001000B    ; ICW2
        OUT     DX,AL
        MOV     AL,00001101B    ; ICW4
        OUT     DX,AL
        MOV     AL,11111110B    ; OCW1
        OUT     DX,AL
        MOV     AL,20H          ; EOI
        OUT     20H,AL
        STI
;
sloop:  call    disp
        CALL    KSCAN
        jmp     sloop
;
KSCAN:  MOV     DX,C8279
        IN      AL,DX
        AND     AL,0FH
        CMP     AL,0
        JE      KEND
        MOV     AL,40H
        OUT     DX,AL
        MOV     DX,D8279
        IN      AL,DX
        AND     AL,3FH
        MOV     AH,AL
        AND     AH,7
        CMP     AH,0
        JNE     KEND
        MOV     CL,3
        SHR     AL,CL
        CMP     AL,0
        JE      ADDM            ; MINUTE + 1
        CMP     AL,1
        JE      DECM            ; MINUTE - 1
        CMP     AL,2
        JE      ADDS            ; SECOND + 1
        CMP     AL,3
        JNE     KEND            
        CALL    KDEC1   ; SECOND - 1
KEND:   RETN
ADDM:   CALL    KINC2
        RETN
DECM:   CALL    KDEC2
        RETN
ADDS:   CALL    KINC1
        RETN
        ;
DISP:   MOV     AL,10010000B   ; RAM INC FROM 0
        MOV     DX,C8279
        OUT     DX,AL
        MOV     DX,D8279
        MOV     AL,second
        AND     AL,0FH
        MOV     AH,0
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,CS:[SI]
        NOT     AL
        OUT     DX,AL
        MOV     AL,second
        MOV     CL,4
        SHR     AL,CL
        MOV     AH,0
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,CS:[SI]
        NOT     AL
        OUT     DX,AL
        MOV     AL,minute
        AND     AL,0FH
        MOV     AH,0
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,CS:[SI]
        NOT     AL
        OUT     DX,AL
        MOV     AL,minute
        MOV     CL,4
        SHR     AL,CL
        MOV     AH,0
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,CS:[SI]
        NOT     AL
        OUT     DX,AL
        RETN
;
ring:
        cli
        push    ds
        push    ax
        push    cx
        push    dx
        mov     ax,dseg
        mov     ds,ax
        dec     count
        jnz     exit
        mov     count,38
        call    kinc1
exit:   pop     dx
        pop     cx
        pop     ax
        pop     ds
        MOV     AL,20H          ; EOI
        OUT     20H,AL
        sti
        iret
;
KDEC1:  DEC     second
        MOV     CH,second
        CALL    ADJ
        JNE     TINT1
        SUB     second,CH
        CMP     second,0F9H
        JNE     TINT1
        MOV     second,59H
KDEC2:  DEC     minute
        MOV     CH,minute
        CALL    ADJ
        JNE     TINT1
        SUB     minute,CH
        CMP     minute,0F9H
        JNE     TINT1
        MOV     minute,59H
        RETn
        ;
ADJ:    AND     CH,0FH
        CMP     CH,0FH
        MOV     CH,6
        RETN
        ;
KINC1:  INC     second
        MOV     CH,second
        CALL    ADJUST
        JNE     TINT1
        ADD     second,CH
        CMP     second,60H
        JNE     TINT1
        MOV     second,0
KINC2:  INC     minute
        MOV     CH,minute
        CALL    ADJUST
        JNE     TINT1
        ADD     minute,CH
        CMP     minute,60H
        JNE     TINT1
        MOV     minute,0
TINT1:  RETn
        ;
ADJUST: AND     CH,0FH
        CMP     CH,0AH
        MOV     CH,6
        RETN
;
TIMER:
        MOV     DX,43H
        MOV     AL,34H          ; TIMER0 NEG PULSE
        OUT     DX,AL

        MOV     DX,40H          ; 1 SECOND /38
        MOV     AL,79
        OUT     DX,AL
        MOV     AL,245
        OUT     DX,AL
        RETN

SEGTAB  DB      3FH,06H,5BH,4FH,66H,6DH     ;0-5
        DB      7DH,07H,7FH,6FH,77H,7CH     ;6-B
main    endp
;
cseg    ends
        end     start
