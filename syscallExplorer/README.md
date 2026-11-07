# System Call Explorer

An interactive NASM program demonstrating Linux i386 system calls.

## Features

- `sys_write` — print a message.
- `sys_read` — read text from the keyboard.
- `getpid` — display the current process ID.
- `getppid` — display the parent process ID.

This is an educational program. It uses Linux i386 system call numbers
and the `int 0x80` interface.

## Requirements

- Linux x86 system with 32-bit execution support
- NASM
- GNU ld with 32-bit ELF support

## Build

```bash
nasm -f elf syscall_explorer.asm -o syscall_explorer.o
ld -m elf_i386 syscall_explorer.o -o syscall_explorer
```

## Run

```bash
./syscall_explorer
```

Or use your `nrun` helper:

```bash
nrun syscall_explorer.asm
```

## Menu

- `1` — call `sys_write`
- `2` — call `sys_read`
- `3` — call `getpid`
- `4` — call `getppid`
- `0` — exit

## Learning topics

- System calls
- Software interrupt `int 0x80`
- Linux i386 system call numbers
- Standard input and standard output
- Converting an integer to decimal text
