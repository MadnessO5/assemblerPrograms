; Basic console input and output routines for Linux i386.
BITS 32
GLOBAL read_line
GLOBAL write_string

SECTION .text

; int read_line(char *buffer, unsigned int capacity)
; Returns the number of bytes read, excluding the NUL terminator.
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
    jbe .read_done

.read_loop:
    mov eax, [ebp - 4]
    lea edx, [eax + 1]
    cmp edx, edi
    jae .read_done

    mov eax, 3
    xor ebx, ebx
    lea ecx, [ebp - 8]
    mov edx, 1
    int 0x80
    cmp eax, 1
    jne .read_done

    mov al, [ebp - 8]
    cmp al, 10
    je .read_done

    mov edx, [ebp - 4]
    mov [esi + edx], al
    inc dword [ebp - 4]
    jmp .read_loop

.read_done:
    mov edx, [ebp - 4]
    mov byte [esi + edx], 0
    mov eax, edx

    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret

; void write_string(const char *text)
write_string:
    push ebp
    mov ebp, esp
    push ebx
    push esi

    mov esi, [ebp + 8]
    xor edx, edx
.count_loop:
    cmp byte [esi + edx], 0
    je .write_now
    inc edx
    jmp .count_loop

.write_now:
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    int 0x80

    pop esi
    pop ebx
    pop ebp
    ret
