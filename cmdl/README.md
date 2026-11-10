# cmdl

A simple NASM program that prints all command-line arguments, including the program name.

## Features

- Reads command-line arguments from the initial stack.
- Prints the argument count indirectly by processing each argument.
- Calculates string lengths using a custom `strlen` procedure.
- Prints strings using Linux i386 system calls.

## Requirements

- Linux x86 system call interface (i386)
- NASM
- GNU ld
- 32-bit ELF support

## Build and Run

```bash
nasm -f elf cmdl.asm -o cmdl.o
ld -m elf_i386 cmdl.o -o cmdl
./cmdl Hello Linux World 123
```

## Example

```text
./cmdl Hello Linux World 123

./cmdl
Hello
Linux
World
123
```

## Learning Topics

- Command-line arguments (`argc` and `argv`)
- Initial process stack (`ESP`)
- Stack-based argument passing
- Procedures (`call` and `ret`)
- CDECL calling convention
- String length calculation (`strlen`)
- Linux i386 system calls (`write` and `exit`)
- Registers (`EAX`, `EBX`, `ECX`, `EDX`, `ESI`, `EBP`)
