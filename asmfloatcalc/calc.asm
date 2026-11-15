; Interactive floating-point calculator using x87 and a static library.
BITS 32
GLOBAL _start
EXTERN read_line
EXTERN write_string
EXTERN parse_float
EXTERN print_float
EXTERN calc_add
EXTERN calc_subtract
EXTERN calc_multiply
EXTERN calc_divide

SECTION .data
welcome db 10, '=== NASM Floating-Point Calculator ===', 10, 0
menu db 10, '1. Add', 10, '2. Subtract', 10, '3. Multiply', 10, '4. Divide', 10, '0. Exit', 10, 'Choose: ', 0
first_prompt db 'First number (-999.99 to 999.99): ', 0
second_prompt db 'Second number (-999.99 to 999.99): ', 0
invalid_text db 'Invalid number. Use up to 3 integer and 2 decimal digits.', 10, 0
choice_error db 'Choose 0, 1, 2, 3 or 4.', 10, 0
zero_error db 'Error: division by zero.', 10, 0
result_text db 'Result: ', 0
hundred_value dd 100

SECTION .bss
input_buffer resb 64
choice_value resd 1
first_scaled resd 1
second_scaled resd 1
first_value resq 1
second_value resq 1
result_value resq 1

SECTION .text
_start:
    finit
    push dword welcome
    call write_string
    add esp, 4

.main_menu:
    push dword menu
    call write_string
    add esp, 4
    push dword 64
    push dword input_buffer
    call read_line
    add esp, 8
    mov esi, input_buffer
    cmp byte [esi], '0'
    je .exit_program
    cmp byte [esi], '1'
    jb .bad_choice
    cmp byte [esi], '4'
    ja .bad_choice
    movzx eax, byte [esi]
    sub eax, '0'
    mov [choice_value], eax

.read_first:
    push dword first_prompt
    call write_string
    add esp, 4
    call read_input_number
    test edx, edx
    jnz .bad_number_first
    mov [first_scaled], eax
    fild dword [first_scaled]
    fidiv dword [hundred_value]
    fstp qword [first_value]

.read_second:
    push dword second_prompt
    call write_string
    add esp, 4
    call read_input_number
    test edx, edx
    jnz .bad_number_second
    mov [second_scaled], eax
    fild dword [second_scaled]
    fidiv dword [hundred_value]
    fstp qword [second_value]

    cmp dword [choice_value], 4
    jne .calculate
    cmp dword [second_scaled], 0
    je .division_by_zero

.calculate:
    push dword [second_value + 4]
    push dword [second_value]
    push dword [first_value + 4]
    push dword [first_value]
    mov eax, [choice_value]
    cmp eax, 1
    je .do_add
    cmp eax, 2
    je .do_subtract
    cmp eax, 3
    je .do_multiply
    call calc_divide
    jmp .save_result
.do_add:
    call calc_add
    jmp .save_result
.do_subtract:
    call calc_subtract
    jmp .save_result
.do_multiply:
    call calc_multiply
.save_result:
    add esp, 16
    fstp qword [result_value]
    push dword result_text
    call write_string
    add esp, 4
    push dword [result_value + 4]
    push dword [result_value]
    call print_float
    add esp, 8
    jmp .main_menu

.bad_number_first:
    push dword invalid_text
    call write_string
    add esp, 4
    jmp .read_first
.bad_number_second:
    push dword invalid_text
    call write_string
    add esp, 4
    jmp .read_second
.bad_choice:
    push dword choice_error
    call write_string
    add esp, 4
    jmp .main_menu
.division_by_zero:
    push dword zero_error
    call write_string
    add esp, 4
    jmp .read_second

.exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Read and parse one decimal number. Returns scaled value in EAX and status in EDX.
read_input_number:
    push dword 64
    push dword input_buffer
    call read_line
    add esp, 8
    push dword input_buffer
    call parse_float
    add esp, 4
    ret
