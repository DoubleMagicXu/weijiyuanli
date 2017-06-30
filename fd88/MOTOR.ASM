; MOTOR.ASM
; DC MOTOR
; cx=speed user wanted 0-40r/s
;
        U8250  EQU 180H             ;8250A DATA PORT
        porta   =      8h
        portb   =      9h
        portc   =      0ah
        c8255   =      0bh
        c8259   =       20h
;
main    proc    far
data    segment 'data'
count   db      38
waitt   db      1
ontime  dw      ?
offtime dw      ?
speed   dw      ?
getsp   dw      ?
data    ends

cg      segment  'code'
        assume  cs:cg,ds:data,es:data
;
begin:  MOV     AX,DATA
        MOV     DS,AX
        MOV     ES,AX

        MOV     AL,80H
        OUT     C8255,AL
        XOR     AL,AL
        OUT     PORTA,AL

        mov     ontime,5
        mov     offtime,10
        mov     waitt,5
        mov     count,38
        mov     speed,cx

        MOV     AX,CS
        MOV     ES,AX
        MOV     BP,OFFSET MESS
        MOV     AH,4
        INT     14H

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

        call    timer1
        sti
run:    mov     al,0ffh
        out     porta,al
        mov     cx,ontime
on:     call    delay
        loop    on
        xor     al,al
        out     porta,al
        mov     cx,offtime
off:    call    delay
        loop    off
        jmp     run
;
ring:   cli
        push    ds
        push    ax
        push    bx
        push    cx
        push    dx
        mov     ax,data
        mov     ds,ax
        dec     count
        jnz     exit
        mov     count,38
        call    timer1
        dec     waitt
        jnz     exit
        mov     waitt,5
        call    adjust
exit:   pop     dx
        pop     cx
        pop     bx
        pop     ax
        pop     ds
        mov     al,20h          ; EOI
        out     20h,al
        sti
        iret
;
adjust: in      al,41h
        mov     ah,al
        mov     al,99h
        sub     al,ah
        das
        mov     cl,al
        in      al,41h
        mov     ah,al
        mov     al,99h
        sbb     al,ah
        mov     ch,al
        mov     getsp,cx

        mov     ax,cs
        mov     es,ax
        mov     bp,offset spmess
        mov     ah,4
        int     14h

        mov     ax,getsp
        mov     cl,12
        sar     ax,cl
        add     al,30h
        mov     ah,1
        int     14h
        mov     ax,getsp
        mov     cl,8
        sar     ax,cl
        and     al,0fh
        add     al,30h
        mov     ah,1
        int     14h

        mov     ax,getsp
        mov     cl,4
        sar     al,cl
        add     al,30h
        mov     ah,1
        int     14h
        mov     ax,getsp
        and     al,0fh
        add     al,30h
        mov     ah,1
        int     14h

        mov     ax,cs
        mov     es,ax
        mov     bp,offset tmmess
        mov     ah,4
        int     14h

D21:    MOV     DX,OFFTIME
        MOV     AX,DX
        MOV     BL,100
        DIV     BL
        MOV     DL,AH
        ADD     AL,30H
        MOV     AH,1
        INT     14H

D31:    MOV     AL,DL
        MOV     AH,0
        MOV     BL,10
        DIV     BL
        PUSH    AX
        ADD     AL,30H
        MOV     AH,1
        INT     14H
        POP     AX

D41:    MOV     AL,AH
        MOV     AH,0
        AND     AL,0FH
        ADD     AL,30H
        MOV     AH,1
        INT     14H

        mov     ax,cs
        mov     es,ax
        mov     bp,offset space
        mov     ah,4
        int     14h

aj:     mov     ax,speed
        cmp     ax,getsp
        je      exita
        jg      dect
        mov     ax,offtime
        add     ax,5
        mov     offtime,ax
        jmp     exita
dect:   mov     ax,offtime
        cmp     al,1
        je      exita
        sub     ax,5
        cmp     ax,0
        jne     dect1
        mov     ax,1
dect1:  mov     offtime,ax
exita:  retn
;
delay   proc    near
        push    cx
        mov     cx,200
        loop    $
        pop     cx
        retn
delay   endp
;
timer1: mov     al,01111001b
        out     43h,al
        mov     al,99h
        out     41h,al
        out     41h,al
        retn
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

mess    db      "**********    DC  Motor    **********",0
spmess  db      "     Speed=",0
tmmess  db      "r/s    ON:OFF=5:",0
space   db      "    ",0
main    endp
cg      ends
        end     begin

