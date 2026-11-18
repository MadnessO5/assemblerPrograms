BITS 32
global _start
extern print_string, read_int, random_range

section .data
 title db 10, "=== GUESS THE NUMBER ===", 10, 0
 ask_min db "Minimum (1..100000): ", 0
 ask_max db "Maximum (1..100000): ", 0
 ask_guess db "Your guess: ", 0
 low db "Too low! Try higher.", 10, 0
 high db "Too high! Try lower.", 10, 0
 win db "Correct! You won!", 10, 0
 bad db "Invalid input or range.", 10, 0
 bye db "Goodbye!", 10, 0

section .bss
 minimum resd 1
 maximum resd 1
 secret resd 1

section .text
_start:
 push title
 call print_string
 add esp, 4

 push ask_min
 call print_string
 add esp, 4
 call read_int
 cmp eax, 1
 jl .error
 cmp eax, 100000
 jg .error
 mov [minimum], eax

 push ask_max
 call print_string
 add esp, 4
 call read_int
 cmp eax, 1
 jl .error
 cmp eax, 100000
 jg .error
 mov [maximum], eax

 mov eax, [minimum]
 cmp eax, [maximum]
 jge .error

 push dword [maximum]
 push dword [minimum]
 call random_range
 add esp, 8
 mov [secret], eax

.loop:
 push ask_guess
 call print_string
 add esp, 4
 call read_int
 cmp eax, 1
 jl .error
 cmp eax, 100000
 jg .error
 cmp eax, [secret]
 je .won
 jl .too_low
 push high
 call print_string
 add esp, 4
 jmp .loop

.too_low:
 push low
 call print_string
 add esp, 4
 jmp .loop

.won:
 push win
 call print_string
 add esp, 4
 jmp .exit

.error:
 push bad
 call print_string
 add esp, 4

.exit:
 push bye
 call print_string
 add esp, 4
 mov eax, 1
 xor ebx, ebx
 int 0x80
