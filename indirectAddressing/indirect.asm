%include "stud_io.inc"

global _start

section .bss
        array resd 10

section .text

_start:
        mov     edi, array
        mov     ecx, 10
        mov     eax, 1

fill:
        mov     [edi], eax
        add     edi, 4
        inc     eax
        loop    fill

        lea     edi, [array]

        mov     ecx, 10

show_array:
        mov     eax, [edi]
        call    print_int
        PUTCHAR ' '

        add     edi, 4
        loop    show_array

        PUTCHAR 10
        FINISH  0


print_int:
        xor     esi, esi
        mov     ebx, 10

convert:
        xor     edx, edx
        div     ebx
        push    edx
        inc     esi
        test    eax, eax
        jnz     convert

.print_digits:
        pop     eax
        add     al, '0'
        PUTCHAR al
        dec     esi
        jnz     .print_digits

        ret
