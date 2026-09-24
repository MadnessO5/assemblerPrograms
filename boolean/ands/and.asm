%include "stud_io.inc"

global _start

section .text

_start:
        call read_bin
        mov ebx, eax

        call read_bin
        and eax, ebx

        call print_bin
        PUTCHAR 10

        FINISH 0


read_bin:
        xor ecx, ecx

.loop:
        GETCHAR
        cmp al, '0'
        je .bit
        cmp al, '1'
        je .bit
        jmp .done

.bit:
        shl ecx, 1
        sub al, '0'
        or cl, al
        jmp .loop

.done:
        mov eax, ecx
        ret


print_bin:
        mov ecx, 32

.loop:
        shl eax, 1
        jc .one

        PUTCHAR '0'
        jmp .next

.one:
        PUTCHAR '1'

.next:
        loop .loop
        ret
