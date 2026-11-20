; Interactive text-to-binary encoder.
BITS 32

global _start
extern print_string
extern read_line
extern encode_to_file

section .data
    prompt          db "Enter English text: ", 0
    success_message db "Binary text saved to binary.txt", 10, 0
    error_message   db "Error: could not create or write binary.txt", 10, 0
    output_name     db "binary.txt", 0

section .bss
    input_buffer resb 256

section .text
_start:
    push prompt
    call print_string
    add esp, 4

    push dword 256
    push dword input_buffer
    call read_line
    add esp, 8

    mov edx, eax
    push dword output_name
    push edx
    push dword input_buffer
    call encode_to_file
    add esp, 12

    test eax, eax
    jnz .error

    push success_message
    call print_string
    add esp, 4
    jmp .exit

.error:
    push error_message
    call print_string
    add esp, 4

.exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
