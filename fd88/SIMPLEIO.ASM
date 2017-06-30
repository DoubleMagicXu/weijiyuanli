; simpleio.asm
; 74ls377 address is 10h
; 74ls244 address is 8h
; read from 244, output to 377
;
main    proc    far

code    segment 'code'
        assume  cs:code
begin:  mov     bl,0
start:  mov     dx,8h                   ; 244 读入开关状态
        in      al,dx
        test    al,0ffh                 ; 判断是否全为'0'
        jz      flash
        mov     dx,10h                  ; 377输出, LED显示
        not     al
        out     dx,al
        jmp     start
flash:  not     bl
        mov     dx,10h                  ; 闪烁显示
        mov     al,bl
        not     al
        out     dx,al
        mov     cx,0bfffh
        loop    $
        not     bl
        mov     al,bl
        not     al
        out     dx,al
        mov     cx,0bfffh
        loop    $
        jmp     start
code    ends
main    endp
        end     begin
