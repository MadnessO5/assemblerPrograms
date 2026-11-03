; interactivePcallLab - practice with variable-argument NASM macros
; Build with: nrun interactive_pcall.asm
; NASM ELF32 / Linux int 0x80.

%macro PRINT 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

; First macro argument is a procedure address/name.
; Remaining arguments are pushed right-to-left.
%macro pcall 1-*
    %rep %0 - 1
        %rotate -1
        push dword %1
    %endrep
    %rotate -1
    call %1
    add esp, (%0 - 1) * 4
%endmacro

section .data
    title db 10, "interactivePcallLab - variable macro arguments", 10
    title_len equ $ - title

    menu db 10, "Choose a procedure:", 10
         db "1. Add two numbers", 10
         db "2. Add three numbers", 10
         db "3. Add four numbers", 10
         db "4. Show the last result", 10
         db "0. Exit", 10
         db "> "
    menu_len equ $ - menu

    prompt_a db "First number: "
    prompt_a_len equ $ - prompt_a
    prompt_b db "Second number: "
    prompt_b_len equ $ - prompt_b
    prompt_c db "Third number: "
    prompt_c_len equ $ - prompt_c
    prompt_d db "Fourth number: "
    prompt_d_len equ $ - prompt_d

    result_msg db "Result: "
    result_len equ $ - result_msg
    no_result db "No calculation yet.", 10
    no_result_len equ $ - no_result
    bad_menu db "Invalid choice. Enter 0..4.", 10
    bad_menu_len equ $ - bad_menu
    bad_number db "Invalid number. Enter an unsigned decimal integer.", 10
    bad_number_len equ $ - bad_number
    newline db 10

section .bss
    input_buf resb 64
    value_a resd 1
    value_b resd 1
    value_c resd 1
    value_d resd 1
    last_result resd 1
    has_result resd 1
    number_buf resb 16

section .text
    global _start

_start:
    mov dword [has_result], 0
    PRINT title, title_len

.menu_loop:
    PRINT menu, menu_len
    call read_line
    test eax, eax
    jle .exit
    call parse_decimal
    cmp eax, -1
    je .bad_choice
    cmp eax, 0
    je .exit
    cmp eax, 1
    je .add_two
    cmp eax, 2
    je .add_three
    cmp eax, 3
    je .add_four
    cmp eax, 4
    je .show_last
    jmp .bad_choice

.add_two:
    PRINT prompt_a, prompt_a_len
    call read_number
    jc .menu_loop
    mov [value_a], eax

    PRINT prompt_b, prompt_b_len
    call read_number
    jc .menu_loop
    mov [value_b], eax

    ; Three macro parameters: procedure + two arguments.
    pcall add_two, [value_a], [value_b]
    jmp .save_result

.add_three:
    PRINT prompt_a, prompt_a_len
    call read_number
    jc .menu_loop
    mov [value_a], eax

    PRINT prompt_b, prompt_b_len
    call read_number
    jc .menu_loop
    mov [value_b], eax

    PRINT prompt_c, prompt_c_len
    call read_number
    jc .menu_loop
    mov [value_c], eax

    ; Four macro parameters: procedure + three arguments.
    pcall add_three, [value_a], [value_b], [value_c]
    jmp .save_result

.add_four:
    PRINT prompt_a, prompt_a_len
    call read_number
    jc .menu_loop
    mov [value_a], eax

    PRINT prompt_b, prompt_b_len
    call read_number
    jc .menu_loop
    mov [value_b], eax

    PRINT prompt_c, prompt_c_len
    call read_number
    jc .menu_loop
    mov [value_c], eax

    PRINT prompt_d, prompt_d_len
    call read_number
    jc .menu_loop
    mov [value_d], eax

    ; Five macro parameters: procedure + four arguments.
    pcall add_four, [value_a], [value_b], [value_c], [value_d]
    jmp .save_result

.save_result:
    mov [last_result], eax
    mov dword [has_result], 1
    call show_result
    jmp .menu_loop

