section .data
    menu db 10, "=== MINI CALCULATOR ===", 10
         db "1. Add", 10
         db "2. Subtract", 10
         db "3. Multiply", 10
         db "4. Divide", 10
         db "0. Exit", 10
         db "Choice: "
    menu_len equ $ - menu

    prompt_a db "First number: "
    prompt_a_len equ $ - prompt_a
    prompt_b db "Second number: "
    prompt_b_len equ $ - prompt_b

    result_msg db "Result: "
    result_len equ $ - result_msg
    error_msg db "Error: division by zero!", 10
    error_len equ $ - error_msg
    newline db 10

section .bss
    input resb 32
    output resb 16
    first resd 1
    second resd 1

section .text
    global _start

_start:
menu_loop:
    ; Display the menu.
    mov eax, 4
    mov ebx, 1
    mov ecx, menu
    mov edx, menu_len
    int 0x80

    ; Read the menu choice.
    call read_number
    cmp eax, 0
    je exit_program
    cmp eax, 1
    je add_numbers
    cmp eax, 2
    je subtract_numbers
    cmp eax, 3
    je multiply_numbers
    cmp eax, 4
    je divide_numbers
    jmp menu_loop

add_numbers:
    call read_operands
    mov eax, [first]
    add eax, [second]
    call print_result
    jmp menu_loop

subtract_numbers:
    call read_operands
    mov eax, [first]
    sub eax, [second]
    call print_result
    jmp menu_loop

multiply_numbers:
    call read_operands
    mov eax, [first]
    imul eax, [second]
    call print_result
    jmp menu_loop

divide_numbers:
    call read_operands
    mov ebx, [second]
    test ebx, ebx
    jz division_error
    mov eax, [first]
    cdq
    idiv ebx
    call print_result
    jmp menu_loop

division_error:
    mov eax, 4
    mov ebx, 1
    mov ecx, error_msg
    mov edx, error_len
    int 0x80
    jmp menu_loop

read_operands:
    ; Read the first number.
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_a
    mov edx, prompt_a_len
    int 0x80
    call read_number
    mov [first], eax

    ; Read the second number.
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_b
    mov edx, prompt_b_len
    int 0x80
    call read_number
    mov [second], eax
    ret

read_number:
    ; Read a line from standard input.
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 32
    int 0x80

    ; Convert decimal text to an integer.
    xor eax, eax
    xor esi, esi
    mov edi, input
    xor ebx, ebx
    mov bl, [edi]
    cmp bl, '-'
    jne parse_digits
    mov esi, 1
    inc edi

parse_digits:
    movzx ebx, byte [edi]
    cmp ebx, 10
    je parsed_number
    cmp ebx, 13
    je parsed_number
    test ebx, ebx
    jz parsed_number
    cmp ebx, '0'
    jb parsed_number
    cmp ebx, '9'
    ja parsed_number
    imul eax, eax, 10
    sub ebx, '0'
    add eax, ebx
    inc edi
    jmp parse_digits

parsed_number:
    test esi, esi
    jz read_done
    neg eax

read_done:
    ret

print_result:
    ; Print the result label.
    push eax
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, result_len
    int 0x80
    pop eax

    ; Convert the signed integer to decimal text.
    mov edi, output + 16
    xor ecx, ecx
    xor esi, esi
    test eax, eax
    jns convert_result
    neg eax
    mov esi, 1

convert_result:
    mov ebx, 10

convert_loop:
    xor edx, edx
    div ebx
    dec edi
    add dl, '0'
    mov [edi], dl
    inc ecx
    test eax, eax
    jnz convert_loop

    test esi, esi
    jz write_result
    dec edi
    mov byte [edi], '-'
    inc ecx

write_result:
    ; Write the converted result.
    mov eax, 4
    mov ebx, 1
    mov edx, ecx
    mov ecx, edi
    int 0x80

    ; Print a newline.
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    ret

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80

