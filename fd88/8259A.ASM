INTA00	 EQU	   20H
INTA01   EQU       21H
 
DATA     SEGMENT
MESS     DB        '. THIS IS A 8259A INTERRUPT!',0AH,0DH,'$'
FLAG     DB        0
INTMASK  DB        ?
CSREG    DW        ?
IPREG    DW        ?
DATA     ENDS

CODE     SEGMENT
         ASSUME    CS:CODE,DS:DATA

START:	 CLI
	 MOV	   AX,DATA
	 MOV	   DS,AX
	 MOV	   AX,350AH
	 INT	   21H
	 MOV	   AX,ES
	 MOV	   CSREG,AX
	 MOV	   IPREG,BX
	 PUSH	   DS
	 MOV	   AX,CS
	 MOV	   DS,AX
	 MOV	   DX,OFFSET INT_PROC
	 MOV	   AX,250AH
	 INT	   21H
         POP       DS
	 MOV	   DX,INTA01
	 IN	   AL,DX
         MOV       INTMASK,AL
	 AND	   AL,0FBH
	 OUT	   DX,AL
         MOV       BL,'9'
	 STI
LL:      MOV       AL,FLAG
         CMP       AL,01H
	 JNZ	   LL
	 CLI
	 MOV	   AL,INTMASK
	 MOV	   DX,INTA01
	 OUT	   DX,AL
	 MOV	   DX,IPREG
	 MOV	   AX,CSREG
	 MOV	   DS,AX
	 MOV	   AX,250AH
	 INT	   21H
	 STI
	 MOV	   AX,4C00H
	 INT	   21H
	                     
INT_PROC:PUSH	   DS
         MOV       AH,2
         MOV       DL,BL
         INT       21H
         MOV       AX,DATA
	 MOV	   DS,AX
	 MOV	   DX,OFFSET MESS
         MOV       AH,09 
	 INT	   21H
	 MOV	   DX,INTA00
	 MOV	   AL,20H
	 OUT	   DX,AL
         DEC       BL
         CMP       BL,'0'
	 JNZ	   NEXT
         MOV       AL,01
	 MOV	   FLAG,AL
	 MOV	   DX,INTA01
	 IN	   AL,DX
	 OR	   AL,04H
	 OUT	   DX,AL
NEXT:	 POP	   DS
         IRET
CODE     ENDS
END      START	 					 
					 
