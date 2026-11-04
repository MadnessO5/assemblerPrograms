; Interactive practice for NASM %strlen and %substr.
; Build: nrun string_directives.asm

%strlen HELLO_LEN 'Hello NASM'
%substr HELLO_FIRST 'Hello NASM', 1
%substr HELLO_SECOND 'Hello NASM', 2

%strlen ARCH_LEN 'Arch Linux'
%substr ARCH_FIRST 'Arch Linux', 1
%substr ARCH_SECOND 'Arch Linux', 2

%strlen MACRO_LEN 'Macro magic'
%substr MACRO_FIRST 'Macro magic', 1
%substr MACRO_SECOND 'Macro magic', 2

%macro PRINT 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

section .data
    title db 10, 'interactiveStringDirectives', 10
    title_len equ $ - title
    menu db 10, 'Choose a string:', 10
         db '1. Hello NASM', 10
         db '2. Arch Linux', 10
         db '3. Macro magic', 10
         db '0. Exit', 10
         db '> '
    menu_len equ $ - menu
    prompt db 'Character position (1-based): '
    prompt_len equ $ - prompt
    text_label db 'String: '
    text_label_len equ $ - text_label
    len_label db 'Length from %strlen: '
    len_label_len equ $ - len_label
    first_label db 'First character from %substr: '
    first_label_len equ $ - first_label
    second_label db 'Second character from %substr: '
    second_label_len equ $ - second_label
    char_label db 'Character at that position: '
    char_label_len equ $ - char_label
    bad_choice db 'Invalid choice.', 10
    bad_choice_len equ $ - bad_choice
    bad_pos db 'Position is outside the string.', 10
    bad_pos_len equ $ - bad_pos
    bad_num db 'Enter a positive decimal number.', 10
    bad_num_len equ $ - bad_num
    nl db 10

    str1 db 'Hello NASM'
    str2 db 'Arch Linux'
    str3 db 'Macro magic'
    lengths dd HELLO_LEN, ARCH_LEN, MACRO_LEN
    pointers dd str1, str2, str3
    first_chars db HELLO_FIRST, ARCH_FIRST, MACRO_FIRST
    second_chars db HELLO_SECOND, ARCH_SECOND, MACRO_SECOND

section .bss
    input resb 32
    number_buf resb 16
    selected_ptr resd 1
    selected_len resd 1
    selected_idx resd 1

section .text
global _start

_start:
    PRINT title, title_len
.menu:
    PRINT menu, menu_len
    call read_line
    test eax, eax
    jle .exit
    call parse_number
    cmp eax, 0
    je .exit
    cmp eax, 1
    jb .choice_error
    cmp eax, 3
    ja .choice_error
    dec eax
    mov [selected_idx], eax
    mov ebx, eax
    mov eax, [lengths + ebx*4]
    mov [selected_len], eax
    mov eax, [pointers + ebx*4]
    mov [selected_ptr], eax

    PRINT text_label, text_label_len
    mov eax, 4
    mov ebx, 1
    mov ecx, [selected_ptr]
    mov edx, [selected_len]
    int 0x80
    PRINT nl, 1

    PRINT len_label, len_label_len
    mov eax, [selected_len]
    call print_uint
    PRINT nl, 1

    PRINT first_label, first_label_len
    mov ebx, [selected_idx]
    mov al, [first_chars + ebx]
    call print_char
    PRINT nl, 1

    PRINT second_label, second_label_len
    mov ebx, [selected_idx]
    mov al, [second_chars + ebx]
    call print_char
    PRINT nl, 1

    PRINT prompt, prompt_len
    call read_line
    test eax, eax
    jle .menu
    call parse_number
    cmp eax, -1
    je .number_error
    test eax, eax
    jz .number_error
    cmp eax, [selected_len]
    ja .position_error
    dec eax
    push eax
    PRINT char_label, char_label_len
    pop eax
    mov esi, [selected_ptr]
    mov al, [esi + eax]
    call print_char
    PRINT nl, 1
    jmp .menu

.choice_error:
    PRINT bad_choice, bad_choice_len
    jmp .menu
.position_error:
    PRINT bad_pos, bad_pos_len
    jmp .menu
.number_error:
    PRINT bad_num, bad_num_len
    jmp .menu
.exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

read_line:
    mov eax, 3
    xor ebx, ebx
    mov ecx, input
    mov edx, 31
    int 0x80
    ret

; Parse unsigned decimal digits. Return -1 if invalid.
parse_number:
    push ebx
    push ecx
    push edx
    push esi
    mov esi, input
    xor eax, eax
    xor ecx, ecx
.parse:
    mov bl, [esi]
    cmp bl, '0'
    jb .end
    cmp bl, '9'
    ja .end
    imul eax, eax, 10
    jo .invalid
    movzx edx, bl
    sub edx, '0'
    add eax, edx
    jo .invalid
    inc esi
    inc ecx
    jmp .parse
.end:
    test ecx, ecx
    jz .invalid
    cmp bl, 10
    je .valid
    cmp bl, 13
    je .valid
    cmp bl, 0
    je .valid
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

; Print the character in AL.
print_char:
    push eax
    push ebx
    push ecx
    push edx
    mov [input + 31], al
    mov eax, 4
    mov ebx, 1
    mov ecx, input + 31
    mov edx, 1
    int 0x80
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; Print unsigned EAX as decimal.
print_uint:
    push eax
    push ebx
    push ecx
    push edx
    push edi
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
    pop eax
    ret
