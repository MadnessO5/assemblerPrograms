# String Operations

A simple x86 Assembly program that demonstrates string instructions by copying an array, incrementing its elements, and calculating their sum.

## Requirements

- NASM
- Linux or FreeBSD
- `stud_io.inc`

## Build & Run

```bash
nasm -f elf string_operations.asm
ld -m elf_i386 string_operations.o -o string_operations
./string_operations
```

## Usage

The program copies an array, increases each element by 1, and prints the modified array and its sum.

Example output:

```text
Copied array: 11 21 31 41 51
Sum: 155
```

## How It Works

- `REP MOVSD` copies the array.
- `LODSD` loads each element into `EAX`.
- `INC` increases each element by 1.
- `ESI` points to the current element.
- The program calculates and prints the sum.
