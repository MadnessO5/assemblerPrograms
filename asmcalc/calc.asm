global _start

extern read_uint
extern putstr
extern print_int
extern add_int
extern sub_int
extern mul_int
extern div_int
extern quit

section .data
menu_text db 10, '=== Modular Calculator ===', 10
          db '1. Addition', 10
          db '2. Subtraction', 10
          db '3. Multiplication', 10
          db '4. Division', 10
          db '0. Exit', 10, 0
prompt_a db 'Enter first number (0-9999): ', 0
prompt_b db 'Enter second number (0-9999): ', 0
prompt_choice db 'Choose an operation: ', 0
invalid_input db 'Invalid input. Enter an integer from 0 to 9999.', 10, 0
invalid_choice db 'Invalid choice. Try again.', 10, 0
division_zero db 'Error: division by zero is not allowed.', 10, 0
result_text db 'Result: ', 0
newline db 10, 0

section .bss
first_value resd 1
second_value resd 1
choice_value resd 1

section .text
_start:
.menu:
    push dword menu_text
    call putstr
    add esp, 4

    push dword prompt_choice
    call read_uint
    add esp, 4
    test edx, edx
    jnz .bad_choice

    cmp eax, 0
    je .exit
    cmp eax, 4
    ja .bad_choice
    mov [choice_value], eax

.read_first:
    push dword prompt_a
    call read_uint
    add esp, 4
    test edx, edx
    jnz .bad_first
    mov [first_value], eax

.read_second:
    push dword prompt_b
    call read_uint
    add esp, 4
    test edx, edx
    jnz .bad_second
    mov [second_value], eax

    mov eax, [choice_value]
    cmp eax, 1
    je .addition
    cmp eax, 2
    je .subtraction
    cmp eax, 3
    je .multiplication

    cmp dword [second_value], 0
    je .zero_divisor
    push dword [second_value]
    push dword [first_value]
    call div_int
    add esp, 8
    jmp .show_result

.addition:
    push dword [second_value]
    push dword [first_value]
    call add_int
    add esp, 8
    jmp .show_result

.subtraction:
    push dword [second_value]
    push dword [first_value]
    call sub_int
    add esp, 8
    jmp .show_result

.multiplication:
    push dword [second_value]
    push dword [first_value]
    call mul_int
    add esp, 8

.show_result:
    push eax
    push dword result_text
    call putstr
    add esp, 4
    pop eax

    push eax
    call print_int
    add esp, 4

    push dword newline
    call putstr
    add esp, 4
    jmp .menu

.bad_choice:
    push dword invalid_choice
    call putstr
    add esp, 4
    jmp .menu

.bad_first:
    push dword invalid_input
    call putstr
    add esp, 4
    jmp .read_first

.bad_second:
    push dword invalid_input
    call putstr
    add esp, 4
    jmp .read_second

.zero_divisor:
    push dword division_zero
    call putstr
    add esp, 4
    jmp .menu

.exit:
    call quit
