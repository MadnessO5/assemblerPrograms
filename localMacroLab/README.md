# Local Macro Labels Lab

A small NASM project demonstrating multi-line macros, parameters, and local
labels written as `%%name`.

## Build and run

From this directory:

```sh
nrun local_macro_lab.asm
```

Or build manually:

```sh
nasm -f elf local_macro_lab.asm -o local_macro_lab.o
ld -m elf_i386 local_macro_lab.o -o local_macro_lab
./local_macro_lab
```

## What it demonstrates

- `%macro name count` declares a macro with a fixed number of parameters.
- `%1`, `%2`, etc. refer to macro arguments.
- `%%loop` becomes a unique label in each macro expansion.
- `push` and `pop` preserve registers used internally by a macro.

The example uses Linux 32-bit system calls (`int 0x80`).
