BITS 32
GLOBAL count_file_stats

SECTION .bss
read_buffer resb 4096

SECTION .text
; count_file_stats(int fd, unsigned stats[3])
; stats[0] = bytes, stats[1] = LF characters, stats[2] = words.
; Returns 0 on success or -1 on read error.
count_file_stats:
    push ebp
    mov ebp, esp
    sub esp, 8
    push ebx
    push esi
    push edi

    mov dword [ebp - 4], 0  ; inside-word flag
    mov edi, [ebp + 12]
    mov dword [edi], 0
    mov dword [edi + 4], 0
    mov dword [edi + 8], 0

.read_chunk:
    mov eax, 3              ; sys_read
    mov ebx, [ebp + 8]
    mov ecx, read_buffer
    mov edx, 4096
    int 0x80
    test eax, eax
    js .error
    jz .success
    mov [ebp - 8], eax
    xor esi, esi

.process_byte:
    cmp esi, [ebp - 8]
    jae .read_chunk
    mov edi, [ebp + 12]
    inc dword [edi]         ; Count every byte.
    mov al, [read_buffer + esi]
    cmp al, 10
    jne .not_newline
    inc dword [edi + 4]
.not_newline:
    cmp al, ' '
    je .separator
    cmp al, 9
    je .separator
    cmp al, 10
    je .separator
    cmp al, 13
    je .separator
    cmp dword [ebp - 4], 0
    jne .next_byte
    inc dword [edi + 8]
    mov dword [ebp - 4], 1
    jmp .next_byte
.separator:
    mov dword [ebp - 4], 0
.next_byte:
    inc esi
    jmp .process_byte

.success:
    xor eax, eax
    jmp .done
.error:
    mov eax, -1
.done:
    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret
