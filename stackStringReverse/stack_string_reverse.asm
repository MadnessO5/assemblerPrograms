%include "stud_io.inc"

section .data
    prompt db "Enter a string: "
    prompt_len equ $ - prompt

section .bss
    buffer resb 256

section .text
    global _start

_start:
    _syscall_write 1, prompt, prompt_len

    mov esi, buffer
    xor ecx, ecx

.read:
    GETCHAR
    cmp al, 10
    je .reverse

    movzx ebx, al
    push ebx
    inc ecx
    cmp ecx, 255
    jb .read

.reverse:
    test ecx, ecx
    jz .done

.print:
    pop ebx
    mov al, bl
    PUTCHAR al
    loop .print

.done:
    mov al, 10
    PUTCHAR al
    FINISH 0
