; copy.asm
; Copy a file using Linux i386 system calls.
; Usage: ./copy source_file destination_file

%macro kernel 4
    mov eax, %1
    mov ebx, %2
    mov ecx, %3
    mov edx, %4
    int 0x80

    ; Convert Linux negative errno results to EAX = -1, ECX = errno.
    cmp eax, -4095
    jae %%error
    xor ecx, ecx
    jmp %%done

%%error:
    neg eax
    mov ecx, eax
    mov eax, -1

%%done:
%endmacro

section .data
    usage_msg db "Usage: copy source_file destination_file", 10
    usage_len equ $ - usage_msg

    source_error db "Couldn't open source file for reading", 10
    source_error_len equ $ - source_error

    dest_error db "Couldn't open destination file for writing", 10
    dest_error_len equ $ - dest_error

    write_error db "Couldn't write to destination file", 10
    write_error_len equ $ - write_error

section .bss
    buffer resb 4096
    source_fd resd 1
    dest_fd resd 1
    source_path resd 1
    dest_path resd 1

section .text
global _start

_start:
    ; Require the program name and two file names.
    cmp dword [esp], 3
    jne .usage

    ; Save pointers to argv[1] and argv[2].
    mov eax, [esp + 8]
    mov [source_path], eax
    mov eax, [esp + 12]
    mov [dest_path], eax

    ; Open the source file: O_RDONLY = 0.
    kernel 5, [source_path], 0, 0
    cmp eax, -1
    je .source_open_failed
    mov [source_fd], eax

    ; Open/create destination: O_WRONLY | O_CREAT | O_TRUNC.
    ; File mode 0666 (octal).
    kernel 5, [dest_path], 0x241, 0666q
    cmp eax, -1
    je .dest_open_failed
    mov [dest_fd], eax

.copy_loop:
    ; Read up to 4096 bytes from the source.
    kernel 3, [source_fd], buffer, 4096
    cmp eax, 0
    jle .finish

    ; Write the bytes that were read.
    mov esi, eax
    kernel 4, [dest_fd], buffer, esi
    cmp eax, -1
    je .write_failed

    jmp .copy_loop

.finish:
    ; Close both files and exit successfully.
    kernel 6, [source_fd], 0, 0
    kernel 6, [dest_fd], 0, 0
    kernel 1, 0, 0, 0

.usage:
    kernel 4, 2, usage_msg, usage_len
    kernel 1, 1, 0, 0

.source_open_failed:
    kernel 4, 2, source_error, source_error_len
    kernel 1, 1, 0, 0

.dest_open_failed:
    kernel 6, [source_fd], 0, 0
    kernel 4, 2, dest_error, dest_error_len
    kernel 1, 1, 0, 0

.write_failed:
    kernel 4, 2, write_error, write_error_len
    kernel 6, [source_fd], 0, 0
    kernel 6, [dest_fd], 0, 0
    kernel 1, 1, 0, 0
