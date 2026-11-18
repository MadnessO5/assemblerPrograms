BITS 32
GLOBAL read_line
GLOBAL write_string
GLOBAL print_uint

SECTION .bss
number_buffer resb 16

SECTION .text
; read_line(char *buffer, unsigned capacity)
; Returns the number of characters read in EAX.
read_line:
    push ebp
    mov ebp, esp
    sub esp, 8
    push ebx
    push esi
    push edi
    mov esi, [ebp + 8]
    mov edi, [ebp + 12]
    mov dword [ebp - 4], 0
    cmp edi, 1
    jbe .finish
.read_char:
    mov eax, 3              ; sys_read
    xor ebx, ebx            ; stdin
    lea ecx, [ebp - 8]
    mov edx, 1
    int 0x80
    cmp eax, 1
    jne .finish
    mov al, [ebp - 8]
    cmp al, 10
    je .finish
    mov edx, [ebp - 4]
    mov [esi + edx], al
    inc edx
    mov [ebp - 4], edx
    mov eax, edi
    dec eax
    cmp edx, eax
    jb .read_char
.finish:
    mov edx, [ebp - 4]
    mov byte [esi + edx], 0
    mov eax, edx
    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret

; write_string(const char *text)
write_string:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    mov esi, [ebp + 8]
    xor edx, edx
.count:
    cmp byte [esi + edx], 0
    je .write
    inc edx
    jmp .count
.write:
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, esi
    int 0x80
    pop esi
    pop ebx
    pop ebp
    ret

; print_uint(unsigned value)
print_uint:
    push ebp
    mov ebp, esp
    sub esp, 4
    push ebx
    push esi
    mov eax, [ebp + 8]
    mov ebx, 10
    lea esi, [number_buffer + 15]
    mov byte [esi], 10
    mov dword [ebp - 4], 1
    test eax, eax
    jnz .convert
    dec esi
    mov byte [esi], '0'
    inc dword [ebp - 4]
    jmp .output
.convert:
    xor edx, edx
    div ebx
    add dl, '0'
    dec esi
    mov [esi], dl
    inc dword [ebp - 4]
    test eax, eax
    jnz .convert
.output:
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    mov edx, [ebp - 4]
    int 0x80
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret
