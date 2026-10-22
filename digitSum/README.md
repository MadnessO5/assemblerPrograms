# Digit Sum

A simple NASM program that calculates the sum of digits in a number.

## Requirements

- NASM
- GNU linker
- 32-bit Linux system-call support

## Build

```bash
nasm -f elf digit_sum.asm -o digit_sum.o
ld -m elf_i386 digit_sum.o -o digit_sum
```

## Run

```bash
./digit_sum
```

Or use your `nrun` command:

```bash
nrun digit_sum.asm
```

## Example

```text
Enter a number: 24356457634
Sum of digits: 49
```

## How It Works

- `read` reads the number from standard input.
- A loop processes each digit.
- `add` calculates the sum.
- `div` converts the sum into decimal digits for output.
- Linux system calls display the result.
