# MOV Demo

A simple x86 Assembly program that demonstrates the `mov` instruction and different types of operands.

## Requirements

- NASM
- Linux or FreeBSD
- `stud_io.inc`

## Build & Run

```bash
nasm -f elf32 mov_demo.asm -o mov_demo.o
ld -m elf_i386 mov_demo.o -o mov_demo
./mov_demo
```

## Usage

The program demonstrates:

- Immediate operands
- Register operands
- Memory operands
- Loading data from memory
- Storing data in memory

Output:

```text
42
```

## How It Works

- `mov eax, 42` uses an immediate operand.
- `mov ebx, eax` copies data between registers.
- `mov [count], ebx` stores data in memory.
- `mov eax, [count]` loads data from memory.
