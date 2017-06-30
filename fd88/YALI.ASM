; MEASURE PRESSURE
; CLOCK CONNECT TO 1M
; 244 READ EOC STATES BIT 0 ADDR: 10H
;
PADC    =       08H
;

CODE    SEGMENT
        ASSUME  CS:CODE
MAIN    PROC    FAR
START:  MOV     CX,200
        MOV     BX,0
RDON:   MOV     AL,80h            ; 0809 START CONVERT
        OUT     PADC,AL
        PUSH    CX
        MOV     CX,100
        LOOP    $
        POP     CX
        OUT     PADC,AL
ADOK:   IN      AL,10H
        AND     AL,1
        CMP     AL,1
        JNE     ADOK
        IN      AL,PADC
        MOV     AH,0
        ADD     BX,AX
        LOOP    RDON
        MOV     AX,BX
        MOV     BL,200
        DIV     BL
        MOV     BL,4
        MUL     BL
        MOV     DX,AX
        CALL    DISP
        JMP     START

DISP:   MOV     AX,CS
        MOV     ES,AX
        MOV     BP,OFFSET MESS
        MOV     AH,4
        INT     14H

D11:    MOV     AX,DX
        MOV     DX,0
        MOV     BX,1000
        DIV     BX
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,CS:[SI]
        MOV     AH,1
        INT     14H

D21:    MOV     AX,DX
        MOV     BL,100
        DIV     BL
        MOV     DL,AH
        MOV     AH,0
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,CS:[SI]
        MOV     AH,1
        INT     14H

D31:    MOV     AL,DL
        MOV     AH,0
        MOV     BL,10
        DIV     BL
        PUSH    AX
        MOV     AH,0
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,CS:[SI]
        MOV     AH,1
        INT     14H
        POP     AX

D41:    MOV     AL,AH
        MOV     AH,0
        AND     AL,0FH
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,CS:[SI]
        MOV     AH,1
        INT     14H

        MOV     AL,'g'
        MOV     AH,1
        INT     14H

        RETN
;
SEGTAB  DB      "0123456789"
MESS    DB      '     PRESSURE=',0


CODE    ENDS

MAIN    ENDP
;
        END

