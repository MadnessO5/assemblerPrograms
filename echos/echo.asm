; --------------------------------------------------------------------
; echo.asm
;
; The simplest possible demonstration of every macro stud_io.inc
; provides: PRINT a message, then read characters one at a time with
; GETCHAR and echo each one straight back out with PUTCHAR, until
; end of input, then PRINT a goodbye message and FINISH.
;
; Formatted per the rules in section 3.1.6: columns, a tab before
; every instruction, a comment on every line, ASCII only, English
; comments, no line over 79 columns, meaningful names.
; --------------------------------------------------------------------

%include "stud_io.inc"
global  _start

section .text
_start:
        PRINT   "Type something (Ctrl+D to finish):"
        PUTCHAR 10                     ; newline after the prompt

echo_loop:
        GETCHAR                        ; next character (or -1) into eax
        cmp     eax, -1                ; end of input reached?
        je      echo_done
        PUTCHAR al                     ; echo the character straight back
        jmp     echo_loop

echo_done:
        PRINT   "Goodbye!"
        PUTCHAR 10                     ; newline after the goodbye

        FINISH  0                      ; exit code 0
