global _start

%macro PRINT 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

section .data
    menu db 10, "=== File Explorer ===", 10
         db "1. Create / overwrite file", 10
         db "2. Read file", 10
         db "3. Append text to file", 10
         db "4. Show process ID", 10
         db "0. Exit", 10
         db "Choose: "
    menu_len equ $ - menu

    filename db "notes.txt", 0

    input_msg db "Enter text: "
    input_len equ $ - input_msg

    read_msg db 10, "File contents:", 10
    read_len equ $ - read_msg

    empty_msg db "File is empty or EOF.", 10
    empty_len equ $ - empty_msg

    saved_msg db "File updated successfully.", 10
    saved_len equ $ - saved_msg

    pid_msg db "Process ID: "
    pid_len equ $ - pid_msg

    newline db 10
    error_msg db "An error occurred.", 10
    error_len equ $ - error_msg

section .bss
    menu_buf resb 16
    buffer resb 512
    file_fd resd 1
    num_buf resb 16

section .text

_start:

menu_loop:
    PRINT menu, menu_len

    ; Read menu choice.
    mov eax, 3
    mov ebx, 0
    mov ecx, menu_buf
    mov edx, 16
    int 80h

    cmp eax, 0
    jle exit_program

    cmp byte [menu_buf], '1'
    je create_file

    cmp byte [menu_buf], '2'
    je read_file

    cmp byte [menu_buf], '3'
    je append_file

    cmp byte [menu_buf], '4'
    je show_pid

    cmp byte [menu_buf], '0'
    je exit_program

    jmp menu_loop


; Create a new file or overwrite an existing one.
create_file:
    PRINT input_msg, input_len

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 512
    int 80h

    test eax, eax
    js show_error
    jz menu_loop

    mov esi, eax

    ; O_WRONLY | O_CREAT | O_TRUNC
    mov eax, 5
    mov ebx, filename
    mov ecx, 0x241
    mov edx, 438
    int 80h

    test eax, eax
    js show_error

    mov [file_fd], eax
    jmp write_file


; Append text to the end of an existing file.
append_file:
    PRINT input_msg, input_len

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 512
    int 80h

    test eax, eax
    js show_error
    jz menu_loop

    mov esi, eax

    ; O_WRONLY | O_CREAT | O_APPEND
    mov eax, 5
    mov ebx, filename
    mov ecx, 0x441
    mov edx, 438
    int 80h

    test eax, eax
    js show_error

    mov [file_fd], eax


; Write all entered bytes to the file.
write_file:
    mov edi, buffer

write_loop:
    test esi, esi
    jz write_done

    mov eax, 4
    mov ebx, [file_fd]
    mov ecx, edi
    mov edx, esi
    int 80h

    test eax, eax
    jle write_error

    add edi, eax
    sub esi, eax
    jmp write_loop

write_done:
    ; Close the file.
    mov eax, 6
    mov ebx, [file_fd]
    int 80h

    PRINT saved_msg, saved_len
    jmp menu_loop

write_error:
    mov eax, 6
    mov ebx, [file_fd]
    int 80h
    jmp show_error


; Open and read the file.
read_file:
    mov eax, 5
    mov ebx, filename
    mov ecx, 0
    mov edx, 0
    int 80h

    test eax, eax
    js show_error

    mov [file_fd], eax

    ; Read up to 512 bytes.
    mov eax, 3
    mov ebx, [file_fd]
    mov ecx, buffer
    mov edx, 512
    int 80h

    test eax, eax
    js read_error

    cmp eax, 0
    je file_empty

    mov esi, eax

    ; Close the file.
    mov eax, 6
    mov ebx, [file_fd]
    int 80h

    PRINT read_msg, read_len

    ; Display exactly the bytes that were read.
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, esi
    int 80h

    jmp menu_loop

file_empty:
    mov eax, 6
    mov ebx, [file_fd]
    int 80h

    PRINT empty_msg, empty_len
    jmp menu_loop

read_error:
    mov eax, 6
    mov ebx, [file_fd]
    int 80h
    jmp show_error


; Display the current process ID.
show_pid:
    mov eax, 20
    int 80h

    ; Convert the PID to decimal text.
    mov edi, num_buf + 16
    mov ebx, 10

convert_loop:
    xor edx, edx
    div ebx
    add dl, '0'
    dec edi
    mov [edi], dl
    test eax, eax
    jnz convert_loop

    PRINT pid_msg, pid_len

    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, num_buf + 16
    sub edx, edi
    int 80h

    PRINT newline, 1
    jmp menu_loop


show_error:
    PRINT error_msg, error_len
    jmp menu_loop


; Exit with status code 0.
exit_program:
    mov eax, 1
    mov ebx, 0
    int 80h

