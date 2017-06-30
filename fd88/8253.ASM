; 8253.asm
; 8253 wave output
;
CODE    SEGMENT
MAIN    PROC    FAR
ASSUME  CS:CODE
START:  MOV     DX,43H
        MOV     AL,01110110B
        OUT     DX,AL
        MOV     DX,41H
        MOV     AL,0E8H
        OUT     DX,AL
        MOV     AL,03H
        OUT     DX,AL

        MOV     DX,43H
        MOV     AL,10110100B
        OUT     DX,AL
        MOV     DX,42H
        MOV     AL,0FH
        OUT     DX,AL
        MOV     AL,0H
        OUT     DX,AL
        INT     20H
MAIN    ENDP
CODE    ENDS
        END
