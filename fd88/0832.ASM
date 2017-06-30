; 0832.asm
; 0832 DA CONVERT  ADDRESS=8H
; OUTPUT SQUARE WAVE
;
main    proc    far

cg      segment  'code'
        assume  cs:cg
;
start:  mov     bl,10
ab:     mov     cx,0
        mov     dx,8h
        mov     al,0
abc:    out     dx,al
        inc     dx
        out     dx,al
        inc     al
        dec     dx
        loop    abc
        dec     bl
        jnz     ab
;
        mov     cx,2000
abd:    mov     al,0
        out     dx,al
        inc     dx
        out     dx,al
        call    delay
        mov     al,0ffh
        dec     dx
        out     dx,al
        inc     dx
        out     dx,al
        dec     dx
        call    delay
        loop    abd
;
wave1:  mov     cx,1000
        mov     dx,8h
        mov     al,0
wave2:  out     dx,al
        inc     dx
        out     dx,al
        inc     al
        dec     dx
        cmp     al,0ffh
        jne     wave2
wave3:  dec     al
        out     dx,al
        inc     dx
        out     dx,al
        dec     dx
        cmp     al,0
        jne     wave3
        inc     al
        loop    wave2
;
        jmp      start
;
delay   proc    near
        push    cx
        mov     cx,100h
a1:     loop    a1
        pop     cx
        retn
delay   endp
;
main    endp
cg      ends
        end
