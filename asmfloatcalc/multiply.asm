; double calc_multiply(double left, double right)
BITS 32
GLOBAL calc_multiply
SECTION .text
calc_multiply:
    push ebp
    mov ebp, esp
    fld qword [ebp + 8]
    fmul qword [ebp + 16]
    pop ebp
    ret
