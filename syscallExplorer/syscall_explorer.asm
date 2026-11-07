; Interactive Linux i386 system call explorer.
; Demonstrates sys_write, sys_read, getpid and getppid.

section .data
    menu db 10, "=== System Call Explorer ===", 10
         db "1. sys_write - print a message", 10
         db "2. sys_read  - enter text", 10
         db "3. getpid    - show this process ID", 10
         db "4. getppid   - show parent process ID", 10
         db "0. Exit", 10
         db "Choose: "
    menu_len equ $ - menu

    write_msg db "Hello from the Linux kernel via sys_write!", 10
    write_len equ $ - write_msg
    prompt db "Enter some text: "
    prompt_len equ $ - prompt
    received db "You entered: "
    received_len equ $ - received
    pid_msg db "Process ID: "
    pid_len equ $ - pid_msg
    ppid_msg db "Parent process ID: "
    ppid_len equ $ - ppid_msg
    newline db 10
    newline_len equ $ - newline
    invalid_msg db "Invalid choice.", 10
    invalid_len equ $ - invalid_msg
    goodbye db "Goodbye!", 10
    goodbye_len equ $ - goodbye

section .bss
    choice resb 4
    input_buf resb 128
    number_buf resb 12

section .text
    global _start

_start:
menu_loop:
    ; Display the menu.
    mov eax, 4
    mov ebx, 1
    mov ecx, menu
    mov edx, menu_len
    int 0x80

    ; Read the menu choice.
    mov eax, 3
    mov ebx, 0
    mov ecx, choice
    mov edx, 4
    int 0x80

    ; Check the first input character.
    mov al, [choice]
    cmp al, '1'
    je do_write
    cmp al, '2'
    je do_read
    cmp al, '3'
    je do_getpid
    cmp al, '4'
    je do_getppid
    cmp al, '0'
    je exit_program

    ; Handle invalid input.
    mov eax, 4
    mov ebx, 1
    mov ecx, invalid_msg
    mov edx, invalid_len
    int 0x80
    jmp menu_loop

do_write:
    ; Ask the kernel to write a message to standard output.
    mov eax, 4
    mov ebx, 1
    mov ecx, write_msg
    mov edx, write_len
    int 0x80
    jmp menu_loop

do_read:
    ; Display the input prompt.
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    ; Read up to 128 bytes from standard input.
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 128
    int 0x80
    mov esi, eax

    ; Display the received text.
    mov eax, 4
    mov ebx, 1
    mov ecx, received
    mov edx, received_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, input_buf
    mov edx, esi
    int 0x80
    jmp menu_loop

do_getpid:
    ; Linux i386 getpid system call number is 20.
    mov eax, 20
    int 0x80
    push eax
    mov eax, 4
    mov ebx, 1
    mov ecx, pid_msg
    mov edx, pid_len
    int 0x80
    pop eax
    call print_number
    jmp menu_loop

do_getppid:
    ; Linux i386 getppid system call number is 64.
    mov eax, 64
    int 0x80
    push eax
    mov eax, 4
    mov ebx, 1
    mov ecx, ppid_msg
    mov edx, ppid_len
    int 0x80
    pop eax
    call print_number
    jmp menu_loop

; Print the unsigned integer stored in EAX.
print_number:
    mov edi, number_buf + 12
    xor ecx, ecx
    mov ebx, 10
.convert:
    xor edx, edx
    div ebx
    add dl, '0'
    dec edi
    mov [edi], dl
    inc ecx
    test eax, eax
    jnz .convert

    ; Write the converted digits.
    mov eax, 4
    mov ebx, 1
    mov edx, ecx
    mov ecx, edi
    int 0x80

    ; Print a newline.
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, newline_len
    int 0x80
    ret

exit_program:
    ; Display the exit message.
    mov eax, 4
    mov ebx, 1
    mov ecx, goodbye
    mov edx, goodbye_len
    int 0x80

    ; Exit the program.
    mov eax, 1
    xor ebx, ebx
    int 0x80
