# Macro Expansion Lab

A NASM project demonstrating macro expansion strategies and macro variables.

## Features

- Lazy expansion with `%define`.
- Eager expansion with `%xdefine`.
- Arithmetic macro variables with `%assign`.
- Conditional assembly with `%if` and `%else`.

## Requirements

- NASM
- GNU `ld`
- Linux with 32-bit ELF support

## Build

```bash
nasm -f elf macro_expansion.asm -o macro_expansion.o
ld -m elf_i386 macro_expansion.o -o macro_expansion
```

## Run

```bash
./macro_expansion
```

Or use `nrun`:

```bash
nrun macro_expansion.asm
```
