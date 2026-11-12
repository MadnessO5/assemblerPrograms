# logicOperations

An interactive binary logic calculator written in NASM assembly for Linux (32-bit).

## Description

This program performs bitwise logical operations on 8-bit binary numbers.

Available operations:

| Operation | Operator | Description |
|---|---|---|
| AND | `&` | Sets a bit if both bits are 1 |
| OR | `\|` | Sets a bit if at least one bit is 1 |
| XOR | `^` | Sets a bit if the bits are different |
| NOT | `~` | Inverts all 8 bits |

## Requirements

- NASM
- Linux (32-bit ELF support)
- GNU ld

## Build

```bash
nasm -f elf logic.asm -o logic.o
ld -m elf_i386 logic.o -o logic
```

## Run

```bash
./logic
```

Or use `nrun`:

```bash
nrun logic.asm
```

## Example

```text
=== Binary Logic Calculator ===

1. AND  (&)
2. OR   (|)
3. XOR  (^)
4. NOT  (~)
0. Exit
Choose: 1
First 8-bit binary number: 11111111
Second 8-bit binary number: 10101010
Result: 10101010
```

## Input

- Enter an operation number from `0` to `4`.
- Enter exactly 8 binary digits (`0` or `1`).
- NOT requires only the first binary number.
- Enter `0` to exit.

## Notes

- All calculations use 8-bit binary numbers.
- Invalid operations and binary inputs are rejected.
- The program uses Linux `int 0x80` system calls.
