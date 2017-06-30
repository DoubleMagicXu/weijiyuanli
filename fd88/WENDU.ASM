; WENDU.asm
; AD MC14433 Vr=2V
; ad result read from 244 address is 08H
;
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
        mov     ch,1
        call    readad
        call    disp
        mov     cx,00
        loop    $
        jmp     start

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
read4:  shl     ch,1
        cmp     ch,10h
        jne     readad
        mov     ch,1
        retn
;
DISP:   MOV     AX,CS
        MOV     ES,AX
        MOV     BP,OFFSET MESS
        MOV     AH,4
        INT     14H

        MOV     AL,b4
        MOV     AH,0
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,CS:[SI]
        MOV     AH,1
        INT     14H

        MOV     AL,b3
        MOV     AH,0
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,CS:[SI]
        MOV     AH,1
        INT     14H

        MOV     AL,b2
        MOV     AH,0
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,CS:[SI]
        MOV     AH,1
        INT     14H

        MOV     AL,'.'
        MOV     AH,1
        INT     14H

        MOV     AL,b1
        MOV     AH,0
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,CS:[SI]
        MOV     AH,1
        INT     14H

        RETN
;
SEGTAB  DB      "0123456789"
MESS    DB      '  TEMPERATURE=',0
main    endp
;
cseg    ends
        end     start

