# Bitwise Operations

A simple x86 Assembly program that demonstrates bitwise operations on an integer.

## Requirements

- NASM
- Linux or FreeBSD
- `stud_io.inc`

## Build & Run

```bash
nasm -f elf bitwise_operations.asm
ld -m elf_i386 bitwise_operations.o -o bitwise_operations
./bitwise_operations
```

## Usage

Enter a number and a bit number from 0 to 31.

Example:

```text
Number: 2
Bit (0-31): 3
Bit is not set
Result: 10
```

## How It Works

- `SHL` creates a mask for the selected bit.
- `TEST` checks whether the bit is set.
- `OR` sets the selected bit.
- The result is printed as a decimal number.
