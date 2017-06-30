; 8259.asm
; IRQ1 INTERRUPT
;
C8259   EQU     20H

CODE    SEGMENT
MAIN    PROC    FAR
ASSUME  CS:CODE
START:  XOR     AX,AX
        MOV     DS,AX
        LEA     AX,IRQ1
        MOV     DS:24H,AX
        MOV     AX,CS
        MOV     DS:26H,AX
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

        MOV     BL,'0'
        MOV     AL,BL
        MOV     AH,1
        INT     14H
        STI
        JMP     $

IRQ1:   CLI
        INC     BL
        MOV     AL,BL
        MOV     AH,1
        INT     14H
        MOV     AL,20H          ; EOI
        OUT     20H,AL
        STI
        IRET
MAIN    ENDP
CODE    ENDS
        END
