%include "stud_io.inc"

section .data
    msg_sx  db "MOVSX (-5): "
    len_sx  equ $ - msg_sx
    msg_zx  db "MOVZX (250): "
    len_zx  equ $ - msg_zx
    msg_xch db "XCHG EAX: "
    len_xch equ $ - msg_xch
    msg_bsw db "BSWAP: "
    len_bsw equ $ - msg_bsw
    msg_cf  db "CF after STC: "
    len_cf  equ $ - msg_cf
    newline db 10
    hex_digits db "0123456789ABCDEF"

section .bss
    buffer resb 12

section .text
    global _start

_start:
    ; Demonstrate signed extension.
    mov eax, 4
    mov al, -5
    movsx eax, al
    push eax
    mov ebx, 1
    mov ecx, msg_sx
    mov edx, len_sx
    call write_text
    pop eax
    call print_int
    call print_newline

    ; Demonstrate zero extension.
    mov al, 250
    movzx eax, al
    push eax
    mov ebx, 1
    mov ecx, msg_zx
    mov edx, len_zx
    call write_text
    pop eax
    call print_int
    call print_newline

    ; Exchange register values.
    mov eax, 10
    mov ebx, 20
    xchg eax, ebx
    push eax
    mov ebx, 1
    mov ecx, msg_xch
    mov edx, len_xch
    call write_text
    pop eax
    call print_int
    call print_newline

    ; Reverse the byte order.
    mov eax, 0x12345678
    bswap eax
    push eax
    mov ebx, 1
    mov ecx, msg_bsw
    mov edx, len_bsw
    call write_text
    pop eax
    call print_hex
    call print_newline

    ; Read the carry flag.
    stc
    lahf
    and ah, 1
    movzx eax, ah
    push eax
    mov ebx, 1
    mov ecx, msg_cf
    mov edx, len_cf
    call write_text
    pop eax
    call print_int
    call print_newline

    clc
    nop

    mov eax, 1
    xor ebx, ebx
    int 0x80

write_text:
    push eax
    mov eax, 4
    int 0x80
    pop eax
    ret

print_newline:
    push eax
    push ebx
    push ecx
    push edx
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; Print a signed integer from EAX.
print_int:
    push eax
    push ebx
    push ecx
    push edx
    push esi

    mov esi, buffer + 11
    mov byte [esi], 0
    mov ebx, 10
    xor ecx, ecx

    test eax, eax
    jns .convert
    neg eax
    mov ecx, 1

.convert:
    xor edx, edx
    div ebx
    add dl, '0'
    dec esi
    mov [esi], dl
    test eax, eax
    jnz .convert

    test ecx, ecx
    jz .output
    dec esi
    mov byte [esi], '-'

.output:
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    mov edx, buffer + 12
    sub edx, esi
    int 0x80

    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; Print EAX as eight hexadecimal digits.
print_hex:
    push eax
    push ebx
    push ecx
    push edx
    push esi

    mov esi, eax
    mov ecx, 8

.hex_loop:
    rol esi, 4
    mov ebx, esi
    and ebx, 15
    mov dl, [hex_digits + ebx]
    mov [buffer], dl

    push ecx
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 0x80
    pop ecx

    loop .hex_loop

    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
