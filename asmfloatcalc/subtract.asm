; double calc_subtract(double left, double right)
BITS 32
GLOBAL calc_subtract
SECTION .text
calc_subtract:
    push ebp
    mov ebp, esp
    fld qword [ebp + 8]
    fsub qword [ebp + 16]
    pop ebp
    ret
