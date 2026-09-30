%include "stud_io.inc"

global _start

section .data
        count dd 0

section .text

_start:
        mov     eax, 42
        mov     ebx, eax
        mov     [count], ebx
        mov     eax, [count]

        call    print_int
        PUTCHAR 10

        FINISH  0


print_int:
        xor     ecx, ecx
        mov     ebx, 10

convert:
        xor     edx, edx
        div     ebx
        push    edx
        inc     ecx
        test    eax, eax
        jnz     convert

print:
        pop     eax
        add     al, '0'
        PUTCHAR al
        loop    print

        ret
