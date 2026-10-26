section .data
    title db 10, "=== NASM INTERACTIVE CALCULATOR ===", 10
          db "1. Add", 10
          db "2. Subtract", 10
          db "3. Multiply", 10
          db "4. Divide", 10
          db "5. Modulo", 10
          db "6. Bitwise AND", 10
          db "7. Bitwise OR", 10
          db "8. Bitwise XOR", 10
          db "9. Shift left", 10
          db "10. Shift right", 10
          db "0. Exit", 10
          db "Choice: "
    title_len equ $ - title

    prompt_a db "First number: "
    prompt_a_len equ $ - prompt_a

    prompt_b db "Second number: "
    prompt_b_len equ $ - prompt_b

    result_msg db "Result: "
    result_len equ $ - result_msg

    error_zero db "Error: division by zero!", 10
    error_zero_len equ $ - error_zero

    error_shift db "Error: shift count must be 0..31!", 10
    error_shift_len equ $ - error_shift

    error_choice db "Invalid choice!", 10
    error_choice_len equ $ - error_choice

    newline db 10

section .bss
    input resb 32
    output resb 12
    first resd 1
    second resd 1

section .text
    global _start

_start:

menu_loop:
    mov ecx, title
    mov edx, title_len
    call print_text

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
    cmp eax, 5
    je modulo_numbers
    cmp eax, 6
    je and_numbers
    cmp eax, 7
    je or_numbers
    cmp eax, 8
    je xor_numbers
    cmp eax, 9
    je shift_left
    cmp eax, 10
    je shift_right

    mov ecx, error_choice
    mov edx, error_choice_len
    call print_text
    jmp menu_loop

; Read two operands.

read_operands:
    mov ecx, prompt_a
    mov edx, prompt_a_len
    call print_text
    call read_number
    mov [first], eax

    mov ecx, prompt_b
    mov edx, prompt_b_len
    call print_text
    call read_number
    mov [second], eax
    ret

; Arithmetic operations.

add_numbers:
    call read_operands
    mov eax, [first]
    add eax, [second]
    jmp show_result

subtract_numbers:
    call read_operands
    mov eax, [first]
    sub eax, [second]
    jmp show_result

multiply_numbers:
    call read_operands
    mov eax, [first]
    imul eax, [second]
    jmp show_result

divide_numbers:
    call read_operands
    mov ebx, [second]
    test ebx, ebx
    jz division_error

    mov eax, [first]
    cdq
    idiv ebx
    jmp show_result

modulo_numbers:
    call read_operands
    mov ebx, [second]
    test ebx, ebx
    jz division_error

    mov eax, [first]
    cdq
    idiv ebx
    mov eax, edx
    jmp show_result

; Bitwise operations.

and_numbers:
    call read_operands
    mov eax, [first]
    and eax, [second]
    jmp show_result

or_numbers:
    call read_operands
    mov eax, [first]
    or eax, [second]
    jmp show_result

xor_numbers:
    call read_operands
    mov eax, [first]
    xor eax, [second]
    jmp show_result

; Shift operations.

shift_left:
    call read_operands
    mov ecx, [second]
    cmp ecx, 0
    jl invalid_shift
    cmp ecx, 31
    jg invalid_shift

    mov eax, [first]
    shl eax, cl
    jmp show_result

shift_right:
    call read_operands
    mov ecx, [second]
    cmp ecx, 0
    jl invalid_shift
    cmp ecx, 31
    jg invalid_shift

    mov eax, [first]
    sar eax, cl
    jmp show_result

; Error handlers.

division_error:
    mov ecx, error_zero
    mov edx, error_zero_len
    call print_text
    jmp menu_loop

invalid_shift:
    mov ecx, error_shift
    mov edx, error_shift_len
    call print_text
    jmp menu_loop

; Display the result in EAX.

show_result:
    push eax

    mov ecx, result_msg
    mov edx, result_len
    call print_text

    pop eax
    call print_number

    jmp menu_loop

; Print a string at ECX with length EDX.

print_text:
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret

; Read a signed decimal integer from stdin.
; Returns the result in EAX.

read_number:
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 32
    int 0x80

    xor eax, eax
    xor esi, esi
    mov edi, input

    movzx ebx, byte [edi]
    cmp ebx, '-'
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

; Print the signed integer in EAX.

print_number:
    mov edi, output + 12
    xor ecx, ecx
    xor esi, esi

    test eax, eax
    jns convert_number

    neg eax
    mov esi, 1

convert_number:
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
    jz write_number

    dec edi
    mov byte [edi], '-'
    inc ecx

write_number:
    mov eax, 4
    mov ebx, 1
    mov edx, ecx
    mov ecx, edi
    int 0x80

    mov ecx, newline
    mov edx, 1
    call print_text
    ret

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
