%include "stud_io.inc"

section .text
    global _start

_start:
    ; Call both procedures.
    call first_proc
    call second_proc
    FINISH 0

first_proc:
    ; Print A three times.
    mov ecx, 3

.cycle:
    mov al, 'A'
    PUTCHAR al
    loop .cycle

    mov al, 10
    PUTCHAR al
    ret

second_proc:
    ; Print B two times.
    mov ecx, 2

.cycle:
    mov al, 'B'
    PUTCHAR al
    loop .cycle

    mov al, 10
    PUTCHAR al
    ret

