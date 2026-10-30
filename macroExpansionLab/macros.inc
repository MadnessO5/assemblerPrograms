; Reusable macros for Linux system calls.

%define SYS_WRITE 4
%define SYS_EXIT 1
%define STDOUT 1

; Print a string.
%macro PRINT 2
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

; Exit the program.
%macro EXIT 0
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80
%endmacro
