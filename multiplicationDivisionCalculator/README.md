# Multiplication Division Calculator

A simple x86 Assembly calculator that performs integer multiplication and division.

## Requirements

- NASM
- Linux or FreeBSD
- `stud_io.inc`

## Build & Run

```bash
nasm -f elf32 calculator.asm -o calculator.o
ld -m elf_i386 calculator.o -o calculator
./calculator
```

## Usage

Enter two numbers and choose `*` for multiplication or `/` for division.

Example:

```text
1: 12
2: 4
*/: *
48
```

Division:

```text
1: 20
2: 4
*/: /
5
```

## How It Works

- `imul` performs signed multiplication.
- `idiv` performs signed division.
- `cdq` prepares `EDX:EAX` for signed division.
- The program checks for division by zero.
- The result is printed to the console.
