# Expression Calculator

An interactive x86 Assembly calculator written in NASM.

## Features

- Addition, subtraction, multiplication, and division
- Modulo operation
- Bitwise AND, OR, and XOR
- Left and right bit shifts
- Negative integer support
- Division-by-zero handling
- Interactive menu with repeated calculations

## Requirements

- NASM
- GNU `ld` linker
- Linux with 32-bit ELF support
- Zsh and the `nrun` function (optional)

## Build

```bash
nasm -f elf expression_calculator.asm -o expression_calculator.o
ld -m elf_i386 expression_calculator.o -o expression_calculator
```

## Run

```bash
./expression_calculator
```

Or use `nrun`:

```zsh
nrun expression_calculator.asm
```

## Example

```text
Choice: 1
First number: 25
Second number: 17
Result: 42
```

## How It Works

The program displays a menu, reads the user's choice and two integers, performs the selected operation, and prints the result.

It uses x86 instructions such as `add`, `sub`, `imul`, `idiv`, `and`, `or`, `xor`, `shl`, and `sar`.

## Notes

- Division returns an integer and discards the fractional part.
- Division by zero is handled.
- Shift counts must be between 0 and 31.
- Arithmetic overflow and invalid numeric input are not fully checked.
