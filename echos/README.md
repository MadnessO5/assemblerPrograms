# Echo

A simple x86 Assembly program demonstrating the macros provided by `stud_io.inc`. It prints a message, reads characters from standard input, and echoes them back until the end of input.

## Requirements

* NASM

* Linux or FreeBSD

* `stud_io.inc`

## Build & Run

Bash

```
nasm -f elf32 echo.asm -o echo.o
ld -m elf_i386 echo.o -o echo
./echo
```

## Usage

```
Type something (Ctrl+D to finish):
Hello World
Hello World
Goodbye!
```

## How It Works

* `PRINT` displays a message.

* `GETCHAR` reads one character at a time.

* `PUTCHAR` prints each character back to the terminal.

* `Ctrl+D` signals the end of input on Linux.

* `FINISH 0` exits the program with code `0`.
