%include "stud_io.inc"

global _start

section .bss
    num1 resd 1
    num2 resd 1
    op   resb 1

section .text

_start:
    PUTCHAR '1'
    PUTCHAR ':'
    PUTCHAR ' '
    call read_int
    mov [num1], eax

    PUTCHAR '2'
    PUTCHAR ':'
    PUTCHAR ' '
    call read_int
    mov [num2], eax

    PUTCHAR '*'
    PUTCHAR '/'
    PUTCHAR ':'
    PUTCHAR ' '

    GETCHAR
    mov [op], al
    GETCHAR

    mov eax, [num1]
    mov ebx, [num2]

    cmp byte [op], '*'
    je multiply

    cmp byte [op], '/'
    je divide

    FINISH 0

multiply:
    imul ebx
    call print_int
    PUTCHAR 10
    FINISH 0

divide:
    test ebx, ebx
    jz error

    cdq
    idiv ebx
    call print_int
    PUTCHAR 10
    FINISH 0

error:
    PUTCHAR 'E'
    PUTCHAR 'r'
    PUTCHAR 'r'
    PUTCHAR 'o'
    PUTCHAR 'r'
    PUTCHAR 10
    FINISH 0


read_int:
    xor esi, esi

.read:
    GETCHAR

    cmp al, 10
    je .done

    sub al, '0'
    movzx edx, al

    imul esi, 10
    add esi, edx

    jmp .read

.done:
    mov eax, esi
    ret


print_int:
    test eax, eax
    jns .positive

    PUTCHAR '-'
    neg eax

.positive:
    xor ecx, ecx
    mov ebx, 10

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
