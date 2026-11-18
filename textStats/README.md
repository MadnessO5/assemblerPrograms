# TextStats

TextStats is an interactive Linux command-line utility written in NASM.
It counts the bytes, newline characters, and words in a text file.

## Requirements

- NASM
- GNU binutils (`ld` and `ar`)
- Linux with 32-bit ELF support

## Build

```bash
make
```

## Run

```bash
./textstats
```

Enter a file path when prompted. Enter `q` to quit.

## Project structure

- `main.asm` - interactive program and file opening/closing
- `io.asm` - input and output routines
- `file_stats.asm` - file statistics routine
- `libtext.a` - static library containing `io.o` and `file_stats.o`
- `Makefile` - build rules

## Clean

```bash
make clean
```

The linker receives `main.o` before `libtext.a`, because the main object
imports symbols provided by the library.
