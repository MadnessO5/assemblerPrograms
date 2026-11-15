; double calc_divide(double left, double right)
BITS 32
GLOBAL calc_divide
SECTION .text
calc_divide:
    push ebp
    mov ebp, esp
    fld qword [ebp + 8]
    fdiv qword [ebp + 16]
    pop ebp
    ret
