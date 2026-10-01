# Indirect Addressing

A simple x86 Assembly program that demonstrates indirect addressing and the `lea` instruction.

## Requirements

- NASM
- Linux or FreeBSD
- `stud_io.inc`

## Build & Run

```bash
nasm -f elf32 indirect.asm -o indirect.o
ld -m elf_i386 indirect.o -o indirect
./indirect
```

## Usage

The program creates an array of 10 integers and prints them:

```text
1 2 3 4 5 6 7 8 9 10
```

## How It Works

- `EDI` stores the address of the array.
- `mov [edi], eax` writes data to memory using indirect addressing.
- `mov eax, [edi]` reads data from memory.
- `add edi, 4` moves to the next `dword`.
- `lea edi, [array]` calculates the address of the array without reading memory.
