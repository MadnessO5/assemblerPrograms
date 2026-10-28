; Interactive calculator demonstrating NASM macro directives.

%include "macros.inc"

%ifndef DEBUG
    %define DEBUG 0
%endif

%assign MENU_ITEMS 6

%if MENU_ITEMS < 1
    %error "MENU_ITEMS must be positive"
%elif MENU_ITEMS > 10
    %error "MENU_ITEMS is too large"
%else
    %define MENU_CONFIG_OK 1
%endif

%if DEBUG
    %define DEBUG_MESSAGE 1
    %warning "Debug build enabled"
%endif

%ifdef TEMP_VALUE
    %error "TEMP_VALUE should have been undefined"
%endif

section .data
    separator:
        SEPARATOR
    separator_len equ $ - separator

    title db "       MACRO CALCULATOR", 10
          db "1. Add", 10
          db "2. Subtract", 10
          db "3. Multiply", 10
          db "4. Divide", 10
          db "5. Modulo", 10
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

    error_choice db "Invalid choice.", 10
    error_choice_len equ $ - error_choice

    debug_msg db "DEBUG: debug build enabled.", 10
    debug_msg_len equ $ - debug_msg

    newline db 10
    newline_len equ $ - newline

section .bss
    input resb 32
    output resb 12
    first resd 1
    second resd 1

section .text
    global _start

_start:
%ifdef DEBUG_MESSAGE
    PRINT debug_msg, debug_msg_len
%endif

menu_loop:
    PRINT separator, separator_len
    PRINT title, title_len

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

    PRINT error_choice, error_choice_len
    jmp menu_loop

read_operands:
    PRINT prompt_a, prompt_a_len
    call read_number
    mov [first], eax

    PRINT prompt_b, prompt_b_len
    call read_number
    mov [second], eax
    ret

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
    cmp dword [second], 0
    je division_error
    mov eax, [first]
    cdq
    idiv dword [second]
    jmp show_result

modulo_numbers:
    call read_operands
    cmp dword [second], 0
    je division_error
    mov eax, [first]
    cdq
    idiv dword [second]
    mov eax, edx
    jmp show_result

division_error:
    PRINT error_zero, error_zero_len
    jmp menu_loop

show_result:
    ; Preserve the calculation result while PRINT uses EAX.
    push eax
    PRINT result_msg, result_len
    pop eax
    call print_number
    NEWLINE
    jmp menu_loop

; Read a signed decimal integer.
read_number:
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, input
    mov edx, 32
    int 0x80

    xor eax, eax
    xor esi, esi
    mov edi, input

    cmp byte [edi], '-'
    jne parse_digits
    mov esi, 1
    inc edi

parse_digits:
    movzx ebx, byte [edi]

    cmp ebx, 10
    je parsed_number

    cmp ebx, 13
    je parsed_number

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

; Print signed EAX as a decimal number.
print_number:
    mov edi, output + 11
    mov byte [edi], 10
    dec edi

    xor esi, esi
    test eax, eax
    jns .convert

    mov esi, 1
    neg eax

.convert:
    mov ebx, 10

.loop:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz .loop

    test esi, esi
    jz .write

    mov byte [edi], '-'
    dec edi

.write:
    lea ecx, [edi + 1]
    lea edx, [output + 12]
    sub edx, ecx

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    int 0x80
    ret

exit_program:
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80

