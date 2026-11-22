
; TextEncryptor - 64-bit NASM front end.
; OpenSSL operations are called through crypto.c.

default rel
global main

extern printf
extern fgets
extern strlen
extern stdin
extern encrypt_buffer_to_file
extern encrypt_file_to_file
extern decrypt_file_to_file

section .data
    menu db 10, "=== TEXT ENCRYPTOR ===", 10
         db "1. Encrypt text", 10
         db "2. Decrypt file", 10
         db "3. Encrypt file", 10
         db "4. Exit", 10
         db "Select: ", 0

    prompt_text db "Text: ", 0
    prompt_input db "Input file: ", 0
    prompt_output db "Output file: ", 0
    prompt_password db "Password: ", 0

    msg_success db "Operation completed successfully.", 10, 0
    msg_error db "Operation failed: wrong password, invalid file, or I/O error.", 10, 0
    msg_invalid db "Invalid menu option.", 10, 0

section .bss
    choice resb 32
    text_buffer resb 4096
    input_path resb 1024
    output_path resb 1024
    password resb 1024

section .text

main:
    push rbp
    mov rbp, rsp

menu_loop:
    lea rdi, [menu]
    xor eax, eax
    call printf

    lea rdi, [choice]
    mov esi, 32
    mov rdx, [rel stdin]
    call fgets

    test rax, rax
    jz main_exit

    lea rdi, [choice]
    call strip_newline

    lea rdi, [choice]
    call parse_choice

    cmp eax, 1
    je encrypt_text

    cmp eax, 2
    je decrypt_file

    cmp eax, 3
    je encrypt_file

    cmp eax, 4
    je main_exit

    lea rdi, [msg_invalid]
    xor eax, eax
    call printf
    jmp menu_loop

encrypt_text:
    lea rdi, [prompt_text]
    xor eax, eax
    call printf

    lea rdi, [text_buffer]
    mov esi, 4096
    mov rdx, [rel stdin]
    call fgets

    test rax, rax
    jz menu_loop

    lea rdi, [text_buffer]
    call strip_newline

    lea rdi, [prompt_output]
    xor eax, eax
    call printf

    lea rdi, [output_path]
    mov esi, 1024
    mov rdx, [rel stdin]
    call fgets

    test rax, rax
    jz menu_loop

    lea rdi, [output_path]
    call strip_newline

    call get_password
    test eax, eax
    jnz menu_loop

    lea rdi, [text_buffer]
    call strlen
    mov rsi, rax

    lea rdi, [text_buffer]
    lea rdx, [password]
    lea rcx, [output_path]

    call encrypt_buffer_to_file
    jmp show_result

decrypt_file:
    lea rdi, [prompt_input]
    xor eax, eax
    call printf

    lea rdi, [input_path]
    mov esi, 1024
    mov rdx, [rel stdin]
    call fgets

    test rax, rax
    jz menu_loop

    lea rdi, [input_path]
    call strip_newline

    lea rdi, [prompt_output]
    xor eax, eax
    call printf

    lea rdi, [output_path]
    mov esi, 1024
    mov rdx, [rel stdin]
    call fgets

    test rax, rax
    jz menu_loop

    lea rdi, [output_path]
    call strip_newline

    call get_password
    test eax, eax
    jnz menu_loop

    lea rdi, [input_path]
    lea rsi, [password]
    lea rdx, [output_path]

    call decrypt_file_to_file
    jmp show_result

encrypt_file:
    lea rdi, [prompt_input]
    xor eax, eax
    call printf

    lea rdi, [input_path]
    mov esi, 1024
    mov rdx, [rel stdin]
    call fgets

    test rax, rax
    jz menu_loop

    lea rdi, [input_path]
    call strip_newline

    lea rdi, [prompt_output]
    xor eax, eax
    call printf

    lea rdi, [output_path]
    mov esi, 1024
    mov rdx, [rel stdin]
    call fgets

    test rax, rax
    jz menu_loop

    lea rdi, [output_path]
    call strip_newline

    call get_password
    test eax, eax
    jnz menu_loop

    lea rdi, [input_path]
    lea rsi, [password]
    lea rdx, [output_path]

    call encrypt_file_to_file
    jmp show_result

show_result:
    test eax, eax
    jnz operation_error

    lea rdi, [msg_success]
    xor eax, eax
    call printf
    jmp menu_loop

operation_error:
    lea rdi, [msg_error]
    xor eax, eax
    call printf
    jmp menu_loop

; Read password from the terminal.
get_password:
    lea rdi, [prompt_password]
    xor eax, eax
    call printf

    lea rdi, [password]
    mov esi, 1024
    mov rdx, [rel stdin]
    call fgets

    test rax, rax
    jz password_failed

    lea rdi, [password]
    call strip_newline

    xor eax, eax
    ret

password_failed:
    mov eax, 1
    ret

; Remove the newline from a string.
strip_newline:
    xor eax, eax

strip_scan:
    mov dl, [rdi+rax]
    test dl, dl
    jz strip_done

    cmp dl, 10
    je strip_replace

    inc rax
    jmp strip_scan

strip_replace:
    mov byte [rdi+rax], 0

strip_done:
    ret

; Convert the first character to an integer.
parse_choice:
    xor eax, eax

    movzx ecx, byte [rdi]

    cmp ecx, '0'
    jb parse_done

    cmp ecx, '9'
    ja parse_done

    sub ecx, '0'
    mov eax, ecx

parse_done:
    ret

main_exit:
    xor eax, eax
    pop rbp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits

