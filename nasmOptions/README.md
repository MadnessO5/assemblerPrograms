# NASM Options

A simple NASM program for practicing command-line options.

## Requirements

- NASM
- Linux
- GNU ld

## Build

```bash
nasm -f elf nasm_options.asm -o nasm_options.o
ld -m elf_i386 nasm_options.o -o nasm_options
```

## Run

```bash
./nasm_options
```

Expected output:

```text
Hello from NASM!
```

## NASM Options

Create an object file with debug information:

```bash
nasm -f elf -g nasm_options.asm -o nasm_options.o
```

Create a listing:

```bash
nasm -f elf -l nasm_options.lst nasm_options.asm
```

Preprocess the source:

```bash
nasm -e nasm_options.asm
```
