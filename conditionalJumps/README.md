# Conditional Jumps

A simple x86 Assembly program that compares two integers using `cmp` and conditional jumps.

## Requirements

- NASM
- Linux or FreeBSD
- `stud_io.inc`

## Build & Run

```bash
nasm -f elf conditional_jumps.asm
ld -m elf_i386 conditional_jumps.o -o conditional_jumps
./conditional_jumps
```

## Usage

Enter two positive integers.

Example:

```text
1: 23
2: 33
<
```

Another example:

```text
1: 33
2: 23
>
```

If the numbers are equal:

```text
1: 10
2: 10
=
```

## How It Works

- `cmp` compares the two numbers by setting CPU flags.
- `jl` jumps if the first number is less than the second.
- `jg` jumps if the first number is greater than the second.
- `je` jumps if the numbers are equal.
- `jmp` performs an unconditional jump.
