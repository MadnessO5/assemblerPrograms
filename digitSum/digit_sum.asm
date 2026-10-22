section .data
    prompt db "Enter a number: "
    prompt_len equ $ - prompt
    result_msg db "Sum of digits: "
    result_len equ $ - result_msg
    newline db 10

section .bss
    input resb 32
    output resb 12

section .text
    global _start

_start:
    ; Print the prompt.
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    ; Read the number.
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 32
    int 0x80

    ; Calculate the sum of digits.
    xor esi, esi
    mov edi, input

sum_loop:
    movzx eax, byte [edi]
    cmp eax, 10
    je show_result
    cmp eax, 13
    je show_result
    test eax, eax
    jz show_result

    sub eax, '0'
    cmp eax, 9
    ja show_result

    add esi, eax
    inc edi
    jmp sum_loop

show_result:
    ; Print the result message.
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, result_len
    int 0x80

    ; Convert the sum into decimal digits.
    mov eax, esi
    mov ebx, 10
    mov edi, output + 12
    xor ecx, ecx

convert_loop:
    xor edx, edx
    div ebx
    dec edi
    add dl, '0'
    mov [edi], dl
    inc ecx
    test eax, eax
    jnz convert_loop

    ; Print the result.
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, ecx
    sub edx, edi
    ; The digit count is stored in ECX.
    mov edx, ecx
    mov ecx, edi
    mov ebx, 1
    mov eax, 4
    int 0x80

    ; Print a newline.
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit the program.
    mov eax, 1
    xor ebx, ebx
    int 0x80

