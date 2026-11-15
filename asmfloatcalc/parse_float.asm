; Parse a decimal number with at most three integer and two fractional digits.
; int parse_float(const char *text): EAX = value scaled by 100, EDX = status.
; EDX is 0 on success and 1 on invalid input.
BITS 32
GLOBAL parse_float

SECTION .text
parse_float:
    push ebp
    mov ebp, esp
    sub esp, 12
    push ebx
    push esi
    push edi

    mov esi, [ebp + 8]
    mov ebx, 1                  ; Sign.
    xor edi, edi                ; Integer part.
    xor ecx, ecx                ; Fraction part.
    mov dword [ebp - 4], 0      ; Decimal point seen.
    mov dword [ebp - 8], 0      ; Fraction digit count.
    mov dword [ebp - 12], 0     ; Total digit count.

    cmp byte [esi], '-'
    jne .check_plus
    mov ebx, -1
    inc esi
    jmp .parse_loop
.check_plus:
    cmp byte [esi], '+'
    jne .parse_loop
    inc esi

.parse_loop:
    movzx eax, byte [esi]
    test al, al
    jz .parse_end
    cmp al, '.'
    je .decimal_point
    cmp al, '0'
    jb .invalid
    cmp al, '9'
    ja .invalid
    sub eax, '0'
    inc dword [ebp - 12]

    cmp dword [ebp - 4], 1
    je .fraction_digit
    imul edi, edi, 10
    add edi, eax
    cmp edi, 999
    ja .invalid
    jmp .next_char

.fraction_digit:
    cmp dword [ebp - 8], 2
    jae .invalid
    imul ecx, ecx, 10
    add ecx, eax
    inc dword [ebp - 8]
    jmp .next_char

.decimal_point:
    cmp dword [ebp - 4], 1
    je .invalid
    mov dword [ebp - 4], 1

.next_char:
    inc esi
    jmp .parse_loop

.parse_end:
    cmp dword [ebp - 12], 0
    je .invalid
    cmp dword [ebp - 4], 1
    jne .make_value
    cmp dword [ebp - 8], 0
    je .invalid

.make_value:
    cmp dword [ebp - 8], 1
    jne .fraction_ready
    imul ecx, ecx, 10
.fraction_ready:
    imul edi, edi, 100
    add edi, ecx
    imul edi, ebx
    mov eax, edi
    xor edx, edx
    jmp .finish

.invalid:
    xor eax, eax
    mov edx, 1

.finish:
    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret
