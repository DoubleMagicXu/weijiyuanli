; STEP.ASM
; STEP MOTOR

        U8250  EQU 180H             ;8250A DATA PORT
        porta   =      8h
        portb   =      9h
        portc   =      0ah
        c8255   =      0bh
;
main    proc    far
data    segment 'data'
arrow   db      ?
time    dw      ?
data    ends
cg      segment  'code'
        assume  cs:cg,ds:data,es:data
;
begin:  MOV     AL,80H
        OUT     C8255,AL
        XOR     AL,AL
        OUT     PORTA,AL
        MOV     AX,DATA
        MOV     DS,AX
        MOV     ES,AX

        mov     arrow,0
        mov     time,100

        MOV     AX,CS
        MOV     ES,AX
        MOV     BP,OFFSET MESS
        MOV     AH,4
        INT     14H

run:    MOV     DX,U8250+5           ; IF RXRAY=1 IN 8250A?
        IN      AL,DX
        AND     AL,81H
        CMP     AL,01
        JNE     RUN1
        MOV     DX,U8250             ; CPU GET A CHAR FROM 8250A
        IN      AL,DX
        CMP     AL,'U'
        JNE     RUN2
        MOV     ARROW,0
        JMP     RUN1
RUN2:   CMP     AL,'D'
        JNE     RUN3
        MOV     ARROW,1
        JMP     RUN1
RUN3:   CMP     AL,'-'
        JNE     RUN4
        ADD     TIME,10
        JMP     RUN1
RUN4:   CMP     AL,'+'
        JNE     RUN1
        MOV     AX,TIME
        SUB     AX,10
        CMP     AX,0
        JG      RUN5
        MOV     AX,8
RUN5:   MOV     TIME,AX
        JMP     RUN1
run1:   call    step
        jmp     run
;
delay   proc    near
        push    cx
        mov     cx,time
delay1: push    cx
        mov     cx,100
        loop    $
        pop     cx
        loop    delay1
        pop     cx
        retn
delay   endp
;
step:   mov     al,arrow
        cmp     al,0
        jne     stepd
        mov     al,1
        out     porta,al
        call    delay
        mov     al,2
        out     porta,al
        call    delay
        mov     al,4
        out     porta,al
        call    delay
        mov     al,8
        out     porta,al
        call    delay
        retn
stepd:  mov     al,8
        out     porta,al
        call    delay
        mov     al,4
        out     porta,al
        call    delay
        mov     al,2
        out     porta,al
        call    delay
        mov     al,1
        out     porta,al
        call    delay
        retn

mess    db      "**********  Stepper Motor  **********"
        db      "** Direct Control: U: <-  D:->        "
        db      "** Speed Control: +:increase -:reduce "
        db      0
main    endp
cg      ends
        end     begin
