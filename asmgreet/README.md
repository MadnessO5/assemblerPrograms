# asmgreet

A simple modular NASM assembly program for Linux (32-bit).

The program asks the user for their name and prints a greeting. Its functionality is divided into separate assembly modules.

## Project Structure

```text
asmgreet/
├── kernel.inc
├── strlen.asm
├── putstr.asm
├── getstr.asm
├── quit.asm
├── greet.asm
├── Makefile
└── README.md
```

## Requirements

- NASM
- GNU Make
- GNU Binutils (`ld`)
- Linux with 32-bit ELF support

On Arch Linux, install the required tools:

```bash
sudo pacman -S nasm make binutils
```

## Build

Navigate to the project directory:

```bash
cd ~/assemblerPrograms/asmgreet
```

Build the program:

```bash
make
```

This creates the executable file `prog`.

## Run

```bash
./prog
```

Example:

```text
Hi, what is your name?
Papyrus
Pleased to meet you, dear Papyrus!
```

## Modules

| File | Description |
|---|---|
| `kernel.inc` | Defines the `kernel` system call macro and OS-specific flags |
| `strlen.asm` | Calculates the length of a null-terminated string |
| `putstr.asm` | Prints a null-terminated string |
| `getstr.asm` | Reads a string from standard input |
| `quit.asm` | Terminates the program |
| `greet.asm` | Main program |

## Clean

Remove generated object files and the executable:

```bash
make clean
```

## Manual Build

The project can also be assembled and linked manually:

```bash
nasm -f elf -dOS_LINUX -g greet.asm -o greet.o
nasm -f elf -dOS_LINUX -g strlen.asm -o strlen.o
nasm -f elf -dOS_LINUX -g getstr.asm -o getstr.o
nasm -f elf -dOS_LINUX -g putstr.asm -o putstr.o
nasm -f elf -dOS_LINUX -g quit.asm -o quit.o

ld -m elf_i386 greet.o strlen.o getstr.o putstr.o quit.o -o prog
```

Run:

```bash
./prog
```
