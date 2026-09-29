# Memory Sections

A simple x86 Assembly program that demonstrates memory sections and memory allocation.

## Requirements

- NASM
- Linux or FreeBSD
- `stud_io.inc`

## Build & Run

```bash
nasm -f elf32 sections.asm -o sections.o
ld -m elf_i386 sections.o -o sections
./sections
```

## Usage

The program copies a string from `.data` to a buffer in `.bss` and prints it.

```text
Hello from Assembly!
```

## How It Works

- `.data` stores initialized data.
- `.bss` reserves uninitialized memory.
- `db` creates initialized bytes.
- `resb` reserves bytes.
- The program copies the string from `.data` to `.bss`.
- The copied string is printed using `PUTCHAR`.
