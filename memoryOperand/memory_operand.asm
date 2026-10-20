%include "stud_io.inc"

section .data
    message db "Value from memory: "
    message_len equ $ - message

    number dd 7

section .text
    global _start

_start:
    ; Print the message.
    mov eax, 4
    mov ebx, 1
    mov ecx, message
    mov edx, message_len
    int 0x80

    ; Load the value from memory and print it.
    mov eax, [number]
    add eax, '0'
    PUTCHAR al
    PUTCHAR 10

    ; Exit the program.
    mov eax, 1
    xor ebx, ebx
    int 0x80
