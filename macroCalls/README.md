# Macro Calls

A NASM assembly project demonstrating macros and procedure calls.

## Features

- `pcall0`, `pcall1`, `pcall2`, and `pcall3` macros.
- Passing arguments through the stack.
- Accessing arguments with `arg(n)`.
- Accessing local variables with `local(n)`.
- Calculating the sum of three numbers.

## Requirements

- NASM
- GNU `ld`
- Linux with 32-bit ELF support

## Build

```bash
nasm -f elf macro_calls.asm -o macro_calls.o
ld -m elf_i386 macro_calls.o -o macro_calls
```

## Run

```bash
./macro_calls
```

Or use `nrun`:

```bash
nrun macro_calls.asm
```
