%include "stud_io.inc"

global _start

section .bss
    num1    resd 1
    num2    resd 1

section .text

_start:
        PUTCHAR 'A'
        PUTCHAR ':'
        PUTCHAR ' '
        call    read_int
        mov     [num1], eax

        PUTCHAR 'B'
        PUTCHAR ':'
        PUTCHAR ' '
        call    read_int

        mov     [num2], eax
        mov     eax, [num1]

        cmp     eax, [num2]
        jg      first_greater

        jl      second_greater

        PUTCHAR '='
        PUTCHAR 10
        FINISH 0

first_greater:
        sub     eax, [num2]
        call    print_int
        PUTCHAR 10
        FINISH 0

second_greater:
        mov     eax, [num2]
        sub     eax, [num1]
        call    print_int
        PUTCHAR 10
        FINISH 0


read_int:
        xor     esi, esi

.read:
        GETCHAR
        cmp     al, 10
        je      .done

        sub     al, '0'
        movzx   edx, al
        imul    esi, 10
        add     esi, edx
        jmp     .read

.done:
        mov     eax, esi
        ret


print_int:
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
