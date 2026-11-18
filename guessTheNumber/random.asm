BITS 32
global random_range

section .text
; random_range(minimum, maximum), inclusive range
random_range:
 push ebp
 mov ebp, esp
 push ebx
 push esi
 mov esi, [ebp+8]
 mov ebx, [ebp+12]
 sub ebx, esi
 inc ebx
 rdtsc
 xor eax, edx
 xor edx, edx
 div ebx
 add edx, esi
 mov eax, edx
 pop esi
 pop ebx
 mov esp, ebp
 pop ebp
 ret
