%include "stud_io.inc"

section .data
    msg_num db "Number: "
    len_num equ $ - msg_num

    msg_bit db "Bit (0-31): "
    len_bit equ $ - msg_bit

    msg_set db "Bit is set", 10
    len_set equ $ - msg_set

    msg_off db "Bit is not set", 10
    len_off equ $ - msg_off

    msg_res db "Result: "
    len_res equ $ - msg_res

section .text
    global _start

_start:
    _syscall_write 1, msg_num, len_num
    call read_int
    mov ebx, eax

    _syscall_write 1, msg_bit, len_bit
    call read_int
    mov ecx, eax

    ; Create bit mask.
    mov eax, 1
    shl eax, cl

    ; Check the bit.
    test ebx, eax
    jz .not_set

    _syscall_write 1, msg_set, len_set
    jmp .set_bit

.not_set:
    _syscall_write 1, msg_off, len_off

.set_bit:
    ; Set the bit.
    or ebx, eax

    _syscall_write 1, msg_res, len_res
    mov eax, ebx
    call print_int

    mov al, 10
    PUTCHAR al

    FINISH 0


read_int:
    xor eax, eax

.read:
    GETCHAR
    cmp al, 10
    je .done

    sub al, '0'
    movzx edx, al
    imul eax, 10
    add eax, edx
    jmp .read

.done:
    ret


print_int:
    mov ebx, 10
    xor ecx, ecx

.convert:
    xor edx, edx
    div ebx
    push edx
    inc ecx
    test eax, eax
    jnz .convert

.print:
    pop eax
    add al, '0'
    PUTCHAR al
    loop .print

    ret
