 pa55    equ 10h
 pb55    equ 11h
 p55ctl  equ 13h
 
 code   segment
 main   proc far
 assume cs:code
 start: mov     ax,cs
        mov     ds,ax
	  
 scan:  call    key                ;get a char in (dl) and display it
        jmp     scan
 main  endp
  
key     proc    near
        mov     al,82h
        mov     dx,p55ctl
        out     dx,al                ;set command word of 8255a
                                     ;porta for output,portb for input
wait1:  mov     al,00
        mov     dx,pa55
        out     dx,al                ;porta output 00
        mov     dx,pb55
        in      al,dx                ;get col data
        and     al,0fh
        cmp     al,0fh
        jnz     key1                 ;no key is closed ,wait
        retn
key1:   push    ax                   ;save the col data
        push    ax
        mov     cx,1000h             ;delay for amoment
        loop    $
        mov     dx,p55ctl
        mov     al,90h               ;set command word of 8255a
        out     dx,al                ;porta for input,portb for output
        mov     dx,pb55
        pop     ax
        out     dx,al                ;output col data from portb
        mov     dx,pa55
        in      al,dx                ;(al) is row data
        pop     bx
        mov     ah,bl                ;(ah) is col data
        not     ax
        and     ax,0f0fh
        mov     si,offset table
        mov     di,offset char
        mov     cx,24
  tt:   cmp     ax,[si]              ;cmp (col,row) with every word
        jz      nn                   ;in the table
        dec     cx
        jnz     key2
        retn
key2:   add     si,2
        inc     di
        jmp     tt
  nn:   mov     al,[di]
        mov     ah,1
        int     14h
        push    dx
        mov     al,82h
        mov     dx,p55ctl
        out     dx,al                ;set command word of 8255a
                                     ;porta for output,portb for input
wait2:  mov     al,00
        mov     dx,pa55
        out     dx,al                ;porta output 00
        mov     dx,pb55
        in      al,dx                 ;get col data
        and     al,0fh
        cmp     al,0fh
        jnz     wait2                ;wait until the key is up
        pop     dx
        retn
key     endp
table   dw 0101h,0102h,0104h,0108h
        dw 0201h,0202h,0204h,0208h
        dw 0401h,0402h,0404h,0408h
        dw 0801h,0802h,0804h,0808h
char    db '048C159D26AE37BF'
code    ends
        end     start
