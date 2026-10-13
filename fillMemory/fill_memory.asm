%include "stud_io.inc"

section .data
    message db "Filled memory: "
    message_len equ $ - message

section .bss
    buffer resb 20

section .text
    global _start

_start:
    ; Fill the buffer with '@'.
    mov edi, buffer
    mov ecx, 20
    mov al, '@'
    call fill_memory

    ; Print the message.
    _syscall_write 1, message, message_len

    ; Print the filled buffer.
    mov esi, buffer
    mov ecx, 20

.print:
    mov al, [esi]
    PUTCHAR al
    inc esi
    loop .print

    mov al, 10
    PUTCHAR al
    FINISH 0

; Fill memory (EDI=address, ECX=length, AL=value).
fill_memory:
    jecxz .done

.loop:
    mov [edi], al
    inc edi
    loop .loop

.done:
    ret
