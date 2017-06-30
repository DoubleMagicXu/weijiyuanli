; clock.asm
; 8279
; display second and minute
; clk connect to 1MHz
;
D8279   =       300H
C8279   =       301H
;
dseg    segment
B1      db      ?
B2      db      ?
B3      db      ?
B4      db      ?

SEGTAB  DB      3FH,06H,5BH,4FH,66H,6DH     ;0-5
        DB      7DH,07H,7FH,6FH,77H,7CH     ;6-B
        DB      39H,5EH,79H,71H,40H
dseg    ends
;
cseg    segment
main    proc    far
        assume  cs:cseg, ds:dseg, es:dseg
start:
        push    ds
        sub     ax,ax
        push    ax
        mov     ax,dseg
        mov     ds,ax
;                              initial 8279
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
        MOV     AL,16
        MOV     B1,AL
        MOV     B2,AL
        MOV     B3,AL
        MOV     B4,AL
delay:  call    disp
        CALL    KSCAN
        mov     ah,0bh
        int     21h
        cmp     al,0
        je      delay

        retf
;
KSCAN:  MOV     DX,C8279
        IN      AL,DX
        nop
        nop
        nop
        AND     AL,0FH
        CMP     AL,0
        JE      KEND
        MOV     AL,B2
        MOV     B1,AL
        MOV     AL,B3
        MOV     B2,AL
        MOV     AL,B4
        MOV     B3,AL
        MOV     DX,D8279
        IN      AL,DX
        nop
        nop
        nop
        AND     AL,3FH
        MOV     AH,AL
        AND     AH,7
        AND     AL,38H
        MOV     CL,1
        SHR     AL,CL
        OR      AL,AH
        MOV     B4,AL
KEND:   RETN
        ;
DISP:   MOV     AL,10010000B   ; RAM INC FROM 0
        MOV     DX,C8279
        OUT     DX,AL
        MOV     DX,D8279
        MOV     AL,b1
        MOV     AH,0
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,[SI]
        NOT     AL
        OUT     DX,AL
        MOV     AL,b2
        MOV     AH,0
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,[SI]
        NOT     AL
        OUT     DX,AL
        MOV     AL,b3
        MOV     AH,0
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,[SI]
        NOT     AL
        OUT     DX,AL
        MOV     AL,b4
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,[SI]
        NOT     AL
        OUT     DX,AL
        nop
        nop
        nop
        OUT     DX,AL
        nop
        nop
        nop
        OUT     DX,AL
        nop
        nop
        nop
        OUT     DX,AL
        nop
        nop
        nop
        OUT     DX,AL
        RETN
;
main    endp
;
cseg    ends
        end     start
