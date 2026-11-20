; Console input/output routines.
BITS 32

global print_string
global read_line

section .bss
    input_char resb 1

section .text
; print_string(const char *text)
print_string:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    mov esi, [ebp+8]
    xor edx, edx
.count:
    cmp byte [esi+edx], 0
    je .write
    inc edx
    jmp .count
.write:
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    int 0x80
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret

; read_line(char *buffer, unsigned int capacity)
; Returns the number of bytes read in EAX.
read_line:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi
    sub esp, 4

    mov esi, [ebp+8]
    mov edi, [ebp+12]
    mov dword [ebp-16], 0
    test edi, edi
    jz .finish
    dec edi
.read_next:
    mov eax, [ebp-16]
    cmp eax, edi
    jae .finish

    mov eax, 3
    xor ebx, ebx
    mov ecx, input_char
    mov edx, 1
    int 0x80
    cmp eax, 1
    jne .finish

    mov al, [input_char]
    cmp al, 10
    je .finish
    cmp al, 13
    je .read_next

    mov edx, [ebp-16]
    mov [esi+edx], al
    inc dword [ebp-16]
    jmp .read_next
.finish:
    mov edx, [ebp-16]
    mov byte [esi+edx], 0
    mov eax, edx
    add esp, 4
    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret
