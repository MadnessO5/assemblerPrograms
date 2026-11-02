; Interactive asmMemoryTool.
; Build: nrun asm_memory_tool.asm
; Linux i386 syscalls, NASM ELF32.

%macro print_text 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

section .data
    title db 10, "asmMemoryTool - interactive memory utility", 10
    title_len equ $ - title
    menu db 10, "Choose an operation:", 10
         db "1. Fill buffer with a byte", 10
         db "2. Zero buffer", 10
         db "3. Copy buffer A to buffer B", 10
         db "4. Show both buffers (hex)", 10
         db "5. Compare buffers", 10
         db "0. Exit", 10
         db "> "
    menu_len equ $ - menu
    prompt_byte db "Byte value (decimal 0..255): "
    prompt_byte_len equ $ - prompt_byte
    msg_filled db "Buffer A filled.", 10
    msg_filled_len equ $ - msg_filled
    msg_zeroed db "Buffer A zeroed.", 10
    msg_zeroed_len equ $ - msg_zeroed
    msg_copied db "Buffer A copied to buffer B.", 10
    msg_copied_len equ $ - msg_copied
    msg_a db "Buffer A: "
    msg_a_len equ $ - msg_a
    msg_b db "Buffer B: "
    msg_b_len equ $ - msg_b
    msg_same db "Buffers are identical.", 10
    msg_same_len equ $ - msg_same
    msg_diff db "Buffers differ.", 10
    msg_diff_len equ $ - msg_diff
    msg_invalid db "Invalid input. Enter a menu digit 0..5.", 10
    msg_invalid_len equ $ - msg_invalid
    msg_bad_byte db "Invalid byte. Enter a decimal value 0..255.", 10
    msg_bad_byte_len equ $ - msg_bad_byte
    newline db 10

section .bss
    buffer_a resb 8
    buffer_b resb 8
    input_buf resb 32
    hex_buf resb 3
    number_buf resb 16

section .text
    global _start

_start:
    ; Initialize buffers with different recognizable values.
    mov byte [buffer_a + 0], 1
    mov byte [buffer_a + 1], 2
    mov byte [buffer_a + 2], 3
    mov byte [buffer_a + 3], 4
    mov byte [buffer_a + 4], 5
    mov byte [buffer_a + 5], 6
    mov byte [buffer_a + 6], 7
    mov byte [buffer_a + 7], 8

    mov byte [buffer_b + 0], 8
    mov byte [buffer_b + 1], 7
    mov byte [buffer_b + 2], 6
    mov byte [buffer_b + 3], 5
    mov byte [buffer_b + 4], 4
    mov byte [buffer_b + 5], 3
    mov byte [buffer_b + 6], 2
    mov byte [buffer_b + 7], 1

    print_text title, title_len

.menu_loop:
    print_text menu, menu_len
    call read_line
    test eax, eax
    jle .exit
    call parse_uint
    cmp eax, -1
    je .invalid_menu
    cmp eax, 0
    je .exit
    cmp eax, 1
    je .fill
    cmp eax, 2
    je .zero
    cmp eax, 3
    je .copy
    cmp eax, 4
    je .show
    cmp eax, 5
    je .compare
    jmp .invalid_menu

.fill:
    print_text prompt_byte, prompt_byte_len
    call read_line
    test eax, eax
    jle .menu_loop
    call parse_uint
    cmp eax, -1
    je .bad_byte
    cmp eax, 255
    ja .bad_byte
    mov edi, buffer_a
    mov ecx, 8
    mov bl, al
    call fill_memory
    print_text msg_filled, msg_filled_len
    jmp .menu_loop

.zero:
    mov edi, buffer_a
    mov ecx, 8
    call zero_memory
    print_text msg_zeroed, msg_zeroed_len
    jmp .menu_loop

.copy:
    mov esi, buffer_a
    mov edi, buffer_b
    mov ecx, 8
    call copy_memory
    print_text msg_copied, msg_copied_len
    jmp .menu_loop

.show:
    print_text msg_a, msg_a_len
    mov esi, buffer_a
    mov ecx, 8
    call print_hex_bytes
    print_text msg_b, msg_b_len
    mov esi, buffer_b
    mov ecx, 8
    call print_hex_bytes
    jmp .menu_loop

.compare:
    mov esi, buffer_a
    mov edi, buffer_b
    mov ecx, 8
    call compare_memory
    test eax, eax
    jz .identical
    print_text msg_diff, msg_diff_len
    jmp .menu_loop
.identical:
    print_text msg_same, msg_same_len
    jmp .menu_loop

.invalid_menu:
    print_text msg_invalid, msg_invalid_len
    jmp .menu_loop

.bad_byte:
    print_text msg_bad_byte, msg_bad_byte_len
    jmp .menu_loop

.exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Read one line from stdin into input_buf.
; Returns byte count in EAX. Reads at most 31 characters.
read_line:
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 31
    int 0x80
    ret

; Parse unsigned decimal integer from input_buf.
; Returns value in EAX, or -1 for invalid input.
; Supports digits and surrounding whitespace; rejects overflow.
parse_uint:
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov esi, input_buf
    xor eax, eax
    xor edi, edi
    mov ecx, 31

.skip_leading:
    mov bl, [esi]
    cmp bl, ' '
    je .advance_leading
    cmp bl, 9
    je .advance_leading
    cmp bl, 10
    je .advance_leading
    jmp .digits
.advance_leading:
    inc esi
    loop .skip_leading

.digits:
    xor ecx, ecx
.parse_loop:
    mov bl, [esi]
    cmp bl, '0'
    jb .check_end
    cmp bl, '9'
    ja .check_end
    imul eax, eax, 10
    jo .invalid
    movzx edx, bl
    sub edx, '0'
    add eax, edx
    jo .invalid
    inc esi
    inc ecx
    jmp .parse_loop

.check_end:
    test ecx, ecx
    jz .invalid
    cmp bl, 10
    je .valid
    cmp bl, 13
    je .valid
    cmp bl, ' '
    je .skip_trailing
    cmp bl, 9
    je .skip_trailing
    jmp .invalid
.skip_trailing:
    inc esi
    mov bl, [esi]
    cmp bl, 10
    je .valid
    cmp bl, 13
    je .valid
    cmp bl, ' '
    je .skip_trailing
    cmp bl, 9
    je .skip_trailing
    jmp .invalid
.valid:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
.invalid:
    mov eax, -1
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

; Fill ECX bytes at EDI with byte BL.
fill_memory:
    push eax
    push ecx
    push edi
    test ecx, ecx
    jz .fill_done
.fill_loop:
    mov [edi], bl
    inc edi
    dec ecx
    jnz .fill_loop
.fill_done:
    pop edi
    pop ecx
    pop eax
    ret

; Set ECX bytes at EDI to zero.
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

; Copy ECX bytes from ESI to EDI (buffers must not overlap).
copy_memory:
    push eax
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
    pop eax
    ret

; Compare ECX bytes at ESI and EDI. Returns EAX=0 if equal, 1 if not.
compare_memory:
    push ecx
    push esi
    push edi
    xor eax, eax
.compare_loop:
    test ecx, ecx
    jz .compare_done
    mov bl, [esi]
    cmp bl, [edi]
    jne .not_equal
    inc esi
    inc edi
    dec ecx
    jmp .compare_loop
.not_equal:
    mov eax, 1
.compare_done:
    pop edi
    pop esi
    pop ecx
    ret

; Print ECX bytes starting at ESI as hexadecimal byte pairs.
print_hex_bytes:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
.hex_loop:
    test ecx, ecx
    jz .hex_done
    mov al, [esi]
    mov ah, al
    shr al, 4
    and al, 0x0F
    call nibble_to_ascii
    mov edi, hex_buf
    mov [edi], al
    mov al, ah
    and al, 0x0F
    call nibble_to_ascii
    mov [edi + 1], al
    mov byte [edi + 2], ' '
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, 3
    int 0x80
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    push ebx
    push ecx
    push edx
    push esi
    push edi
    inc esi
    dec ecx
    jmp .hex_loop
.hex_done:
    print_text newline, 1
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; Convert AL (0..15) to a hexadecimal ASCII character.
nibble_to_ascii:
    cmp al, 9
    jbe .digit
    add al, 'A' - 10
    ret
.digit:
    add al, '0'
    ret