.show_last:
    cmp dword [has_result], 0
    je .nothing_to_show
    mov eax, [last_result]
    call show_result
    jmp .menu_loop

.nothing_to_show:
    PRINT no_result, no_result_len
    jmp .menu_loop

.bad_choice:
    PRINT bad_menu, bad_menu_len
    jmp .menu_loop

.exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Read one line from stdin. Returns byte count in EAX.
read_line:
    mov eax, 3
    xor ebx, ebx
    mov ecx, input_buf
    mov edx, 63
    int 0x80
    ret

; Read and parse an unsigned decimal number.
; Returns value in EAX; CF=1 on invalid input.
read_number:
    call read_line
    test eax, eax
    jle .invalid
    call parse_decimal
    cmp eax, -1
    je .invalid
    clc
    ret
.invalid:
    PRINT bad_number, bad_number_len
    stc
    ret

; Parse digits from input_buf. Returns -1 on invalid input.
; Accepts spaces/tabs around the number and ignores line ending.
parse_decimal:
    push ebx
    push ecx
    push edx
    push esi

    mov esi, input_buf
    xor eax, eax
    xor ecx, ecx

.skip_space:
    mov bl, [esi]
    cmp bl, ' '
    je .space_next
    cmp bl, 9
    je .space_next
    jmp .digits
.space_next:
    inc esi
    jmp .skip_space

.digits:
    mov bl, [esi]
    cmp bl, '0'
    jb .after_digits
    cmp bl, '9'
    ja .after_digits

    ; Check overflow before multiplying by ten.
    cmp eax, 429496729
    ja .invalid
    jne .multiply
    cmp bl, '5'
    ja .invalid
.multiply:
    imul eax, eax, 10
    movzx edx, bl
    sub edx, '0'
    add eax, edx
    inc esi
    inc ecx
    jmp .digits

.after_digits:
    test ecx, ecx
    jz .invalid
    cmp bl, 10
    je .valid
    cmp bl, 13
    je .valid
    cmp bl, 0
    je .valid
    cmp bl, ' '
    je .trailing_space
    cmp bl, 9
    je .trailing_space
    jmp .invalid

.trailing_space:
    inc esi
    mov bl, [esi]
    cmp bl, 10
    je .valid
    cmp bl, 13
    je .valid
    cmp bl, 0
    je .valid
    cmp bl, ' '
    je .trailing_space
    cmp bl, 9
    je .trailing_space
    jmp .invalid

.valid:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

.invalid:
    mov eax, -1
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

; int add_two(unsigned a, unsigned b)
add_two:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]
    add eax, [ebp + 12]
    mov esp, ebp
    pop ebp
    ret

; int add_three(unsigned a, unsigned b, unsigned c)
add_three:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]
    add eax, [ebp + 12]
    add eax, [ebp + 16]
    mov esp, ebp
    pop ebp
    ret

; int add_four(unsigned a, unsigned b, unsigned c, unsigned d)
add_four:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]
    add eax, [ebp + 12]
    add eax, [ebp + 16]
    add eax, [ebp + 20]
    mov esp, ebp
    pop ebp
    ret

show_result:
    push eax
    PRINT result_msg, result_len
    pop eax
    push eax
    call print_uint
    add esp, 4
    PRINT newline, 1
    ret

; Print unsigned integer passed at [ebp+8].
print_uint:
    push ebp
    mov ebp, esp
    push ebx
    push ecx
    push edx
    push edi

    mov eax, [ebp + 8]
    mov edi, number_buf + 15
    mov byte [edi], 0
    mov ebx, 10
    xor ecx, ecx

    test eax, eax
    jnz .convert
    dec edi
    mov byte [edi], '0'
    inc ecx
    jmp .write

.convert:
    xor edx, edx
    div ebx
    add dl, '0'
    dec edi
    mov [edi], dl
    inc ecx
    test eax, eax
    jnz .convert

.write:
    mov eax, 4
    mov ebx, 1
    mov edx, ecx
    mov ecx, edi
    int 0x80

    pop edi
    pop edx
    pop ecx
    pop ebx
    mov esp, ebp
    pop ebp
    ret
