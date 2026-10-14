%include "stud_io.inc"

section .data
    message db "10 + 20 = "
    message_len equ $ - message
    newline db 10

section .bss
    number_buffer resb 10

section .text
    global _start

_start:
    ; Pass two parameters through the stack.
    push dword 20
    push dword 10
    call add_numbers
    add esp, 8

    ; Print the message.
    mov esi, eax
    _syscall_write 1, message, message_len

    ; Print the result.
    mov eax, esi
    call print_uint

    ; Print a newline.
    _syscall_write 1, newline, 1
    FINISH 0

; Add two numbers using a stack frame.
add_numbers:
    push ebp
    mov ebp, esp
    sub esp, 4

    ; Read the parameters and calculate the sum.
    mov eax, [ebp+8]
    add eax, [ebp+12]

    ; Store the result in a local variable.
    mov [ebp-4], eax
    mov eax, [ebp-4]

    ; Restore the stack frame.
    mov esp, ebp
    pop ebp
    ret

; Print an unsigned integer stored in EAX.
print_uint:
    mov edi, number_buffer + 10
    xor ecx, ecx
    mov ebx, 10

.convert:
    xor edx, edx
    div ebx
    add dl, '0'
    dec edi
    mov [edi], dl
    inc ecx
    test eax, eax
    jnz .convert

    ; Write the converted digits.
    mov eax, 4
    mov ebx, 1
    mov edx, ecx
    mov ecx, edi
    int 0x80
    ret
