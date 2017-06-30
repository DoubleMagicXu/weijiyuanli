;DMA
; read from memory, write to io port
;
code    segment
        assume cs:code
start:  mov     dl,0
        mov     ax,100h
        mov     es,ax
wio:    mov     es:0,dl
        mov     al,05h
        out     8ah,al              ; set channel 1 mask bit
        out     8ch,al              ; clear triger
        mov     al,01001001b        ; work mode: single byte, addr inc
        out     8bh,al              ; read transfer channel 1
        mov     al,0
        out     82h,al              ; ch1 current address
        mov     al,10h
        out     82h,al              ; 0000

        mov     al,0
        out     83h,al              ; ch1 current counter
        mov     al,0
        out     83h,al              ;

        mov     al,01h
        out     8ah,al              ; clear ch1 mask bit
        mov     al,5
        out     89h,al
wait0:  in      al,88h              ; read status register
        and     al,02h              ; test ch1 if arrive t/c
        jz      wait0
        dec     dl
        push    cx
        mov     cx,0
        loop    $
        pop     cx
        jmp     wio

code 	ends
        end start

