; Conditional assembly laboratory.
; Build with: nasm -f elf conditional_assembly.asm -o conditional_assembly.o
; Link with: ld -m elf_i386 conditional_assembly.o -o conditional_assembly
; Debug build: nasm -DDEBUG_PRINT -f elf conditional_assembly.asm -o conditional_assembly.o

%ifdef DEBUG_PRINT
%warning "DEBUG_PRINT is enabled"
%define BUILD_MODE 1
%else
%define BUILD_MODE 0
%endif

%if BUILD_MODE = 1
%define MODE_TEXT "Debug build enabled", 10
%elif BUILD_MODE = 0
%define MODE_TEXT "Normal build", 10
%else
%error "Unsupported build mode"
%endif

section .data
    mode_message db MODE_TEXT
    mode_length equ $ - mode_message

%ifdef SHOW_EXTRA
    extra_message db "Extra message enabled", 10
    extra_length equ $ - extra_message
%endif

section .text
    global _start

_start:
    ; Print the selected build mode.
    mov eax, 4
    mov ebx, 1
    mov ecx, mode_message
    mov edx, mode_length
    int 0x80

%ifdef SHOW_EXTRA
    ; Print the optional message.
    mov eax, 4
    mov ebx, 1
    mov ecx, extra_message
    mov edx, extra_length
    int 0x80
%endif

%ifndef NO_FAREWELL
    ; Print a final message unless disabled.
    mov eax, 4
    mov ebx, 1
    mov ecx, farewell_message
    mov edx, farewell_length
    int 0x80
%endif

    ; Exit the program.
    mov eax, 1
    xor ebx, ebx
    int 0x80

section .data
farewell_message db "Conditional assembly complete.", 10
farewell_length equ $ - farewell_message
