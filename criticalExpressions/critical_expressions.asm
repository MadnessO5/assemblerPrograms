%include "stud_io.inc"

section .data
    title db 10, "=== CRITICAL EXPRESSIONS ===", 10
          db "1. Show label addresses", 10
          db "2. Show the current address ($)", 10
          db "3. Show reserved data sizes", 10
          db "0. Exit", 10
          db "Choice: "
    title_len equ $ - title

    label_msg db "Address of start: "
    label_msg_len equ $ - label_msg

    current_msg db "Current address: "
    current_msg_len equ $ - current_msg

    size_msg db "Reserved bytes: "
    size_msg_len equ $ - size_msg

    newline db 10

section .bss
    buffer resb 16

section .text
    global _start

_start:
menu:
    mov eax, 4
    mov ebx, 1
    mov ecx, title
    mov edx, title_len
    int 0x80

    call read_choice

    cmp eax, 0
    je exit_program

    cmp eax, 1
    je show_labels

    cmp eax, 2
    je show_current

    cmp eax, 3
    je show_sizes

    jmp menu

show_labels:
    mov eax, 4
    mov ebx, 1
    mov ecx, label_msg
    mov edx, label_msg_len
    int 0x80

    mov eax, start
    call print_number

    jmp menu

show_current:
    mov eax, 4
    mov ebx, 1
    mov ecx, current_msg
    mov edx, current_msg_len
    int 0x80

    mov eax, current_position
    call print_number

    jmp menu

show_sizes:
    mov eax, 4
    mov ebx, 1
    mov ecx, size_msg
    mov edx, size_msg_len
    int 0x80

    mov eax, data_end - data_start
    call print_number

    jmp menu

read_choice:
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 16
    int 0x80

    movzx eax, byte [buffer]
    sub eax, '0'
    ret

print_number:
    push eax
    mov ebx, 10
    mov ecx, buffer
    add ecx, 15
    mov byte [ecx], 10
    dec ecx
    mov edi, 1

.convert:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [ecx], dl
    dec ecx
    test eax, eax
    jnz .convert

    inc ecx
    mov edx, buffer
    add edx, 16
    sub edx, ecx
    mov eax, 4
    mov ebx, 1
    int 0x80

    pop eax
    ret

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80

section .data
data_start:
    times 5 db 0
    times 3 db 1
data_end:

section .text
start:
    nop

current_position:
    nop

