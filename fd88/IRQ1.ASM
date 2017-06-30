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
        MOV     DS:24H,AX
;        MOV     AX,0F000h
        MOV     AX,CS
        MOV     DS:26H,AX
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

        MOV     BL,'S'
        MOV     AL,BL
        MOV     AH,1
        INT     14H
        STI
CCC:    MOV     CX,0
        LOOP    $
;        INT     8
        JMP     CCC


IRQ0:   CLI
        INC     BL
        MOV     AL,BL
        MOV     AH,1
        INT     14H
        MOV     AL,20H          ; EOI
        OUT     20H,AL
        STI
        IRET
        

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
        MOV     AL,255
        OUT     DX,AL
        MOV     AL,255
        OUT     DX,AL
        RETN
MAIN    ENDP
CODE    ENDS
DATA    SEGMENT
MESS    DB      0DH,0AH,' 8253 T0 IS IN MODE 3 ( SQUARE WAVE) COUNT=1000(3E8H)',0DH,0AH,'$'
DATA    ENDS
        END
