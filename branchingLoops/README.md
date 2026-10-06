# Branching and Loops

A simple x86 Assembly program that compares two integers and calculates the difference between them.

## Requirements

- NASM
- Linux or FreeBSD
- `stud_io.inc`

## Build & Run

```bash
nasm -f elf branching_loops.asm
ld -m elf_i386 branching_loops.o -o branching_loops
./branching_loops
```

## Usage

Enter two integers.

If the first number is greater, the program calculates `A - B`.

If the second number is greater, the program calculates `B - A`.

If the numbers are equal, the program prints `=`.

Example:

```text
A: 15
B: 8
7
```

Another example:

```text
A: 8
B: 15
7
```

Equal numbers:

```text
A: 20
B: 20
=
```

## How It Works

- `cmp` compares the two numbers.
- `jg` jumps when the first number is greater.
- `jl` jumps when the first number is less.
- `jmp` and conditional jumps create the branching structure.
- The program uses the same idea as `if-else` in Pascal.
- The result is calculated and printed.
