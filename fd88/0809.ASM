; 0809 AD CONVERT
; CLOCK CONNECT TO SYSTEM ALE
; ADDRESS IS 308H
; AD RESULT OUTPUT TO 377 -> LED ADDR: 10h
; 244 READ EOC STATES BIT 0 ADDR: 18h
;
PLED    =       10H
PADC    =       08H
;
DELAY   MACRO
        NOP
        NOP
        NOP
        ENDM

CODE    SEGMENT
        ASSUME  CS:CODE
MAIN    PROC    FAR
START:  MOV     AL,80h            ; 0809 START CONVERT
        MOV     DX,PADC
        OUT     DX,AL
        MOV     CX,100
        LOOP    $
        OUT     DX,AL
        MOV     DX,18H
ADOK:   IN      AL,DX
        AND     AL,1
        CMP     AL,1
        JNE     ADOK
        MOV     DX,PADC
        IN      AL,DX
        MOV     DX,PLED
        NOT     AL
        OUT     DX,AL
        JMP     START

CODE    ENDS

MAIN    ENDP
;
        END
