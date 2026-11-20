; ASCII text-to-binary file encoder.
; encode_to_file(input, length, filename)
; Writes each input byte as eight '0'/'1' characters.
; Bytes are separated by spaces. Returns 0 on success, -1 on error.
BITS 32

global encode_to_file

section .bss
    output_buffer resb 2304

section .text
encode_to_file:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi
    sub esp, 4

    ; open(filename, O_WRONLY | O_CREAT | O_TRUNC, 0644)
    mov eax, 5
    mov ebx, [ebp+16]
    mov ecx, 577
    mov edx, 420
    int 0x80
    test eax, eax
    js .open_error
    mov [ebp-16], eax

    mov esi, [ebp+8]
    mov ecx, [ebp+12]
    mov ebx, output_buffer
.encode_byte:
    test ecx, ecx
    jz .finish_encoding
    movzx eax, byte [esi]
    mov edi, 7
.encode_bit:
    bt eax, edi
    jc .write_one
    mov byte [ebx], '0'
    jmp .next_bit
.write_one:
    mov byte [ebx], '1'
.next_bit:
    inc ebx
    dec edi
    jns .encode_bit
    mov byte [ebx], ' '
    inc ebx
    inc esi
    dec ecx
    jmp .encode_byte
.finish_encoding:
    cmp ebx, output_buffer
    je .empty_input
    dec ebx
    mov byte [ebx], 10
    inc ebx
    jmp .write_file
.empty_input:
    mov byte [ebx], 10
    inc ebx
.write_file:
    mov edx, ebx
    sub edx, output_buffer
    mov ecx, output_buffer
    mov ebx, [ebp-16]
    mov eax, 4
    int 0x80
    test eax, eax
    js .write_error
    mov ebx, [ebp-16]
    mov eax, 6
    int 0x80
    xor eax, eax
    jmp .return
.write_error:
    mov ebx, [ebp-16]
    mov eax, 6
    int 0x80
    mov eax, -1
    jmp .return
.open_error:
    mov eax, -1
.return:
    add esp, 4
    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret
