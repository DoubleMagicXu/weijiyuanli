; RAMDMA.ASM
; RAM TO RAM
;
code    segment
        assume cs:code
start:  mov     ax,0100h
        mov     es,ax
        mov     bx,0000h
        mov     cx,10h
        mov     dl,40h
rep1:   inc     dl
        mov     es:[bx],dl
        inc     bx
ss1:    loop    rep1

set823: out     8dh,al          ; reset 8237
        out     8ch,al          ; clear first/last register

        mov     al,0
        out     80h,al
        mov     al,10h
        out     80h,al

        mov     al,10h
        out     82h,al
        mov     al,10h
        out     82h,al

        mov     al,10h
        out     81h,al
        mov     al,0h
        out     81h,al

        mov     al,10h
        out     83h,al
        mov     al,0h
        out     83h,al

        mov     al,88h
        out     8bh,al
        mov     al,85h
        out     8bh,al


        mov     al,10000001B
        out     88h,al          ; dack high, ram to ram

        mov     al,0            ; enable request
        out     8fh,al

        mov     al,4
        out     89h,al
        int     20h

code 	ends
        end start

