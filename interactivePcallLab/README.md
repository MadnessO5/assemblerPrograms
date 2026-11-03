# interactivePcallLab

Interactive NASM practice for section 3.5.7: macros with a variable number
of parameters.

## Build and run

```sh
nrun interactive_pcall.asm
```

Or manually:

```sh
nasm -f elf interactive_pcall.asm -o interactive_pcall.o
ld -m elf_i386 interactive_pcall.o -o interactive_pcall
./interactive_pcall
```

## Menu

- `1` - enter two numbers and add them
- `2` - enter three numbers and add them
- `3` - enter four numbers and add them
- `4` - show the last result
- `0` - exit

## What to study

The `pcall` macro uses `%macro pcall 1-*`, `%0`, `%rep`, and `%rotate -1`.
Each menu operation calls the same macro with a different number of
arguments. The program asks for values at runtime; the macro argument count
is determined at assembly time.

Numbers are unsigned 32-bit decimal values. Addition wraps modulo 2^32.
