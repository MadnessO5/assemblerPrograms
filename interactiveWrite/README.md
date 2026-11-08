# interactiveWrite

A simple interactive NASM program demonstrating Linux i386 system calls.

## Features

- Reads text entered by the user using `sys_read`.
- Displays the entered text using `sys_write`.
- Terminates using `sys_exit`.

## Requirements

- Linux x86 system call interface (i386)
- NASM
- GNU ld
- 32-bit ELF support

## Build and Run

Using `nrun`:

```bash
nrun interactive_write.asm
```

Or manually:

```bash
nasm -f elf interactive_write.asm -o interactive_write.o
ld -m elf_i386 interactive_write.o -o interactive_write
./interactive_write
```

## Usage

1. Run the program.
2. Enter some text.
3. Press Enter.
4. The program displays the entered text and exits.

## Learning Topics

- Linux i386 system call convention
- `int 80h`
- `sys_read` (3)
- `sys_write` (4)
- `sys_exit` (1)
- Registers `EAX`, `EBX`, `ECX`, `EDX`, `ESI`
- `.data` and `.bss` sections
- `resb` and `equ`
