%include "stud_io.inc"

global _start

section .data
    b db 10
    w dw 20
    d dd 30

section .text

_start:
    movzx eax, byte [b]
    call print_int
    PUTCHAR ' '

    movzx eax, word [w]
    call print_int
    PUTCHAR ' '

    mov eax, [d]
    call print_int
    PUTCHAR 10

    mov byte [b], 40
    mov word [w], 50
    mov dword [d], 60

    movzx eax, byte [b]
    call print_int
    PUTCHAR ' '

    movzx eax, word [w]
    call print_int
    PUTCHAR ' '

    mov eax, [d]
    call print_int
    PUTCHAR 10

    FINISH 0


print_int:
    xor ecx, ecx
    mov ebx, 10

.loop:
    xor edx, edx
    div ebx
    push edx
    inc ecx
    test eax, eax
    jnz .loop

.print:
    pop eax
    add al, '0'
    PUTCHAR al
    loop .print

    ret
