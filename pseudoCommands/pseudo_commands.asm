%include "stud_io.inc"

section .data
    message db "Hello!", 10
    message_len equ $ - message

    stars times 5 db '*'
    number dd 42

section .bss
    buffer resb 10

section .text
    global _start

_start:
    ; Print the message.
    mov eax, 4
    mov ebx, 1
    mov ecx, message
    mov edx, message_len
    int 0x80

    ; Print five stars.
    mov eax, 4
    mov ebx, 1
    mov ecx, stars
    mov edx, 5
    int 0x80

    ; Print a newline.
    PUTCHAR 10

    ; Exit the program.
    mov eax, 1
    xor ebx, ebx
    int 0x80

