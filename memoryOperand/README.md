# Memory Operand

A simple NASM program demonstrating how to read a value from memory.

## Requirements

- NASM
- GNU linker
- 32-bit Linux system-call support

## Build

```bash
nasm -f elf memory_operand.asm -o memory_operand.o
ld -m elf_i386 memory_operand.o -o memory_operand
```

## Run

```bash
./memory_operand
```

## How It Works

- `number dd 7` defines a 32-bit value in memory.
- `mov eax, [number]` reads the value from memory into EAX.
- Square brackets `[]` indicate a memory access.
- `PUTCHAR` prints the digit.

## Example Output

```text
Value from memory: 7
```
