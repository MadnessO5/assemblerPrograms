# Macro Repetition Lab

A small NASM program demonstrating `%rep`, `%endrep`, `%exitrep`, and `%assign`.

## Build and run

From this directory, run:

```sh
nrun macro_repetition.asm
```

Or build manually:

```sh
nasm -f elf macro_repetition.asm -o macro_repetition.o
ld -m elf_i386 macro_repetition.o -o macro_repetition
./macro_repetition
```

## What it demonstrates

- Generates bytes `5, 7, 9, 11` at assembly time.
- Generates Fibonacci values as 32-bit integers, stopping when the next value
  would exceed `100000`.
- Generates eight 16-bit values with `%rep` and `%assign`.

The repeated directives are expanded before the program runs.
