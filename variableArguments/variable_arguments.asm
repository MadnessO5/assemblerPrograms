%include "stud_io.inc"

section .data
    message db "Sum: "
    message_len equ $ - message
    newline db 10

section .text
    global _start

_start:
    ; Call sum_numbers(3, 10, 20, 30).
    push dword 30
    push dword 20
    push dword 10
    push dword 3
    call sum_numbers
    add esp, 16

    ; Save the sum before printing the message.
    push eax
    _syscall_write 1, message, message_len
    pop eax

    ; Print the result.
    call print_uint

    ; Print a newline.
    _syscall_write 1, newline, 1
    FINISH 0

; Sum a variable number of arguments.
; [ebp+8] = number of arguments.
; [ebp+12] = first number.
sum_numbers:
    push ebp
    mov ebp, esp

    xor eax, eax
    mov ecx, [ebp+8]
    lea esi, [ebp+12]

.sum_loop:
    test ecx, ecx
    jz .done

    add eax, [esi]
    add esi, 4
    dec ecx
    jmp .sum_loop

.done:
    pop ebp
    ret

; Print the unsigned integer in EAX.
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

    mov eax, 4
    mov ebx, 1
    mov edx, ecx
    mov ecx, edi
    int 0x80
    ret

section .bss
    number_buffer resb 10
