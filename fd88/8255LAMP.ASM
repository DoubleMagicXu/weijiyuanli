; 8255lamp.asm
; 8255 traffic lamp
;
porta   EQU     8H
portb   EQU     9H
control EQU     0bH
;
dseg    segment
time    db      ?
value   db      ?
done    db      0
intmask db      ?
dseg    ends
;
cseg    segment
        assume  cs:cseg, ds:dseg

start:  mov     al,80h
        mov     dx,control
        out     dx,al           ; 8255 ≥ı ºªØ
sw:     mov     al,11h
        mov     dx,porta
        not     al
        out     dx,al           ; ALL RED LIGHT
        inc     dx
        not     al
        out     dx,al
        mov     cx,3
cp1:    call    delay
        loop    cp1
lamp:   mov     al,14h
        mov     dx,porta
        not     al
        out     dx,al
        mov     al,41h
        inc     dx
        not     al
        out     dx,al
        mov     cx,6
cp2:    call    delay
        loop    cp2
        mov     value,5
flash:                           ; GREEN FLASH
        mov     al,10h           ; ¬Ãµ∆…¡À∏, 0.5√Î¡¡, 0.5√Î√
        mov     dx,porta
        not     al
        out     dx,al
        mov     AL,1h
        inc     dx
        not     al
        out     dx,al
        mov     cx,1
cp3:    call    delay
        loop    cp3
        mov     al,14h
        mov     dx,porta
        not     al
        out     dx,al
        mov     al,41h
        inc     dx
        not     al
        out     dx,al
        mov     cx,1
cp4:    call    delay
        loop    cp4
        dec     value
        jne     flash            ; ÷ÿ∏¥5¥Œ

                                 ; ª∆µ∆ 1 √Î÷”
        mov     al,12h
        mov     dx,porta
        not     al
        out     dx,al
        mov     al,21h
        inc     dx
        not     al
        out     dx,al
        mov     cx,2
cpa:    call    delay
        loop    cpa

                                 ; ¬Ãµ∆ 6 √Î÷”
        mov     al,41h
        mov     dx,porta
        not     al
        out     dx,al
        mov     al,14h
        inc     dx
        not     al
        out     dx,al
        mov     cx,6
cp5:    call    delay
        loop    cp5

        mov     value,5
flass:                          ; GREEN FLASH
        mov     al,1h           ; ¬Ãµ∆…¡À∏, 0.5√Î¡¡, 0.5√Î√
        mov     dx,porta
        not     al
        out     dx,al
        mov     al,10h
        inc     dx
        not     al
        out     dx,al
        mov     cx,1
cp6:    call    delay
        loop    cp6
        mov     al,41h
        mov     dx,porta
        not     al
        out     dx,al
        mov     al,14H
        inc     dx
        not     al
        out     dx,al
        mov     cx,1
cp7:    call    delay
        loop    cp7
        dec     value
        jnz     flass

                                 ; ª∆µ∆ 1 √Î÷”
        mov     al,21h
        mov     dx,porta
        not     al
        out     dx,al
        mov     al,12h
        inc     dx
        not     al
        out     dx,al
        mov     cx,2
cpb:    call    delay
        loop    cpb

        jmp     lamp
;
back:   int     20h
;
delay   proc    near
        push    ds
        push    ax
        push    cx
        xor     cx,cx
        loop    $
        pop     cx
        pop     ax
        pop     ds
        retn
delay   endp
;
cseg    ends
        end     start
        ;
