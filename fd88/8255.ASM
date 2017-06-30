; 8255.asm
; test 8255 io
; read from portb
; output to porta
        porta   =      8h
        portb   =      9h
        portc   =      0bh
;
main    proc    far
dcons   =       10h                     ; 延时常数

cg      segment  'code'
        assume  cs:cg
;
begin:  mov     dx,portc                ; 8255 初始化
        mov     al,82h
        out     dx,al
        mov     ah,0ffh
        mov     bl,0
lp:     mov     dx,portb                ; B 口读入开关状态
        in      al,dx
        test    al,ah
        jz      shift
        mov     dx,porta                ; A 口输出开关状态
        not     al
        out     dx,al
        jmp     lp
shift:  mov     al,bl
        mov     dx,porta
        not     al
        out     dx,al
        call    delay                   ; 延时
        shl     bl,1                    ; 移位
        test    bl,ah
        jnz     lp
        mov     bl,1
        jmp     lp
back:
        retf
;
delay   proc    near
        push    cx
        mov     cx,0
delay1: or      cx,cx
        or      cx,cx
        loop    delay1
        pop     cx
        retn
delay   endp
;
main    endp
cg      ends
        end     begin
