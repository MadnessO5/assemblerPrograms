# AssemblerPrograms

A collection of small **x86 Assembly** programs and experiments written in NASM.

This repository is a personal learning project focused on low-level programming, computer architecture, and Linux system calls.

## Requirements

- NASM
- GNU `ld` linker
- Linux with 32-bit ELF support
- Zsh (optional, for `nrun`)
- `stud_io.inc` for projects that use it

## Build and Run

To assemble and run a program manually:

```bash
nasm -f elf program.asm -o program.o
ld -m elf_i386 program.o -o program
./program
```

Replace `program.asm` with the name of your source file.

## Quick Build with `nrun`

`nrun` is a Zsh function that assembles, links, and runs a NASM program with one command.

### Installation

Open your Zsh configuration using `nano` or `vim`:

```bash
nano ~/.zshrc
```

Or:

```bash
vim ~/.zshrc
```

Add the following function:

```zsh
nrun() {
    if [[ -z "$1" ]]; then
        echo "Usage: nrun file.asm"
        return 1
    fi

    local src="$1"
    local base="${src%.asm}"

    nasm -f elf "$src" -o "$base.o" &&
    ld -m elf_i386 "$base.o" -o "$base" &&
    "./$base"
}
```

Reload your configuration:

```bash
source ~/.zshrc
```

### Usage

Navigate to the directory containing your source file and run:

```bash
nrun program.asm
```

The function assembles the source file, creates an executable, and runs it if compilation succeeds.

## Topics

The repository contains examples involving:

- Registers and instructions
- Loops and conditional jumps
- Arithmetic and bitwise operations
- Input and output
- Linux system calls
- Memory and data definitions
- Assembly macros
- String operations
- Subroutines and pattern matching
- Variable arguments
- `stud_io.inc` input/output helpers

## Project Structure

Each project is stored in a separate directory and may include its own source code and README.

Example structure:

```text
AssemblerPrograms/
├── bitwiseOperations/
├── digitSum/
├── fillMemory/
├── miniCalculator/
├── miscInstructions/
├── pseudoCommands/
├── stringOperations/
├── variableArguments/
└── ...
```

The directory list is illustrative and may change as new projects are added.

## Goal

Learn x86 Assembly through practical experiments, understand how programs interact with memory and the operating system, and gradually develop low-level programming skills.
