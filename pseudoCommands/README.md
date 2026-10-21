# Pseudo Commands

A simple NASM program demonstrating pseudo-instructions and data definitions.

## Requirements

- NASM
- GNU linker
- 32-bit Linux system-call support
- `stud_io.inc`

## Build

```bash
nasm -f elf pseudo_commands.asm -o pseudo_commands.o
ld -m elf_i386 pseudo_commands.o -o pseudo_commands
```

## Run

```bash
./pseudo_commands
```

## How It Works

- `db` defines byte-sized data.
- `dd` defines a four-byte value.
- `resb` reserves a specified number of bytes.
- `equ` defines a constant.
- `$` represents the current assembly address.
- `times` repeats a data definition.

## Example Output

```text
Hello!
*****
```
