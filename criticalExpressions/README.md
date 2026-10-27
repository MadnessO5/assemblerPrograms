# Critical Expressions

A small interactive NASM program demonstrating critical expressions.

## Features

- Displays a label address.
- Displays a position represented by `$`.
- Calculates the size of a data block.
- Demonstrates compile-time expressions.

## Requirements

- NASM
- GNU `ld`
- Linux with 32-bit ELF support
- `stud_io.inc` if required by your environment

## Build

```bash
nasm -f elf critical_expressions.asm -o critical_expressions.o
ld -m elf_i386 critical_expressions.o -o critical_expressions
```

## Run

```bash
./critical_expressions
```

Or use `nrun`:

```bash
nrun critical_expressions.asm
```

## How It Works

NASM evaluates expressions during assembly. Expressions that affect memory layout must be computable during the first pass.

The program demonstrates label addresses, the current position, and compile-time size calculations.
