%include "stud_io.inc"

global _start

section .text

_start:
        mov     eax, 10

        add     eax, 5
        call    print_save
        PUTCHAR ' '

        sub     eax, 3
        call    print_save
        PUTCHAR ' '

        inc     eax
        call    print_save
        PUTCHAR ' '

        dec     eax
        call    print_save
        PUTCHAR ' '

        neg     eax
        call    print_save
        PUTCHAR 10

        cmp     eax, -12
        je      equal

        PUTCHAR 'N'
        PUTCHAR 10
        FINISH 0

equal:
        PUTCHAR 'Y'
        PUTCHAR 10
        FINISH 0


print_save:
        push    eax
        call    print_int
        pop     eax
        ret


print_int:
        test    eax, eax
        jns     .positive

        PUTCHAR '-'
        neg     eax

.positive:
        xor     ecx, ecx
        mov     ebx, 10

.convert:
        xor     edx, edx
        div     ebx
        push    edx
        inc     ecx
        test    eax, eax
        jnz     .convert

.print:
        pop     eax
        add     al, '0'
        PUTCHAR al
        loop    .print

        ret
