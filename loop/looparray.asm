; --------------------------------------------------------------------
; looparray.asm
;
; Demonstrates section 3.2.11: the LOOP instruction (ECX as a
; dedicated loop counter), JECXZ as a guard against the "loop runs
; 2^32 times" bug when ECX starts at zero, and LOOPNE for a
; search-until-found-or-exhausted pattern.
;
; Sums a fixed array two different ways -- once with an ESI pointer
; walking forward alongside the ECX counter, once using ECX alone in
; the effective address, counting down -- and prints both sums so you
; can see they agree. Then searches the same array for its first zero
; element using LOOPNE.
;
; Formatted per section 3.1.6: columns, a tab before every
; instruction, a comment on every line, ASCII only, English comments,
; no line over 79 columns, meaningful names.
; --------------------------------------------------------------------

%include "stud_io.inc"
global  _start

section .data
array:          dd      5, 3, 8, 0, 7, 2        ; six dwords; note the
                                                 ; zero at index 3
count:          equ     6

sum1_msg:       db      "Sum (method 1, ESI pointer + LOOP): "
sum1_msg_len:   equ     $ - sum1_msg

sum2_msg:       db      10, "Sum (method 2, ECX-only address): "
sum2_msg_len:   equ     $ - sum2_msg

zero_msg:       db      10, "Index of first zero (-1 if none): "
zero_msg_len:   equ     $ - zero_msg

section .text
_start:
        ; ---- method 1: ECX as counter, ESI as a walking pointer ----
        mov     ecx, count              ; iterations = number of items
        jecxz   m1_done                 ; guard against ECX already 0
                                         ; (see the book's warning: a
                                         ; LOOP on ECX=0 would run
                                         ; 2^32 times, not zero times)
        mov     esi, array              ; esi -> first element
        xor     eax, eax                ; running sum := 0
m1_loop:
        add     eax, [esi]              ; add the current element
        add     esi, 4                  ; esi -> next element
        loop    m1_loop                 ; ecx := ecx-1; loop while <>0
m1_done:
        _syscall_write 1, sum1_msg, sum1_msg_len
        call    print_int

        ; ---- method 2: ECX alone, address computed as array+4*ecx-4
        ; ---- (walking the array from its END back to its start) ----
        mov     ecx, count
        jecxz   m2_done                 ; same guard, same reason
        xor     eax, eax
m2_loop:
        add     eax, [array + 4*ecx - 4]  ; NASM folds "array-4" into
                                           ; one constant at assembly
                                           ; time, so this is still a
                                           ; single constant offset in
                                           ; the actual machine code
        loop    m2_loop
m2_done:
        _syscall_write 1, sum2_msg, sum2_msg_len
        call    print_int

        ; ---- LOOPNE: search for the first element equal to zero ----
        mov     ecx, count
        mov     esi, array              ; esi -> first element
        xor     eax, eax                ; the value we are looking for
        jecxz   search_not_found        ; guard: nothing to search

search_loop:
        cmp     eax, [esi]              ; does this element match?
        lea     esi, [esi + 4]          ; advance regardless, so esi
                                         ; is always "one past" the
                                         ; element just compared
        loopne  search_loop             ; keep going only while NOT
                                         ; equal (ZF clear) and ecx<>0

        jne     search_not_found        ; stopped because ecx hit 0
                                         ; without ever matching

        sub     esi, array              ; esi := byte offset of the
                                         ; element AFTER the match
        shr     esi, 2                  ; esi := that offset in dwords
        dec     esi                     ; esi := index of the match
                                         ; itself
        jmp     search_report

search_not_found:
        mov     esi, -1                 ; sentinel: no zero in array

search_report:
        _syscall_write 1, zero_msg, zero_msg_len
        mov     eax, esi
        call    print_int               ; signed -- the sentinel is -1
        PUTCHAR 10

        FINISH  0                       ; exit code 0


; ----------------------------------------------------------------
; print_int: prints the signed integer in eax in decimal, with a
; leading '-' if it is negative.
; Input:    eax = the integer to print
; Output:   none
; Clobbers: eax, ebx, ecx, edx
; ----------------------------------------------------------------
print_int:
        xor     ecx, ecx                ; ecx = digits pushed so far

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
        pop     eax                     ; digits come back in the
                                         ; right order (stack is LIFO)
        add     eax, '0'                ; digit value -> ASCII char
        PUTCHAR al
        dec     ecx
        jmp     pi_print_loop

pi_done:
        ret
