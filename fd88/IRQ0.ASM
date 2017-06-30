; 8259.asm
;
C8259   EQU     20H
LCDC    =       0
LCDD    =       140H
TIME    =       50

CODE    SEGMENT
MAIN    PROC    FAR
ASSUME  CS:CODE,DS:DATA
START:  XOR     AX,AX
        MOV     DS,AX
        LEA     AX,IRQ0
        MOV     DS:22H,AX
;        MOV     AX,0F000h
        MOV     AX,CS
        MOV     DS:24H,AX
        CALL    TIMER

        MOV     DX,C8259
        MOV     AL,00010011B   ; ICW1
        OUT     DX,AL
        INC     DX
        MOV     AL,00001000B    ; ICW2
        OUT     DX,AL
        MOV     AL,00001101B    ; ICW4
        OUT     DX,AL
        MOV     AL,11111101B    ; OCW1
        OUT     DX,AL
        MOV     AL,20H          ; EOI
        OUT     20H,AL

        mov     bl,1            ; INIT LCD
        call    wlcd
        mov     bl,30h
        call    wlcd
        mov     bl,0eh
        call    wlcd
        mov     bl,6
        call    wlcd
        mov     bh,80h
        call    wlcd
        MOV     BL,'S'
        CALL    DLCD
        STI
CCC:    MOV     CX,0
        LOOP    $
;        INT     8
        JMP     CCC

waitlcd:push    cx
        mov     cx,48fh         ;18fh
        loop    $
        pop     cx
        retn

IRQ0:   INC     BL
        CALL    DLCD
        MOV     AL,20H          ; EOI
        OUT     20H,AL
        IRET
        
dlcd:   call    waitlcd
        mov     dx,LCDC
        mov     aL,4
        out     dx,al
mov cx,TIME
loop  $
        mov     al,14h
        out     dx,al
mov cx,TIME
loop  $
        mov     dx,lcdd
        mov     al,bl
        out     dx,al
mov cx,TIME
loop  $
        mov     dx,lcdc
        mov     al,4
        out     dx,al
mov cx,TIME
loop  $
        retn

wlcd:   call    waitlcd
        mov     dx,LCDC
        mov     aL,0
        out     dx,al
mov cx,TIME
loop  $
        mov     al,10h
        out     dx,al
mov cx,TIME
loop  $
        mov     dx,lcdd
        mov     al,bl
        out     dx,al
mov cx,TIME
loop  $
        mov     dx,lcdc
        mov     al,0
        out     dx,al
mov cx,TIME
loop  $
        retn

TIMER:  MOV     DX,43H
        MOV     AL,76H          ; TIMER1 SQUARE WAVE 19200
        OUT     DX,AL

        MOV     DX,41H
        MOV     AL,124
        OUT     DX,AL
        MOV     AL,0H
        OUT     DX,AL

        MOV     DX,43H
        MOV     AL,34H          ; TIMER0 NEG PULSE
        OUT     DX,AL

        MOV     DX,40H          ; 1 SECOND /38
        MOV     AL,79
        OUT     DX,AL
        MOV     AL,245
        OUT     DX,AL
        RETN
MAIN    ENDP
CODE    ENDS
DATA    SEGMENT
MESS    DB      0DH,0AH,' 8253 T0 IS IN MODE 3 ( SQUARE WAVE) COUNT=1000(3E8H)',0DH,0AH,'$'
DATA    ENDS
        END
