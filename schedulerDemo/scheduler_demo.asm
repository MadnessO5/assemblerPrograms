; Interactive multitasking scheduler demonstration.

section .data
	menu db 10, "=== Scheduler Demo ===", 10
	     db "1. Batch processing", 10
	     db "2. Time-sharing", 10
	     db "0. Exit", 10
	     db "Choose mode: "
	menu_len equ $ - menu

	batch_msg db 10, "Batch processing:", 10
		  db "Task A: A A A", 10
		  db "Task B: B B", 10
		  db "Task C: C", 10
	batch_len equ $ - batch_msg

	time_msg db 10, "Time-sharing:", 10
		 db "A -> B -> C -> A -> B -> A", 10
	time_len equ $ - time_msg

	invalid_msg db "Invalid choice!", 10
	invalid_len equ $ - invalid_msg

	exit_msg db "Goodbye!", 10
	exit_len equ $ - exit_msg

section .bss
	choice resb 2

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

	; Read the user's choice.
	mov eax, 3
	mov ebx, 0
	mov ecx, choice
	mov edx, 2
	int 0x80

	; Check the selected option.
	mov al, [choice]

	cmp al, '1'
	je batch_mode

	cmp al, '2'
	je time_mode

	cmp al, '0'
	je exit_program

	; Handle invalid input.
	mov eax, 4
	mov ebx, 1
	mov ecx, invalid_msg
	mov edx, invalid_len
	int 0x80
	jmp menu_loop

batch_mode:
	; Display batch processing example.
	mov eax, 4
	mov ebx, 1
	mov ecx, batch_msg
	mov edx, batch_len
	int 0x80
	jmp menu_loop

time_mode:
	; Display time-sharing example.
	mov eax, 4
	mov ebx, 1
	mov ecx, time_msg
	mov edx, time_len
	int 0x80
	jmp menu_loop

exit_program:
	; Display the exit message.
	mov eax, 4
	mov ebx, 1
	mov ecx, exit_msg
	mov edx, exit_len
	int 0x80

	; Exit the program.
	mov eax, 1
	xor ebx, ebx
	int 0x80
