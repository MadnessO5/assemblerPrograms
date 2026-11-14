global add_int
global sub_int
global mul_int
global div_int

section .text
add_int:
    push ebp
    mov ebp, esp
    mov eax, [ebp+8]
    add eax, [ebp+12]
    pop ebp
    ret

sub_int:
    push ebp
    mov ebp, esp
    mov eax, [ebp+8]
    sub eax, [ebp+12]
    pop ebp
    ret

mul_int:
    push ebp
    mov ebp, esp
    mov eax, [ebp+8]
    imul eax, [ebp+12]
    pop ebp
    ret

div_int:
    push ebp
    mov ebp, esp
    mov eax, [ebp+8]
    cdq
    idiv dword [ebp+12]
    pop ebp
    ret
