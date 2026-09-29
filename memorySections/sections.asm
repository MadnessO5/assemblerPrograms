; --------------------------------------------------------------------
; sections.asm
;
; Demonstrates .data, .bss, db and resb.
; --------------------------------------------------------------------

%include "stud_io.inc"

global _start

section .data
        message db "Hello from Assembly!", 10
        msg_len equ $ - message

section .bss
        buffer resb msg_len

section .text

_start:
        ; Copy message from .data to .bss
        mov     esi, message
        mov     edi, buffer
        mov     ecx, msg_len

copy:
        mov     al, [esi]
        mov     [edi], al
        inc     esi
        inc     edi
        loop    copy

        ; Print copied string
        mov     esi, buffer
        mov     ecx, msg_len

print:
        mov     al, [esi]
        PUTCHAR al
        inc     esi
        loop    print

        FINISH  0
