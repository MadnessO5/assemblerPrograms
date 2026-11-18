; Interactive text file statistics tool.
; Build with NASM as 32-bit ELF on Linux.

BITS 32
GLOBAL _start
EXTERN read_line
EXTERN write_string
EXTERN print_uint
EXTERN count_file_stats

SECTION .data
welcome db 10, '=== Text Statistics ===', 10, 0
prompt db 'Enter file path (or q to quit): ', 0
open_error db 'Error: could not open that file.', 10, 0
read_error db 'Error: could not read the file.', 10, 0
bytes_label db 'Bytes: ', 0
lines_label db 'Lines: ', 0
words_label db 'Words: ', 0
newline db 10, 0

SECTION .bss
path resb 256
stats resd 3

SECTION .text
_start:
    push welcome
    call write_string
    add esp, 4

.loop:
    push prompt
    call write_string
    add esp, 4

    push dword 256
    push path
    call read_line
    add esp, 8

    cmp eax, 0
    je .loop

    cmp byte [path], 'q'
    jne .open_file
    cmp byte [path + 1], 0
    je .exit

.open_file:
    mov eax, 5              ; sys_open
    mov ebx, path
    xor ecx, ecx            ; O_RDONLY
    xor edx, edx
    int 0x80
    test eax, eax
    js .open_failed
    mov esi, eax            ; Save file descriptor.

    push stats
    push esi
    call count_file_stats
    add esp, 8
    mov edi, eax

    mov eax, 6              ; sys_close
    mov ebx, esi
    int 0x80

    cmp edi, 0
    jne .read_failed

    push bytes_label
    call write_string
    add esp, 4
    push dword [stats]
    call print_uint
    add esp, 4
    push newline
    call write_string
    add esp, 4

    push lines_label
    call write_string
    add esp, 4
    push dword [stats + 4]
    call print_uint
    add esp, 4
    push newline
    call write_string
    add esp, 4

    push words_label
    call write_string
    add esp, 4
    push dword [stats + 8]
    call print_uint
    add esp, 4
    push newline
    call write_string
    add esp, 4
    jmp .loop

.open_failed:
    push open_error
    call write_string
    add esp, 4
    jmp .loop

.read_failed:
    push read_error
    call write_string
    add esp, 4
    jmp .loop

.exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
