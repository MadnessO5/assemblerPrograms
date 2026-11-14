global read_uint
extern putstr
extern getstr
extern parse_uint

section .bss
input_buffer resb 64

section .text
; read_uint(prompt)
; Prints prompt, reads a line and parses an unsigned integer.
; Returns EAX = value, EDX = 0 on success or 1 on error.
read_uint:
    push ebp
    mov ebp, esp

    push dword [ebp+8]
    call putstr
    add esp, 4

    push dword 64
    push dword input_buffer
    call getstr
    add esp, 8

    push dword input_buffer
    call parse_uint
    add esp, 4

    mov esp, ebp
    pop ebp
    ret
