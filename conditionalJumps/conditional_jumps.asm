%include "stud_io.inc"

global _start

section .text

_start:
        PUTCHAR '1'
        PUTCHAR ':'
        PUTCHAR ' '
        call    read_int
        mov     ebx, eax

        PUTCHAR '2'
        PUTCHAR ':'
        PUTCHAR ' '
        call    read_int

        cmp     ebx, eax
        jl      less
        jg      greater
        jmp     equal

less:
        PUTCHAR '<'
        PUTCHAR 10
        FINISH 0

greater:
        PUTCHAR '>'
        PUTCHAR 10
        FINISH 0

equal:
        PUTCHAR '='
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
