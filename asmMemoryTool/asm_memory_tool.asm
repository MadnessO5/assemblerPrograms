; asmMemoryTool - a small memory utility demonstration.
; Build and run with: nrun asm_memory_tool.asm
; This program uses 32-bit Linux system calls (int 0x80).

%macro print_text 2
    ; Print the string at %1 with length %2.
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

section .data
    title db "asmMemoryTool - memory utilities", 10
    title_len equ $ - title

    before_msg db "Original buffer: "
    before_len equ $ - before_msg

    after_fill_msg db "After fill_memory(0x2A): "
    after_fill_len equ $ - after_fill_msg

    after_zero_msg db "After zero_memory: "
    after_zero_len equ $ - after_zero_msg

    after_copy_msg db "Copied buffer: "
    after_copy_len equ $ - after_copy_msg

    newline db 10

section .bss
    source_buffer resb 8
    copied_buffer resb 8
    hex_buffer resb 3

section .text
    global _start

_start:
    print_text title, title_len

    ; Initialize the source buffer with bytes 1 through 8.
    mov byte [source_buffer + 0], 1
    mov byte [source_buffer + 1], 2
    mov byte [source_buffer + 2], 3
    mov byte [source_buffer + 3], 4
    mov byte [source_buffer + 4], 5
    mov byte [source_buffer + 5], 6
    mov byte [source_buffer + 6], 7
    mov byte [source_buffer + 7], 8

    print_text before_msg, before_len
    mov esi, source_buffer
    mov ecx, 8
    call print_hex_bytes

    ; Fill the source buffer with byte 0x2A.
    mov edi, source_buffer
    mov ecx, 8
    mov al, 0x2A
    call fill_memory

    print_text after_fill_msg, after_fill_len
    mov esi, source_buffer
    mov ecx, 8
    call print_hex_bytes

    ; Copy the filled source buffer to the destination buffer.
    mov esi, source_buffer
    mov edi, copied_buffer
    mov ecx, 8
    call copy_memory

    print_text after_copy_msg, after_copy_len
    mov esi, copied_buffer
    mov ecx, 8
    call print_hex_bytes

    ; Zero the original source buffer.
    mov edi, source_buffer
    mov ecx, 8
    call zero_memory

    print_text after_zero_msg, after_zero_len
    mov esi, source_buffer
    mov ecx, 8
    call print_hex_bytes

    ; Exit successfully.
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Fill ECX bytes at EDI with AL.
; Clobbers EDI and ECX; preserves EAX.
fill_memory:
    push eax
    push ecx
    push edi
    test ecx, ecx
    jz .fill_done
.fill_loop:
    mov [edi], al
    inc edi
    dec ecx
    jnz .fill_loop
.fill_done:
    pop edi
    pop ecx
    pop eax
    ret

; Set ECX bytes at EDI to zero.
; Clobbers EDI and ECX.
zero_memory:
    push eax
    push ecx
    push edi
    xor eax, eax
    test ecx, ecx
    jz .zero_done
.zero_loop:
    mov [edi], al
    inc edi
    dec ecx
    jnz .zero_loop
.zero_done:
    pop edi
    pop ecx
    pop eax
    ret

; Copy ECX bytes from ESI to EDI.
; This routine assumes source and destination do not overlap.
; Clobbers ESI, EDI, and ECX.
copy_memory:
    push ecx
    push esi
    push edi
    test ecx, ecx
    jz .copy_done
.copy_loop:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    jnz .copy_loop
.copy_done:
    pop edi
    pop esi
    pop ecx
    ret

; Print ECX bytes starting at ESI as two-digit hexadecimal bytes.
; Example: 0x2A is printed as "2A ".
; Clobbers EAX, EBX, ECX, EDX, ESI, EDI.
print_hex_bytes:
    push ebp
    mov ebp, esp
    push ecx
    push esi
    push edi

    mov edi, hex_buffer
.hex_loop:
    test ecx, ecx
    jz .hex_done

    mov al, [esi]
    mov ah, al
    shr al, 4
    and al, 0x0F
    call nibble_to_ascii
    mov [edi], al

    mov al, ah
    and al, 0x0F
    call nibble_to_ascii
    mov [edi + 1], al
    mov byte [edi + 2], ' '

    ; Write the three characters for this byte.
    push ecx
    push esi
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, 3
    int 0x80
    pop esi
    pop ecx

    inc esi
    dec ecx
    jmp .hex_loop

.hex_done:
    print_text newline, 1
    pop edi
    pop esi
    pop ecx
    mov esp, ebp
    pop ebp
    ret

; Convert AL (0..15) to its hexadecimal ASCII character.
; Returns the character in AL.
nibble_to_ascii:
    cmp al, 9
    jbe .digit
    add al, 'A' - 10
    ret
.digit:
    add al, '0'
    ret
