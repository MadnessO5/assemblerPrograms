# Macro Calculator

An interactive calculator written in NASM assembly. It demonstrates NASM macro directives and conditional assembly.

## Features

- Addition, subtraction, multiplication, division, and modulo.
- Signed integer input and output.
- Division-by-zero handling.
- Reusable macros in `macros.inc`.
- Compile-time directives such as `%define`, `%assign`, `%if`, `%ifdef`, and `%rep`.
- Optional debug build.

## Requirements

- NASM
- GNU `ld`
- Linux with 32-bit ELF support

## Build

```bash
nasm -f elf macro_calculator.asm -o macro_calculator.o
ld -m elf_i386 macro_calculator.o -o macro_calculator
```

## Run

```bash
./macro_calculator
```

Or use `nrun`:

```bash
nrun macro_calculator.asm
```

## Debug Build

```bash
nasm -DDEBUG=1 -f elf macro_calculator.asm -o macro_calculator.o
ld -m elf_i386 macro_calculator.o -o macro_calculator
./macro_calculator
```

## How It Works

The `%include` directive loads reusable macros from `macros.inc`. The `PRINT` macro prints text using Linux system calls. Conditional directives control assembly, while `%rep` repeats data declarations.
