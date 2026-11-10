global _start

section .text

nlstr db 10, 0

; Calculate string length.
; Argument: address of string.
; Result: EAX = string length.

strlen:
    push ebp
    mov ebp, esp

    xor eax, eax
    mov ecx, [ebp+8]

.loop:
    cmp byte [eax+ecx], 0
    je .done

    inc eax
    jmp .loop

.done:
    pop ebp
    ret


; Print a zero-terminated string.
; Argument: address of string.

print_str:
    push ebp
    mov ebp, esp

    push ebx

    mov ebx, [ebp+8]

    push ebx
    call strlen
    add esp, 4

    ; write(stdout, string, length)
    mov edx, eax
    mov ecx, ebx
    mov ebx, 1
    mov eax, 4
    int 80h

    pop ebx

    mov esp, ebp
    pop ebp
    ret


_start:
    ; Get argc.
    mov ebx, [esp]

    ; ESI points to argv[0].
    mov esi, esp
    add esi, 4

.print_loop:
    ; Print argv[i].
    push dword [esi]
    call print_str
    add esp, 4

    ; Print newline.
    push dword nlstr
    call print_str
    add esp, 4

    ; Move to next argument.
    add esi, 4
    dec ebx
    jnz .print_loop

    ; Exit successfully.
    mov eax, 1
    xor ebx, ebx
    int 80h

