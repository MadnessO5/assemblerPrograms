; Demonstrate NASM macro expansion strategies.

%include "macros.inc"

; Demonstrate lazy expansion.
%define number 10
%define lazy_value number

; Demonstrate eager expansion.
%xdefine eager_value number

; Redefine the original macro.
%define number 20

; Demonstrate arithmetic macro variables.
%assign counter 5
%assign counter counter+3
%assign counter counter*2

; Select messages during assembly.
%if lazy_value = 20
    lazy_msg db "Lazy value: 20", 10
    lazy_len equ $ - lazy_msg
%else
    lazy_msg db "Lazy value: unexpected", 10
    lazy_len equ $ - lazy_msg
%endif

%if eager_value = 10
    eager_msg db "Eager value: 10", 10
    eager_len equ $ - eager_msg
%else
    eager_msg db "Eager value: unexpected", 10
    eager_len equ $ - eager_msg
%endif

%if counter = 16
    counter_msg db "Counter value: 16", 10
    counter_len equ $ - counter_msg
%else
    counter_msg db "Counter value: unexpected", 10
    counter_len equ $ - counter_msg
%endif

section .data
    title db "NASM MACRO EXPANSION LAB", 10
    title_len equ $ - title

    newline db 10
    newline_len equ $ - newline

section .text
    global _start

_start:
    PRINT title, title_len
    PRINT lazy_msg, lazy_len
    PRINT eager_msg, eager_len
    PRINT counter_msg, counter_len
    PRINT newline, newline_len

    EXIT
