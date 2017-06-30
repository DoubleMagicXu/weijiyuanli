; 8250.asm
;
U8250  EQU 180H             ;8250A DATA PORT
;
CODE    SEGMENT
MAIN    PROC    FAR
ASSUME  CS:CODE
START:
;INIT 8250A
;        MOV     DX,U8250+3
;        MOV     AL,80H
;        OUT     DX,AL
;        MOV     DX,U8250
;        MOV     AL,6
;        OUT     DX,AL
;        INC     DX
;        XOR     AL,AL
;        OUT     DX,AL

;        MOV     DX,U8250+3
;        MOV     AL,3            ; DATA 8 BIT,STOP 1 BIT
;        OUT     DX,AL
;        MOV     DX,U8250+1
;        mov     al,0            ; 0FH ENABLE INTERRUPT
;        OUT     DX,AL
;        MOV     DX,U8250+4
;        MOV     AL,03H          ; ENABLE INPUT AND OUTPUT
;        OUT     DX,AL

        MOV     AH,'S'
key:    MOV     DX,U8250+5
TRAN:   IN      AL,DX           ; IF TXRAY=1 IN 8250A?
        AND     AL,0C0H
        CMP     AL,40H
        JNE     rece
        MOV     DX,U8250
        MOV     AL,AH
        OUT     DX,AL           ; CPU OUTPUT THE CHAR TO 8250A
RECE:   MOV     DX,U8250+5           ; IF RXRAY=1 IN 8250A?
RXD:    IN      AL,DX
        AND     AL,81H
        CMP     AL,01
        JNE     RXD
        MOV     DX,U8250             ; CPU GET A CHAR FROM 8250A
        IN      AL,DX
        MOV     AH,AL
        JMP     KEY
;
        MOV     AL,'S'
SSS:    MOV     AH,1
        INT     14H
        MOV     AH,2
        INT     14H
        JMP     SSS
;
MAIN    ENDP
CODE    ENDS
        END
