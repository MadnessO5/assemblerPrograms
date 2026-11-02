; Local macro labels laboratory.
; Demonstrates %%local labels and macro parameters.
; Build: nrun local_macro_lab.asm

%macro count_up 2
    ; Preserve the registers used by this macro.
    push eax
    push ecx

    mov eax, %1
    mov ecx, %2

%%loop:
    inc eax
    loop %%loop

    ; Restore the original register values.
    pop ecx
    pop eax
%endmacro

%macro print_text 2
    ; Write a string to standard output.
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

section .data
    title db "Local macro labels demo", 10
    title_len equ $ - title

    info db "Two macro calls use their own local loop labels.", 10
    info_len equ $ - info

    done db "Finished without duplicate-label errors.", 10
    done_len equ $ - done

section .text
    global _start

_start:
    ; Print the title and explanation.
    print_text title, title_len
    print_text info, info_len

    ; Call the macro twice. Each expansion has a unique %%loop label.
    mov eax, 7
    mov ecx, 9
    count_up 0, 3
    count_up 0, 2

    ; Print a completion message.
    print_text done, done_len

    ; Exit successfully.
    mov eax, 1
    xor ebx, ebx
    int 0x80
