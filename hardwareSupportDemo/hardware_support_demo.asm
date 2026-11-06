; Interactive demonstration of hardware support for multitasking.
; This program simulates concepts; it does not control real hardware.

%macro PRINT 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

%macro READ 2
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

section .data
    menu db 10, "=== Hardware Support Demo ===", 10
         db "1. Memory protection", 10
         db "2. CPU modes", 10
         db "3. Hardware interrupts", 10
         db "4. Timer", 10
         db "0. Exit", 10
         db "Choose: "
    menu_len equ $ - menu

    memory_menu db 10, "=== Memory Protection ===", 10
                db "1. Process A writes to its own memory", 10
                db "2. Process A tries to write to Process B memory", 10
                db "0. Back", 10
                db "Choose: "
    memory_menu_len equ $ - memory_menu
    memory_ok db "Allowed: the address belongs to Process A.", 10
    memory_ok_len equ $ - memory_ok
    memory_denied db "Blocked: Process A cannot access Process B memory.", 10
    memory_denied_len equ $ - memory_denied

    modes_menu db 10, "=== CPU Modes ===", 10
               db "1. User mode tries a privileged operation", 10
               db "2. Kernel mode performs a privileged operation", 10
               db "0. Back", 10
               db "Choose: "
    modes_menu_len equ $ - modes_menu
    user_denied db "Blocked: user mode cannot perform this operation.", 10
    user_denied_len equ $ - user_denied
    kernel_allowed db "Allowed: kernel mode has the required privilege.", 10
    kernel_allowed_len equ $ - kernel_allowed

    interrupt_menu db 10, "=== Hardware Interrupts ===", 10
                   db "1. Simulate disk I/O completion", 10
                   db "0. Back", 10
                   db "Choose: "
    interrupt_menu_len equ $ - interrupt_menu
    interrupt_start db "Process A requests disk input and becomes blocked.", 10
                    db "The CPU runs Process B while the disk works.", 10
                    db "Disk controller sends an interrupt!", 10
                    db "The OS interrupt handler runs.", 10
                    db "Process A is moved from blocked to ready.", 10
    interrupt_start_len equ $ - interrupt_start

    timer_menu db 10, "=== Timer ===", 10
               db "1. Simulate timer interrupts", 10
               db "0. Back", 10
               db "Choose: "
    timer_menu_len equ $ - timer_menu
    timer_demo db "Task A runs for one time quantum.", 10
               db "Timer interrupt: the OS gets control.", 10
               db "Scheduler switches to Task B.", 10
               db "Task B runs for one time quantum.", 10
               db "Timer interrupt: the OS gets control.", 10
               db "Scheduler switches to Task C.", 10
               db "Task C runs for one time quantum.", 10
               db "Timer interrupt: the OS gets control.", 10
               db "Scheduler switches back to Task A.", 10
    timer_demo_len equ $ - timer_demo

    invalid_msg db "Invalid choice. Try again.", 10
    invalid_len equ $ - invalid_msg
    exit_msg db "Goodbye!", 10
    exit_len equ $ - exit_msg

section .bss
    choice resb 2

section .text
    global _start

_start:
main_menu:
    PRINT menu, menu_len
    READ choice, 2
    cmp byte [choice], '1'
    je memory_protection
    cmp byte [choice], '2'
    je cpu_modes
    cmp byte [choice], '3'
    je hardware_interrupts
    cmp byte [choice], '4'
    je timer_demo_menu
    cmp byte [choice], '0'
    je exit_program
    PRINT invalid_msg, invalid_len
    jmp main_menu

memory_protection:
    PRINT memory_menu, memory_menu_len
    READ choice, 2
    cmp byte [choice], '1'
    je memory_allowed
    cmp byte [choice], '2'
    je memory_blocked
    cmp byte [choice], '0'
    je main_menu
    PRINT invalid_msg, invalid_len
    jmp memory_protection

memory_allowed:
    PRINT memory_ok, memory_ok_len
    jmp memory_protection

memory_blocked:
    PRINT memory_denied, memory_denied_len
    jmp memory_protection

cpu_modes:
    PRINT modes_menu, modes_menu_len
    READ choice, 2
    cmp byte [choice], '1'
    je user_mode_attempt
    cmp byte [choice], '2'
    je kernel_mode_attempt
    cmp byte [choice], '0'
    je main_menu
    PRINT invalid_msg, invalid_len
    jmp cpu_modes

user_mode_attempt:
    PRINT user_denied, user_denied_len
    jmp cpu_modes

kernel_mode_attempt:
    PRINT kernel_allowed, kernel_allowed_len
    jmp cpu_modes

hardware_interrupts:
    PRINT interrupt_menu, interrupt_menu_len
    READ choice, 2
    cmp byte [choice], '1'
    je interrupt_demo
    cmp byte [choice], '0'
    je main_menu
    PRINT invalid_msg, invalid_len
    jmp hardware_interrupts

interrupt_demo:
    PRINT interrupt_start, interrupt_start_len
    jmp hardware_interrupts

timer_demo_menu:
    PRINT timer_menu, timer_menu_len
    READ choice, 2
    cmp byte [choice], '1'
    je show_timer_demo
    cmp byte [choice], '0'
    je main_menu
    PRINT invalid_msg, invalid_len
    jmp timer_demo_menu

show_timer_demo:
    PRINT timer_demo, timer_demo_len
    jmp timer_demo_menu

exit_program:
    PRINT exit_msg, exit_len
    mov eax, 1
    xor ebx, ebx
    int 0x80
