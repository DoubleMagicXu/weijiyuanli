; 8279KEY.asm
; 8279
; GET KEY & SEND TO PC
;
D8279   =       10H
C8279   =       11H
;
dseg    segment
B1      db      ?
dseg    ends
;
cseg    segment
main    proc    far
        assume  cs:cseg, ds:dseg, es:dseg
start:
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
        MOV     AL,0
        MOV     B1,AL
delay:  call    disp
        CALL    KSCAN
        JMP     delay

        retf
;
KSCAN:  MOV     DX,C8279
        IN      AL,DX
        AND     AL,0FH
        CMP     AL,0
        JE      KSCAN
        MOV     DX,D8279
        IN      AL,DX
        AND     AL,3FH
        MOV     AH,AL
        AND     AH,7
        AND     AL,38H
        MOV     CL,1
        SHR     AL,CL
        OR      AL,AH
        MOV     B1,AL
KEND:   RETN
        ;
DISP:
        MOV     AL,b1
        MOV     AH,0
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,CS:[SI]
        MOV     AH,1
        INT     14H
        RETN
;
main    endp
;
SEGTAB  DB      30H,31H,32H,33H,34H,35H     ;0-5
        DB      36H,37H,38H,39H,41H,42H     ;6-B
        DB      43H,44H,45H,46H,47H
cseg    ends
        end     start
