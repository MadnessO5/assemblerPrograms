# Loop Array

A simple x86 Assembly program that demonstrates the `LOOP`, `JECXZ`, and `LOOPNE` instructions with an array of integers.

## Requirements

- NASM
- Linux or FreeBSD
- `stud_io.inc`

## Build & Run

```bash
nasm -f elf looparray.asm
ld -m elf_i386 looparray.o -o looparray
./looparray
```

## Usage

The program uses a fixed array:

```text
5, 3, 8, 0, 7, 2
```

It calculates the sum in two different ways and searches for the first zero.

Example output:

```text
Sum (method 1, ESI pointer + LOOP): 25
Sum (method 2, ECX-only address): 25
Index of first zero (-1 if none): 3
```

## How It Works

- `ECX` is used as the loop counter.
- `LOOP` decreases `ECX` and repeats the loop while it is not zero.
- `JECXZ` prevents a loop from starting when `ECX` is zero.
- The first method uses `ESI` as a pointer to walk through the array.
- The second method uses `ECX` directly to calculate array addresses.
- `LOOPNE` searches for the first element equal to zero.
- `print_int` prints signed integer values.
