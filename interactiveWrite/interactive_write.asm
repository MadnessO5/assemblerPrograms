global _start

section .data
    prompt db "Enter some text: "
    prompt_len equ $ - prompt
    prefix db "You entered: "
    prefix_len equ $ - prefix

section .bss
    buffer resb 128

section .text
_start:
    ; Print the input prompt.
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 80h

    ; Read up to 128 bytes from standard input.
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 128
    int 80h

    ; Save the number of bytes read.
    cmp eax, 0
    jle .exit
    mov esi, eax

    ; Print the output prefix.
    mov eax, 4
    mov ebx, 1
    mov ecx, prefix
    mov edx, prefix_len
    int 80h

    ; Print the text entered by the user.
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, esi
    int 80h

.exit:
    ; Exit with status code 0.
    mov eax, 1
    mov ebx, 0
    int 80h

