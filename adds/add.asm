; --------------------------------------------------------------------
; add.asm
;
; Reads two (optionally negative) decimal integers from standard
; input, separated by whitespace, adds them, and prints the sum.
;
; stud_io.inc only provides character-at-a-time I/O (GETCHAR/PUTCHAR),
; with no built-in support for reading or printing whole numbers, so
; this program does the ASCII-digit <-> integer conversion itself, in
; both directions, using two small subroutines called via CALL/RET.
;
; Formatted per section 3.1.6: columns, a tab before every
; instruction, a comment on every line, ASCII only, English comments,
; no line over 79 columns, meaningful names.
; --------------------------------------------------------------------

%include "stud_io.inc"
global  _start

section .text
_start:
        call    read_int                ; first number -> eax
        mov     esi, eax                ; keep it safe across the next call

        call    read_int                ; second number -> eax
        add     eax, esi                ; eax := first number + second number

        call    print_int               ; print the sum
        PUTCHAR 10                      ; newline after the result

        FINISH  0                       ; exit code 0


; ----------------------------------------------------------------
; read_int: skips any leading spaces/newlines, then reads an
; optional leading '-' followed by one or more decimal digits,
; stopping at the first character that is not a digit (which is
; consumed, not put back).
; Input:    none
; Output:   eax = the parsed signed integer
; Clobbers: ebx, ecx, edx
; ----------------------------------------------------------------
read_int:
        mov     ebx, 1                  ; ebx = sign, 1 means positive
        xor     ecx, ecx                ; ecx = value accumulated so far

ri_skip_spaces:
        GETCHAR                         ; skip any leading whitespace
        cmp     eax, ' '
        je      ri_skip_spaces
        cmp     eax, 10                 ; a stray newline counts too
        je      ri_skip_spaces

        cmp     eax, '-'                ; a leading minus sign?
        jne     ri_digit_loop
        mov     ebx, -1                 ; remember the number is negative
        GETCHAR                         ; move on to the first real digit

ri_digit_loop:
        cmp     eax, '0'                ; below the digit range?
        jl      ri_done
        cmp     eax, '9'                ; above the digit range?
        jg      ri_done
        sub     eax, '0'                ; ASCII digit -> its value 0..9
        imul    ecx, ecx, 10            ; shift the accumulated value left
        add     ecx, eax                ; and add in the new digit
        GETCHAR                         ; next character
        jmp     ri_digit_loop

ri_done:
        mov     eax, ecx                ; move the magnitude into eax
        imul    eax, ebx                ; apply the sign
        ret


; ----------------------------------------------------------------
; print_int: prints the signed integer in eax in decimal, with a
; leading '-' if it is negative.
; Input:    eax = the integer to print
; Output:   none
; Clobbers: eax, ebx, ecx, edx
; ----------------------------------------------------------------
print_int:
        xor     ecx, ecx                ; ecx = how many digits were
                                         ; pushed onto the stack

        cmp     eax, 0                  ; is the value negative?
        jge     pi_convert
        PUTCHAR '-'                     ; print the minus sign
        neg     eax                     ; continue with the magnitude

pi_convert:
        cmp     eax, 0                  ; special case: the value is 0
        jne     pi_convert_loop
        push    eax                     ; push the single digit 0
        inc     ecx
        jmp     pi_print_loop

pi_convert_loop:
        cmp     eax, 0                  ; any digits left to peel off?
        je      pi_print_loop
        xor     edx, edx                ; clear edx before dividing
        mov     ebx, 10
        div     ebx                     ; eax := eax/10, edx := eax mod 10
        push    edx                     ; save this digit for later
        inc     ecx                     ; one more digit pushed
        jmp     pi_convert_loop

pi_print_loop:
        cmp     ecx, 0                  ; any digits left to print?
        je      pi_done
        pop     eax                     ; digits come back in the right
                                         ; order, since a stack is LIFO
        add     eax, '0'                ; digit value -> ASCII character
        PUTCHAR al
        dec     ecx
        jmp     pi_print_loop

pi_done:
        ret
