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
        

TIMER:;  MOV     DX,43H
      ;  MOV     AL,76H          ; TIMER1 SQUARE WAVE 19200
      ;  OUT     DX,AL

      ;  MOV     DX,41H
      ;  MOV     AL,124
      ;  OUT     DX,AL
      ;  MOV     AL,0H
      ;  OUT     DX,AL

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
        END
