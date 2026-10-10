# Misc Instructions

A simple NASM assembly program demonstrating several x86 instructions.

## Requirements

- NASM
- GNU Linker (`ld`)
- `stud_io.inc`

## Build & Run

```bash
nasm -f elf misc_instructions.asm -o misc_instructions.o
ld -m elf_i386 misc_instructions.o -o misc_instructions
./misc_instructions
```

## Instructions

- `MOVSX` — extends a value while preserving its sign.
- `MOVZX` — extends a value with zeros.
- `XCHG` — exchanges two operand values.
- `BSWAP` — reverses the byte order of a register.
- `STC` — sets the carry flag.
- `LAHF` — copies status flags into `AH`.
- `CLC` — clears the carry flag.
- `NOP` — performs no operation.

## Example Output

```text
MOVSX (-5): -5
MOVZX (250): 250
XCHG EAX: 20
BSWAP: 78563412
CF after STC: 1
```
