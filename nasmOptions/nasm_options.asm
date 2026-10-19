%include "stud_io.inc"

section .data
    message db "Hello from NASM!", 10
    message_len equ $ - message

section .text
    global _start

_start:
    ; Print the message using Linux sys_write.
    mov eax, 4
    mov ebx, 1
    mov ecx, message
    mov edx, message_len
    int 0x80

    ; Exit the program.
    mov eax, 1
    xor ebx, ebx
    int 0x80

