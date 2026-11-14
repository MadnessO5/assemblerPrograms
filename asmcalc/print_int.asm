global print_int
extern putstr

section .text
; print_int(number)
; Prints a signed 32-bit integer followed by no newline.
print_int:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi
    sub esp, 16

    lea edi, [ebp-13]
    mov byte [edi], 0

    mov eax, [ebp+8]
    xor esi, esi
    test eax, eax
    jns .convert
    neg eax
    mov esi, 1

.convert:
    mov ebx, 10

.digit:
    xor edx, edx
    div ebx
    add dl, '0'
    dec edi
    mov [edi], dl
    test eax, eax
    jnz .digit

    test esi, esi
    jz .print
    dec edi
    mov byte [edi], '-'

.print:
    push edi
    call putstr
    add esp, 4

    lea esp, [ebp-12]
    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret
