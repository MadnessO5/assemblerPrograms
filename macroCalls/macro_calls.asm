; Demonstrate NASM macros and procedure arguments.

%include "macros.inc"

%define SYS_READ 3
%define SYS_WRITE 4
%define SYS_EXIT 1
%define STDIN 0
%define STDOUT 1

section .data
    prompt1 db "First number: "
    prompt1_len equ $ - prompt1

    prompt2 db "Second number: "
    prompt2_len equ $ - prompt2

    prompt3 db "Third number: "
    prompt3_len equ $ - prompt3

    result_msg db "Sum: "
    result_len equ $ - result_msg

    newline db 10
    newline_len equ $ - newline

section .bss
    input resb 32
    output resb 12
    number1 resd 1
    number2 resd 1
    number3 resd 1

section .text
    global _start

_start:
    ; Read the first number.
    mov ecx, prompt1
    mov edx, prompt1_len
    call print_text
    call read_number
    mov [number1], eax

    ; Read the second number.
    mov ecx, prompt2
    mov edx, prompt2_len
    call print_text
    call read_number
    mov [number2], eax

    ; Read the third number.
    mov ecx, prompt3
    mov edx, prompt3_len
    call print_text
    call read_number
    mov [number3], eax

    ; Call sum_three with three arguments.
    pcall3 sum_three, dword [number1], \
        dword [number2], dword [number3]

    ; Print the result.
    push eax
    mov ecx, result_msg
    mov edx, result_len
    call print_text
    pop eax
    call print_number

    ; Print a newline.
    mov ecx, newline
    mov edx, newline_len
    call print_text

    ; Exit.
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80

; Print text from ECX with length EDX.
print_text:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    int 0x80
    ret

; Read a positive decimal integer.
read_number:
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, input
    mov edx, 32
    int 0x80

    xor eax, eax
    mov esi, input

.read_loop:
    movzx ebx, byte [esi]

    cmp ebx, 10
    je .done

    cmp ebx, '0'
    jb .done

    cmp ebx, '9'
    ja .done

    imul eax, eax, 10
    sub ebx, '0'
    add eax, ebx

    inc esi
    jmp .read_loop

.done:
    ret

; Sum three arguments using EBP-relative addressing.
sum_three:
    push ebp
    mov ebp, esp
    sub esp, 4

    ; Store the first argument in a local variable.
    mov eax, [arg(1)]
    mov [local(1)], eax

    ; Add the second and third arguments.
    add eax, [arg(2)]
    add eax, [arg(3)]

    ; Restore the stack frame.
    mov esp, ebp
    pop ebp
    ret

; Print the signed integer in EAX.
print_number:
    mov edi, output + 11
    mov byte [edi], 10
    dec edi

    xor esi, esi
    test eax, eax
    jns .convert

    mov esi, 1
    neg eax

.convert:
    mov ebx, 10

.loop:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz .loop

    test esi, esi
    jz .write

    mov byte [edi], '-'
    dec edi

.write:
    lea ecx, [edi + 1]
    lea edx, [output + 12]
    sub edx, ecx

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    int 0x80
    ret
