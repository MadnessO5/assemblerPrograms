%include "stud_io.inc"

section .data
    source  dd 10, 20, 30, 40, 50
    count   equ 5

    msg_copy db "Copied array: "
    len_copy equ $ - msg_copy
    msg_sum  db "Sum: "
    len_sum  equ $ - msg_sum

section .bss
    dest resd count

section .text
    global _start

_start:
    ; Copy the array using REP MOVSD.
    cld
    mov esi, source
    mov edi, dest
    mov ecx, count
    rep movsd

    ; Increase every element and calculate the sum.
    mov esi, dest
    mov ecx, count
    xor ebx, ebx

.process:
    lodsd
    inc eax
    mov [esi - 4], eax
    add ebx, eax
    loop .process

    ; Print the modified array.
    _syscall_write 1, msg_copy, len_copy
    mov esi, dest
    mov ecx, count

.print:
    lodsd
    call print_int
    mov al, ' '
    PUTCHAR al
    loop .print

    mov al, 10
    PUTCHAR al

    ; Print the sum.
    _syscall_write 1, msg_sum, len_sum
    mov eax, ebx
    call print_int
    mov al, 10
    PUTCHAR al

    FINISH 0

print_int:
    push ebx
    push ecx
    push edx
    xor ecx, ecx
    mov ebx, 10

.convert:
    xor edx, edx
    div ebx
    push edx
    inc ecx
    test eax, eax
    jnz .convert

.output:
    pop eax
    add al, '0'
    PUTCHAR al
    loop .output

    pop edx
    pop ecx
    pop ebx
    ret
