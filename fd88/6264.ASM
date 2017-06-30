; 6264.ASM
;
code    segment
        assume cs:code
start : mov     ax,1000H
        mov     ds,ax
        mov     bx,0000h
        mov     dl,40h
rep1:   inc     dl
        mov     ds:[bx],dl
        inc     bx
        cmp     dl,5ah
        jnz     rep1
        mov     dl,0
        mov     [bx],dl
        mov     ax,ds
        mov     es,ax
        mov     bp,0
        mov     ah,4
        int     14h
        xor     cx,cx
        loop    $
        int     20h
code    ends
        end     start
			
