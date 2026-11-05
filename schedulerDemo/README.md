# Scheduler Demo

A small interactive NASM program demonstrating two multitasking
approaches:

- **Batch processing** — tasks are shown one after another.
- **Time-sharing** — tasks are shown in an alternating sequence.

This program is an educational simulation. It does not manage real
processes or control the CPU.

## Requirements

- Linux
- NASM
- GNU ld (32-bit ELF support)

## Build

```bash
nasm -f elf scheduler_demo.asm -o scheduler_demo.o
ld -m elf_i386 scheduler_demo.o -o scheduler_demo
```

## Run

```bash
./scheduler_demo
```

Or use your `nrun` helper:

```bash
nrun scheduler_demo.asm
```

## Usage

Choose an option from the menu:

- `1` — Batch processing
- `2` — Time-sharing
- `0` — Exit

## Learning topics

- Linux system calls (`int 0x80`)
- Keyboard input (`sys_read`)
- Terminal output (`sys_write`)
- Comparisons (`cmp`)
- Conditional jumps (`je`)
- Unconditional jumps (`jmp`)
