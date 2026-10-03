# Integer Arithmetic

A simple x86 Assembly program that demonstrates integer arithmetic instructions.

## Requirements

- NASM
- Linux or FreeBSD
- `stud_io.inc`

## Build & Run

```bash
nasm -f elf32 integer_arithmetic.asm -o integer_arithmetic.o
ld -m elf_i386 integer_arithmetic.o -o integer_arithmetic
./integer_arithmetic
```

## Usage

The program demonstrates:

- `add` — addition
- `sub` — subtraction
- `inc` — increment
- `dec` — decrement
- `neg` — change the sign
- `cmp` — comparison

Output:

```text
15 12 13 12 -12
Y
```

## How It Works

- The program starts with `10`.
- `add` adds `5`.
- `sub` subtracts `3`.
- `inc` increases the value by `1`.
- `dec` decreases the value by `1`.
- `neg` changes the sign.
- `cmp` compares the final value with `-12`.
