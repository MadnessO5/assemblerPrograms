%include "stud_io.inc"
global  _start
 
section .bss
buffer: resb    256                    ; holds the input line
 
section .text
_start:
        xor     esi, esi               ; esi = write index while reading
 
read_loop:
        GETCHAR                        ; next character (or -1) into eax
        cmp     eax, -1                ; end of input reached?
        je      read_done
        cmp     eax, 10                ; newline ends the line
        je      read_done
        mov     [buffer + esi], al     ; store the character
        inc     esi                    ; advance the write index
        jmp     read_loop
 
read_done:
        mov     ecx, esi               ; ecx = number of characters read
        jecxz   print_result           ; nothing to reverse if the line
                                        ; was empty
 
        xor     ebx, ebx               ; ebx = read index while pushing
 
push_loop:
        movzx   eax, byte [buffer + ebx] ; next character from the buffer
        push    eax                    ; save it on the stack
        inc     ebx                    ; advance the read index
        cmp     ebx, ecx               ; reached the end yet?
        jl      push_loop
 
        xor     edi, edi               ; edi = write index while popping
 
pop_loop:
        pop     eax                    ; characters come back reversed
        mov     [buffer + edi], al     ; overwrite the buffer in place
        inc     edi                    ; advance the write index
        cmp     edi, ecx               ; written every character yet?
        jl      pop_loop
 
print_result:
        _syscall_write 1, buffer, ecx  ; write the (now reversed) line
        PUTCHAR 10                     ; followed by a newline
 
        FINISH  0                      ; exit code 0
