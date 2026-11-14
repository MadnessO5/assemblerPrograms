global strlen

section .text
strlen:
    push ebp
    mov ebp, esp

    xor eax, eax
    mov ecx, [ebp+8]

.loop:
    cmp byte [eax+ecx], 0
    je .done
    inc eax
    jmp short .loop

.done:
    pop ebp
    ret
