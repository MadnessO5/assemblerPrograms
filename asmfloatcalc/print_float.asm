; Print a double with two digits after the decimal point.
; void print_float(double value)
BITS 32
GLOBAL print_float
EXTERN write_string

SECTION .data
minus_sign db '-', 0
dot_text db '.', 0
newline_text db 10, 0
digit_table db '0123456789'

SECTION .bss
scaled_value resd 1
integer_part resd 1
fraction_part resd 1
fraction_text resb 3

SECTION .text
print_float:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi

    fld qword [ebp + 8]
    fimul dword [hundred_value]
    frndint
    fistp dword [scaled_value]

    mov eax, [scaled_value]
    test eax, eax
    jns .positive
    push eax
    push dword minus_sign
    call write_string
    add esp, 4
    pop eax
    neg eax
.positive:
    xor edx, edx
    mov ebx, 100
    div ebx
    mov [integer_part], eax
    mov [fraction_part], edx

    push dword [integer_part]
    call print_unsigned
    add esp, 4

    push dword dot_text
    call write_string
    add esp, 4

    mov eax, [fraction_part]
    xor edx, edx
    mov ebx, 10
    div ebx
    mov esi, digit_table
    mov al, [esi + eax]
    mov [fraction_text], al
    mov esi, digit_table
    mov al, [esi + edx]
    mov [fraction_text + 1], al
    mov byte [fraction_text + 2], 0

    push dword fraction_text
    call write_string
    add esp, 4
    push dword newline_text
    call write_string
    add esp, 4

    pop edi
    pop esi
    pop ebx
    pop ebp
    ret

; Print an unsigned integer passed on the stack.
print_unsigned:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi
    sub esp, 16

    mov eax, [ebp + 8]
    lea esi, [esp + 15]
    mov byte [esi], 0
    mov ebx, 10
.convert_loop:
    xor edx, edx
    div ebx
    add dl, '0'
    dec esi
    mov [esi], dl
    test eax, eax
    jnz .convert_loop

    lea edi, [esp + 15]
    sub edi, esi
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    mov edx, edi
    int 0x80

    add esp, 16
    pop edi
    pop esi
    pop ebx
    pop ebp
    ret

SECTION .rodata
hundred_value dd 100
