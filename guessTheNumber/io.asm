BITS 32
global print_string, read_int

section .bss
 ch resb 1

section .text
print_string:
 push ebp
 mov ebp, esp
 push ebx
 push esi
 mov esi, [ebp+8]
 xor edx, edx
.len:
 cmp byte [esi+edx], 0
 je .write
 inc edx
 jmp .len
.write:
 mov eax, 4
 mov ebx, 1
 mov ecx, esi
 int 0x80
 pop esi
 pop ebx
 mov esp, ebp
 pop ebp
 ret

read_int:
 push ebp
 mov ebp, esp
 push ebx
 push esi
 push edi
 xor esi, esi
 xor edi, edi
.next:
 mov eax, 3
 xor ebx, ebx
 mov ecx, ch
 mov edx, 1
 int 0x80
 cmp eax, 1
 jne .done
 mov al, [ch]
 cmp al, 10
 je .done
 cmp al, 13
 je .next
 cmp al, '0'
 jb .invalid
 cmp al, '9'
 ja .invalid
 sub al, '0'
 movzx ebx, al
 imul esi, esi, 10
 add esi, ebx
 cmp esi, 1000000
 ja .invalid
 jmp .next
.invalid:
 mov edi, 1
 jmp .next
.done:
 test edi, edi
 jnz .bad
 mov eax, esi
 jmp .return
.bad:
 mov eax, -1
.return:
 pop edi
 pop esi
 pop ebx
 mov esp, ebp
 pop ebp
 ret
