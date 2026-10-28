; Reusable macros for the calculator.

; Define Linux system call constants.
%define SYS_READ 3
%define SYS_WRITE 4
%define SYS_EXIT 1
%define STDIN 0
%define STDOUT 1

; Print a string.
%macro PRINT 2
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

; Print a newline.
%macro NEWLINE 0
    PRINT newline, newline_len
%endmacro

; Add two values.
%macro ADD_VALUES 2
    mov eax, %1
    add eax, %2
%endmacro

; Repeat a separator at assembly time.
%macro SEPARATOR 0
    %rep 2
        db "========================================", 10
    %endrep
%endmacro

; Remove a temporary definition.
%define TEMP_VALUE 123
%undef TEMP_VALUE

