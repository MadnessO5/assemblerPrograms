%include "stud_io.inc"

section .data
    string db "kitten", 0
    pattern db "k*en", 0

    message db "Match: "
    message_len equ $ - message
    newline db 10

section .text
    global _start

_start:
    ; Print the message.
    _syscall_write 1, message, message_len

    ; Call match(string, pattern).
    push dword pattern
    push dword string
    call match
    add esp, 8

    ; Print the result (0 or 1).
    add al, '0'
    PUTCHAR al

    ; Print a newline.
    _syscall_write 1, newline, 1
    FINISH 0

; Match a string against a pattern.
; [ebp+8]  = string address
; [ebp+12] = pattern address
; EAX = 1 if matched, otherwise 0
match:
    push ebp
    mov ebp, esp
    sub esp, 4

    push esi
    push edi

    mov esi, [ebp+8]
    mov edi, [ebp+12]

.again:
    ; Check whether the pattern has ended.
    cmp byte [edi], 0
    jne .not_end

    ; Both strings must end together.
    cmp byte [esi], 0
    jne .false
    jmp .true

.not_end:
    ; Check for the '*' wildcard.
    cmp byte [edi], '*'
    jne .not_star

    ; Try matching zero characters first.
    mov dword [ebp-4], 0

.star_loop:
    ; Recursive call with the pattern after '*'.
    mov eax, edi
    inc eax
    push eax

    ; Try the string at the current offset.
    mov eax, esi
    add eax, [ebp-4]
    push eax

    call match
    add esp, 8

    ; If the remainder matches, succeed.
    test eax, eax
    jnz .true

    ; Try consuming one more character.
    mov eax, [ebp-4]
    cmp byte [esi+eax], 0
    je .false

    inc dword [ebp-4]
    jmp .star_loop

.not_star:
    ; Check for the '?' wildcard.
    mov al, [edi]
    cmp al, '?'
    je .quest

    ; Ordinary characters must match.
    cmp al, [esi]
    jne .false
    jmp .goon

.quest:
    ; '?' requires one available character.
    cmp byte [esi], 0
    je .false

.goon:
    ; Advance both pointers.
    inc esi
    inc edi
    jmp .again

.true:
    mov eax, 1
    jmp .quit

.false:
    xor eax, eax

.quit:
    ; Restore registers and the stack frame.
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret

