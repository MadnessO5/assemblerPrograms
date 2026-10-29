; Reusable macros for procedure calls and stack access.

; Call a procedure with zero arguments.
%macro pcall0 1
    call %1
%endmacro

; Call a procedure with one argument.
%macro pcall1 2
    push %2
    call %1
    add esp, 4
%endmacro

; Call a procedure with two arguments.
%macro pcall2 3
    push %3
    push %2
    call %1
    add esp, 8
%endmacro

; Call a procedure with three arguments.
%macro pcall3 4
    push %4
    push %3
    push %2
    call %1
    add esp, 12
%endmacro

; Access procedure arguments.
%define arg(n) ebp+(4*n)+4

; Access local variables.
%define local(n) ebp-(4*n)
