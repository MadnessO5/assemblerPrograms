%include "kernel.inc"

global putstr
extern strlen

section .text
putstr:
    push ebp
    mov ebp, esp

    push dword [ebp+8]
    call strlen
    add esp, 4

    kernel 4, 1, [ebp+8], eax

    mov esp, ebp
    pop ebp
    ret
