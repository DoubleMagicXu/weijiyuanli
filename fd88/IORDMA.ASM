code 	segment
        assume  cs:code
start:
        mov     ax,100h
        mov     es,ax

rio:    mov     al,05h
        out     8ah,al
        out     8ch,al
        mov     al,01000101b
        out     8bh,al
        mov     al,0
        out     82h,al
        mov     al,10h
        out     82h,al

        mov     al,0
        out     83h,al
        mov     al,0
        out     83h,al

        mov     al,01h
        out     8ah,al
        mov     al,5
        out     89h,al

wait1:  in      al,88h
        and     al,02h
        jz      wait1

wio:
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
        jmp     rio

code 	ends
        end start

