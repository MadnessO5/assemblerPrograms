%include "stud_io.inc"          ; Include input/output macros

global  _start                  ; Declare the program entry point

section .text                   ; Start the code section

_start:
        PRINT   "Type something (Enter to finish):" ; Display prompt
        PUTCHAR 10              ; Print a newline

read_loop:
        GETCHAR                 ; Read a character into eax
        cmp     eax, -1         ; Check for end of input
        je      done            ; Exit if EOF is reached
        cmp     al, 10          ; Check for Enter (newline)
        je      done            ; Exit if Enter is pressed

        cmp     al, 'a'         ; Check if character is below 'a'
        jl      print_char      ; Skip conversion if it is
        cmp     al, 'z'         ; Check if character is above 'z'
        jg      print_char      ; Skip conversion if it is

        sub     al, 32          ; Convert lowercase to uppercase

print_char:
        PUTCHAR al              ; Print the character
        jmp     read_loop       ; Read the next character

done:
        PUTCHAR 10              ; Print a newline
        PRINT   "Goodbye!"      ; Display goodbye message
        PUTCHAR 10              ; Print a newline

        FINISH  0               ; Exit with code 0
