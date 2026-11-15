; double calc_add(double left, double right)
BITS 32
GLOBAL calc_add
SECTION .text
calc_add:
    push ebp
    mov ebp, esp
    fld qword [ebp + 8]
    fadd qword [ebp + 16]
    pop ebp
    ret
