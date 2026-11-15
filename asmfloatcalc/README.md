# NASM Floating-Point Calculator

An interactive 32-bit Linux calculator written in NASM. It reads decimal
numbers, converts them to x87 floating-point values, and performs arithmetic
using separate modules stored in the static library `libcalc.a`.

## Requirements

- Linux x86 or x86-64 with 32-bit ELF support
- NASM
- GNU `ld`, `ar`, and `make`

On Arch Linux, install the tools with:

```sh
sudo pacman -S nasm binutils make
```

## Build

```sh
make
```

## Run

```sh
./prog
```

Enter a menu option and two numbers. The calculator accepts values from
`-999.99` to `999.99`, with up to two digits after the decimal point.

## Clean

```sh
make clean
```

## Project files

| File | Purpose |
|---|---|
| `calc.asm` | Main interactive program |
| `io.asm` | Console input and output |
| `parse_float.asm` | Decimal input parser |
| `print_float.asm` | Prints a floating-point result |
| `add.asm` | Addition library module |
| `subtract.asm` | Subtraction library module |
| `multiply.asm` | Multiplication library module |
| `divide.asm` | Division library module |
| `libcalc.a` | Static library created by `ar` |
| `Makefile` | Build and clean commands |

The four arithmetic modules are assembled into `libcalc.a`. The linker takes
the required routines from that archive when it builds `prog`.
