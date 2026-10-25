# Mini Calculator

A simple x86 assembly calculator written in NASM.

## Features

- Addition
- Subtraction
- Multiplication
- Integer division
- Negative numbers
- Division-by-zero handling
- Interactive menu

## Requirements

- NASM
- GNU linker
- 32-bit Linux system-call support

## Build

```bash
nasm -f elf mini_calculator.asm -o mini_calculator.o
ld -m elf_i386 mini_calculator.o -o mini_calculator
```

## Run

```bash
./mini_calculator
```

Or use the `nrun` command:

```bash
nrun mini_calculator.asm
```

## Example

```text
Choice: 3
First number: 7
Second number: 8
Result: 56
```

## How It Works

The program reads numbers from standard input, performs the selected arithmetic operation, and prints the result.

It uses subroutines, loops, conditional jumps, integer arithmetic, and Linux system calls.

**Note:** Division uses integers, so `7 / 2` produces `3`. The program does not check for integer overflow or fully validate input.
