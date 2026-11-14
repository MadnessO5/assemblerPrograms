global parse_uint

section .text
; parse_uint(const char *text)
; Returns EAX = value, EDX = 0 on success or 1 on error.
; Accepted range: 0..9999.
parse_uint:
    push ebp
    mov ebp, esp
    push ebx
    push esi

    mov esi, [ebp+8]
    xor eax, eax
    xor ecx, ecx

.next_char:
    movzx ebx, byte [esi]
    test bl, bl
    jz .finish

    cmp bl, '0'
    jb .invalid
    cmp bl, '9'
    ja .invalid

    sub ebx, '0'
    imul eax, eax, 10
    add eax, ebx
    cmp eax, 9999
    ja .invalid

    inc esi
    inc ecx
    jmp .next_char

.finish:
    test ecx, ecx
    jz .invalid

    xor edx, edx
    jmp .return

.invalid:
    xor eax, eax
    mov edx, 1

.return:
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret
