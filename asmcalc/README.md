# asmcalc

An interactive modular integer calculator written in NASM assembly for 32-bit Linux.

## Features

- Addition
- Subtraction
- Multiplication
- Integer division
- Division-by-zero check
- Input validation

The calculator accepts integers from `0` to `9999`. Subtraction can produce a negative result. Division returns the integer quotient.

## Project Structure

```text
asmcalc/
├── kernel.inc
├── calc.asm
├── read_uint.asm
├── parse_uint.asm
├── print_int.asm
├── operations.asm
├── strlen.asm
├── putstr.asm
├── getstr.asm
├── quit.asm
├── Makefile
└── README.md
```

## Requirements

- NASM
- GNU Make
- GNU Binutils (`ld`)
- Linux with 32-bit ELF support

On Arch Linux:

```bash
sudo pacman -S nasm make binutils
```

## Build

```bash
cd ~/assemblerPrograms/asmcalc
make
```

## Run

```bash
./prog
```

## Example

```text
=== Modular Calculator ===
1. Addition
2. Subtraction
3. Multiplication
4. Division
0. Exit
Choose an operation: 1
Enter first number (0-9999): 25
Enter second number (0-9999): 17
Result: 42
```

## Modules

| File | Description |
|---|---|
| `kernel.inc` | System call macro and OS-specific flags |
| `calc.asm` | Main menu and program control |
| `read_uint.asm` | Reads and parses a number |
| `parse_uint.asm` | Validates and converts decimal text |
| `print_int.asm` | Prints a signed integer |
| `operations.asm` | Arithmetic functions |
| `strlen.asm` | Calculates string length |
| `putstr.asm` | Prints a string |
| `getstr.asm` | Reads a line from standard input |
| `quit.asm` | Exits the program |

## Clean

```bash
make clean
```
