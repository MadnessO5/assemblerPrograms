# Hardware Support Demo

A small interactive NASM program demonstrating four hardware features
used by multitasking operating systems:

- **Memory protection** — processes should not access each other's memory.
- **CPU modes** — user mode is restricted; kernel mode can perform
  privileged operations.
- **Hardware interrupts** — a device can notify the CPU when an I/O
  operation finishes.
- **Timer** — periodic timer interrupts let the OS regain control and
  switch tasks.

This is an educational simulation. It does not change memory permissions,
CPU privilege levels, real device interrupts, or the hardware timer.

## Requirements

- Linux
- NASM
- GNU ld with 32-bit ELF support

## Build

```bash
nasm -f elf hardware_support_demo.asm -o hardware_support_demo.o
ld -m elf_i386 hardware_support_demo.o -o hardware_support_demo
```

## Run

```bash
./hardware_support_demo
```

Or use the `nrun` helper:

```bash
nrun hardware_support_demo.asm
```

## Usage

Choose an item from the menu and follow the prompts. Enter `0` to go back
or exit.

## Learning topics

- Linux system calls (`int 0x80`)
- `sys_read` and `sys_write`
- NASM macros (`%macro` and `%endmacro`)
- Comparisons (`cmp`)
- Conditional jumps (`je`)
- Unconditional jumps (`jmp`)
