
; Interactive binary logic calculator.
; Linux i386, NASM ELF.

section .data
    title db 10, "=== Binary Logic Calculator ===", 10
    title_len equ $ - title

    menu db 10, "1. AND  (&)", 10
         db "2. OR   (|)", 10
         db "3. XOR  (^)", 10
         db "4. NOT  (~)", 10
         db "0. Exit", 10
         db "Choose: "
    menu_len equ $ - menu

    first_msg db "First 8-bit binary number: "
    first_len equ $ - first_msg

    second_msg db "Second 8-bit binary number: "
    second_len equ $ - second_msg

    result_msg db "Result: "
    result_len equ $ - result_msg

    invalid_op db "Error: invalid operation!", 10
    invalid_op_len equ $ - invalid_op

    invalid_num db "Error: enter exactly 8 bits (0 or 1).", 10
    invalid_num_len equ $ - invalid_num

section .bss
    input resb 32
    number_a resd 1
    number_b resd 1
    result resd 1
    output resb 9

section .text
global _start

_start:
    ; Display the program title.
    mov eax, 4
    mov ebx, 1
    mov ecx, title
    mov edx, title_len
    int 0x80

.menu:
    ; Display the operation menu.
    mov eax, 4
    mov ebx, 1
    mov ecx, menu
    mov edx, menu_len
    int 0x80

    ; Read the menu choice.
    call read_line
    jc .exit

    ; Require exactly one character.
    cmp eax, 1
    jne .bad_operation

    ; Check the selected operation.
    mov al, [input]

    cmp al, '0'
    je .exit

    cmp al, '1'
    je .and_op

    cmp al, '2'
    je .or_op

    cmp al, '3'
    je .xor_op

    cmp al, '4'
    je .not_op

.bad_operation:
    ; Display an operation error.
    call show_invalid_op
    jmp .menu

.and_op:
    ; Read the first number.
    call read_first
    jc .menu

    ; Read the second number.
    call read_second
    jc .menu

    ; Perform bitwise AND.
    mov eax, [number_a]
    and eax, [number_b]
    jmp .show_result

.or_op:
    ; Read both numbers.
    call read_first
    jc .menu

    call read_second
    jc .menu

    ; Perform bitwise OR.
    mov eax, [number_a]
    or eax, [number_b]
    jmp .show_result

.xor_op:
    ; Read both numbers.
    call read_first
    jc .menu

    call read_second
    jc .menu

    ; Perform bitwise XOR.
    mov eax, [number_a]
    xor eax, [number_b]
    jmp .show_result

.not_op:
    ; Read the first number.
    call read_first
    jc .menu

    ; Invert exactly eight bits.
    mov eax, [number_a]
    not eax
    and eax, 0xFF
    jmp .show_result

.show_result:
    ; Save the result.
    mov [result], eax

    ; Display the result label.
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, result_len
    int 0x80

    ; Print the result in binary.
    mov eax, [result]
    call print_binary

    jmp .menu

.exit:
    ; Exit successfully.
    mov eax, 1
    xor ebx, ebx
    int 0x80

read_first:
    ; Display the first number prompt.
    mov eax, 4
    mov ebx, 1
    mov ecx, first_msg
    mov edx, first_len
    int 0x80

    ; Read and validate the number.
    call read_binary
    jc .error

    mov [number_a], eax
    clc
    ret

.error:
    stc
    ret

read_second:
    ; Display the second number prompt.
    mov eax, 4
    mov ebx, 1
    mov ecx, second_msg
    mov edx, second_len
    int 0x80

    ; Read and validate the number.
    call read_binary
    jc .error

    mov [number_b], eax
    clc
    ret

.error:
    stc
    ret

read_line:
    ; Read one line from standard input.
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 32
    int 0x80

    ; Check for EOF or read error.
    cmp eax, 0
    jle .read_error

    ; Remove the trailing newline.
    mov edx, eax
    cmp byte [input + edx - 1], 10
    jne .done

    dec edx

.done:
    ; Return the number of characters.
    mov eax, edx
    clc
    ret

.read_error:
    stc
    ret

read_binary:
    ; Read the binary input.
    call read_line
    jc .invalid

    ; Require exactly eight characters.
    cmp eax, 8
    jne .invalid

    ; Convert binary text into an integer.
    mov esi, input
    xor eax, eax
    mov ecx, 8

.convert:
    ; Shift the current value left.
    shl eax, 1

    ; Check the current character.
    cmp byte [esi], '0'
    je .next

    cmp byte [esi], '1'
    jne .invalid

    ; Set the lowest bit.
    or eax, 1

.next:
    inc esi
    loop .convert

    ; Return the converted number.
    clc
    ret

.invalid:
    ; Display an input error.
    mov eax, 4
    mov ebx, 1
    mov ecx, invalid_num
    mov edx, invalid_num_len
    int 0x80

    stc
    ret

show_invalid_op:
    ; Display an operation error.
    mov eax, 4
    mov ebx, 1
    mov ecx, invalid_op
    mov edx, invalid_op_len
    int 0x80
    ret

print_binary:
    ; Prepare the output buffer.
    mov ebx, eax
    mov edi, output
    mov ecx, 8

.print_loop:
    ; Check the highest bit.
    test ebx, 0x80
    jnz .print_one

    mov byte [edi], '0'
    jmp .next_bit

.print_one:
    mov byte [edi], '1'

.next_bit:
    ; Move to the next bit.
    shl ebx, 1
    inc edi
    loop .print_loop

    ; Add a newline.
    mov byte [edi], 10

    ; Print eight binary digits.
    mov eax, 4
    mov ebx, 1
    mov ecx, output
    mov edx, 9
    int 0x80

    ret

