; 14433.asm
; AD MC14433 Vr=2V
; ad result read from 244 address is 08H
; 8279 display ad convert result address is 10H
;
D8279   =       10H
C8279   =       11H
ADRES   =       08H
;
dseg    segment
b1      db      0
b2      db      0
b3      db      0
b4      db      0
dseg    ends
;
cseg    segment
main    proc    far
        assume  cs:cseg, ds:dseg, es:dseg
start:
;                              initial 8279
        MOV     AL,11011111B   ; CLEAR
        MOV     DX,C8279
        OUT     DX,AL
WN:     IN      AL,DX
        AND     AL,80H
        CMP     AL,80H
        JE      WN
        MOV     AL,00000000B    ; LEFT IN 8*8 DECODE
        OUT     DX,AL
        MOV     AL,00101010B
        OUT     DX,AL           ; F/10
;
        mov     ch,1
delay:  call    readad
        call    disp
        jmp     delay

;
readad: mov     dx,adres
        in      al,dx
        mov     ah,al
        mov     cl,4
        shr     ah,cl
        and     al,0fh
        cmp     al,ch
        jne     readad
        cmp     ch,1
        jne     read1
        mov     b1,ah
        jmp     read4
read1:  cmp     ch,2
        jne     read2
        mov     b2,ah
        jmp     read4
read2:  cmp     ch,4
        jne     read3
        mov     b3,ah
        jmp     read4
read3:  cmp     ch,8
        jne     read4
        shr     ah,1
        shr     ah,1
        shr     ah,1
        not     ah
        and     ah,1
        mov     b4,ah
        add     b4,10
read4:  shl     ch,1
        cmp     ch,10h
        jne     readad
        mov     ch,1
        retn
;
DISP:   MOV     AL,10010000B   ; RAM INC FROM 0
        MOV     DX,C8279
        OUT     DX,AL
        MOV     DX,D8279
        MOV     AL,b1
        MOV     AH,0
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,CS:[SI]
        NOT     AL
        OUT     DX,AL
        MOV     AL,b2
        MOV     AH,0
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,CS:[SI]
        NOT     AL
        OUT     DX,AL
        MOV     AL,b3
        MOV     AH,0
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,CS:[SI]
        NOT     AL
        OUT     DX,AL
        MOV     AL,b4
        MOV     AH,0
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,CS:[SI]
        NOT     AL
        OUT     DX,AL
        RETN
;
SEGTAB  DB      3FH,06H,5BH,4FH,66H,6DH     ;0-5
        DB      7DH,07H,7FH,6FH,0BFH,86H    ;6-9, 0. 1.
main    endp
;
cseg    ends
        end     start
