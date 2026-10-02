# Operand Sizes

A simple x86 Assembly program that demonstrates different operand sizes: byte, word and dword.

## Requirements

- NASM
- Linux or FreeBSD
- `stud_io.inc`

## Build & Run

```bash
nasm -f elf32 operand_sizes.asm -o operand_sizes.o
ld -m elf_i386 operand_sizes.o -o operand_sizes
./operand_sizes
```

## Usage

The program stores and reads values of different sizes.

Output:

```text
10 20 30
40 50 60
```

## How It Works

- `byte` stores 1 byte.
- `word` stores 2 bytes.
- `dword` stores 4 bytes.
- `movzx` loads smaller values into a 32-bit register.
- The program changes the values and prints them again.
