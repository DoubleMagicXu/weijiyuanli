; arrow.asm
; display an arrow
        porta   =      8h
        portb   =      9h
        portc   =      0ah
        c8255   =      0bh
;
main    proc    far

cg      segment  'code'
        assume  cs:cg
;
begin:                                  ; 8255 ≥ı ºªØ
        mov     al,80h
        out     c8255,al
        xor     al,al
        out     portc,al

        mov     bx,offset uparr
        mov     cl,1
        mov     ch,0
lp1:    mov     al,cl
        out     portc,al
        mov     al,cs:[bx]
        not     al
        out     porta,al
        add     bx,10
        mov     al,cs:[bx]
        not     al
        out     portb,al
        sub     bx,10
        call    delay
        add     cl,cl
        inc     ch
        inc     bx
        cmp     ch,8
        jne     lp1
        xor     al,al
        out     portc,al
        mov     al,cs:[bx]
        not     al
        out     porta,al
        add     bx,10
        mov     al,cs:[bx]
        not     al
        or      al,80h
        out     portb,al
        sub     bx,10
        call    delay
        inc     ch
        inc     bx

        mov     al,cs:[bx]
        not     al
        or      al,80h
        out     porta,al
        add     bx,10
        mov     al,cs:[bx]
        not     al
        out     portb,al
        sub     bx,10
        call    delay
        inc     ch
        inc     bx
        jmp     begin
;
delay   proc    near
        push    cx
        mov     cx,50
delay1: or      cx,cx
        or      cx,cx
        loop    delay1
        pop     cx
        retn
delay   endp
;
main    endp
uparr   db      80h,82h,86h,8fh,9fh
        db      9fh,8fh,86h,82h,80h
dnarr   db      80h,80h,80h,9fh,9fh
        db      9fh,9fh,80h,80h,80h
cg      ends
        end     begin

