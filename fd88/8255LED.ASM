; 8255led.asm
; 8255 address is 10h
; port a connect to led segment
; port b 0-3 connect to led common
;
porta   equ     10h
portb   equ     11h
control equ     13h
;
main    proc    far
code    segment 'code'
        assume  cs:code,ds:code
        mov     ax,cs
        mov     ds,ax
        mov     al,80h          ; all port output
        mov     dx,control
        out     dx,al
        mov     al,0ffh         ; close display
        mov     dx,porta
        out     dx,al
        inc     dx
        out     dx,al
        mov     bx,0e00h
disp:   mov     si,offset segtab
        push    bx
        mov     bh,0
        add     si,bx
        pop     bx
        mov     al,[si]
        not     al
        mov     dx,porta
        out     dx,al           ; output segment
        mov     al,bh
        inc     dx
        out     dx,al           ; select led
        mov     cx,01ffh
        loop    $
        shl     bh,1
        or      bh,1
        inc     bl
        cmp     bl,04
        jne     disp1
        mov     bh,0eh
disp1:  and     bl,3
        jmp     disp
segtab: db      3fh,06h,5bh,4fh,66h,6dh,7dh,7,7fh,6fh
code    ends
main    endp
        end
